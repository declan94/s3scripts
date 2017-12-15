#!/bin/bash

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

function usage()
{
	echo "Usage: $0 [BucketName] [MountPoint]"
}

function isDirEmpty()
{
	[ "$(ls -A $1)" ] && return 1
}

function ensureNotEmpty()
{
	read -p "Mount point [$1] is NOT EMPTY, continue to mount? [y/n] " ans
	[[ $ans == "y" || $ans == "Y" ]] && return 0
	return 1
}

function ensureCreate()
{
	read -p "Mount point [$1] does not exist, create directory? [y/n] " ans
	[[ $ans == "y" || $ans == "Y" ]] || return 1
	mkdir -p $1
}

function addPwdFile()
{
	storeRoot=/etc/s3fs-pwds
	if [[ ! -d $storeRoot ]]; then
		sudo mkdir -p $storeRoot
	fi
	i=0
	while [[ 1 -eq 1 ]]; do
		if [[ ! -e $storeRoot/s3fs-passwd.$i ]]; then
			break
		fi
		((i=i+1))
	done
	pwdFile=$storeRoot/s3fs-passwd.$i
	echo "$1:$2" | sudo tee $pwdFile || return 1
	sudo chmod 600 $pwdFile || return 1
	echo $pwdFile
}

function ensureS3fs()
{
	read -p "s3fs currently not installed, install it now? [y/n] " ans
	[[ $ans == "y" || $ans == "Y" ]] || return 1
	$SCRIPT_DIR/install_s3fs.sh || return 1
}

if [[ $# -lt 2 ]]; then
	usage
	exit 1
fi

s3fsCmd=`which s3fs`
if [[ -z $s3fsCmd ]]; then
	ensureS3fs || exit 1
fi

BucketName=$1
MountPoint=$2

if [[ -d $MountPoint ]]; then
	isDirEmpty $MountPoint || ensureNotEmpty $MountPoint || exit 1
else
	ensureCreate $MountPoint || exit 1
fi

MountPoint=$(cd $MountPoint; pwd)

read -p "Server Url: " serverAddr
read -p "Access Key ID: " key
read -p "Access Key Secret: " secret

if [[ ${serverAddr:0:4} != "http" ]]; then
	serverAddr="http://$serverAddr"
fi

pwdFile=`addPwdFile $key $secret | tail -n 1 || exit 1`

echo "Mounting..."
cmd="$s3fsCmd $BucketName $MountPoint -o nocopyapi -o use_path_request_style -o nomultipart -o sigv2 -o url=$serverAddr -o allow_other -o passwd_file=$pwdFile"
echo $cmd
sudo $cmd || exit 1

echo "Mount Succeeded!"

read -p "Write to /etc/fstab? [y/n]" ans
[[ $ans == "y" || $ans == "Y" ]] || return 0

echo "$s3fsCmd#$BucketName $MountPoint fuse _netdev,allow_other,url=$serverAddr,passwd_file=$pwdFile 0  0" | sudo tee -a /etc/fstab








