#!/bin/bash

#install MySQL
sudo apt-get install mysql-server

# MySQL Connection Details
DB_USER="root"
DB_PASSWORD="Jo123456"

# Database name
DB_NAME="q2"

# Table name to create
TABLE_NAME="tortilla_prices"

# SQL command to create database if not exists
CREATE_DB_SQL="CREATE DATABASE IF NOT EXISTS $DB_NAME;"

# SQL command to create table with predefined columns
CREATE_TABLE_SQL="CREATE TABLE IF NOT EXISTS $DB_NAME.$TABLE_NAME (
    id INT AUTO_INCREMENT PRIMARY KEY,
    State VARCHAR(255),
    City VARCHAR(255),
    Year INT,
    Month INT,
    Day INT,
    Store_type VARCHAR(255),
    Price_per_kilogram VARCHAR(255)
);"

# Import CSV data into MySQL table
IMPORT_DATA_SQL="LOAD DATA LOCAL INFILE 'tortilla_prices.csv' INTO TABLE $DB_NAME.$TABLE_NAME
FIELDS TERMINATED BY ','
ENCLOSED BY '\"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;"

# Connect to MySQL and execute SQL commands
echo "$CREATE_DB_SQL" | mysql --local-infile=1 -u$DB_USER -p$DB_PASSWORD
echo "$CREATE_TABLE_SQL" | mysql --local-infile=1 -u$DB_USER -p$DB_PASSWORD
echo "$IMPORT_DATA_SQL" | mysql --local-infile=1 -u$DB_USER -p$DB_PASSWORD

# Select first 3 rows from the table
SELECT_SQL="SELECT * FROM $DB_NAME.$TABLE_NAME LIMIT 1, 3;"

# Print the first 3 rows from the table
echo "First 3 rows of the $TABLE_NAME table:"
echo "$SELECT_SQL" | mysql -u$DB_USER -p$DB_PASSWORD

echo "Database $DB_NAME, table $TABLE_NAME created, data imported, and first 3 rows printed."

#PART 2
#saving the table created as a file to later query

# Select all rows from the table
SELECT_SQL="SELECT * FROM $DB_NAME.$TABLE_NAME;"

# File path to save the table data
OUTPUT_FILE="tortilla_prices_table.txt"

# Check if the output file already exists
if [ ! -e "$OUTPUT_FILE" ]; then
    # Save the contents of the table to a file
    echo "Saving table $TABLE_NAME to $OUTPUT_FILE..."
    echo "$SELECT_SQL" | mysql -u$DB_USER -p$DB_PASSWORD > $OUTPUT_FILE
    echo "Database $DB_NAME, table $TABLE_NAME created, data imported, and table saved to $OUTPUT_FILE."
else
    echo "Output file $OUTPUT_FILE already exists. Skipping saving the table data."
fi