Gizur backend services
======================

A collection of services used by the applications hosted in Gizur's private
docker cloud.

These services are collected into one container in order to simplfy
for the applications. Services here should be stable and change infrequently.
Containers with applications should `--link` to a beservices container at
start.

logserver
---------

This container has a rsyslog server running and listening on UDP port 514.
Any client (container in the network) can log to this rsyslog server.

Build the image: `docker build -t logserver .`


Starting the server this way makes it possible to connect and reconnect to the
server:

    docker run -t -i -p 9200:9200 -p 9292:9292 --restart="on-failure:10" \
    --name logserver -h logserver logserver /bin/bash -c "supervisord; bash"

Exit the server with `ctrl-p` `ctrl-q`. Reconnect with `docker attach logserver`

There is a example of a client configuration in `rsyslog.conf.client`.
Test to print to syslog with `logger` from a client to make sure things are ok.


Resources
--------


Some links:

 * http://logstash.net/docs/1.4.0/tutorials/getting-started-with-logstash
