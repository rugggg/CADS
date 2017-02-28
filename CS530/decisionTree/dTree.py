#!/usr/bin/python

import numpy as np
import math

'''
    Main recursion function

'''
def createDTree(dataSet,dTags):
    print("-------------------------------------------------------")
    print("-------------------------------------------------------")
    print("----------------Starting Data Set: --------------------")
    print(dataSet)
    splitAttr = selectSplitAttribute(dataSet)
    print("Split On: ",dTags[splitAttr])
    nodes = splitOnAttribute(dataSet,splitAttr)
    for node in nodes:
        nodeName = node[0,splitAttr]
        print()
        print("     ",nodeName,"    ")
        if isPureNode(node):
            print("****** PURE: ",node)
#            assignDecision(node)
        elif node.shape[1] < 3:
            print(">>>>>> Done")
        else:
            print("....new tree...")
            newNodeStart = np.delete(node,splitAttr,1)
            newDTags = np.delete(dTags,splitAttr,0)
            createDTree(newNodeStart,newDTags)


def selectSplitAttribute(_data):
    #for each attr(a) compute and compare IG
    _data = np.transpose(_data)

#    for a in _data[:-1]:
    g = np.apply_along_axis(calcIG,1,_data[:-1],_data[-1])
    return np.argmax(g)

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
    for a in A:
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
        
def isPureNode(node):
    n = getValues(node)
    if np.count_nonzero(n) <= 1:
        return True
    else:
        return False
    
def splitOnAttribute(data,attribute):
    n = [data[data[:,attribute]==k] for k in np.unique(data[:,attribute])]
    return n; 
#    print(data[data[:,attribute].argsort()])
        
def getValues(node):
    S = [0,0]
    for i in node:
        if i[-1] == "Yes":
            S[0] += 1
        else:
            S[1] += 1
    return S



    



data = np.genfromtxt('tennis.csv',delimiter=",",dtype="str")

dataTags = ["Outlook","Temp","Humidity","Wind"]
def main():
    createDTree(data,dataTags)

if __name__ == "__main__":
    main()


