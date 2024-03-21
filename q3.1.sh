#!/bin/bash

# Filtering all words that comprise of 5 letters into word_bank
word_bank=$(curl https://raw.githubusercontent.com/dwyl/english-words/master/words.txt | grep -xE '[[:alpha:]]{5}'| tr '[:lower:]' '[:upper:]')

# Check tha two inputs where entered correctly
# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <word> <colors>"
    exit 1
fi
# Catching the inputs into parameters in lower-case
word=$(echo "$1" | tr '[:lower:]' '[:upper:]')
colors=$(echo "$2" | tr '[:lower:]' '[:upper:]')





