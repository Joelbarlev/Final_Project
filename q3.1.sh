#!/bin/bash

# Filtering all words that comprise of 5 letters into word_bank in caps
word_bank=$(curl https://raw.githubusercontent.com/dwyl/english-words/master/words.txt | grep -xE '[[:alpha:]]{5}'| tr '[:lower:]' '[:upper:]')

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <word> <colors>"
    exit 1
fi

# Check if both inputs are exactly 5 characters long

# Catching the inputs into parameter in upper-case
word=$(echo "$1" | tr '[:lower:]' '[:upper:]')
colors=$(echo "$2" | tr '[:lower:]' '[:upper:]')

if [[ $colors == *"S"* ]]; then

  # Creating y_letters with all silver letters in word
  s_letters=""

  # Loop through each character position in 'colors'
  for ((i = 1; i <= ${#colors}; i++)); do
    # Check if the character at position 'i' in 'colors' is "S"
    if [ "${colors:i-1:1}" = "S" ]; then
        # Append the character at position 'i' in 'word' to 'extracted_letters'
        s_letters+=${word:i-1:1}
    fi
  done

  # Filtering now the word_bank based on the y_letters
for (( i=0; i<${#s_letters}; i++ )); do
    # Construct the regular expression pattern to exclude words containing the current character
    pattern="${s_letters:i:1}"
    word_bank=$(echo "$word_bank" | grep -vE "[$pattern]")
done

# Use grep to filter out words containing any of the characters in $X

fi

echo "$word_bank"

