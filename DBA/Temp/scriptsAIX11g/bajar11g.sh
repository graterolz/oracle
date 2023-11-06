#!/bin/sh

export ORACLE_HOME=/fs/vol1/app/oracle/product/11.1.0/db_1
export AGENT_HOME=/fs/vol1/app/oracle/product/11.1.0/Middleware/agent11g

#Oracle Agent Stop
echo -n "-->Stop Agent: "
su - oracle -c "$AGENT_HOME/bin/emctl stop agent"

# Oracle listener and instance stop

# stop TNS listener
echo -n "-->Stopping Listener: "
su - oracle -c "$ORACLE_HOME/bin/lsnrctl stop"

# stop  database
echo -n "-->Stopping DB: "
su - oracle -c $ORACLE_HOME/bin/dbshut


echo "Chequear el log de salida /fs/vol1/app/oracle/product/11.1.0/db_1/shutdown.log"
