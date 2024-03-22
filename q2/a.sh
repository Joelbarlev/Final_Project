#!/bin/bash

# Full path to PostgreSQL 16 bin directory
PG_BIN_DIR="/Library/PostgreSQL/16/bin"

# Full path to PostgreSQL data directory
PG_DATA_DIR="/Library/PostgreSQL/16/data"

# Check if pg_ctl and createdb commands are available
if [ ! -x "$PG_BIN_DIR/pg_ctl" ]; then
    echo "pg_ctl command not found. Please check your PostgreSQL installation."
    exit 1
fi

if [ ! -x "$PG_BIN_DIR/createdb" ]; then
    echo "createdb command not found. Please check your PostgreSQL installation."
    exit 1
fi

# Start PostgreSQL service if not already running
if ! "$PG_BIN_DIR/pg_ctl" status &> /dev/null; then
    echo "Starting PostgreSQL service..."
    "$PG_BIN_DIR/pg_ctl" -D "$PG_DATA_DIR" start
fi

# Create a new PostgreSQL database
echo "Creating a new PostgreSQL database..."
"$PG_BIN_DIR/createdb" mydatabase

# Create a new table in the database
echo "Creating a new table..."
cat <<EOF | "$PG_BIN_DIR/psql" -d mydatabase
CREATE TABLE IF NOT EXISTS tortilla_prices (
    id SERIAL PRIMARY KEY,
    region VARCHAR,
    state VARCHAR,
    location VARCHAR,
    price_kg NUMERIC,
    currency VARCHAR,
    year INT,
    month INT,
    day INT
);
EOF

# Insert data from CSV file into the table
echo "Inserting data from CSV file..."
"$PG_BIN_DIR/psql" -d mydatabase -c "\copy tortilla_prices FROM 'tortilla_prices.csv' WITH (FORMAT CSV, HEADER);"

echo "Data inserted successfully."

# Print head of the table
echo "Printing head of the table:"
"$PG_BIN_DIR/psql" -d mydatabase -c "SELECT * FROM tortilla_prices LIMIT 5;"

# Stop PostgreSQL service
"$PG_BIN_DIR/pg_ctl" -D "$PG_DATA_DIR" stop

echo "Script execution completed."
