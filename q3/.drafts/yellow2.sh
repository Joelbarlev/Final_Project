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


# Filtering yellow letters
if [[ $colors == *"Y"* ]]; then

#PART 1 : Fetch words that contain yellow letters ( no matter the position)
 # Initialize an empty string to store yellow letters
    yellow_letters=""

    # Loop through each character position in 'colors'
    for ((i = 0; i < ${#colors}; i++)); do
        # Check if the character at position 'i' in 'colors' is "Y"
        if [ "${colors:i:1}" = "Y" ]; then
            # Append the character at position 'i' in 'word' to 'yellow_letters'
            yellow_letters+="${word:i:1}"
        fi
    done

    # Initialize an empty string to store the grep pattern
    grep_pattern=""

    # Loop through each character in 'yellow_letters' to construct the grep pattern
    for ((i = 0; i < ${#yellow_letters}; i++)); do
        # Append the character at position 'i' in 'yellow_letters' to the grep pattern
        grep_pattern+="${yellow_letters:i:1}"
    done

    # Fetch words from the word_bank that contain the yellow letters
    word_bank=$(echo "$word_bank" | grep -i "$grep_pattern")


#PART 2 : Exclude the words that the yellow letter is found in the same position as word
# Define arrays for y_letters and y_position
declare -a y_letters
declare -a y_position

    # Loop through each character position in 'colors'
    for ((i = 0; i < ${#colors}; i++)); do
        # Check if the character at position 'i' in 'colors' is "Y"
        if [ "${colors:i:1}" = "Y" ]; then
            # Append the character at position 'i' in 'word' to 'y_letters'
            y_letters+=(${word:i:1})
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
        filtered_words=$(echo "$filtered_words" | grep -Ev "$pattern")
    done

    word_bank="$filtered_words"

fi

echo "$word_bank"
