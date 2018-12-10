#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo "Install some common packages"
apt-get install -y \
  wget \
  curl \
  mousepad \
  net-tools \
  dnsutils \
  locales \
  bzip2

echo "Generate locales for en_US.UTF-8"
locale-gen en_US.UTF-8