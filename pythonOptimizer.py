#!/usr/bin/env python3
# %pip install -q pulp

import pandas as pd
import numpy as np
from datetime import datetime

import os

import warnings

warnings.filterwarnings('always')

warnings.filterwarnings('ignore')

from pulp import *

# Opening JSON Schedule file to create nested dictionary
with open('./Schedule.json') as json_file:
    input_schedule = json.load(json_file)

with open('./People.json') as json_file:
    worker_schedule = json.load(json_file)

dow = list(input_schedule.keys())
# dow

dow_dict = {}
for i in range(len(dow)):
    dow_dict[dow[i]] = i
# dow_dict

shifts = []
for i in range(len(dow)):
    tmpLST = input_schedule[dow[i]]['timesWeNeedWorkers']
    for j in range(len(tmpLST)):
        if tmpLST[j]['shifts'] not in shifts:
            shifts.append(tmpLST[j]['shifts'])
# shifts

shifts_dict = {}
for i in range(len(shifts)):
    shifts_dict[shifts[i]] = i
# shifts_dict

# M = number of workers
M = len(worker_schedule['People'])

# N = number of shifts
N = len(shifts)

# T = number of time windows
T = 24

# F = days of the week
F = len(list(input_schedule.keys()))

# M, N, T, F

timeWin = ['TW' + str(i) for i in range(T)]
# timeWin

timeWin_dict = {}
for i in range(len(timeWin)):
    timeWin_dict[timeWin[i]] = i
# timeWin_dict

workers = []
for i in range(M):
    workers.append(worker_schedule['People'][i]['id'])
# workers

workers_dict = {}
for i in range(len(workers)):
    workers_dict[workers[i]] = i
# workers_dict

# Time windows (TW) for each shift
# F = days of the week
# T = number of time windows
# N = number of shifts
a = np.zeros((F, T, N))


for f in range(F):

    tmpLST = input_schedule[dow[f]]['timesWeNeedWorkers']

    for i in range(len(tmpLST)):

        # map shift to column position
        n = shifts_dict[tmpLST[i]['shifts']]

        tmpStart = tmpLST[i]['from']
        tmpEnd = tmpLST[i]['to']

        # determine shift start time
        tmpStart_object = datetime.strptime(tmpStart, '%H:%M')
        tmpStart = np.ceil(tmpStart_object.hour + tmpStart_object.minute/60)

        # determine shift end time
        tmpEnd_object = datetime.strptime(tmpEnd, '%H:%M')
        tmpEnd = np.ceil(tmpEnd_object.hour + tmpEnd_object.minute/60)

        # determine time shifts
        tmpTimeRange = np.arange(tmpStart, tmpEnd, 1)

        for j in range(len(tmpTimeRange)):
            a[dow_dict[dow[f]],int(tmpTimeRange[j]),n]=1

# a

# The cost data is made into a dictionary
a_dict = makeDict([dow, timeWin, shifts], a, 0)
# a_dict

#a_dict['Monday']['TW0']['morning']

# The number of workers needed per time tindow
# F = days of the week
# T = number of time windows
# N = number of shifts
d = np.zeros((F, T, N))

for f in range(F):

    tmpLST = input_schedule[dow[f]]['timesWeNeedWorkers']

    for i in range(len(tmpLST)):

        # map shift to column position
        n = shifts_dict[tmpLST[i]['shifts']]

        tmpStart = tmpLST[i]['from']
        tmpEnd = tmpLST[i]['to']

        # determine shift start time
        tmpStart_object = datetime.strptime(tmpStart, '%H:%M')
        tmpStart = np.ceil(tmpStart_object.hour + tmpStart_object.minute/60)

        # determine shift end time
        tmpEnd_object = datetime.strptime(tmpEnd, '%H:%M')
        tmpEnd = np.ceil(tmpEnd_object.hour + tmpEnd_object.minute/60)

        # determine time shifts
        tmpTimeRange = np.arange(tmpStart, tmpEnd, 1)

        for j in range(len(tmpTimeRange)):
            d[dow_dict[dow[f]],int(tmpTimeRange[j]),n] = int(tmpLST[i]['numberOfEmployeesNeeded'])

# d

# The cost data is made into a dictionary
d_dict = makeDict([dow, timeWin, shifts], d, 0)
# d_dict

#d_dict['Monday']['TW0']['morning']

# Worker (W) availablity per time window
# F = days of the week
# T = number of time windows
# M = number of workers
w = np.zeros((F, T, M))

for m in range(M):

    tmpDict = worker_schedule['People'][m]

    for f in range(F):
        try:
            tmpLST = tmpDict[dow[f]]['freeTimes']

            for i in range(len(tmpLST)):

                # map shift to column position
                tmpLST[i]

                tmpStart = tmpLST[i]['from']
                tmpEnd = tmpLST[i]['to']

                # determine shift start time
                tmpStart_object = datetime.strptime(tmpStart, '%H:%M')
                tmpStart = np.ceil(tmpStart_object.hour + tmpStart_object.minute/60)

                # determine shift end time
                tmpEnd_object = datetime.strptime(tmpEnd, '%H:%M')
                tmpEnd = np.ceil(tmpEnd_object.hour + tmpEnd_object.minute/60)

                # determine time shifts
                tmpTimeRange = np.arange(tmpStart, tmpEnd, 1)

                for j in range(len(tmpTimeRange)):
                    w[f, int(tmpTimeRange[j]), workers_dict[tmpDict['id']] ] = 1
        except:
            pass

# w[0,:,:]

# The cost data is made into a dictionary
w_dict = makeDict([dow, timeWin, workers], w, 0)
# w_dict

#w_dict['Monday']['TW0']['W0']

b_var = LpVariable.dicts("b", (dow, timeWin, workers), cat="Binary")
# b_var

#b_var['Monday']['TW0']['W0']

# Creates the 'prob' variable to contain the problem data
prob = LpProblem("Worker Scheduler", LpMinimize)

var_list = []
for f in range(F): # DOW
    for n in range(N): # shifts
        for m in range(M): # workers
            for t in range(T): # timeWin
                # w[t,m]*a[t,n]*b[t,m]
                var_list.append(w_dict[dow[f]][timeWin[t]][workers[m]] * a_dict[dow[f]][timeWin[t]][shifts[n]] * b_var[dow[f]][timeWin[t]][workers[m]])

prob += lpSum(var_list)

# prob

# Add constraints

for t in range(T): # timeWin
    for n in range(N): # shifts
        for f in range(F): # DOW
            var_list = []
            for m in range(M): # workers
                var_list.append(w_dict[dow[f]][timeWin[t]][workers[m]] * a_dict[dow[f]][timeWin[t]][shifts[n]] * b_var[dow[f]][timeWin[t]][workers[m]])
            prob += lpSum(var_list) == d_dict[dow[f]][timeWin[t]][shifts[n]], dow[f]+"_"+timeWin[t]+"_"+shifts[n]

# prob

"""Finally, we have our problem ready and now we shall run the Solver algorithm. Kindly note that we could pass our own parameters while running the solver n terms of the algorithm which could be used, but in this case, I shall run the solver without any parameters and let it decide the best algorithm to run according to the structure of the problem. Yes, this library is quite optimized to do so!"""


# solver = PULP_CBC_CMD(msg=True, keepFiles=True)
# prob.solve(solver)
prob.solve()

prob.solver

"""Now we print the status of the problem. Note that if the problem is not formulated well then it might have an "infeasible" soltuin or if it does not provide sufficient information then it might be "Unbounded". But our solution is "optimal" which means that the solution is optimized."""

LpStatus[prob.status]

#for var in prob.variables():
#    print(f'Variable name: {var.name} , Variable value : {var.value()}\n')

## OBJECTIVE VALUE
#print(f'OBJECTIVE VALUE IS: {round(prob.objective.value(),2)}')

res = []
for var in prob.variables():
    if var.value() == 1:
        name = var.name.split("_")[1:]
        res.append(name)
# res

w_res = np.zeros((F,T, M))
# w_res

for k in range(len(res)):
    w_res[dow_dict[res[k][0]], timeWin_dict[res[k][1]], workers_dict[res[k][2]]] = 1

# original availability
# w[0,:,:]

# optimized results
# w_res[0,:,:]

# format results for output
scheduleDF = pd.DataFrame()
for f in range(F):
    tmpLST = []
    for t in range(T):
        tmpLST.append(datetime.strptime(str(t), '%H').strftime('%H:%M'))

    tmpDF = pd.DataFrame(w_res[f,:,:], columns=workers, index=tmpLST).reset_index(drop=False)
    tmpDF['Day'] = dow[f]
    tmpDF = tmpDF.rename(columns={'index': 'timeWindow'})
    scheduleDF = scheduleDF.append(tmpDF)
scheduleDF = scheduleDF.reset_index(drop=True)

# save dataframe as a json format
scheduleDF.to_json('./scheduleDF.json', orient='index')
