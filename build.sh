#!/bin/bash

set -e

app=apt-cacher-ng
user=$app

echo "Adding $user ..."
useradd --home-dir ~ --create-home --shell=/bin/bash --user-group $user


echo "Installing $app ..."
apt-get update
apt-get install -y apt-cacher-ng


echo "Setting daemon up for docker ..."
sed -ir 's/# ForeGround: 0/ForeGround: 1/' /etc/apt-cacher-ng/acng.conf 


echo "Cleaning up ..."
apt-clean --aggressive

rm -r -- "$0"
