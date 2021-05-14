#!/usr/bin/env bash
#
# Backup files from $HOME to /mnt/usb
#
# © 2021 Jussi Heinonen
#
SRC_DIRS=( "Desktop" "Documents" "Music" "Omat" "Pictures" "workspace" )
DST_DIR="/mnt/usb"

for each in ${SRC_DIRS[*]}; do 
    echo "Backing up ${HOME}/$each/ to ${DST_DIR}/${each}/"
    rsync --info=progress2 -auvz ${HOME}/$each/ ${DST_DIR}/${each}/
done
