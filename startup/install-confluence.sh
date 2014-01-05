#!/bin/sh

DATADIR=/confluence/data

if [ ! -d $DATADIR ]; then
	chmod +x /atlassian-confluence-5.4.1-x64.bin
	(echo ""; echo ""; echo ""; echo "$DATADIR"; echo ""; echo "n") | /atlassian-confluence-5.4.1-x64.bin

	sleep 20
	kill `cat /opt/atlassian/confluence/work/catalina.pid`
	rm -f /opt/atlassian/confluence/work/catalina.pid
fi
