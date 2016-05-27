#!/bin/bash

service sshd start
service cassandra start

su guest zookeeper-server-start.sh $HOME/kafka/config/zookeeper.properties  > /home/guest/zookeeper.log 2>&1 &
su guest kafka-server-start.sh $HOME/kafka/config/server.properties > /home/guest/kafka.log 2>&1 &
