FROM tomcat:9.0
MAINTAINER SiarheiPrakhin

ARG NEXUS_REPO_ARG=default_value

ADD $NEXUS_REPO_ARG /usr/local/tomcat/webapps/
