#Set the base image to Centos 6
FROM centos:6

# File Author / Maintainer
MAINTAINER vineet sharma v_vineetsharma@outlook.com

############################################## Installing Python2.7 #################################################################

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# Install prepare infrastructure 
RUN yum -y update \
&& yum groupinstall -y development \
&& yum install -y wget


RUN set -x \
        \
 && wget http://www.python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz \
 && tar -xvf Python-2.7.6.tar.xz \
 && cd Python-2.7.6 \
 && ./configure --prefix=/usr/local \
 && make \
 &&make altinstall

######################################################## Installing Apache Tomcat7 ############################################################

# Install prepare infrastructure
RUN yum -y update && \
 yum -y install wget && \
 yum -y install tar

# Prepare environment 
ENV JAVA_HOME /opt/java
ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin:$CATALINA_HOME/scripts

# Install Oracle Java8
ENV JAVA_VERSION 8u121
ENV JAVA_BUILD 8u121-b13
ENV JAVA_DL_HASH e9e7ea248e2c4826b92b3f075a80e441

RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" \
 http://download.oracle.com/otn-pub/java/jdk/${JAVA_BUILD}/${JAVA_DL_HASH}/jdk-${JAVA_VERSION}-linux-x64.tar.gz && \
 tar -xvf jdk-${JAVA_VERSION}-linux-x64.tar.gz && \
 rm jdk*.tar.gz && \
 mv jdk* ${JAVA_HOME}


# Install Tomcat
ENV TOMCAT_MAJOR 7
ENV TOMCAT_VERSION 7.0.77

RUN wget http://ftp.riken.jp/net/apache/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
 tar -xvf apache-tomcat-${TOMCAT_VERSION}.tar.gz && \
 rm apache-tomcat*.tar.gz && \
 mv apache-tomcat* ${CATALINA_HOME}

RUN chmod +x ${CATALINA_HOME}/bin/*sh

WORKDIR /opt/tomcat

EXPOSE 8080

CMD ["catalina.sh", "run"]


############################################# Installing MongoDB #######################################################################

# Install prepare infrastructure
RUN yum -y update

# Add MongoDB to the repository
COPY mongodb-org-3.4.repo /etc/yum.repos.d/mongodb-org-3.4.repo

# Install MongoDB package
RUN yum repolist
RUN yum install -y mongodb-org

RUN mkdir -p /data/db /data/configdb && chown -R mongod:mongod /data/db /data/configdb
VOLUME /data/db /data/configdb

# Expose the default port
EXPOSE 27017

CMD ["/usr/bin/mongod"]
