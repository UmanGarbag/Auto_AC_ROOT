#!/bin/bash


 
#Creation de l'arboresence


dir=/etc/ssl
dir_AC_ROOT=AC_ROOT

#Rm les directory pour le test

rm -rf $dir/$dir_AC_ROOT/ 2> /dev/null
#Creation du répertoire qui va accueillir notre arboresence

create_tree(){
 
  entry_dir="mkdir -v $dir/$dir_AC_ROOT"
  $entry_dir
  echo $?
  if (($? == 0))
     then
	   echo "entry_dir successful creation !"
  else
	  echo "Error creation = $?"
  fi

  touch $dir/$dir_AC_ROOT/crlnumber 
  touch $dir/$dir_AC_ROOT/index.txt
  touch $dir/$dir_AC_ROOT/serial

  echo 01 > $dir/$dir_AC_ROOT/serial
  echo 01 > $dir/$dir_AC_ROOT/crlnumber
 
  #cd $dir/$dir_AC_ROOT
  tree="mkdir $dir/$dir_AC_ROOT/{certs,crl,newcerts,private}"
  $tree
  echo $?
  if (($?  == 0))
     then
  	  echo "tree successful creation !"
  else 
	  echo "Error creation = $?"
  fi
} 
#create_tree
#pwd //affiche le chemin courant

#Generation d'un fichier aléatoire pour générer la clé privé

#openssl rand -out  private/.rand 5791

conf_file(){ 
  echo "Choose your CA root name :"
  read CAname
  echo "rootcaname=$CAname" > openssl.cnf
   printf "\n" >> openssl.cnf 
#  echo $rootcaname
 
  echo " Set the complete URL where the root CA's downloadable certificate will be published :"  
  echo " Example : http://rootca1.miom.local/MioMRootCA.crt"
  echo " http://[<not_important>].[<yourADdomain>][/<name_of_your_certificate>.crt]"
  echo " This user gonna be define later, on the windows server, but we need to define here because certificate gonna be generate with the conf file"
  echo " Choose the url :"
  read rootcaissuer
  echo "rootcaissuerssite = $rootcaissuer"
   printf "\n" >> openssl.cnf
  echo " Set the complete URL where the root CA's downloadable CRL will be published"
 
  echo " Example : http://rootca1.miom.local/MioMRootCA.crl"
  echo " http://[<not_important>].[<yourADdomain>][/<name_of_your_certificate>.crl]"
  echo " This user gonna be define later, on the windows server, but we need to define here because certificate gonna be generate with the conf file"
  
  read rootcrl
  echo "rootcrldistributionpoint = $rootcrl" 
  printf "\n" >> openssl.cnf

  echo " Set the FQDN where the root CA's OCSP will be located (optional -- uncomment OCSP line in v3_root_aia)"
  echo " Example : http://rootca1.miom.local/ocsp"

  read rootocsp 
  echo "rootocspsite = $rootocsp" >> openssl.cnf
  printf "\n" >> openssl.cnf

  echo "Set default like this : default_ca = CA_default"
  echo " [ ca ]" >> openssl.cnf
   printf "\n" >> openssl.cnf
  read default_ca >> openssl.cnf
  

  echo "[ $default_ca ]" >> openssl.cnf

  echo "dir = $dir/$dir_AC_ROOT" >> openssl.cnf

  echo "certs = $dir/$dir_AC_ROOT/certs" >> openssl.cnf

  echo "crl_dir = $dir/$dir_AC_ROOT/crl" >> openssl.cnf

  echo "database = $dir/$dir_AC_ROOT/index.txt" >> openssl.cnf

  echo "new_certs_dir = $dir/$dir_AC_ROOT/newcerts" >> openssl.cnf

  echo "certificate = $dir/$dir_AC_ROOT/private/$rootcaname.crt" >> openssl.cnf

  echo "serial = $dir/$dir_AC_ROOT/serial" >> openssl.cnf

  echo "crlnumber = $dir/$dir_AC_ROOT/crlnumber" >> openssl.cnf

  echo "crl = $dir/$dir_AC_ROOT/crl/$rootcaname.crl" >> openssl.cnf

  echo "crl_extensions = crl_ext" >> openssl.cnf

  echo "private_key = $dir/$dir_AC_ROOT/private/$rootcaname.key" >> openssl.cnf

  echo "RANDFILE = $dir/$dir_AC_ROOT/private/.rand" >> openssl.cnf

  echo "name_opt = ca_default" >> openssl.cnf

  echo "cert_opt = ca_default" >> openssl.cnf

  echo -n "Set the value for default_days :"
  read cert_days 
  echo "default_days = $cert_days" >> openssl.cnf
  echo -n "Set the value for default_crl_days :"
  read crl_days
  echo "default_crl_days = $crl_days" >> openssl.cnf
  echo -n "Set the value for default_md :"
  read hash_md
  echo "default_md = $hash_md" >> openssl.cnf
  echo "preserve = no" >> openssl.cnf
  printf "\n" >> openssl.cnf
  echo "policy = policy_match"
  printf "\n" >> openssl.cnf
  echo " [ policy_match ]" >> openssl.cnf
  read CN
  echo "commonName=$CN"
  printf "\n" >> openssl.cnf
#----------------------SECTION REQ-----------------------------# 
  echo " [ req ]" >> openssl.cnf
  echo "Set the default bit for the key :"
  read key_length
  echo "default_bits = $key_length" >> openssl.cnf
  echo "distinguished_name = req_distinguished_name" >> openssl.cnf
  echo "x509_extensions = v3_ca" >> openssl.cnf
  echo "string_mask = utf8only" >> openssl.cnf
   
#-------------------SECTION REQ_DISTINGUISHED_NAME--------------#
  print "\n" >> openssl.cnf
  echo "[ req_distinguished_name ]" >> openssl.cnf
  echo "commonName = Common Name (e.g. server FQDN or YOUR name)" >> openssl.cnf
  echo "commonName_max = 64" >> openssl.cnf

#------------------SECTION V3_ca--------------------------------#
  print "\n" >> openssl.cnf
  echo "[ v3_ca ]" >> openssl.cnf
  echo "subjectKeyIdentifier=hash" >> openssl.cnf
  echo "authorityKeyIdentifier=keyid:always,issuer" >> openssl.cnf
  echo "basicConstraints=critical,CA:true" >> openssl.cnf
  echo "keyUsage=critical,digitalSignature,cRLSign,keyCertSign" >> openssl.cnf

#-----------------SECTION V3_subca-------------------------------#
  print "\n" >> openssl.cnf
  echo "[ v3_subca ]" >> openssl.cnf
  echo "subjectKeyIdentifier=hash" >> openssl.cnf
  echo "authorityKeyIdentifier=keyid:always,issuer" >> openssl.cnf
  echo "basicConstraints=critical,CA:true,pathlen:1" >> openssl.cnf
  echo "keyUsage=critical,digitalSignature,cRLSign,keyCertSign" >> openssl.cnf
  echo "authorityInfoAccess = @v3_root_aia" >> openssl.cnf
  echo "crlDistributionPoints = URI:$rootcrldistributionpoint" >> openssl.cnf
  print "\n" >> openssl.cnf
#------------------SECTION V3_root_aia----------------------------#
  echo "[ v3_root_aia ]" >> openssl.cnf
  echo "caIssuers;URI=$rootcaissuerssite" >> openssl.cnf
  echo "#OCSP;URI=$rootocspsite" >> openssl.cnf

#------------------SECTION crl_ext--------------------------------#
  print "\n" >> openssl.cnf
  echo "[ crl_ext ]" >> openssl.cnf
  echo "authorityKeyIdentifier=keyid:always" >> openssl.cnf
  echo "issuerAltName=issuer:copy" >> openssl.cnf




conf_file
