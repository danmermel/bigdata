#!/bin/bash

echo "install node"
#see https://tecadmin.net/install-latest-nodejs-npm-on-debian/
apt-get -y install curl software-properties-common 
curl -sL https://deb.nodesource.com/setup_17.x |  bash - 
apt-get -y install nodejs 

echo "install datamaker"
npm install -g datamaker

echo "install redis-server" 
apt-get -y install redis-server

echo "install stunnel to allow an https connection via redis cli"
apt-get install stunnel

echo "move the stunnel config to the right place"
mv stunnel.conf /etc/stunnel/

echo "Starting stunnel..."
stunnel

echo "Create the data template"
echo "SET {{uuid}} '{\"a\":{{integer}},\"txt\":\"{{words 10}}\",\"email\":\"{{email}}\"}'" > template.txt

echo "Create the data. This will take a while because it is creating 350 million rows!"
cat template.txt | datamaker -i 350000000 > batch.txt

echo "Create the auth token to access redis"
echo auth admin <redis_password_from_terraform_tf_vars> > auth.txt

echo "Pipe the data into redis"
cat auth.txt batch.txt | redis-cli -p 6830 --pipe

