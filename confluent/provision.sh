# Step 1: Add apt get repo and update
wget -qO - http://packages.confluent.io/deb/1.0/archive.key | apt-key add -

add-apt-repository "deb [arch=all] http://packages.confluent.io/deb/1.0 stable main"

apt-get -y update 

# Step 2: Installing Java

apt-get -y install openjdk-7-jdk

# Step 3: Installing confluent

apt-get -y install confluent-platform-2.10.4


# Step 4: Start Confluent

cp /vagrant/upstart/*.conf /etc/init/

service confluent-zookeeper restart
service confluent-kafka restart
service confluent-schema restart
service confluent-rest restart
