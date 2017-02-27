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

def getDataSize(fileName):
    f = open(fileName,'rt')
    rowCount = 0
    try:
        reader = csv.reader(f)
        for row in reader:
            rowCount += 1
    finally:
        f.close()
    return rowCount

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
    return e

#gets the weighted entropy
def M(A,setSize): 
    #A is the total number of items covered by the attribute
    #a is the total number of results 
    wE = 0
    for a in A:
        a_size = getTotal(a)
        wE +=(abs(a_size)/setSize) * H(a)
    return wE

def IG(S,A):
    return H(S) -  M(A,rowCount)



#setup from csv file
A = readCsvForDTree("tennis.csv")
rowCount = getDataSize("tennis.csv")
S = getStartingS("tennis.csv")
A_list = convertAToList(A)
A_list = A_list[:-1]

#iterate and find each inormation gain
for a in A_list:
    print(a)
    print(IG(S,a))

#we need an attribute to check
#in this attribute, we have states
#for each state, we can calculate entropy using H - which works
#to get the total - M - for the whole attribute - we need 
#the total number of values for the entire set
#and also the total number of values for each state












