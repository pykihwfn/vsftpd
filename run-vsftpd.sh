#!/bin/bash

touch /hehe.log

if [ "$PASV_ADDRESS" = "127.0.0.1" ]
then
  PASV_ADDRESS=`ip ad | grep "inet" | grep -v "127.0.0.1" | awk -F ' ' '{print $2}' | awk -F '/' '{print $1}'
  # if not defin then PAVS_ADDRESS = container's IP`
fi
##############################
if [ "$MIN_PORT" = "50000" ]
then
  MIN_PORT=50000 
  # if not defin then MIN_PORT=50000
fi
##############################
if [ "$MAX_PORT" = "52000" ]
then
  MAX_PORT=50000 
  # if not defin then MAX_PORT=52000
fi
##############################

#begin modify vsftpd.conf file
sed -i "s/pasv_address.*/pasv_address=$PASV_ADDRESS/g" /etc/vsftpd/vsftpd.conf
sed -i "s/pasv_min_port.*/pasv_min_port=$MIN_PORT/g" /etc/vsftpd/vsftpd.conf
sed -i "s/pasv_max_port.*/pasv_max_port=$MIN_PORT/g" /etc/vsftpd/vsftpd.conf

###########################################################################
if [ "$USER" = "admin" ]
then
  USER="admin";
fi

if [ "$PASSWORD" = "admin123" ]
then
  PASSWORD=`cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c${1:-16}`;
fi



chown -R ftpuser.ftpuser /home/ftpuser

echo $USER >> /etc/vsftpd/user_list
#add user name into  /etc/vsftpd/user_list file

echo -e "$USER\n$PASSWORD" >> /etc/vsftpd/virtual_list.txt
# add USER AND PASSWORD in to virtual_list.txt

/usr/bin/db_load -T -t hash -f /etc/vsftpd/virtual_list.txt  /etc/vsftpd/vsftpd_login.db
# add USER AND PASSWORD into db file


cp /etc/vsftpd/vsftpd_user_conf/template  /etc/vsftpd/vsftpd_user_conf/$USER
#cp vsftpd_user_conf sub user's config file

###########################################################################
if [ "$DIRECTORY" != "/home/ftpuser" ]
then
  DIRECTORY=/home/ftpuser/$DIRECTORY
fi

sed -i "s#local_root.*#local_root=${DIRECTORY}#g" /etc/vsftpd/vsftpd_user_conf/$USER
###########################################################################



echo """
*******************************************
       SERVEDR SETTINGS:
       FTP ADDRESS: $PASV_ADDRESS
       FTP USER: $USER
       FTP PASSWROD:  $PASSWORD
       FTP CHROOT_DIRECTORY: $DIRECTORY
*******************************************
"""



# Run vsftpd:

&>/dev/null /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf

tail -f /dev/null
