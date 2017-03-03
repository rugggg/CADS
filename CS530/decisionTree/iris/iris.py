#!/usr/bin/python

import numpy as np


def getZ(n,z,mean):
    return round((n-mean)/z)

def main():    
    data = np.genfromtxt('iris.csv',delimiter=",",dtype="float")
    tData = np.transpose(data)[:-1]
    means = np.mean(tData,axis=1)
    stds = np.std(tData,axis=1)
    print(means)
    print(stds)
    zScored = [];
    for i in data:
        for idx,j in enumerate(i):
            item = [];
            if idx < 4:
                val = getZ(j,stds[idx],means[idx])
                item[] = val;
            else:
                item[] = j
        zScored[] = j
    print(zScored)

if __name__ == "__main__":
    main()



