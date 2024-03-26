#!/bin/bash

#install MySQL REMOVE COMMENTS
#sudo apt-get install mysql-server

# We had trouble using the Kaggle api in a generic way so we uploaded the csv to our drive
#zip tortilla_prices.zip tortilla_prices.csv
# Check if a zip file exists
# shellcheck disable=SC2144

#Unzip file
if [ -f *.zip ]; then
    # Unzip the file
    unzip *.zip
    echo "File unzipped successfully."
else
    echo "No zip file found."
fi

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

#Data-base setup

# MySQL Connection Details
DB_USER="root"
DB_PASSWORD="Jo123456"
# Database name
DB_NAME="tacolicious"

# Table name to create
TABLE_NAME="tortilla_prices"

# SQL command to create database if not exists
CREATE_DB_SQL="CREATE DATABASE $DB_NAME;"

# SQL command to create table with predefined columns
# SQL command to create table with predefined columns
CREATE_TABLE_SQL="CREATE TABLE $DB_NAME.$TABLE_NAME (
    State VARCHAR(20),
    City VARCHAR(20),
    Year INT,
    Month INT,
    Day INT,
    Store_type VARCHAR(20),
    Price_per_kilogram DOUBLE DEFAULT NULL
);"

# Import CSV data into MySQL table
IMPORT_DATA_SQL="LOAD DATA LOCAL INFILE 'tortilla_prices.csv' INTO TABLE $DB_NAME.$TABLE_NAME
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(State, City, Year, Month, Day, Store_type, Price_per_kilogram);"


# Connect to MySQL and execute SQL commands
echo "$CREATE_DB_SQL" | mysql --local-infile=1 -u$DB_USER -p$DB_PASSWORD
echo "$CREATE_TABLE_SQL" | mysql --local-infile=1 -u$DB_USER -p$DB_PASSWORD
echo "$IMPORT_DATA_SQL" | mysql --local-infile=1 -u$DB_USER -p$DB_PASSWORD


# Verify table by select first 3 rows from the table
SELECT_SQL="SELECT * FROM $DB_NAME.$TABLE_NAME LIMIT 3;"

# Print the first 3 rows from the table
echo "First 3 rows of the $TABLE_NAME table:"
echo "$SELECT_SQL" | mysql -u$DB_USER -p$DB_PASSWORD

echo "Database $DB_NAME, table $TABLE_NAME created, data imported, and first 3 rows printed."

