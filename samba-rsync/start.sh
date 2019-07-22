#!/bin/bash

if [ "$smb1_server_and_share_name" != '' ]; then
   if [ "$smb1_mount_folder" = '' ]; then
      export smb1_mount_folder=smb1
   fi
   export smb1_mount_point=/data/from/$smb1_mount_folder

   # prefix the mount options with -o if specified
   if [ "$smb1_mount_options" != '' ]; then
      export smb1_full_mount_options="-o $smb1_mount_options"
   fi

   echo "Mounting samba share 1"
   mkdir -p $smb1_mount_point
   echo "mount -t cifs $smb1_full_mount_options $smb1_server_and_share_name $smb1_mount_point"
   mount -t cifs $smb1_full_mount_options $smb1_server_and_share_name $smb1_mount_point
fi

sleep 3600
exit 0
