#!/bin/bash

set -e

if [[ ! -z `which s3cmd` ]]; then
	echo "s3cmd has already been installed: `which s3cmd`"
	exit 0
fi

wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | sudo apt-key add -
sudo wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list
sudo apt-get update && sudo apt-get install s3cmd -y