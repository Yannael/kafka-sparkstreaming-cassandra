# Docker container for Kafka - Spark streaming - Cassandra

This Dockerfile sets up a complete streaming environment for experimenting with Kafka, Spark streaming (PySpark), and Cassandra. It installs

* Kafka 0.9.0.0
* Spark 1.6.1 for Scala 2.11
* Cassandra 2.1.7

It additionnally installs

* Anaconda 2.4 Python distribution 
* Jupyter notebook for Python 

# Container configuration details

The container is based on CentOS 6 Linux distribution. The main steps of the building process are

* Install some common Linux tools (wget, unzip, tar, ssh tools, ...), and Java (1.8)
* Create a guest user (UID important for sharing folders with host!, see below), and install Spark and sbt, Kafka, Anaconda and Jupyter notbooks for the guest user
* Go back to root user, and install startup script (for starting SSH and Cassandra services), sentenv.sh script to set up environment variables (JAVA, Kafka, Spark, ...), spark-default.conf, and Cassandra 

## User UID

In the Dockerfile, the line

````
RUN useradd guest -u 1000
```

creates the user under which the container will be run as a guest user. The username is 'guest', with password 'guest', and the '-u' parameter sets the linux UID for that user.

In order to make sharing of folders easier between the container and your host, **make sure this UID matches your user UID on the host**. You can see what your host UID is with

```
echo $UID
```


# Quick start-up guide

## Build

From Dockerfile folder, run

```
docker build -t streaming .
```

## Run

```
docker run -v `pwd`:/home/guest/host -p 4040:4040 -p 8888:8888 -p 23:22 -ti --privileged streaming
```

Note:
* The "-v `pwd`:/home/guest/host" shares the local folder (i.e. folder containing Dockerfile, ipynb files, etc...) on your computer - the 'host') with the container in the '/home/guest/host' folder. 
* Port are shared as follows:
..* 4040 will redirect to Spark UI
..* 8888 will redirect to the Jupyter Notebook

## Start services

Once run, you are logged in as root in the container. Run the startup_script.sh (in /usr/bin) to start

* SSH server. You can connect to the container using user 'guest' and password 'guest'
* Cassandra
* Zookeeper server
* Kafka server

```
startup_script.sh
```


## Connect, create Cassandra table, open notebook and start streaming

Connect as user 'guest' and go to 'host' folder (shared with the host)

```
su guest
cd host
```

Create Cassandra 'test_time' table

```
cqlsh -f init_cassandra.cql
```

Start Jupyter notebook

```
notebook
```

and connect from your browser at port host:8888 (where 'host' is the IP for your host. If run locally on your computer, this should be 127.0.0.1 or 192.168.99.100, check Docker documentation)

### Start Kafka producer

Open kafkaSendDataPy.ipynb and run all cells.

### Start Kafka receiver

Open kafkaReceiveAndSaveToCassandraPy.ipynb and run cells up to start streaming. Check in subsequent cells that Cassandra collects data properly.

### Connect to Spark UI

It is available in your browser at port 4040



