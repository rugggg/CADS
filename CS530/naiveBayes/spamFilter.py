#!/usr/bin/env python

import numpy as np


def main():
    spamData = np.loadtxt("spamdata_binary.txt")
    spamLabels = np.loadtxt("spamlabels.txt")
     


    train(spamData,spamLabels)
def isSpam(pSpam,pNotSpam):
    if(pSpam >= pNotSpam):
        return True
    else:
        return False

#our training set will be some slice of our total set
#we will compute pSpam and pNotSpams from this
def train(dataSet,labelSet):
    #compute prior
    _prior = determinePrior(labelSet)
    #compute all the pSpam terms for each word(attr)
    #by going through the data set, and dividing the 
    #number of times the word occurs with spam 
    #computing our pSpam for each attr:
    #iterate over each row in the data
    numSpams = 0
    attrSpamCounts = np.zeros(dataSet.shape[1])
    attrNotSpamCounts = np.zeros(dataSet.shape[1])
    for idx,email in enumerate(dataSet):
        spam = labelSet[idx]
        if spam: numSpams +=1
        for i,word in enumerate(email):
            if spam and word:
                attrSpamCounts[i] += 1
            if not spam and word:
                attrNotSpamCounts[i] += 1
    numNotSpams = len(labelSet) - numSpams 
    np.set_printoptions(suppress=True)
    
    print(numSpams)
    print(numNotSpams)
    print(attrSpamCounts)
    print(attrNotSpamCounts)
    
    pSpamNotSpam = []
    for idx,word in enumerate(attrSpamCounts): 
        probSpam = word/numSpams
        probNotSpam = attrNotSpamCounts[idx]/numNotSpams
        pSpamNotSpam.append([probSpam,probNotSpam])
    print(pSpamNotSpam)




def pSpam(email,prior):
    #p(spam|data) = p(data|spam)p(data) 
    return likelyhoodTerm("",email,True)*prior
        
def pNotSpam(email,prior):
    #p(notSpam|data) = p(data|notSpam)p(data) 
    return likelyhoodTerm("",email,False)*prior
    
def likelyhoodTerm(data,email,spam):
    lTerm = 1
    for idx,attr in enumerate(email):
        if(spam):
            lTerm *= pWordSpam(data,idx)
        else:
            lTerm *= pWordNotSpam(data,idx)

#
def pWordSpam(data,wordIndex):
    k = 0
    spamCount = 1
    for idx,row in enumerate(data):
        if row[wordIndex] and spamLabels[idx]:
            k += 1
        if spamLabels[wordIndex]:
            spamCount += 1
    return k/spamCount

def pWordNotSpam(data,wordIndex):
    k = 0
    notSpamCount = 1
    for idx,row in enumerate(data):
        if row[wordIndex] and not spamLabels[idx]:
            k += 1
        if not spamLabels[wordIndex]:
            notSpamCount += 1
    return k/notSpamCount


def determinePrior(dataLabelSet):
    return np.sum(dataLabelSet)/dataLabelSet.size





if __name__ == "__main__":
    main()
