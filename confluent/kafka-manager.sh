#!/bin/bash

# Installing Yahoo's Kafka manager
# https://github.com/yahoo/kafka-manager

echo "Installing Yahoo's Kafka manager..."

command -v sbt sbtVersion &>/dev/null || {

  echo "deb http://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
  apt-get -y update >/dev/null

  echo "Installing sbt..."
  apt-get -y --force-yes install sbt >/dev/null
}

if [ ! -f "/kafka-manager/bin/kafka-manager" ]; then

  command -v unzip -v &>/dev/null || {
    echo "Installing upzip..."
    apt-get -y update >/dev/null
    apt-get -y install unzip
  }


  echo "Cloning kafka-manager git repository..."
  cd /tmp
  git clone https://github.com/yahoo/kafka-manager

  echo "Building kafka-manager, this may take few minutes..."
  cd kafka-manager
  sbt clean dist >/dev/null

  cd target/universal/
  unzip kafka-*.zip >/dev/null
  
  cd kafka-manager*
  mkdir /kafka-manager
  cp -rf * /kafka-manager
  sed -i 's/"kafka-manager-zookeeper:2181"/"localhost:2181"/g' /kafka-manager/conf/application.conf

  cp /vagrant/service/kafka-manager /etc/init.d/
  copy-kafka-manager-service(){
    rm $1 &>/dev/null
    ln -s /etc/init.d/kafka-manager $1 &>/dev/null
  }

  copy-kafka-manager-service /etc/rc2.d/S99kafka-manager
  copy-kafka-manager-service /etc/rc3.d/S99kafka-manager
  copy-kafka-manager-service /etc/rc4.d/S99kafka-manager
  copy-kafka-manager-service /etc/rc5.d/S99kafka-manager

  copy-kafka-manager-service /etc/rc0.d/K99kafka-manager
  copy-kafka-manager-service /etc/rc6.d/K99kafka-manager

  echo "Deployed built kafka-manager."

  echo "Starting confluent service..."
  /etc/init.d/kafka-manager restart
  
fi
