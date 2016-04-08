#!/bin/bash

#pull image from docker hub
docker pull eldho/docker-zookeeper

COUNT=$1
if [[ -z "$COUNT" ]]; then COUNT=1; fi

#JMX Management variables
JMX=" -e JMXLOCALONLY=false -e JMXPORT=5000 -e JMXSSL=false -e JMXAUTH=false"

echo "******* Starting a $COUNT node Zookeeper cluster *********"
#start all the containers
for ((i=1; i<=$COUNT; i++))
do
	#if container exists remove it
	CID=$(docker ps -a -f name=zk$i --format {{.ID}})
		
	if [[ -n "$CID" ]]; then 
		echo -n "Removing existing container zk$i ... "
		docker stop $CID > /dev/null
		docker rm $CID > /dev/null
		echo "removed"
	fi

	CID=$(docker run -d -it -P --name=zk$i -e ZKID=$i $JMX eldho/docker-zookeeper)
	
	echo "started node zk$i"
done

#grab the initial config from first container
CONF=$(docker exec -it zk1 bash -c "cat /opt/zookeeper/conf/zoo.cfg.initial")

#grab the ip of each node and append to conf
for ((i=1; i<=$COUNT; i++))
do
	IP_ADDR=$(docker inspect -f {{.NetworkSettings.IPAddress}} zk$i)
	CONF=$CONF$'\n'"server.$i=$IP_ADDR:2888:3888"
done

#push the conf file to each container
for ((i=1; i<=$COUNT; i++))
do
	echo "$CONF" | docker exec -i zk$i bash -c 'cat > /opt/zookeeper/conf/zoo.cfg'
done

#After the conf file is pushed, the startup script on each container will read
#the config file and start zookeeper 

echo "******* Started *******"
	
