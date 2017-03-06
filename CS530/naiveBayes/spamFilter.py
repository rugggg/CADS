#!/usr/bin/env python

import numpy as np
import math


def main():
    spamData = np.loadtxt("spamdata_binary.txt")
    spamLabels = np.loadtxt("spamlabels.txt")
    
    trainedData = train(spamData,spamLabels)
    print("spam")
    classify(spamData[4000],trainedData)
    classify(spamData[4001],trainedData)
    print("notSpam")
    classify(spamData[0],trainedData)
    classify(spamData[1],trainedData)
    

def kFold(data,label,numFolds):
    #find number of folds in set
    f = len(data)/numFolds
    fRest = len(data)%numFolds
    
    print(f)
    print(fRest)

def classify(newEmail, trained):
    priors = trained[0]
    likelyhoods = trained[1]
    pWordSpam = 1
    pWordNotSpam = 1
    for idx,word in enumerate(newEmail):
        if word:
            pWordSpam *= likelyhoods[idx][0]
            pWordNotSpam *= likelyhoods[idx][1]
    pSpam = math.log10(pWordSpam) * math.log10(priors[0]/sum(priors))
    pNotSpam = math.log10(pWordNotSpam)* math.log10(priors[1]/sum(priors))     

    print(pSpam)
    print(pNotSpam)
    
        
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

    pSpamNotSpam = []
    for idx,word in enumerate(attrSpamCounts): 
        probSpam = word/numSpams
        probNotSpam = attrNotSpamCounts[idx]/numNotSpams
        pSpamNotSpam.append([probSpam,probNotSpam])
    priors = [numSpams,numNotSpams]
    return [priors,pSpamNotSpam]

def likelyhoodTerm(data,email,spam):
    lTerm = 1
    for idx,attr in enumerate(email):
        if(spam):
            lTerm *= pWordSpam(data,idx)
        else:
            lTerm *= pWordNotSpam(data,idx)

def determinePrior(dataLabelSet):
    return np.sum(dataLabelSet)/dataLabelSet.size





if __name__ == "__main__":
    main()
