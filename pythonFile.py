import os
print("helloWorld")
with open('testOutput.txt', 'w') as f:
    f.write('Create a new text file!')
    f.close()
os.remove("testOutput.txt")