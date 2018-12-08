# start net
sudo -u oracle $ORACLE_HOME/bin/dbstart $ORACLE_HOME

# stop net
#sudo -u oracle $ORACLE_HOME/bin/dbshut $ORACLE_HOME

# una volta dentro:
# start -> STARTUP;
# stop -> SHUTDOWN;
# exit -> EXIT;
sqlplus / as sysdba
