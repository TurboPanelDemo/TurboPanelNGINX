#!/bin/bash

MAIN_DIR=$(pwd)

# Install dependencies
sudo apt-get update -y
sudo apt-get install -y build-essential dpkg-dev debhelper autotools-dev libgeoip-dev libssl-dev libpcre3-dev zlib1g-dev


#Download nginx source
wget http://nginx.org/download/nginx-1.24.0.tar.gz
tar -zxvf nginx-1.24.0.tar.gz
cd nginx-1.24.0

# Configure nginx
sudo ./configure --prefix=/usr/local/turbo/nginx
sudo make
sudo make install

sudo mkdir $MAIN_DIR/turbo-nginx-1.24.0-$1
PACKAGE_MAIN_DIR=$MAIN_DIR/turbo-nginx-1.24.0-$1

# Create debian package directories
sudo mkdir -p $PACKAGE_MAIN_DIR/DEBIAN
sudo mkdir -p $PACKAGE_MAIN_DIR/usr/local/turbo
sudo mkdir -p $PACKAGE_MAIN_DIR/etc/init.d

# Copy nginx compiled files
sudo mv /usr/local/turbo/nginx $PACKAGE_MAIN_DIR/usr/local/turbo

# Rename nginx to alpha-nginx
sudo mv $PACKAGE_MAIN_DIR/usr/local/turbo/nginx/sbin/nginx $PACKAGE_MAIN_DIR/usr/local/turbo/nginx/sbin/turbo-nginx

# Copy nginx configuration files
sudo cp $MAIN_DIR/nginx.conf $PACKAGE_MAIN_DIR/usr/local/turbo/nginx/conf/nginx.conf

# Copy debian package META file
sudo cp $MAIN_DIR/control $PACKAGE_MAIN_DIR/DEBIAN
sudo cp $MAIN_DIR/postinst $PACKAGE_MAIN_DIR/DEBIAN
sudo cp $MAIN_DIR/postrm $PACKAGE_MAIN_DIR/DEBIAN

# Set debian package post files permissions
sudo chmod +x $PACKAGE_MAIN_DIR/DEBIAN/postinst
sudo chmod +x $PACKAGE_MAIN_DIR/DEBIAN/postrm

# Copy ALPHAX series files
sudo cp $MAIN_DIR/turbo $PACKAGE_MAIN_DIR/etc/init.d/turbo
sudo chmod +x $PACKAGE_MAIN_DIR/etc/init.d/turbo

# Make debian package
sudo dpkg-deb --build $PACKAGE_MAIN_DIR
sudo dpkg --info $MAIN_DIR/turbo-nginx-1.24.0-$1.deb
sudo dpkg --contents $MAIN_DIR/turbo-nginx-1.24.0-$1.deb

# Move debian package to dist folder
sudo mkdir -p $MAIN_DIR/dist
sudo mv $MAIN_DIR/turbo-nginx-1.24.0-$1.deb $MAIN_DIR/dist
