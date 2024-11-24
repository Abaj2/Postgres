#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~ Hair Salon ~~~~\n"
MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
  echo -e "Welcome, how can we help you?\n"
  SERVICE_HAIRCUT=$($PSQL "SELECT service_id, name FROM services WHERE name = 'Haircut'" | sed -r 's/^ *| *$//g' | sed -r 's/ \|/)/')
  SERVICE_PERM=$($PSQL "SELECT service_id, name FROM services WHERE name = 'Perm'" | sed -r 's/^ *| *$//g' | sed -r 's/ \|/)/')
  SERVICE_HAIR_COLOURING=$($PSQL "SELECT service_id, name FROM services WHERE name = 'Hair-colouring'" | sed -r 's/^ *| *$//g' | sed -r 's/ \|/)/')
  echo -e "$SERVICE_HAIRCUT\n$SERVICE_PERM\n$SERVICE_HAIR_COLOURING\n4) Exit"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
  1) ENTER_DETAILS  ;;
  2) ENTER_DETAILS ;;
  3) ENTER_DETAILS ;;
  4) echo "You chose exit" ;;
  *) MAIN_MENU "Please enter a valid option" ;;
  esac
}
ENTER_DETAILS() {
  echo "Enter your phone number"
  read CUSTOMER_PHONE
  CHECKING_CUSTOMER_NAME_EXISTENCE=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CHECKING_CUSTOMER_NAME_EXISTENCE ]]
  then
    echo "What is your name?"
    read CUSTOMER_NAME
    INSERT_NAME_PHONE=$($PSQL "INSERT into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  else
    echo "Hello '$CHECKING_CUSTOMER_NAME_EXISTENCE'"
  fi
  echo "Book a time for your appointment"
  read SERVICE_TIME
  INSERT_APPOINTMENT=$($PSQL "INSERT into appointments(service_id, time) values($SERVICE_ID_SELECTED, '$SERVICE_TIME')")
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  SERVICE_NAME_FORMATTED=$(echo "$SERVICE_NAME" | sed -E "s/^[' ]+|[' ]+$//g")
  SERVICE_TIME_FORMATTED=$(echo "$SERVICE_TIME" | sed -E "s/^[' ]+|[' ]+$//g")
  CUSTOMER_NAME_FORMATTED=$(echo "$CUSTOMER_NAME" | sed -E "s/^[' ]+|[' ]+$//g")
  echo "I have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME_FORMATTED, $CUSTOMER_NAME_FORMATTED."
}
MAIN_MENU