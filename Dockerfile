
FROM java:8

#copy zookeeper installer
COPY installer/zookeeper-3.4.8.tar.gz /temp/zookeeper-3.4.8.tar.gz

RUN mkdir /opt/zookeeper && \
	tar -xzf /temp/zookeeper-3.4.8.tar.gz --strip-components=1 -C /opt/zookeeper && \
	cd /opt/zookeeper && \
	cat conf/zoo_sample.cfg > conf/zoo.cfg

#copy the init-script
RUN mkdir /opt/zookeeper/service
COPY run-zookeeper.sh /opt/zookeeper/service
RUN chmod +x /opt/zookeeper/service/run-zookeeper.sh

#set the working dir
WORKDIR /opt/zookeeper

VOLUME ["/opt/zookeeper/conf"]
CMD service/run-zookeeper.sh

