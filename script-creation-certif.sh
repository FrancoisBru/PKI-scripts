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
  sudo apt-get --yes install $REQUIRED_PKG1> /dev/null 2>/dev/null
  sudo apt-get --yes install $REQUIRED_PKG2> /dev/null 2>/dev/null
fi
figlet !!! CA root must be configured !!! -c -f smslant

sleep 2

echo "-------------------------------------------------------------------------------------------"

figlet generate a new certificate -c -f smslant

echo "-------------------------------------------------------------------------------------------"

#Create a certificate
generate_csr(){
    openssl genrsa -des3 -out server.key 2048
    echo -e "${RED} RSA keys generated successfully ${NC}"
    openssl rsa -in server.key -out server.key.insecure
    mv server.key server.key.secure
    mv server.key.insecure server.key
    openssl req -new -key server.key -out server.csr
    echo -e "${RED}CSR generated sucessfully ${NC}" 
}
generate_csr

#Generate the certificate based on the CSR
sign_certificate(){
    sudo openssl ca -in server.csr -config /etc/ssl/openssl.cnf> your-cert.pem  #| openssl x509 -outform pem > cert.pem # sign certificate according to configurations inside openssl.cnf
    if [ $? -eq 0 ];
    then
       echo -e "${RED} certificate signed sucessfully ${NC}"
    else
      echo -e "${RED} something went wrong. Please check the output above ${NC}"
    fi
}
sign_certificate

get_certificate(){
    sudo awk '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/ { print $0 }' your-cert.pem > your-cert.crt
    echo -e "${RED} certificate file created ${NC}"
    sudo mkdir -p /etc/ssl/pkcs12
    echo "donner le nom du pkcs12 et pas oublier .p12 a la fin"
    read pkcs12_name
    openssl pkcs12 -export -name "ce nom" -inkey server.key -in your-cert.crt -out $pkcs12_name  # peut être ajouter l'extension après la variable.p12 comme ça l'utilisateur n'a pas besoin d'ajouter le p.12
    if [ $? -eq 0 ];
    then
       echo -e "${RED} pkcs12 file created sucessfully ${NC}"
    else
       echo -e "${RED} something went wrong. Please check the output above ${NC}"
    fi
    sudo mv ~/generating-certif/$pkcs12_name /etc/ssl/pkcs12/
    #sudo rm -r your-cert.pem your-cert.crt
}
get_certificate

