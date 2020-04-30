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
 
  cd $dir/$dir_AC_ROOT
  tree="mkdir -v certs crl newcerts private"
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
  read rootcaname
 
  echo $rootcaname
 
  echo " Set the complete URL where the root CA's downloadable certificate will be published :"  
  echo " Example : http://rootca1.miom.local/MioMRootCA.crt"
  echo " http://[<not_important>].[<yourADdomain>][/<name_of_your_certificate>.crt]"
  echo " This user gonna be define later, on the windows server, but we need to define here because certificate gonna be generate with the conf file"
  echo " Choose the url :"
  read rootcaissuerssite

  echo " Set the complete URL where the root CA's downloadable CRL will be published"
 
  echo " Example : http://rootca1.miom.local/MioMRootCA.crl"
  echo " http://[<not_important>].[<yourADdomain>][/<name_of_your_certificate>.crl]"
  echo " This user gonna be define later, on the windows server, but we need to define here because certificate gonna be generate with the conf file"
  
  read rootcrldistributionpoint  

  echo " Set the FQDN where the root CA's OCSP will be located (optional -- uncomment OCSP line in v3_root_aia)"
  echo " Example : http://rootca1.miom.local/ocsp"

  read rootocspsite

  echo "Set default like this : default_ca = CA_default"
  #echo " [ ca ]"
  read default_ca

  echo "[ $default_ca ]"
  echo "dir = $dir/$dir_AC_ROOT"
  echo "certs = $dir/$dir_AC_ROOT/certs"
  echo "crl_dir = $dir/$dir_AC_ROOT/crl"
  echo "database = $dir/$dir_AC_ROOT/index.txt"
  echo "new_certs_dir = $dir/$dir_AC_ROOT/newcerts"
  echo "certificate = $dir/$dir_AC_ROOT/private/$rootcaname.crt"
  echo "serial = $dir/$dir_AC_ROOT/serial"
  echo "crlnumber = $dir/$dir_AC_ROOT/crlnumber"
  echo "crl = $dir/$dir_AC_ROOT/crl/$rootcaname.crl"
  echo "crl_extensions = crl_ext"
  echo "private_key = $dir/$dir_AC_ROOT/private/$rootcaname.key"
  echo "RANDFILE = $dir/$dir_AC_ROOT/private/.rand"
  echo "name_opt = ca_default"
  echo "cert_opt = ca_default"
  echo -n "Set the value for default_days :"
  read cert_days
  echo "default_days = $cert_days"
  echo -n "Set the value for default_crl_days :"
  read crl_days
  echo "default_crl_days = $crl_days"
  echo -n "Set the value for default_md :"
  read hash_md
  echo "default_md = $hash_md"
  echo "preserve = no"
  echo "policy = policy_match"

  
 

}

conf_file
