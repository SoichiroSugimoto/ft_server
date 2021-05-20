################### main ########################


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

# install phpmyadmin
WORKDIR /tmp/
RUN set -ex; \
	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz; \
	tar -xvzf phpMyAdmin-5.0.2-all-languages.tar.gz; \
	rm phpMyAdmin-5.0.2-all-languages.tar.gz; \
	mv phpMyAdmin-5.0.2-all-languages phpmyadmin; \
	mv phpmyadmin/ /var/www/html/


# put tmpl file
COPY ./srcs/default.tmpl /etc/nginx/sites-available/

# CMD tail -f /dev/null
ENTRYPOINT ["render", "/etc/nginx/sites-available/default", "--", "bash", "/tmp/service_start.sh"]