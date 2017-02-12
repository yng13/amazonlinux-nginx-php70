FROM amazonlinux:latest

MAINTAINER kentaro yanagida

RUN yum update -y
RUN yum install zip unzip sudo git -y
RUN yum install mysql56-server -y
RUN yum install php70 -y
RUN yum install php70-mysqlnd php70-mbstring php70-mcrypt php70-pdo php70-xml php70-fpm -y

# group, user add
RUN groupadd -g 900 webmaster && \
    useradd -g webmaster -G webmaster,wheel,apache -m -s /bin/bash webmaster

RUN groupadd -g 901 git && \
    useradd -g git -G webmaster,apache git

RUN chown -R root:webmaster /var/www
RUN chmod -R g+w /var/www

RUN curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer

RUN echo "NETWORKING=yes" >/etc/sysconfig/network
RUN chkconfig mysqld on && service mysqld start

RUN echo "ServerName localhost" >> /etc/httpd/conf/httpd.conf
RUN chkconfig httpd on && service httpd start

USER webmaster
RUN cd /var/www && composer create-project block8/phpci phpci --keep-vcs --no-dev
RUN cd /var/www/phpci && composer install
RUN cd /var/www/phpci && ./console phpci:install

USER root
