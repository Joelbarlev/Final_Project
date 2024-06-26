#!/bin/bash

# Filtering all words that comprise of 5 letters into word_bank
word_bank=$(curl https://raw.githubusercontent.com/dwyl/english-words/master/words.txt | grep -xE '[[:alpha:]]{5}'| tr '[:upper:]' '[:lower:]')

# Check tha two inputs where entered correctly
# Catching the inputs into parameters in lower-case
word=$(echo "$1" | tr '[:upper:]' '[:lower:]')
colors=$2

# Check if there are green letters in the input parameters
if [[ $colors == *"G"* ]]; then

  # filter word_bank by Green letters in word using awk
    word_bank=$(echo "$word_bank" | awk -v colors="$colors" -v word="$word" '{
    for (i=1; i<=5; i++) {
        if (substr(colors, i, 1) == "G") {
            if (index($0, substr(word, i, 1)) == 0) {
                next
            }
        }
    }
    print
 }')
fi

# Check if there are yellow letters in the input parameters
if [[ $colors == *"Y"* ]]; then

  # Creating y_letters with all yellow letters in word
  y_letters=""

  # Loop through each character position in 'colors'
  for ((i = 1; i <= ${#colors}; i++)); do
    # Check if the character at position 'i' in 'colors' is "Y"
    if [ "${colors:i-1:1}" = "Y" ]; then
        # Append the character at position 'i' in 'word' to 'extracted_letters'
        y_letters+=${word:i-1:1}
    fi
  done

  # Filtering now the word_bank based on the y_letters
  word_bank=$(echo "$word_bank" | grep -E "[$y_letters]")
fi

# Similar to the yellow letters now will do the inverse of s_letters
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
  word_bank=$(echo "$word_bank" | grep -EV "[$s_letters]")
fi

echo "$word_bank"