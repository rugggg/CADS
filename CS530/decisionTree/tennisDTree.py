#!/usr/bin/python

import math
import csv


def getRowOutcome(row):
    return row[len(row)-1] == "Yes"
    
'''
    takes in a csv with the last column assumed to be the target outcome column
    params: fileName : string
    returns : list of dicts for occurences
'''
def readCsvForDTree(fileName):
    attr = []
    f = open(fileName, 'rt')
    try:
        reader = csv.reader(f)
        #read each row over
        for row in reader:
            count = 0
            #for each attribute - create if does not exist
            #get row outcome
            playTennis = getRowOutcome(row)
            for i in row:
                if count >= len(attr):
                    attr.append({})
                if i in attr[count]:
                    if playTennis:
                        attr[count][i][0] += 1
                    else:
                        attr[count][i][1] += 1
                else:
                    if playTennis:
                        attr[count][i] = [1,0]
                    else:
                        attr[count][i] = [0,1]
                count += 1
    finally:
        f.close()
    return attr

#assumes the last item in the data is the 
#result state set
def getStartingS(fileName):
    _S = [0,0]
    f = open(fileName, 'rt')
    try:
        reader = csv.reader(f)
        #read each row over
        for row in reader:
            if(getRowOutcome(row)):
                _S[0] += 1
            else:
                _S[1] += 1
    finally:
        f.close()
    return _S
def convertToValueList(data):
    converted = []
    for k in data:
        converted.append(data[k])
    return converted
def convertAToList(data):
    aList = []
    for i in data:
        aList.append(convertToValueList(i))
    return aList

#sums the list
def getTotal(K):
    total = 0
    for i in K:
        total+=i
    return total

#gets the entropy of a given result set 
#expects param in form [int,int, ... int]
def H(S):
    e = 0
    sTotal = getTotal(S)
    for s in S:
        if s > 0:
            s = s/sTotal
            e += -s*math.log2(s)
    #print("Entropy of ",S, " is, ",e)
    return e

#gets the weighted entropy
def M(A): 
    #A is the total number of items covered by the attribute
    #a is the total number of results 
    wE = 0
    print(A)
    for a in A:
        print("a:   ",a)
        wE +=(abs(len(a))/abs(len(A)) * H(a))
    return wE

def IG(S,A):
    return H(S) -  M(A)

A = readCsvForDTree("tennis.csv")
S = getStartingS("tennis.csv")
A_list = convertAToList(A)
for a in A_list:
    IG(S,a)

