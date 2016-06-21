#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PROJECTFOLDER='dcadmin'

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade

# install apache 2.5 and php 5.5
sudo apt-get install -y apache2
sudo apt-get install -y php5 
sudo apt-get install -y php5-common
sudo apt-get install php5-mysql
sudo apt-get install php5-mysqlnd 
sudo apt-get install php5-mcrypt
sudo apt-get install php5-gd

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html"
    SetEnv ENVIRONMENT development
	ServerName "mydc.com"
	ServerAlias "*.mydc.com"
    <Directory "/var/www/html">
		Allow From All
		AllowOverride All
		Options +Indexes
		Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite

# restart apache
service apache2 restart

# install git
sudo apt-get -y install git

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer