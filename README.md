# ft_server<br>
## ●　PRPJECT OBJECTIVES<br>
>This is a System Administration subject. You will discover Docker and you will set up your first web server.<br>

Web sever: Nginx<br>
Application: Wordpress, phpMyAdmin<br>
Database: Maria DB<br>
Others: Open SSL, AUTOINDEX<br>
<br>
<br>
<br>
<br>

## ●　USAGE<br>
Buid :<br>
`$ docker build -t debian:buster .`　　<br>
generate an 'image' from Dockerfile on current dir.<br>
<br>
Run :　　<br>
`$ docker run -it -p 80:80 -p 443:443 debian:buster`　　<br>
generate and start a 'container' from an 'image'.
<br>
<br>
In case of Default, 
AUTOINDEX is set as `on`. 
In order to turn it `off`<br>
Run :　　<br>
`$ docker run -it -e AUTOINDEX='off' -p 80:80 -p 443:443 debian:buster `　　<br>
<br>
<br>
<br>
<br>

This project is from [42Tokyo](https://42tokyo.jp/) belongs to [42Network](https://www.42.fr/)


