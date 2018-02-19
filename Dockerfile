# Create the image from the latest image
FROM centos:latest

ARG TOMCAT_VERSION='7.0.75'
ARG JAVA_VERSION='1.7.0'

LABEL Version 1.${TOMCAT_MAJOR}
MAINTAINER dellekappa <https://github.com/dellekappa/>

ENV TOMCAT_MAJOR=`expr match "$TOMCAT_VERSION" '^[0-9]+'` \
    USER_NAME='user' \
    INSTANCE_NAME='instance'
# Install dependencies
RUN yum update -y && yum install -y wget gzip tar

# Install jdk
RUN yum install -y java-${JAVA_VERSION}-openjdk-devel && \
yum clean all

# Install Tomcat
RUN wget --no-cookies http://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/tomcat.tgz && \
tar xzvf /tmp/tomcat.tgz -C /opt && \
ln -s  /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
rm /tmp/tomcat.tgz

# Add the tomcat manager users file
ADD tomcat-users.xml /opt/tomcat/conf/

# Expose HTTP and AJP ports
EXPOSE 8080 8009

# Mount external volumes for logs and webapps
VOLUME ["/opt/tomcat/webapps", "/opt/tomcat/logs"]

ENTRYPOINT ["/opt/tomcat/bin/catalina.sh", "run"]
