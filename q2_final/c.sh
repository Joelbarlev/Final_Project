#!/bin/bash

#This SQL query analyzes the change in average tortilla prices over consecutive years.
#It calculates the difference in price between each pair of consecutive years,
#categorizing the change as an increase, decrease, or no change, and presents the results indicating the start year,
#end year, price trend, and absolute price change for each period.

curl 127.0.0.1:5000 -X POST -d 4


# The data indicates a relative persistent  increase in price and a price dip for tortillas
# between 2018-2020 and then came back up.
# While broader economic factors may not precisely pinpoint the cause,
# the COVID-19 pandemic emerges as a likely explanation. Restaurant
# closures might have reduced demand for bulk tortillas,
# while increased home cooking may not have fully offset that effect.
# Labor shortages or government interventions during the pandemic could have
# further influenced prices. To strengthen this explanation,
# additional research into the tortilla industry's performance specifically
# during COVID-19 would be beneficial.