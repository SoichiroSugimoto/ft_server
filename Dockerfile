FROM debian:buster

RUN	set -ex; \
	apt-get update; \
	apt-get -y install \
		mariadb-server mariadb-client \
		php-cgi php-common php-fpm php-pear php-mbstring php-zip php-net-socket php-gd php-xml-util php-gettext php-mysql php-bcmath \
		wget \
		curl \
		vim \
		openssl \
		nginx; \
	rm -rf /var/lib/apt/lists/*

RUN service mysql start && \
	mysql -u root -e \
	"create database wpdb; \
	grant all on wordpress.* to 'wpuser'@'localhost' identified by 'dbpassword'; \
	GRANT ALL PRIVILEGES ON wpdb.* TO 'wpuser'@'localhost'; \
	FLUSH PRIVILEGES;"

WORKDIR /var/www/html/
RUN wget https://wordpress.org/latest.tar.gz && \
	tar -xvzf latest.tar.gz && \
	rm latest.tar.gz;

WORKDIR /var/www/html/wordpress
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz; \
	tar -xvzf phpMyAdmin-5.0.2-all-languages.tar.gz; \
	mv phpMyAdmin-5.0.2-all-languages phpMyAdmin; \
	rm phpMyAdmin-5.0.2-all-languages.tar.gz;

RUN openssl genrsa -out /etc/ssl/private/server.key 2048 && \
	openssl req -new -key /etc/ssl/private/server.key -out /etc/ssl/certs/server.csr -subj "/C=/ST=/L=/O=/OU=/CN=" && \
	openssl x509 -days 3650 -req -signkey /etc/ssl/private/server.key -in /etc/ssl/certs/server.csr -out /etc/ssl/certs/server.crt

COPY ./srcs/wp-config.php /var/www/html/wordpress
COPY ./srcs/config.inc.php /var/www/html/wordpress/phpMyAdmin
COPY ./srcs/default /etc/nginx/sites-available/

RUN chown -R www-data:www-data "/var/www/html/wordpress" && \
	find /var/www/html/wordpress -type d -exec chmod 755 {} + && \
	find /var/www/html/wordpress -type f -exec chmod 644 {} +

RUN chown -R www-data:www-data "/var/www/html/wordpress/phpMyAdmin" && \
	find /var/www/html/wordpress/phpMyAdmin -type d -exec chmod 755 {} + && \
	find /var/www/html/wordpress/phpMyAdmin -type f -exec chmod 644 {} +

EXPOSE 80 443

CMD service nginx start && \
	service php7.3-fpm start && \
	service php7.3-fpm restart && \
	service mysql start && \
	tail -f /dev/null;