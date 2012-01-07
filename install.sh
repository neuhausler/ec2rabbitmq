#!/bin/bash

#
# This script installs and configures rabbitmq on a fresh Amazon Linux AMI instance.
# Requires Erlang to be installed
#
# Must be run with root privileges
#

export BUILD_DIR="$PWD"

wget http://www.rabbitmq.com/releases/rabbitmq-server/v2.7.1/rabbitmq-server-generic-unix-2.7.1.tar.gz
gunzip *.gz
tar -xf *.tar
cp -r rabbitmq_server-2.7.1 /usr/local/lib/rabbitmq_server-2.7.1
ln -s /usr/local/lib/rabbitmq_server-2.7.1 /usr/local/lib/rabbitmq

mkdir -p /usr/local/etc/rabbitmq
mkdir -p /usr/local/var/log/rabbitmq
mkdir -p /usr/local/var/lib/rabbitmq
mkdir -p /usr/local/var/run/rabbitmq

# add rabbitmq user
adduser --system --home /usr/local/var/lib/rabbitmq -M --shell /bin/bash --comment "RabbitMQ" rabbitmq

# change file ownership
chown -R rabbitmq:rabbitmq /usr/local/var/log/rabbitmq /usr/local/var/lib/rabbitmq /usr/local/var/run/rabbitmq

# download changed startup file
git clone git://gist.github.com/1545444.git
cp 1545444/rabbitmq-server /usr/local/lib/rabbitmq/sbin/rabbitmq-server

# download changed plugin activation file
git clone git://gist.github.com/1545558.git
cp 1545558/rabbitmq-plugins /usr/local/lib/rabbitmq/sbin/rabbitmq-plugins

# download changed env file
git clone git://gist.github.com/1548054.git
cp 1548054/rabbitmq-env /usr/local/lib/rabbitmq/sbin/rabbitmq-env

# install management plugin
export PATH=$PATH:/usr/local/bin/
cd /usr/local/lib/rabbitmq
./sbin/rabbitmq-plugins enable rabbitmq_management
cd $BUILD_DIR

# download init.d script
git clone git://gist.github.com/1547956.git
cp 1547956/rabbitmq-server /usr/local/etc/rc.d/rabbitmq-server
chmod 0755 /usr/local/etc/rc.d/rabbitmq-server
ln -s /usr/local/etc/rc.d/rabbitmq-server /etc/init.d/rabbitmq-server


# done!
echo
echo
echo "Installation complete!"
echo "RabbitMQ is ready to start. Run:"
echo "    sudo service rabbitmq-server start"

