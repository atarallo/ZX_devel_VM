#!/bin/bash
# 
# Unatended creation of VM. Ideas taken from https://andreafortuna.org/2019/10/24/how-to-create-a-virtualbox-vm-from-command-line
#

#
# VBoxTools might be in your $PATH, customize to your install
#
VBOXMANAGE='/usr/bin/VBoxManage'

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
VERSION="${MAYOR}.${MINOR}"
MACHINENAME="${VMNAME}-${VERSION}"

#
# VM Parameters. 
#
VM_DIR="${HOME}/VirtualBox VMs"     # Where VMs are actually stored, adjust acordingly
VM_CPUS=2
VM_VIDEO_MEMORY=16                   # Video in MB
VM_MEMORY=2048                       # RAM in MB, the emulators work fine with 2GB
VM_DISK_SIZE=30720                   # Disk in MB, 30GB sounds fine.
VM_DISK_HOME_SIZE=10240
VM_DISK_PATH=${VM_DIR}/${MACHINENAME}/${MACHINENAME}_DISK.vdi
VM_DISK_HOME_PATH=${VM_DIR}/${MACHINENAME}/${MACHINENAME}_HOME_DISK.vdi
VM_BOOT_DISK_PATH="${HOME}/Downloads/UBUNTU-INSTALL-ISO.iso"

##Create VM
${VBOXMANAGE} createvm --name ${MACHINENAME} --basefolder="${VM_DIR}" --ostype "Ubuntu_64" --register
${VBOXMANAGE} modifyvm ${MACHINENAME} --description="A ZX Spectrum (and clones) Development environment on a Linux VM. Version ${VERSION}"
##Set memory and network
${VBOXMANAGE} modifyvm ${MACHINENAME} --ioapic on
${VBOXMANAGE} modifyvm ${MACHINENAME} --cpus ${VM_CPUS} --memory ${VM_MEMORY} --vram ${VM_VIDEO_MEMORY} --graphicscontroller vmsvga --usbohci on --mouse usbtablet
${VBOXMANAGE} modifyvm ${MACHINENAME} --nic1 nat
## Create Disk 
${VBOXMANAGE} createmedium disk --filename="${VM_DISK_PATH}" --size="${VM_DISK_SIZE}" --format VDI  --variant Standard
${VBOXMANAGE} storagectl ${MACHINENAME} --name "SATA Controller" --add sata --controller IntelAhci
${VBOXMANAGE} storageattach ${MACHINENAME} --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium="${VM_DISK_PATH}"
# Create aditional disk, a separated LV for /home
${VBOXMANAGE} createmedium disk --filename="${VM_DISK_HOME_PATH}" --size="${VM_DISK_HOME_SIZE}" --format VDI  --variant Standard
${VBOXMANAGE} storageattach ${MACHINENAME} --storagectl "SATA Controller" --port 1 --device 0 --type hdd --medium="${VM_DISK_HOME_PATH}"
## Connect to Ubuntu ISO
${VBOXMANAGE} storagectl ${MACHINENAME} --name "IDE Controller" --add ide --controller PIIX4
${VBOXMANAGE} storageattach ${MACHINENAME} --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium=${VM_BOOT_DISK_PATH}
# Boot sequence
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
