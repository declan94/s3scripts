#!/bin/bash


SCRIPT_DIR=$(cd $(dirname ${BASH_SOURCE[0]}); pwd)

useHttps="False"
signV2="False"

savePath="$(cd ~; pwd)/.s3cfg"

if [[ -e savePath ]]; then
	read -p "Configure file [$savePath] already exists, overwirte? [y/n] " ans
	[[ $ans == 'Y' || $ans == 'y' ]] || exit 1
fi

read -p "Server Url: " serverAddr
if [[ ${serverAddr:0:7} == "http://" ]]; then
	serverAddr=${serverAddr:7}
elif [[ ${serverAddr:0:8} == "https://" ]]; then
	serverAddr=${serverAddr:8}
	useHttps="True"
fi

read -p "Access Key ID: " key
read -p "Access Key Secret: " secret

cp $SCRIPT_DIR/s3cfg.tpl $savePath
sed -i "s/#host_base#/$serverAddr/g" $savePath
sed -i "s/#access_key#/$key/g" $savePath
sed -i "s/#secret_key#/$secret/g" $savePath
sed -i "s/#use_https#/$useHttps/g" $savePath
sed -i "s/#signature_v2#/$signV2/g" $savePath

echo "Configure file saved: $savePath"


