FROM debian:jessie
RUN apt-get update
RUN apt-get -o Acquire::Check-Valid-Until=false update

RUN apt-get install -y git curl nginx php5-fpm php5 php5-mcrypt libmyodbc unixodbc-bin php5-dev php5-mysql php5-common php5-cli php5-gd php-pear php5-cli php-apc php5-curl libxml2 libxml2-dev openssl libcurl4-openssl-dev gettext gcc g++
RUN apt-get update

RUN touch /var/log/nginx/astpp_access_log
RUN touch /var/log/nginx/astpp_error_log
RUN touch /var/log/nginx/fs_access_log
RUN touch /var/log/nginx/fs_error_log
RUN php5enmod mcrypt
RUN /etc/init.d/php5-fpm restart
RUN /etc/init.d/nginx reload

RUN mkdir -p /var/lib/astpp/
RUN mkdir -p /var/log/astpp/
RUN mkdir -p /var/www/
RUN mkdir -p /var/www/html
RUN mkdir -p /var/www/html/astpp

RUN chown -Rf root.root /var/lib/astpp/
RUN chown -Rf www-data.www-data /var/log/astpp/
RUN chown -Rf www-data.www-data /var/www/

RUN cd /usr/src/
RUN mkdir /usr/src/ASTPP
RUN mkdir /usr/src/WEBDEV
COPY /usr/src/docker-dir/ope/ASTPP /usr/src/
COPY /usr/src/docker-dir/ope/WEBDEV /usr/src/

RUN cp /usr/src/ASTPP/config/* /var/lib/astpp/
RUN cp -rf /usr/src/ASTPP/web_interface/astpp/* /var/www/html/astpp/
RUN chown -Rf www-data.www-data /var/www/html/astpp
RUN cp /usr/src/ASTPP/web_interface/nginx/deb_* /etc/nginx/conf.d/

RUN chmod -Rf 755 /var/www/html/astpp
RUN touch /var/log/astpp/astpp.log
RUN chown -Rf www-data.www-data /var/log/astpp/astpp.log

RUN sed -i "s#dbpass = <PASSSWORD>#dbpass = kiiiSjFpI7zxGvxv#g" /var/lib/astpp/astpp-config.conf
RUN sed -i "s#DB_PASSWD=\"<PASSSWORD>\"#DB_PASSWD = \"kiiiSjFpI7zxGvxv\"#g" /var/lib/astpp/astpp.lua

RUN sed -i "s#short_open_tag = Off#short_open_tag = On#g" /etc/php.ini

ENTRYPOINT service nginx restart && bash
ENTRYPOINT service php5-fpm restart && bash
ENTRYPOINT service mysql restart && bash
