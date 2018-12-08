#!/bin/bash

### Dependencies:
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install sudo rlwrap original-awk binutils libpcap-dev gcc g++ libc6 libc6-dev ksh libaio1 libstdc++-4.8-dev libXi6 libXtst6 make sysstat build-essential gcc-multilib lib32z1 lib32ncurses5 libstdc++5 rpm xauth

### Create oinstall, oracle and dba group/user
sudo addgroup --system oinstall
sudo addgroup --system dba
sudo adduser --system --ingroup oinstall --shell /bin/bash oracle
# per comodità, possiamo anche dargli una password tipo oracle
sudo adduser oracle dba

### Add user to oinstall and dba groups
sudo gpasswd -a $USER oinstall
sudo gpasswd -a $USER dba

### Symbolic links:
sudo mkdir -p /usr/lib64
sudo ln -s /etc /etc/rc.d
sudo ln -s /usr/bin/awk /bin/awk
sudo ln -s /usr/bin/basename /bin/basename
sudo ln -s /usr/bin/rpm /bin/rpm
sudo ln -s /lib/x86_64-linux-gnu/libgcc_s.so.1 /usr/lib64/
sudo ln -s /usr/lib/x86_64-linux-gnu/libc_nonshared.a /usr/lib64/
sudo ln -s /usr/lib/x86_64-linux-gnu/libpthread_nonshared.a /usr/lib64/
sudo ln -s /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /usr/lib64/


### Directory of installation:
oraclepath="/opt/oracle-database"
orainventorypath="/opt/oraInventory"
oradatapath="/opt/oradata"
sudo mkdir -p "$oraclepath"
sudo mkdir -p "$orainventorypath"
sudo mkdir -p "$oradatapath"

### Permissions change:
sudo chown -R oracle:dba $oraclepath
sudo chown -R oracle:oinstall $orainventorypath
sudo chown -R oracle:dba $oradatapath

### envs:
ORACLE_BASE="$oraclepath"
ORACLE_HOME="$ORACLE_BASE/product/12.1.0/dbhome_1"
echo ORACLE_BASE="$ORACLE_BASE" >> ~/.profile
echo ORACLE_HOME="$ORACLE_HOME" >> ~/.profile
echo ORACLE_SID=orcl >> ~/.profile
echo ORACLE_HOME_LISTNER="$ORACLE_HOME/network/admin" >> ~/.profile
echo TNS_ADMIN="$ORACLE_HOME/network/admin" >> ~/.profile
echo LD_LIBRARY_PATH="$ORACLE_HOME/lib" >> ~/.profile
echo export ORACLE_HOME >> ~/.profile
echo export ORACLE_SID >> ~/.profile
# required for $DISPLAY
xhost +localhost
source ~/.profile

### Oracle's propietary installer init:
# installazione:
# Email: lascia vuota e vai avanti
# Crea e configura un database
# Classe desktop
# Oracle base: /opt/oracle-database
# Posizione software: /opt/oracle-database/product/12.1.0/dbhome_1
# Posizione dei file di database: /opt/oradata
# Set di caratteri: UTF8
# Gruppo OSDBA: dba
# Nome di database globale: orcl
# Password amministrativa: admin
# Crea come database contenitore: Si
# Nome database collegabile: pdborcl
# Directory inventario: /opt/oraInventory (assicurarsi che la directory esiste ed e vuota)
# Nome gruppo oraInventory: oinstall
#
# Nella schermata di riepilogo della avvenuta creazione del db
# setta passwor di:
# SYS -> sys
# SYSTEM -> system
sudo -u oracle bash ./runInstaller -IgnoreSysPreReqs

### Launcher (todo at the end of installation)
#sudo chmod a+x $ORACLE_HOME/bin/sqlplus
#sudo ln -s $ORACLE_HOME/bin/sqlplus /usr/local/bin/ 2> /dev/null

# modificare /usr/local/bin/oraenv alla riga 225 da:
# if [ ${ORACLE_BASE:-"x"} == "x" ]; then
# a:
# if [ ${ORACLE_BASE:-"x"} = "x" ]; then
