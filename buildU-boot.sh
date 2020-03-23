#!/bin/sh


#falta colocar a execução na pasta de origem


#build u-boot to raspberry pi 3 b

#rpi_3_32b_defconfig

BOARD_NAME=rpi_3_32b_defconfig
CROSS_COMPILE=arm-linux-gnueabihf

#Compile u-boot with raspberry defconfig
cd $(pwd)/u-boot/
echo "Configuring u-boot"
sudo make $BOARD_NAME 

if [ -d "$(pwd)/bootloader" ]
then 
	echo "Directory bootloader found \n"
else
	echo "Directory bootloader not found"
	echo "Creating directory ..."
	sudo mkdir $(pwd)/bootloader/
fi

#Genarate file: u-boot.bin
sudo make CROSS_COMPILE=${CROSS_COMPILE}- -j4 

#Creating file: boot.cmd -> boot.scr
sudo touch boot.cmd
sudo echo "mmc dev 0" >> boot.cmd
sudo echo "fatload mmc 0:1 \${kernel_addr_r} zImage" >> boot.cmd
sudo echo "setenv bootargs console=tty1 console=ttyAMA0,115200 earlyprintk root=/dev/mmcblk0p2 rootwait rw" >> boot.cmd
sudo echo "bootz \${kernel_addr_r} - \${fdt_addr}" >> boot.cmd
#sudo echo "setenv load_kernel 'fatload mmc 0:1 \${kernel_addr_r} zImage'" >> boot.cmd
#sudo echo "setenv load_dtb 'ext4load mmc 0:1 \${fdt_addr_r} bcm2837-rpi-3-b.dtb'" >> boot.cmd
#sudo echo "setenv bootcmd 'run load_kernel; run load_dtb; bootz \${kernel_addr_r} - \${fdt_addr_r}'" >> boot.cmd
##sudo echo "setenv bootargs \${consolecfg} root=/dev/mmcblk0p2 rootfstype=ext4 rootwait rw" >> boot.cmd 
#sudo echo "saveenv" >> boot.cmd
echo "Creating boot script \n"

sudo tools/mkimage -C none -A arm -T script -d boot.cmd boot.scr

sudo mv  boot.scr $(pwd)/bootloader/
sudo mv  u-boot.bin $(pwd)/bootloader/

cd ..
