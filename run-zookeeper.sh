#!/bin/bash

if [[ -z "$ZKID" ]]; then
	echo "Zookeeper instance id (ZKID) not given. exiting..."
	exit 1;
fi

while [ ! -f conf/zoo.cfg ]; do
 echo "conf not found. waiting..."
 sleep 2;
done

echo "config file found. starting zookeeper..."

#create a id file
echo $ZKID > /data/zookeeper/myid

export JMXLOCALONLY JMXPORT JMXSSL JMXAUTH

#start zookeeper
bin/zkServer.sh start-foreground
