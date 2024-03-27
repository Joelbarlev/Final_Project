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

