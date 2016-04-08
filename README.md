# docker-zookeeper

## Start a zookeeper cluster

To start a 3 node zookeeper cluster run the following command

	./start-zk-cluster.sh 3
	
## Connect JConsole

Connect jconsole to the ip address of first node (name of first node will be zk1).

	jconsole $(docker inspect -f {{.NetworkSettings.IPAddress}} zk1):5000
	
The default JMX port is set to 5000, authentication=false and ssl=false. You can change the JMX configurations by modifying the script "start-zk-cluster.sh"
