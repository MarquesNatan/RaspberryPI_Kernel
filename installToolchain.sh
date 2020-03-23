#!/bin/sh

#verify libs need
apt-get install libc6-armel-cross libc6-dev-armel-cross binutils-arm-linux-gnueabi libncurses5-dev

#install archives need First: Toolchain
if [ -f "$(pwd)/toolchain/gcc-arm-linux-gnueabihf_4%3a7.4.0-1ubuntu2.3_amd64.deb" ]
then 
	echo "Install Toolchain ... wait"
	dpkg -i $(pwd)/toolchain/gcc-arm-linux-gnueabihf_4%3a7.4.0-1ubuntu2.3_amd64.deb 
	#add PATH
	export PATH=/usr/arm-linux-gnueabihf/bin:$PATH
	echo "Toolchain installed"
	echo "type \"arm-linux-gnueabihf -v\" to show version"
else
	echo "Error file not found"
fi


