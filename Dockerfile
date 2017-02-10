FROM amazonlinux:latest

MAINTAINER kentaro yanagida

RUN yum update -y
RUN yum install php70 -y
RUN yum install php70-mysqlnd php70-mbstring php70-mcrypt php70-pdo php70-xml php70-fpm -y
# RUN yum install nginx -y
