#!/bin/python3

from flask import Flask, request
import subprocess

app = Flask(__name__)

@app.route('/', methods=['GET'])
def get():
  return str("Options:\n1) Agg By City&Year\n2) Temporal Analysis\n3) Store Type Comparison\n4) Price Trend report (C)\n\n\n") #Displays instructions after performing a GET request.








@app.route('/', methods=['POST'])
def post():
  received_value = str(request.get_data(as_text=True)) #Gets the data from the POST request
  answer = calculate_answer(received_value)
  return str(answer) #Returns the data to the user

#Aggregation by City and Year
q1 = '''
SELECT City, Year, AVG(Price_per_kilogram) AS Average_Price
FROM tacolicious.tortilla_prices
GROUP BY City, Year;
'''

#Temporal Analysis: Identify the trend of tortilla prices over the years.
q2 = '''
SELECT Year, AVG(Price_per_kilogram) AS Average_Price
FROM tacolicious.tortilla_prices
GROUP BY Year
ORDER BY Year;
'''

#Store Type Comparison:Compare the average prices of tortillas between store types.
q3 = '''
SELECT Store_type, AVG(Price_per_kilogram) AS Average_Price
FROM tacolicious.tortilla_prices
GROUP BY Store_type;
'''
#intresting query
c='''WITH yearly_prices AS (
    SELECT
        Year,
        AVG(Price_per_kilogram) AS Average_Price,
        ROW_NUMBER() OVER (ORDER BY Year) AS Year_Rank
    FROM
        tacolicious.tortilla_prices
    GROUP BY
        Year
),
price_change AS (
    SELECT
        a.Year AS Start_Year,
        b.Year AS End_Year,
        b.Average_Price - a.Average_Price AS Price_Change
    FROM
        yearly_prices a
    JOIN
        yearly_prices b ON a.Year_Rank = b.Year_Rank - 1
)
SELECT
    Start_Year,
    End_Year,
    CASE
        WHEN Price_Change > 0 THEN 'Increase'
        WHEN Price_Change < 0 THEN 'Decrease'
        ELSE 'No Change'
    END AS Price_Trend,
    ABS(Price_Change) AS Absolute_Price_Change
FROM
    price_change;
'''

#Instert password and user
def calculate_answer(received_value):
  ret_value = None
  match received_value:
    case "1": ret_value = subprocess.run([f'mysql -u"root" -p"Jo123456" --execute="{q1}"'], shell=True, capture_output=True, text=True)
    case "2": ret_value = subprocess.run([f'mysql -u"root" -p"Jo123456" --execute="{q2}"'], shell=True, capture_output=True, text=True)
    case "3": ret_value = subprocess.run([f'mysql -u"root" -p"Jo123456" --execute="{q3}"'], shell=True, capture_output=True, text=True)
    case "4": ret_value = subprocess.run([f'mysql -u"root" -p"Jo123456" --execute="{c}"'], shell=True, capture_output=True, text=True)
  return ret_value.stdout

if __name__ == "__main__":
  app.run(host='0.0.0.0')
