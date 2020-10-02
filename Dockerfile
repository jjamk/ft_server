FROM debian:buster

RUN apt-get update && apt-get -y upgrade 

RUN apt-get install -y nginx openssl php-fpm \
	mariadb-server \
	php-mysql \
	php-mbstring

RUN openssl req -x509 -newkey rsa:4096 -nodes -sha256 -keyout \
	ft_server.key -out ft_server.crt -days 365 -subj \
	"/C=KR/ST=SEOUL/L=SEOUL/O=42/OU=gun/CN=localhost" &&\
	mkdir /etc/nginx/ssl &&\
	mv ft_server.key /etc/nginx/ssl &&\
	mv ft_server.crt /etc/nginx/ssl &&\
	chmod 600 /etc/nginx/ssl/* 

RUN apt-get install -y wget && wget https://wordpress.org/latest.tar.gz &&\
	tar -xvf latest.tar.gz
RUN rm -rf latest.tar.gz && mv /wordpress /var/www/html/ &&\
	chown www-data:www-data /var/www/html/wordpress &&\
	mv /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php

RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz &&\
	tar -xvf phpMyAdmin-5.0.2-all-languages.tar.gz &&\
	rm -rf phpMyAdmin-5.0.2-all-languages.tar.gz &&\
	mv phpMyAdmin-5.0.2-all-languages phpmyadmin

RUN service mysql start &&\
	mv /phpmyadmin /var/www/html/ &&\
	mv /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php

ENTRYPOINT ["bin/bash"]
