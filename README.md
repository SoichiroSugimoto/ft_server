# ft_server<br>
### PRPJECT OBJECTIVES<br>
>This is a System Administration subject. You will discover Docker and you will set up your first web server.

### USAGE<br>
Buid :<br>
`$ docker build -t debian:buster .`　　<br>
<br>
Run :　　<br>
`$ docker run -it -p 80:80 -p 443:443 debian:buster`　　<br>
<br>
<br>
<br>
In case of Default, 
AUTOINDEX is set as `on`. 
In order to turn it on<br>
Run :　　<br>
`$ docker run -it -e AUTOINDEX='off' -p 80:80 -p 443:443 debian:buster `　　<br>
