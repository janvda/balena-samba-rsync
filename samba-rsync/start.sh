#!/bin/bash

if [ "$smb1_server_and_share_name" != '' ]; then
   if [ "$smb1_mount_folder" = '' ]; then
      export smb1_mount_folder=smb1
   fi
   export smb1_mount_point=/data/from/$smb1_mount_folder

   echo "Mounting samba share 1"
   mkdir -p $smb1_mount_point
   mount -t cifs $smb1_mount_options $smb1_server_and_share_name $smb1_mount_point
fi

sleep 3600
exit 0
