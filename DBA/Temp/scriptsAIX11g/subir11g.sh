 #!/bin/sh

export ORACLE_HOME=/fs/vol1/app/oracle/product/11.1.0/db_1
export AGENT_HOME=/fs/vol1/app/oracle/product/11.1.0/Middleware/agent11g

#Oracle Agent Start
echo -n "-->Start Agent: "
su - oracle -c "$AGENT_HOME/bin/emctl start agent"


# Oracle listener and instance startup
# start TNS listener
echo -n "-->Starting Listener: "
su - oracle -c "$ORACLE_HOME/bin/lsnrctl start"

# start database
echo -n "-->Starting DB: "
su - oracle  "$ORACLE_HOME/bin/dbstart"


echo "Chequear el log de salida /fs/vol1/app/oracle/product/11.1.0/db_1/startup.log "
