#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"

echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo "$($PSQL "SELECT * FROM services ORDER BY service_id")" | while read SERVICE_ID BAR NAME
  do
    echo -e "$SERVICE_ID) $NAME"
  done
  read SERVICE_ID_SELECTED
  if [[ $SERVICE_ID_SELECTED != 1 && $SERVICE_ID_SELECTED != 2 && $SERVICE_ID_SELECTED != 3 ]]
  then
    MAIN_MENU "Not a valid service."
  else
    echo -e "\nWhat is your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_ID ]]
    then
      echo -e "\nWhat is your name?"
      read CUSTOMER_NAME
      ADD_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers (name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi
    echo -e "\nWhat time would you like your service?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    ADD_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
    echo "I have put you down for a$SELECTED_SERVICE at $SERVICE_TIME,$CUSTOMER_NAME."
  fi
}

MAIN_MENU
