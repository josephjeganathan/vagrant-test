#!/bin/bash

apt-get -y update

dpkg -s npm &>/dev/null || {

  apt-get -y install nodejs npm
  ln -s /usr/bin/nodejs /usr/bin/node

  npm install -g yo generator-hubot
}

command -v hubot &>/dev/null || {
  
  # npm install -g yo generator-hubot
  
  # mkdir myhubot
  # cd myhubot
  # yo hubot
}
