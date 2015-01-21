# Build hadoo-base image on Ubuntu 14.04.1

FROM ubuntu:14.04.1
MAINTAINER Izhar ul Hassan "ezhaar@gmail.com"

USER root

# Setup a tmp volume for downloads
VOLUME ["/tmp"]

# install java and set JAVA_HOME
RUN apt-get update && apt-get install -y \
  wget \ 
  openjdk-7-jdk \
  openssh-server

RUN rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin:/usr/local/hadoop/bin:/usr/local/hadoop/sbin

# export hadoop variables
ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_COMMON_HOME /usr/local/hadoop
ENV HADOOP_HDFS_HOME /usr/local/hadoop
ENV HADOOP_MAPRED_HOME /usr/local/hadoop
ENV HADOOP_YARN_HOME /usr/local/hadoop
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop

# Download and extract hadoop-2.4.0 compiled by ezhaar on x86_64
RUN /usr/bin/wget \
  https://www.dropbox.com/s/4u3gkf5efpdx4op/hadoop-2.4.0.tar.gz\
  -P /tmp && tar -xzf /tmp/hadoop-2.4.0.tar.gz -C /usr/local/ && rm -rf /tmp/*

# rename hadoop
RUN mv /usr/local/hadoop-2.4.0 /usr/local/hadoop

# copy hadoop conf files 
COPY hadoop_conf/core-site.xml $HADOOP_CONF_DIR/
COPY hadoop_conf/mapred-site.xml $HADOOP_CONF_DIR/
COPY hadoop_conf/hdfs-site.xml $HADOOP_CONF_DIR/
COPY hadoop_conf/yarn-site.xml $HADOOP_CONF_DIR/
COPY hadoop_conf/hadoop-env.sh $HADOOP_CONF_DIR/

# set java_home in yarn-env.sh
RUN echo "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" | tee -a $HADOOP_CONF_DIR/yarn-env.sh

# Define default command.
CMD ["bash"]
