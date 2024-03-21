#!/bin/bash

# Filtering all words that comprise of 5 letters into word_bank in caps
word_bank=$(curl https://raw.githubusercontent.com/dwyl/english-words/master/words.txt | grep -xE '[[:alpha:]]{5}'| tr '[:lower:]' '[:upper:]')

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <word> <colors>"
    exit 1
fi

# Check if both inputs are exactly 5 characters long
if [ "${#word}" -ne 5 ] || [ "${#colors}" -ne 5 ]; then
    echo "Both word and colors must be exactly 5 characters long."
    exit 1
fi

# Catching the inputs into parameter in upper-case
word=$(echo "$1" | tr '[:lower:]' '[:upper:]')
colors=$(echo "$2" | tr '[:lower:]' '[:upper:]')





