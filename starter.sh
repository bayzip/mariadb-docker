#!/bin/sh

#Mysqld Data
if [ -d "/run/mysqld" ]; then
	echo "Mysql Ditemukan"
	chown -R mysql:mysql /run/mysqld
else
	echo "Mysql Tidak Ditemukan! Membuat data ..."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

#Innitialing DB
if [ -d /var/lib/mysql/$MYSQL_DB ]; then
	echo 'Mysql Directory ada'
	chown -R mysql:mysql /var/lib/mysql
else
	echo "Mysql Directory tidak ada! Initializing DB...."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
	chown -R mysql:mysql /var/lib/mysql
	echo "Create temp file: $tfile"
	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
		return 1
	fi
	
	cat << EOF > $tfile
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`$MYSQL_DB\` CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL ON \`$MYSQL_DB\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PW';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOTPW' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOTPW' WITH GRANT OPTION;
GRANT ALL ON *.* TO ${MYSQL_USER}@'localhost*' IDENTIFIED BY '${MYSQL_USER_PW}' WITH GRANT OPTION;
GRANT ALL ON *.* TO ${MYSQL_USER}@'%' IDENTIFIED BY '${MYSQL_USER_PW}' WITH GRANT OPTION;
GRANT ALL ON *.* TO ${MYSQL_USER}@'*' IDENTIFIED BY '${MYSQL_USER_PW}' WITH GRANT OPTION;
DELETE FROM mysql.user WHERE User='';
DROP DATABASE test;
FLUSH PRIVILEGES;
EOF

	echo "Running Temporary File"
	/usr/sbin/mysqld --bootstrap --verbose=0 < $tfile
	rm -f $tfile
fi

exec /usr/sbin/mysqld

