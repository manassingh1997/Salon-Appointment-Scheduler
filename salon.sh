#!/bin/bash

echo -e "\n~~~~ MY SALON ~~~~\n"

PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "Welcome to My Salon, how can I help you?"

MAIN_MENU() {
  # Display the services
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi
  SERVICES_LIST=$($PSQL "SELECT * FROM services")
  echo "$SERVICES_LIST" | sed 's/|/) /'

  read SERVICE_ID_SELECTED
  
  case $SERVICE_ID_SELECTED in
    1) BOOK_SERVICE "cut" $SERVICE_ID_SELECTED;;
    2) BOOK_SERVICE "color" $SERVICE_ID_SELECTED;;
    3) BOOK_SERVICE "perm" $SERVICE_ID_SELECTED;;
    4) BOOK_SERVICE "style" $SERVICE_ID_SELECTED;;
    5) BOOK_SERVICE "trim" $SERVICE_ID_SELECTED;;
    *) MAIN_MENU "I could not find that service. What would you like today?";;
  esac

}

BOOK_SERVICE() {

  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  #if customer phone does not exist
  if [[ -z $CUSTOMER_NAME ]]
  then
  #ask name of customer
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  # add customer to database
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME');")
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # ask for time of booking
  echo -e "\nWhat time would you like your $1, $CUSTOMER_NAME?"
  read SERVICE_TIME

  # make the appointment
  BOOK_SERVICE_DETAIL=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$2,'$SERVICE_TIME');")

  echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME.\n"

  
}


MAIN_MENU 