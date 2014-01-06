#!/bin/sh

APPDIR=/opt/atlassian/confluence
DATADIR=/confluence/data

if [ -d $DATADIR ]; then
	mv $DATADIR ${DATADIR}_`date +%Y%m%d-%H%M`
fi

if [ ! -d $APPDIR ]; then
	chmod +x /atlassian-confluence-5.4.1-x64.bin
	(echo ""; echo ""; echo ""; echo "$DATADIR"; echo ""; echo "n") | /atlassian-confluence-5.4.1-x64.bin

	sleep 20
	kill `cat /opt/atlassian/confluence/work/catalina.pid`
	rm -f /opt/atlassian/confluence/work/catalina.pid

	# MySQL connector
	tar xfvz /mysql-connector-java-5.1.28.tar.gz -C /tmp `tar tfz /mysql-connector-java-5.1.28.tar.gz | grep bin.jar`
	mv /tmp/mysql-connector-java*/*.jar /opt/atlassian/confluence/lib
	rm -fr /tmp/mysql-connector-java*
fi
