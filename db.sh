#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
MYSQL_CONFIG_FILE="/etc/mysql/my.cnf"
PASSWORD='root'
DB='example'

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get -y install mysql-server

echo "Dropping database $DB"
mysql -u root --password=${PASSWORD} -e "DROP DATABASE IF EXISTS $DB";

echo "Creating database $DB"
mysql -u root --password=${PASSWORD} -e "CREATE DATABASE $DB";

sudo sed -i "s/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" ${MYSQL_CONFIG_FILE}

# Allow root access from any host
echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION" | mysql -u root --password=${PASSWORD}
echo "GRANT PROXY ON ''@'' TO 'root'@'%' WITH GRANT OPTION" | mysql -u root --password=${PASSWORD}

if [ -d "/vagrant/sql" ]; then
	echo "Executing all SQL files in /sql folder ..."
	echo "-------------------------------------"
	for sql_file in /vagrant/sql/*.sql
	do
		echo "EXECUTING $sql_file..."
  		time mysql -u root --password=${PASSWORD} < $sql_file
  		echo "FINISHED $sql_file"
  		echo ""
	done
fi

service mysql restart