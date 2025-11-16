#!/bin/bash
# 
# Unatended creation of VM. Ideas taken from https://andreafortuna.org/2019/10/24/how-to-create-a-virtualbox-vm-from-command-line
#

MAYOR="0"
MINOR="2"
VMNAME="ZXDEVEL"
VERSION=""

if [ ${#} -gt 0 ]; then
	if [ ${1} == "--help" ]; then
		echo "Display usage indications"
		exit 0
	else
		VMNAME=${1}
	fi	
fi
#
# VBoxTools might be in your $PATH, customize to your install
#
VBOXMANAGE='/usr/bin/VBoxManage'
VERSION="${MAYOR}.${MINOR}"

MACHINENAME="${VMNAME}-${VERSION}"
##Create VM
${VBOXMANAGE} createvm --name ${MACHINENAME} --ostype "Ubuntu_64" --register
##Set memory and network
${VBOXMANAGE} modifyvm ${MACHINENAME} --ioapic on
${VBOXMANAGE} modifyvm ${MACHINENAME} --cpus 2 --memory 2048 --vram 16 --graphicscontroller vmsvga --usbohci on --mouse usbtablet
${VBOXMANAGE} modifyvm ${MACHINENAME} --nic1 nat
##Create Disk 
${VBOXMANAGE} createmedium disk --filename=~/VirtualBox\ VMs/${MACHINENAME}/${MACHINENAME}_DISK.vdi --size=30720 --format VDI  --variant Standard
${VBOXMANAGE} storagectl ${MACHINENAME} --name "SATA Controller" --add sata --controller IntelAhci
${VBOXMANAGE} storageattach ${MACHINENAME} --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium=~/VirtualBox\ VMs/${MACHINENAME}/${MACHINENAME}_DISK.vdi
##   Connect to Ubuntu ISO
${VBOXMANAGE} storagectl ${MACHINENAME} --name "IDE Controller" --add ide --controller PIIX4
${VBOXMANAGE} storageattach ${MACHINENAME} --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ~/Downloads/ubuntu-24.04.2-live-server-amd64.iso
${VBOXMANAGE} modifyvm ${MACHINENAME} --boot1 dvd --boot2 disk --boot3 none --boot4 none
##
${VBOXMANAGE} setextradata ${MACHINENAME} GUI/ScaleFactor 1.4
#
##Enable RDP
#${VBOXMANAGE} modifyvm $MACHINENAME --vrde on
#${VBOXMANAGE} modifyvm $MACHINENAME --vrdemulticon on --vrdeport 10001
#
##Start the VM
#VBoxHeadless --startvm $MACHINENAME
