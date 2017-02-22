#!/usr/bin/python

import numpy as np
import math

S = [9,14]

def getTotal(K):
    total = 0
    for i in K:
        total+=i
    return total

def H(_S):
    e = 0
    for s in _S:
        e += -s*math.log(s)
    return e

def M(A): 
    #A is the total number of items covered by the attribute
    #a is the total number of results 
    wE = 0
    for a in A:
        wE +=(abs(a.size())/abs(A.size()) * H(a))

def IG(S,A):
    return H(S) -  M(A)

print(getTotal(S))
print(H(S))

