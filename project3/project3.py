#!/usr/local/bin/python
 
import os
import sys
import math
import nltk
 
from os import listdir
from os.path import isfile, join
 
 
# We need to find out how to import nltk.corpus
from nltk.corpus import wordnet
 
# import stop words
 
from nltk.corpus import stopwords
from nltk.corpus import wordnet as wn
 
# This script inputs the labelled documents and outputs 
# the highest frequent words, the input paramater for the 
# script shows how many words to output
 
 
 
# nltk.download()
print(stopwords.words)
 
# Object Labeled files
labeledDirectory = sys.argv[1]
labeledFiles = [ f for f in listdir(labeledDirectory) if isfile(join(labeledDirectory, f))]
# Obtain unlabeled files 
unlabeledDirectory = sys.argv[2]
unlabeledFiles = [ f for f in listdir(unlabeledDirectory) if isfile(join(unlabeledDirectory, f))]

# GET THE BAG OF WORDS IN THE LABELED FILE AND PUT THEM IN THE BAG OF WORDS MAP
wordsInFileMap = { }
 
for fileName in labeledFiles :
    file = open(labeledDirectory + "/" + fileName,"r")
    wordSet = []
    wordsInFileMap[fileName] = wordSet
    #implement a word tokenizer within the loop
    for line in file:
        # Filter stop words either from the nltk set , or your own user defined set
        # Get onley the word, make sure it ia a word.
        # If it is a word and not a stop word then add it to the list 
        splitWords = line.split()
        for word in splitWords :
            if ( wn.synsets(word) and (word not in stopwords.words('english'))) :
                wordSet.append(word)
    
# ITERATE OVER EACH SET OF LIST OF SELECTEDWORDSMAP[FILENAME], INCREMEMENT WORD COUNT FOR EACH WORD,
# EACH WORD REPRESENTS A KEY FROM THE DICTIONARY WORDMAP, EACH WORDLIST HAS A WORDMAP DICTIONARY
 
wordList = []
labeledListMap = {} 
 
class WordObject:
    wordCount = 0
    word = ""
    def __init__(self, countParam,wordParam) :
        self.wordCount = countParam
        self.word = wordParam

for fileName in labeledFiles :
    # WORD MAP WILL COMPOSE OF THE WORD COUNT FOR EVERY DICTIONARY LOOK UP
    wordMap = {}
    wordList.append(wordMap)
    wordSetFromFile = wordsInFileMap[fileName]
    for word in wordSetFromFile :
        keys = wordMap.keys()
 
        if word in keys :
            wordMap[word] += 1
        else :
            wordMap[word] = 1 
 
    finalList = []
    fullLabeledSet = set()
    labeledListMap[fileName] = fullLabeledSet
    for i in range(5):
        highestCount = 0
        selectedKey = -1
        for wordKey, wordCount in wordMap.items() :
            if wordCount > highestCount :
                highestCount = wordCount
                selectedKey = wordKey
 
        wordObject = WordObject(highestCount, selectedKey)
 
        # REMOVE FROM WORDMAP
        del wordMap[selectedKey]    
     
        finalList.append(wordObject)


    for word in finalList :
        for wordSetInst in wn.synsets(word.word) :
            for newWords in wordSetInst.lemma_names():
                fullLabeledSet.add(newWords)

threshold = 0.0001 # minimum frequency for a document to be labeled 

# class for each labeled document
classes = {0:"Diabetes", 1:"Computing", 2:"None"} 
trueLabels = [1,1,1,1,0,2]
predictedLabels = [] # this will store the classification for each labeled document
docCount = 0 # indicates which document we are currently processing
# OPEN THE FILES FROM THE UNLABELED CORPUS
for fileName in unlabeledFiles :
    file = open(unlabeledDirectory + "/" + fileName,"r")
    uWordList = [] # raw word list for unlabeled documents
    for line in file:
        splitWords = line.split()
        for word in splitWords:
            if (wn.synsets(word)) and (word not in stopwords.words("English")):
                uWordList.append(word)
    '''
    Now that we have a list of all words in document, compare this list to the most frequent words
    from the labeled documents to determine similarity.
    '''
    setCount = 0
    maxFrequency = -1
    for key in labeledListMap:
        if key == 2:
            break
        matchCount = 0 # number of words in document that match a word in a labeled document
        for word in uWordList:
            if word in labeledListMap[key]:
                matchCount = matchCount + 1
        # Calculate frequency
        frequency = matchCount / len(uWordList)
        if (frequency > maxFrequency):
            maxFrequency = frequency
            label = setCount
        setCount = setCount + 1
    # make sure that frequency is above threshold
    if (maxFrequency < threshold):
        label = 2 # unlabeled case

    # display results
    print("Actual label for " + fileName + " is " + classes[trueLabels[docCount]])
    print("Classification for " + fileName + " is " + classes[label])
    # add classification to list
    predictedLabels.append(label)
    docCount += 1

'''
Now that we have classified each unlabeled document, compute the precision, accuracy, and recall
Treat computing class as the positive case.
'''

truePositives = 0
falsePositives = 0
falseNegatives = 0
trueNegatives = 0
docCount = 0
for label in predictedLabels:
    if label == 1: # predicted computer
        if (trueLabels[docCount] == 1): # actually computer
            truePositives = truePositives + 1
        else: # not really computer
           falsePositives = falsePositives + 1
    else: # predicted as diabetes
        if (trueLabels[docCount] == 1): # supposed to be computer
            falseNegatives = falseNegatives + 1
        else: trueNegatives += 1
    docCount = docCount + 1

precision = truePositives / (truePositives + falsePositives)
recall = truePositives / (truePositives + falseNegatives)
accuracy = (truePositives + falseNegatives) / len(predictedLabels)

print("Precision: %f" % precision)
print("Recall: %f" % recall)
print("Accuracy: %f" % accuracy)

