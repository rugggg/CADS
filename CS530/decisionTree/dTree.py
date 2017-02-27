#!/usr/bin/python

import numpy as np
import math


data = np.genfromtxt('tennis.csv',delimiter=",",dtype="str")


'''
    Main recursion function

'''
def createDTree(dataSet):
    splitAttr = selectSplitAttribute(dataSet)
    nodes = splitOnAttr(splitAttr)
    for node in nodes:
        if isPureNode(node):
            assignDecision(node)
        else:
            createDTree(node)

def selectSplitAttribute(_data):
    #for each attr(a) compute and compare IG
    _data = np.transpose(_data)


#    for a in _data[:-1]:
    g = np.apply_along_axis(calcIG,1,_data[:-1],_data[-1])
    print(np.max(g))

#function to take an Attribute and the decision col
#and calc the info gain
def calcIG(A,decisions):
    node = constructNode(A,decisions)
    return H(getS(decisions)) - M(node,len(A))

def getS(col):
    S = [0,0]
    for i in col:
        if i == "Yes":
            S[0] += 1
        else:
            S[1] += 1
    return S

def H(S):
    e = 0 
    for s in S:
        if s > 0:
            s = s/np.sum(S)
            e += -s*math.log2(s)
    return e
#gets the weighted entropy
def M(A,setSize): 
    wE = 0
    print(A)
    for a in A:
        print(A[a])
        wE +=(abs(np.sum(A[a]))/setSize) * H(A[a])
    return wE


def constructNode(_A,_R):
    node = {}

    for idx,a in enumerate(_A):
        if _R[idx] == "Yes":
            playTennis =True
        else:
            playTennis = False

        if a in node:
            if playTennis:
                node[a][0] += 1
            else:
                node[a][1] += 1
        else:
            if playTennis:
                node[a] = [1,0]
            else:
                node[a] = [0,1]
    return node
            
selectSplitAttribute(data)



    



