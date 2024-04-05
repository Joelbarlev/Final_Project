#!/bin/bash

# Filtering all words that comprise of 5 letters into word_bank in caps
word_bank=$(curl https://raw.githubusercontent.com/dwyl/english-words/master/words.txt | grep -xE '[[:alpha:]]{5}'| tr '[:lower:]' '[:upper:]')

# As writen in the question we assumed that the 2 inputs are 5 letters long and fit our code requirements and only checked for two inputs
# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <word> <colors>"
    exit 1
fi

# Catching the inputs into parameter in upper-case
word=$(echo "$1" | tr '[:lower:]' '[:upper:]')
colors=$(echo "$2" | tr '[:lower:]' '[:upper:]')

# Checking for silver letters
if [[ $colors == *"S"* ]]; then

  # Creating y_letters with all silver letters in word
  s_letters=""

  # Loop through each character position in 'colors'
  for ((i = 1; i <= ${#colors}; i++)); do
  # Check if the character at position 'i' in 'colors' is "S"
  if [ "${colors:i-1:1}" = "S" ]; then
        s_letters+=${word:i-1:1}
  fi
  done

  # Filtering now the word_bank based on the s_letters
  for (( i=0; i<${#s_letters}; i++ )); do
    # Construct the regular expression pattern to exclude words containing the current character
    pattern="${s_letters:i:1}"
    word_bank=$(echo "$word_bank" | grep -vE "[$pattern]")
  done

fi

# Checking for yellow letters
if [[ $colors == *"Y"* ]]; then
  # Creating y_letters with all yellow letters in word

  declare -a y_letters
  declare -a y_position

  # Loop through each character position in 'colors'
  for ((i = 1; i <= ${#colors}; i++)); do
  # Check if the character at position 'i' in 'colors' is "Y"
  if [ "${colors:i-1:1}" = "Y" ]; then
        y_letters+=${word:i-1:1}
  fi
  done

  # Filtering now the word_bank based on the y_letters
  for (( i=0; i<${#y_letters}; i++ )); do
    # Construct the regular expression pattern to exclude words containing the current character
    pattern="${y_letters:i:1}"
    word_bank=$(echo "$word_bank" | grep -E "[$pattern]")
  done

  #part2
  # Loop through each character position in 'colors'
    for ((i = 0; i < ${#colors}; i++)); do
        # Check if the character at position 'i' in 'colors' is "Y"
        if [ "${colors:i:1}" = "Y" ]; then
            # Append the position to 'y_position'
            y_position+=("$((i + 1))")
        fi
    done

    # Filter words based on yellow letters and positions
    filtered_words="$word_bank"
    for ((i = 0; i < ${#y_letters[@]}; i++)); do
        letter="${y_letters[i]}"
        position="${y_position[i]}"
        # Construct the regular expression pattern for the current letter at its position
        pattern="^.{$((position - 1))}${letter}.*$"
        # Use grep with the pattern to filter words
        filtered_words=$(echo "$filtered_words" | grep -vE "$pattern")
    done
    word_bank="$filtered_words"


fi
# Checking for green letters
if [[ $colors == *"G"* ]]; then

declare -a g_letters
declare -a g_position

    # Loop through each character position in 'colors'
    for ((i = 0; i < ${#colors}; i++)); do
        # Check if the character at position 'i' in 'colors' is "G"
        if [ "${colors:i:1}" = "G" ]; then
            # Append the character at position 'i' in 'word' to 'g_letters'
            g_letters+=(${word:i:1})
            # Append the position to 'g_position'
            g_position+=("$((i + 1))")
        fi
    done

    # Filter words based on green letters and positions
    filtered_words="$word_bank"
    for ((i = 0; i < ${#g_letters[@]}; i++)); do
        letter="${g_letters[i]}"
        position="${g_position[i]}"
        # Construct the regular expression pattern for the current letter at its position
        pattern="^.{$((position - 1))}${letter}.*$"
        # Use grep with the pattern to filter words
        filtered_words=$(echo "$filtered_words" | grep -E "$pattern")
    done
    word_bank="$filtered_words"

fi


echo "$word_bank"