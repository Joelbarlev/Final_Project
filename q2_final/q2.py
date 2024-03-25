#!/bin/python3

from flask import Flask, request
import subprocess

app = Flask(__name__)

@app.route('/', methods=['GET'])
def get():
  return str("Usage:\n1) Agg By City&Year\n2) Temporal Analysis\n3) Store Type Comparison\n\n") #Prints usage information following a GET

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

def calculate_answer(received_value):
  ret_value = None
  match received_value:
    case "1": ret_value = subprocess.run([f'mysql -u"root" -p"Jo123456" --execute="{q1}"'], shell=True, capture_output=True, text=True)
    case "2": ret_value = subprocess.run([f'mysql -u"root" -p"Jo123456" --execute="{q2}"'], shell=True, capture_output=True, text=True)
    case "3": ret_value = subprocess.run([f'mysql -u"root" -p"Jo123456" --execute="{q3}"'], shell=True, capture_output=True, text=True)
  return ret_value.stdout

if __name__ == "__main__":
  app.run(host='0.0.0.0')
