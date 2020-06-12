#!/bin/bash

USER=$1
PASSWORD=$2
DIRECTORY=$3

if [ $# != "3" ];then
  echo """
********************
  Usage: $0 USER PASSWORD DIRECTORY
  Example:  $0 user1 abcd123  web
********************
"""
  exit 2  
fi

##USER IN /etc/vsftpd/virtual_list.txt file OR NOT
awk '{if(NR%2==1) {print $1}}' /etc/vsftpd/virtual_list.txt >> /tmp/1.log
if [ `grep -w $USER /tmp/1.log` ]
then
  echo "USER: $USER was exist..pls retry another USER NAME"
  rm -f /tmp/1.log
  exit 2
fi

:<<!
if [ `awk '{if(NR%2==1 && $0=="$USER") {print $0}}' /etc/vsftpd/virtual_list.txt` ];then
  echo "USER: $USER was exist....pls retroy"
  exit 2
fi
!

echo -e "$USER\n$PASSWORD" >> /etc/vsftpd/virtual_list.txt
# add USER AND PASSOWRD into  /etc/vsftpd/virtual_list.txt file

/usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_list.txt  /etc/vsftpd/vsftpd_login.db
# add USER and PASSOWRD into db file

echo $USER >> /etc/vsftpd/user_list
#add user name into  /etc/vsftpd/user_list file

cp /etc/vsftpd/vsftpd_user_conf/template  /etc/vsftpd/vsftpd_user_conf/$USER
#cp vsftpd_user_conf sub user's config file


DIRECTORY=/home/ftpuser/$DIRECTORY
sed -i "s#local_root.*#local_root=${DIRECTORY}#g" /etc/vsftpd/vsftpd_user_conf/$USER
#modify local_root
rm -f /tmp/1.log
echo """
----------------------------
congratulation, USER create successful.
USER: $USER
PASSWORD: $PASSWORD
DIRECTORY: $DIRECTORY
----------------------------

"""
