Gizur backend services
======================

A collection of services used by the applications hosted in Gizur's private
docker cloud.

These services are collected into one container in order to simplfy
for the applications. Services here should be stable and change infrequently.
Containers with applications should `--link` to a beservices container at
start.

First create `Dockerfile` by copying `Dockerfile.template`. Update the settings
for the mail server, see below.

Build the image: `docker build -t beservices .`

Starting the server this way makes it possible to connect and reconnect to the
server:

    docker run -t -i -p 9200:9200 -p 9292:9292  -p 10000:10000 \
    --restart="on-failure:10" --name beservices -h beservices \
    beservices /bin/bash -c "supervisord; bash"

Exit the server with `ctrl-p` `ctrl-q`. Reconnect with `docker attach logserver`


logstash and elasticsearch
-------------------------

This container has a logstash server running and listening on UDP port 5514.
Any client (container in the network) can log to this logstash server.

There is also an elsticsearch instance that makes it easy to search the logs.
The kibana frontend of elasticsearch is reached port 9292.

There is a example of a client configuration in `rsyslog.conf.client`.
Test to print to syslog with `logger` from a client to make sure things are ok.


rsyslog
---------

This container has a rsyslog server running and listening on UDP port 514.
Any client (container in the network) can log to this rsyslog server.

NOTE: Use logstash for ordinary logging. `rsyslogd` is only used for devops.


Postfix mail server
-----------------

Then create `main.cf` by copying `main.cf.template` and update the domains settings.

Many mail servers don't accept incoming connections from IP-adresses
from virtual machines. A smarthost needs to be used in these cases. This
image therefore requires an account at Google.

Update `USERNAME` and `PASSWORD` in this row in the Dockerfile:
`run echo smtp.gmail.com USERNAME:PASSWORD > /etc/postfix/relay_passwd`.

Build an image and start a container and then test to send a message from
within the container:

    >docker run -t -i --rm postfix /bin/bash
    >supervisord
    >su - someone
    >echo "This is a mail test message" |mutt -s "Test message" jonas@gizur.com
    >exit


See `test-mail/README.md` for instructions on how to send a testmail.


memcached
---------

Test that things is running. `[IP]` is the IP adress of the beservices
container. Run this from within another container on the same docker instance:

    >telnet [IP] 11211
    >add mykey 0 900 2
    >
    >
    >STORED
    >set mykey 0 60 5
    >999
    >
    >STORED
    >get mykey
    >999
    >
    >END
    >quit


redis
-----

Test thas it works like this:

    docker run -t -i --rm --link beservices:beservices ubuntu:trusty /bin/bash
    apt-get update
    apt-get install -y redis-tools
    redis-cli -h beservices
    SET mykey myvalue
    GET mykey


webmin
------

[webmin](http://www.webmin.com) is a gui for linux server administration.

It can be used for many things, for instance to minitor the disk usage.
Login at port `10000` and select `Others->System and Server Status` and add
monitor of type `dosk space`. Set `percentage of total` to `20% `etc. The script
`/server-monitor.sh` will send a mail with extended information.
Update the script with the mail-address you want to use. Select
`Scheduled Monitoring` and setup a monitoring schedule.


Resources
--------

Some usefull links:

 * http://logstash.net/docs/1.4.0/tutorials/getting-started-with-logstash


Troubleshooting
---------------

 * `Could not resolve 'archive.ubuntu.com'`: This is probably related to network
    problems when running in VirtualBox (try to restart the guest). Also try to
    build with `no-cache=true`. It could also be the ubuntu mirror, try another
    (see top of `Dockerfile`).
