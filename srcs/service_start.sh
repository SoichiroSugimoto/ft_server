service mysql start
# service --status-all なぜか[-] php7.3-fpm。stopはさむといける。
service php7.3-fpm stop
service php7.3-fpm start
service nginx start
# tail -f /var/log/nginx/access.log をすると、access.logの逐次出力になる。
tail -f /dev/null
