#!/bin/bash

SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

function usage()
{
	echo "Usage: $0 BucketName MountPoint [s3fs_option1] [s3fs_option2] ..."
}

function isDirEmpty()
{
	[ "$(ls -A $1)" ] && return 1
	return 0
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
	return 0
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
	return 0
}

function ensureS3fs()
{
	read -p "s3fs currently not installed, install it now? [y/n] " ans
	[[ $ans == "y" || $ans == "Y" ]] || return 1
	$SCRIPT_DIR/install_s3fs.sh || return 1
}

function get_fullpath()
{
	relative_path=$1
    tmp_path1=$(dirname $relative_path)
    if [[ -z $tmp_path1 ]]; then
    	tmp_path1="."
    fi
    tmp_fullpath1=$(cd $tmp_path1 ;  pwd)
   	tmp_path2=$(basename $relative_path)
    echo ${tmp_fullpath1}/${tmp_path2}
    return 0
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
shift
MountPoint=$1
shift
options=$@

for opt in $@; do
	if [[ ${opt:0:12} == "passwd_file=" ]]; then
		pwdFile=${opt:12}
		pwdFile=`get_fullpath $pwdFile`
	fi
done

options[${#options[*]}]="allow_other"
options[${#options[*]}]="use_path_request_style"

if [[ -d $MountPoint ]]; then
	isDirEmpty $MountPoint || ensureNotEmpty $MountPoint || exit 1
else
	ensureCreate $MountPoint || exit 1
fi

MountPoint=$(cd $MountPoint; pwd)

read -p "Server Url: " serverAddr
if [[ ${serverAddr:0:4} != "http" ]]; then
	serverAddr="http://$serverAddr"
fi
options[${#options[*]}]="url=$serverAddr"

if [[ -z $pwdFile ]]; then
	read -p "Access Key ID: " key
	read -p "Access Key Secret: " secret
	pwdFile=`addPwdFile $key $secret | tail -n 1 || exit 1`
fi
options[${#options[*]}]="passwd_file=$pwdFile"

echo "Mounting..."
cmd="$s3fsCmd $BucketName $MountPoint"
for opt in ${options[*]}; do
	cmd="$cmd -o $opt"
done

echo $cmd
sudo $cmd || exit 1

echo "Mount Succeeded!"
read -p "Write to /etc/fstab? [y/n]" ans
[[ $ans == "y" || $ans == "Y" ]] || return 0

fstabLine="$s3fsCmd#$BucketName $MountPoint fuse _netdev"
for opt in ${options[*]}; do
	fstabLine="$fstabLine,$opt"
done
fstabLine="$fstabLine	0	0"
echo $fstabLine | sudo tee -a /etc/fstab








