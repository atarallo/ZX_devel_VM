#!/bin/sh
#

WGET=/usr/bin/wget

ISO_DOWNLOAD_URL="https://releases.ubuntu.com/24.04.4/ubuntu-24.04.4-live-server-amd64.iso"
ISO_OUT_FILE="${HOME}/Downloads/UBUNTU-INSTALL-ISO.iso"   #ISO Name remains constant

rm -f ${OUT_FILE}
${WGET} ${ISO_DOWNLOAD_URL} -O ${ISO_OUT_FILE} 
