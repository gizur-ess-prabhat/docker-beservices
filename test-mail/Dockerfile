from ubuntu:latest
maintainer Jonas Colmsjö <jonas@gizur.com>

RUN apt-get update
RUN apt-get install -y telnet

ADD ./testmail.txt /

CMD telnet 172.17.42.1 25 < /testmail.txt
