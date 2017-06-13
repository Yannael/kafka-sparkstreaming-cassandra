#!/bin/bash
alias notebook="jupyter notebook --ip='*'"

export PATH=/home/guest/spark/bin:home/guest/spark/sbin:home/guest/anaconda2/bin:$PATH
export PATH=/home/guest/kafka/bin:$PATH

export SPARK_HOME=/home/guest/spark

export PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH
export PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$PYTHONPATH

export JAVA_HOME=/etc/alternatives/java_sdk

export PATH=$HOME/sbt/bin:$PATH


