#Container for Kafka - Spark streaming - Cassandra
#IMPORTANT: If you wish to share folder between your host and this container, make sure the UID for user guest is the same as your UID
#Check https://github.com/Yannael/brufence/blob/master/docker/streaming/README.md for details
FROM centos:centos6

RUN yum -y update;
RUN yum -y clean all;

# Install basic tools
RUN yum install -y  wget dialog curl sudo lsof vim axel telnet nano openssh-server openssh-clients bzip2 passwd tar bc git unzip

#Install Java
RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel 

#Create guest user. IMPORTANT: Change here UID 1000 to your host UID if you plan to share folders.
RUN useradd guest -u 1000
RUN echo guest | passwd guest --stdin

ENV HOME /home/guest
WORKDIR $HOME

USER guest

#Install Spark (Spark 2.1.1 - 02/05/2017, prebuilt for Hadoop 2.7 or higher)
RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-2.1.1-bin-hadoop2.7.tgz
RUN tar xvzf spark-2.1.1-bin-hadoop2.7.tgz
RUN mv spark-2.1.1-bin-hadoop2.7 spark

ENV SPARK_HOME $HOME/spark

#Install Kafka
RUN wget http://mirrors.dotsrc.org/apache/kafka/0.10.2.1/kafka_2.11-0.10.2.1.tgz
RUN tar xvzf kafka_2.11-0.10.2.1.tgz
RUN mv kafka_2.11-0.10.2.1 kafka

ENV PATH $HOME/spark/bin:$HOME/spark/sbin:$HOME/kafka/bin:$PATH

#Install Anaconda Python distribution
RUN wget https://repo.continuum.io/archive/Anaconda2-4.4.0-Linux-x86_64.sh
RUN bash Anaconda2-4.4.0-Linux-x86_64.sh -b
ENV PATH $HOME/anaconda2/bin:$PATH
RUN conda install python=2.7.10 -y

#Install Jupyer notebook + Toree Scala kernel
RUN conda install jupyter -y 

#Install Kafka Python module
RUN pip install kafka-python

USER root

#Install Cassandra
ADD datastax.repo /etc/yum.repos.d/datastax.repo
RUN yum install -y datastax-ddc
RUN echo "/usr/lib/python2.7/site-packages" |tee /home/guest/anaconda2/lib/python2.7/site-packages/cqlshlib.pth

#Environment variables for Spark and Java
ADD setenv.sh /home/guest/setenv.sh
RUN chown guest:guest setenv.sh
RUN echo . ./setenv.sh >> .bashrc

#Startup (start SSH, Cassandra, Zookeeper, Kafka producer)
ADD startup_script.sh /usr/bin/startup_script.sh
RUN chmod +x /usr/bin/startup_script.sh

#Init Cassandra 
ADD init_cassandra.cql /home/guest/init_cassandra.cql
RUN chown guest:guest init_cassandra.cql

#Add notebooks
ADD notebooks /home/guest/notebooks
RUN chown -R guest:guest notebooks



