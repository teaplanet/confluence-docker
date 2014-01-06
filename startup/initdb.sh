#!/bin/sh

CONFLUENCE_DIR=/confluence
DATADIR=$CONFLUENCE_DIR/db

sed -i "/^datadir*/ s|=.*|= $DATADIR|" /etc/mysql/my.cnf
if [ ! -d $DATADIR/mysql ]; then
	# setup directory
	mkdir -p $DATADIR
	/usr/bin/mysql_install_db
	chown -R mysql:mysql $DATADIR
	chmod 700 $DATADIR

	# setup user
	/usr/bin/mysqld_safe --skip-grant-tables &
	sleep 10s

	MYSQL_PASSWORD=`pwgen -c -n -1 12`
	DB_USER="confluence"
	DB_PASSWORD=`pwgen -c -n -1 12`

	echo MySQL root password: $MYSQL_PASSWORD
	echo user password : $DB_PASSWORD
	echo $MYSQL_PASSWORD > $CONFLUENCE_DIR/mysql-root-pw.txt
	echo $DB_PASSWORD > $CONFLUENCE_DIR/db-user-pw.txt

	mysql -u root -e "use mysql; UPDATE user SET Password=PASSWORD('$MYSQL_PASSWORD') WHERE User='root'; FLUSH PRIVILEGES;"
	mysql -u root --password=$MYSQL_PASSWORD -e "CREATE DATABASE confluence; GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD'; FLUSH PRIVILEGES;"
	killall mysqld
fi
