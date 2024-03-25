#!/bin/bash

# Filtering all words that comprise of 5 letters into word_bank in caps
word_bank=$(curl https://raw.githubusercontent.com/dwyl/english-words/master/words.txt | grep -xE '[[:alpha:]]{5}' | tr '[:lower:]' '[:upper:]')

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <word> <colors>"
    exit 1
fi

# Check if both inputs are exactly 5 characters long

# Catching the inputs into parameter in upper-case
word=$(echo "$1" | tr '[:lower:]' '[:upper:]')
colors=$(echo "$2" | tr '[:lower:]' '[:upper:]')


# Filtering green letters
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
