#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

# echo $($PSQL "TRUNCATE appointments, customers")

MAIN_MENU(){ 
  # if function call text not provided go with generic welcome otherwise, use that text
  if [[ $1 ]]
  then
    echo -e "\n$1"
  else
    echo -e "Welcome to My Salon, how can I help you?\n"
  fi

  service_options=$($PSQL "SELECT service_id, name FROM services") 
  echo "$service_options" | while read SERVICE_ID BAR NAME #CUT BAR COLOR BAR PERM BAR STYLE BAR TRIM
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in 
    1) services_menu ;;
    2) services_menu ;;
    3) services_menu ;;
    4) services_menu ;;
    5) services_menu ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

services_menu() {
  SERVICE_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
  # get customer info
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  # If phone number isn't in the list
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    # insert new customer
    INSERT_CUSTOMER_NAME=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  else # if phone number exists
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  fi 
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  
  echo -e "\nWhat time would you like your color, $CUSTOMER_NAME?"
  read SERVICE_TIME
  INSERT_APPT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $SERVICE_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU #"Welcome to My Salon, how can I help you?"

















# CREATE DATABASE salon;

# \c salon
# CREATE TABLE customers(customer_id SERIAL PRIMARY KEY, 
#                        phone VARCHAR(15) UNIQUE,
#                        name VARCHAR(40) 
#                       );
                      
# CREATE TABLE appointments(appointment_id SERIAL PRIMARY KEY, 
#                           customer_id SERIAL NOT NULL,
#                           service_id SERIAL NOT NULL,
#                           time VARCHAR(40)
#                          );

# CREATE TABLE services(service_id SERIAL PRIMARY KEY, 
#                        name VARCHAR(40) UNIQUE
#                       );

# ALTER TABLE appointments ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
# ALTER TABLE appointments ADD FOREIGN KEY (service_id) REFERENCES services(service_id);
# INSERT INTO services(name) VALUES ('cut'), ('color'), ('perm'), ('style'), ('trim');
