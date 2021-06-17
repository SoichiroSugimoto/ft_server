################### main #######################


# get image
FROM debian:buster

# install tools
RUN	set -ex; \
	apt-get update; \
	apt-get -y install	wget curl vim openssl \
						nginx \
						mariadb-server mariadb-client \
						php-cgi php-common php-fpm php-pear\
						php-mbstring php-zip php-net-socket php-gd php-xml-util php-gettext php-mysql php-bcmath; \
 #apt -getのcache削除
	rm -rf /var/lib/apt/lists/*

RUN sudo apt install openssl

#Configure SSL
RUN openssl req \
	-x509 \
	-nodes \
	-days 42 \
	-newkey rsa:2048 \
	-keyout /etc/ssl/private/nginx-localhost.key \
	-out /etc/ssl/certs/nginx-localhost.crt \
	-subj "/C=JP/ST=Tokyo/L=Roppongi/O=42Tokyo/OU=Free-SE-School/CN=localhost"

#install wordpress
WORKDIR /var/www/html/
RUN set -ex; \
	wget https://wordpress.org/latest.tar.gz; \
	tar -xvzf latest.tar.gz; \
	rm latest.tar.gz

WORKDIR /var/www/html/wordpress
RUN cp wp-config-sample.php wp-config.php; \
	chown -R www-data:www-data /var/www/html/wordpress


# install phpmyadmin
WORKDIR /tmp/
RUN set -ex; \
	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz; \
	tar -xvzf phpMyAdmin-5.0.2-all-languages.tar.gz; \
	rm phpMyAdmin-5.0.2-all-languages.tar.gz; \
	mv phpMyAdmin-5.0.2-all-languages phpmyadmin; \
	mv phpmyadmin/ /var/www/html/


#install Entrykit
FROM gliderlabs/alpine:3.2

ENV ENTRYKIT_VERSION 0.4.0
WORKDIR /
RUN set -ex; \
	wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz; \
	tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz; \
	rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz; \
	mv entrykit /bin/entrykit; \
	chmod +x /bin/entrykit; \
	entrykit --symlink


# put tmpl file
COPY ./srcs/default.tmpl /etc/nginx/sites-available/

# CMD tail -f /dev/null
ENTRYPOINT ["render", "/etc/nginx/sites-available/default", "--", "bash", "/tmp/service_start.sh"]