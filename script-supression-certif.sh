#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
REQUIRED_PKG1="figlet"
REQUIRED_PKG2="openssl"
PKG_OK1=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG1|grep "Package already installed")
PKG_OK2=$(dpkg-query -W --showformat='${Status}\n' $REQUIRED_PKG2|grep "Package already installed")

echo Checking for $REQUIRED_PKG1: $PKG_OK1 && echo Checking for $REQUIRED_PKG2: $PKG_OK2
if [ "" = "$PKG_OK1" ] && [ "" = "$PKG_OK2" ] ; then
  echo "No $REQUIRED_PKG1. Setting up $REQUIRED_PKG1."
  echo "No $REQUIRED_PKG2. Setting up $REQUIRED_PKG2."
  sudo apt-get --yes install $REQUIRED_PKG1 > /dev/null 2>/dev/null
  sudo apt-get --yes install $REQUIRED_PKG2 > /dev/null 2>/dev/null 
fi
figlet !!! CA root must be configured !!! -c -f smslant

sleep 2

echo "-------------------------------------------------------------------------------------------"

figlet You are about to delete a certificate -c -f smslant

echo "-------------------------------------------------------------------------------------------"

delete_certificate(){
    echo "please, enter a certificate name as displayed in the /etc/ssl/newcerts/ path"
    echo "it should be number.pem format. For example : 01.pem"
    read certif_name
    sudo openssl ca -config /etc/ssl/openssl.cnf -revoke /etc/ssl/newcerts/$certif_name -crl_reason superseded
    if [ $? -eq 0 ];
    then            
       echo -e "${RED} certificate deleted sucessfully ${NC}"
    else
      echo -e "${RED} something went wrong. Please check the output above ${NC}"
    fi
}
delete_certificate
