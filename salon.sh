#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Salon services ~~~~~"

MAIN_MENU_SERVICES(){
  #display services
  echo -e "\nChoose a service\n"
  SERVICES_LIST=$($PSQL "SELECT * FROM services")
  echo "$SERVICES_LIST" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done
  #enter service_id
  read SERVICE_ID_SELECTED
  #check if service no exist
  SERVICE_ID_RESULT=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_ID_RESULT ]]
  then
    MAIN_MENU_SERVICES
  else
    #ask for phone
    echo -e "\nInsert your phone number:"
    read CUSTOMER_PHONE
    #check if phone exist
    CUSTOMER_PHONE_SELECT=$($PSQL "SELECT phone FROM customers WHERE phone ='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_PHONE_SELECT ]]
    then
      #if not ask name
      echo -e "\nInsert your name:"
      read CUSTOMER_NAME
      #add customer phone and name
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    fi
    #ask for service time
    echo -e "\nInsert service time:"
    read SERVICE_TIME
    #insert data into appointments table
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
    #final message
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}
MAIN_MENU_SERVICES
