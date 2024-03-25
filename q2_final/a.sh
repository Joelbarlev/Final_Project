#!/bin/bash

#install MySQL
sudo apt-get install mysql-server

# We had trouble using the Kaggle api in a generic way so we uploaded the csv to our drive

# Define the file name
file_name="tortilla_prices.csv"

# Check if the file already exists-We got annoyed of deleting it after each iteration
if [ -f "$file_name" ]; then
    echo "File already exists. No need to download again."
else
    # Extract the file ID from the shareable link
    file_id="1M2Tb1yO5X3qy3a1T4gV_Wy03YHJwFCdC"

    # Download the file
    curl -c ./cookie.txt -s -L "https://drive.google.com/uc?export=download&id=${file_id}" > /dev/null

    confirm_token="$(awk '/confirm=/{print $NF}' ./cookie.txt)"

    # Download the file using the confirm token and name it tortilla_prices.csv
    curl -Lb ./cookie.txt "https://drive.google.com/uc?export=download&confirm=${confirm_token}&id=${file_id}" -o "$file_name"

    # Clean up the cookie file
    rm ./cookie.txt
fi
