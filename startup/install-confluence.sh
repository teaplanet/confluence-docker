#!/bin/sh

APPDIR=/confluence/application
DATADIR=/confluence/data

if [ ! -d $APPDIR ]; then
	chmod +x /atlassian-confluence-5.4.1-x64.bin
	(echo ""; echo ""; echo $APPDIR; echo "$DATADIR"; echo ""; echo "n") | /atlassian-confluence-5.4.1-x64.bin

	sleep 20
	kill `cat $APPDIR/work/catalina.pid`
	rm -f $APPDIR/work/catalina.pid

	# MySQL connector
	tar xfvz /mysql-connector-java-5.1.28.tar.gz -C /tmp `tar tfz /mysql-connector-java-5.1.28.tar.gz | grep bin.jar`
	mv /tmp/mysql-connector-java*/*.jar $APPDIR/lib
	rm -fr /tmp/mysql-connector-java*
else
	groupadd -g 1001 confluence
	useradd -c "Atlassian Confluence" -d /home/confluence -g 1001 -s /bin/sh confluence
fi
