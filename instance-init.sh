#!/bin/bash

#Update Repositories and upgrade packages
sudo apt update && sudo apt upgrade -y

# FFMPEG INSTALLATION
sudo apt-get install ffmpeg -y

# SRT Tools INSTALLATION
sudo apt-get install srt-tools -y

# LIBRIST INSTALLATION
# 1. Install Dependencies
sudo apt install build-essential -y

sudo apt-get install libcmocka-dev libmbedcrypto7 libmbedtls-dev libmbedtls14 \
liblz4-dev meson ninja-build pkg-config cmake libcjson-dev liblz4-1 libmicrohttpd-dev \
libmbedtls-dev -y

# 2. Clone repository
git clone http://code.videolan.org/rist/librist.git

# 3. Complile the library
mkdir builddir
cd builddir
meson ../librist
ninja
sudo ninja install

# 4. Register library
sudo ldconfig

