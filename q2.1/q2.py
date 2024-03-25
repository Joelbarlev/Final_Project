#!/bin/python3

from flask import Flask, request
import subprocess
app = Flask(__name__)

@app.route('/', methods=['GET'])
def get():
  return str("Usage:") #Prints usage information following a GET

@app.route('/', methods=['POST'])
def post():
  received_value = str(request.get_data(as_text=True)) #Gets the data from the POST request
  answer = calculate_answer(received_value)
  return str(answer) #Returns the data to the user

#Aggregation by City and Year
q1 = '''
    SELECT City, Year, AVG(Price_per_kilogram) AS Average_Price
FROM tortilla_prices
GROUP BY City, Year;
'''

#Temporal Analysis: Identify the trend of tortilla prices over the years.
q2 = '''
SELECT Year, AVG(Price_per_kilogram) AS Average_Price
FROM tortilla_prices
GROUP BY Year
ORDER BY Year;
'''

#Store Type Comparison:Compare the average prices of tortillas between store types.
q3 = '''
    SELECT Store_type, AVG(Price_per_kilogram) AS Average_Price
FROM tortilla_prices
GROUP BY Store_type;

'''

def calculate_answer(received_value):
  #write me
  return

if __name__ == "__main__":
  app.run(host='0.0.0.0')
