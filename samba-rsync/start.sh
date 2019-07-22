#!/bin/bash

if [ "$SMB1_SERVER_AND_SHARE_NAME" != '' ]; then
   if [ "$SMB1_MOUNT_FOLDER" = '' ]; then
      export SMB1_MOUNT_FOLDER=smb1
   fi
   export SMB1_MOUNT_POINT=/data/from/$SMB1_MOUNT_FOLDER

   echo "Mounting samba share 1"
   mkdir -p $SMB1_MOUNT_POINT
   mount -t cifs $SMB1_MOUNT_OPTIONS $SMB1_SERVER_AND_SHARE_NAME $SMB1_MOUNT_POINT
fi

sleep 3600
exit 0
