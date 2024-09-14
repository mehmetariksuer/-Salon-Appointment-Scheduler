#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ SALON UYGULAMASI ~~~~~\n"
echo -e "Servis uygulamasına hoş geldiniz. Lütfen seçmek istediğiniz servis numarasını giriniz:\n"

LISTELE()
{

    if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

 LIST_SERVICES=$($PSQL "SELECT * FROM services;")
 
  echo "$LIST_SERVICES" | while read ID BAR NAME
    do
      echo "$ID) $NAME"
    done
  SERVICE_SAYIM=$($PSQL "SELECT COUNT(*) FROM services;")

  read SERVICE_ID_SELECTED


  if [[ $SERVICE_ID_SELECTED -gt $SERVICE_SAYIM || $SERVICE_ID_SELECTED -lt 1 ]]
  then
    LISTELE
  else
    SORGUYAPTIR
  fi


}


  SORGUYAPTIR()
  {
    echo "Telefon numaranızı giriniz."
    read CUSTOMER_PHONE 
     CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE';")
    if [[ -z $CUSTOMER_NAME ]];
      then
      echo "girilen telefon numarasına ait müşterimiz bulunmamaktadır. Lütfen isminizi giriniz:"
      read CUSTOMER_NAME
      KOMUTGONDER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    fi   
   SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED;")
    echo -e "\nNe zaman gelmesini istiyorsunuz $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    CUSTOMER_ID1=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE' AND name='$CUSTOMER_NAME';")
  
   CUSTOMER_ID=$(echo $CUSTOMER_ID1 | xargs)
    echo "gelen customer id $CUSTOMER_ID "
  KOMUTGONDER=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, '$SERVICE_ID_SELECTED', '$SERVICE_TIME');")


echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."


if [[ $SERVICE_ID_SELECTED == 1 ]];then
echo "bire tıkladın"
fi

  }

LISTELE