import os
import pandas as pd
import numpy as np

pd_arr = pd.array(data=['1', '2', '3', '4', '5'], dtype=np.int8)
pd_df = pd.DataFrame(pd_arr)
pd_df.to_csv("junk.csv")


with open('testOutput.txt', 'w') as f:
    f.write('Create a new text file!')
    f.close()
