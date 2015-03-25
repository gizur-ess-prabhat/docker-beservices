#!/bin/bash
df > /tmp/monitor.txt
cat /tmp/monitor.txt|mutt -s "Monitor alert!" admin@example.com
