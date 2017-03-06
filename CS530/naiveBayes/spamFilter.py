#!/usr/bin/env python

import numpy as np
import math


def main():
    spamData = np.loadtxt("spamdata_binary.txt")
    spamLabels = np.loadtxt("spamlabels.txt")
    
    trainedData = train(spamData,spamLabels)
    print(spamLabels[4000])
    print(classify(spamData[4000],trainedData))
    print()
    print(spamLabels[4001])
    print(classify(spamData[4001],trainedData))
    print()
    print(spamLabels[0])
    print(classify(spamData[0],trainedData))
    print() 
    print(spamLabels[1])
    print(classify(spamData[1],trainedData))
    print()

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
    pSpam = math.log10(pWordSpam) + math.log10(priors[0]/sum(priors))
    pNotSpam = math.log10(pWordNotSpam) + math.log10(priors[1]/sum(priors))     

    if pSpam >= pNotSpam:
        return 1
    else:
        return 0
        

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


def determinePrior(dataLabelSet):
    return np.sum(dataLabelSet)/dataLabelSet.size





if __name__ == "__main__":
    main()
