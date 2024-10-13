#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ Copypaste Salon ~~~~~\n"

MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nSelect option:\n"
  OPTIONS=$($PSQL "SELECT * FROM services")
  echo "$OPTIONS" | while read ID BAR NAME
  do
    echo -e "$ID) $NAME"
  done
  echo -e "\nChoose:"
  read SERVICE_ID_SELECTED
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then 
    MAIN_MENU "Choose again"
    else
      ID=$($PSQL "SELECT service_id FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      if [[ -z $ID ]]
        then
        MAIN_MENU "Choose again"
        else
        echo -e "\nEnter Number:"
        read CUSTOMER_PHONE
        GET_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
        if [[ -z $GET_NAME ]]
          then 
            echo -e "\nEnter Name:"
            read CUSTOMER_NAME
            GET_NAME=$CUSTOMER_NAME
        fi
        echo -e "\nEnter Time:"
        read SERVICE_TIME
      
      APPEND_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES ('$CUSTOMER_PHONE','$GET_NAME')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
      APPEND_APPOINTMENTS=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES($CUSTOMER_ID,$ID,'$SERVICE_TIME')")
      SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
      echo -e "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $GET_NAME."
      fi
  fi
}

MAIN_MENU
