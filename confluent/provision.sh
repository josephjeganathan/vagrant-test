#!/bin/bash

# Step 1: Install Java

command -v java -version &>/dev/null || {
  echo "Installing Java..."
  apt-get -y update 
  apt-get -y install openjdk-7-jdk
}

# Step 2: Installing confluent

if [ ! -f "/usr/bin/kafka-server-start" ]; then
  echo "Installing Confluent..."
  wget -qO - http://packages.confluent.io/deb/1.0/archive.key | apt-key add -

  add-apt-repository "deb [arch=all] http://packages.confluent.io/deb/1.0 stable main"
  apt-get -y update 
  
  apt-get -y install confluent-platform-2.10.4
fi                                              

# Step 3: Start Confluent

echo "Installing confluent service..."
rm -rf /confluent &>/dev/null
mkdir -p /confluent/config /confluent/data /confluent/logs
cp /vagrant/config/* /confluent/config

cp /vagrant/service/confluent /etc/init.d/
copy-confluent-service(){
  rm $1 &>/dev/null
  ln -s /etc/init.d/confluent $1 &>/dev/null
}

copy-confluent-service /etc/rc2.d/S99confluent
copy-confluent-service /etc/rc3.d/S99confluent
copy-confluent-service /etc/rc4.d/S99confluent
copy-confluent-service /etc/rc5.d/S99confluent

copy-confluent-service /etc/rc0.d/K99confluent
copy-confluent-service /etc/rc6.d/K99confluent

echo "Starting confluent service..."
/etc/init.d/confluent restart
