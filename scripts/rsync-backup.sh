#!/usr/bin/env bash
#
# Backup files from $HOME to /mnt/usb or secondary hard drive
#
# © 2022 Jussi Heinonen
#
SRC_DIRS=( "Desktop" "Documents" "Music" "Omat" "Omat2" "Pictures" "workspace" )
DST_DIR="/mnt/usb"
#DST_DIR="/media/jussi/df25568c-a3f5-43b6-9a9a-825474fc1af1/backup"

for each in ${SRC_DIRS[*]}; do 
    echo "Backing up ${HOME}/$each/ to ${DST_DIR}/${each}/"
    rsync --info=progress2 -auvz ${HOME}/$each/ ${DST_DIR}/${each}/
done
