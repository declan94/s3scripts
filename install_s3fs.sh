#!/bin/bash

set -e

if [[ ! -z `which s3fs` ]]; then
	echo "s3fs has already been installed: `which s3fs`"
	exit 0
fi

echo "------------------------------ INSTALL DEPENDENCIES ------------------------------------"
sudo apt-get install -y automake autotools-dev fuse g++ git libfuse-dev libssl-dev libxml2-dev make pkg-config
if [[ -z `dpkg -l | grep 'libcurl4-.*-dev'` ]]; then 
	sudo apt-get install -y libcurl4-openssl-dev 
fi
echo "------------------------------ CLONE CODE ------------------------------------"
git clone https://github.com/s3fs-fuse/s3fs-fuse.git

pushd s3fs-fuse
echo "------------------------------ AUTOGEN & CONFIGURE ------------------------------------"
./autogen.sh
./configure
echo "------------------------------ MAKE & INSTALL ------------------------------------"
make
sudo make install
popd
echo "------------------------------ FINISHED ------------------------------------"