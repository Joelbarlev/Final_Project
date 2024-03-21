#!/bin/bash

# Filtering all words that comprise of 5 letters into wordBank
wordBank=$(curl https://raw.githubusercontent.com/dwyl/english-words/master/words.txt | grep -xE '[[:alpha:]]{5}')

# Check tha two inputs where entered correctly

# Catching the inputs into parameters
word=$1
colors=$2
