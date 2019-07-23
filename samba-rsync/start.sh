#!/bin/bash

# Mounting samba share 1 if appropriate device service variables are set.
if [ "$smb1_server_and_share_name" != '' ]; then
   if [ "$smb1_mount_folder" = '' ]; then
      export smb1_mount_folder=smb1
   fi
   export smb1_mount_point=/data/from/$smb1_mount_folder

   # prefix the mount options with -o if specified
   if [ "$smb1_mount_options" != '' ]; then
      export smb1_full_mount_options="-o $smb1_mount_options"
   fi

   echo "Mounting samba share 1: $smb1_server_and_share_name at $smb1_mount_point"
   mkdir -p $smb1_mount_point
   # echo "mount -t cifs $smb1_full_mount_options $smb1_server_and_share_name $smb1_mount_point"
   mount -t cifs $smb1_full_mount_options $smb1_server_and_share_name $smb1_mount_point
fi

# Mounting samba share 2 if appropriate device service variables are set.
if [ "$smb2_server_and_share_name" != '' ]; then
   if [ "$smb2_mount_folder" = '' ]; then
      export smb2_mount_folder=smb2
   fi
   export smb2_mount_point=/data/from/$smb2_mount_folder

   # prefix the mount options with -o if specified
   if [ "$smb2_mount_options" != '' ]; then
      export smb2_full_mount_options="-o $smb2_mount_options"
   fi

   echo "Mounting samba share 2: $smb2_server_and_share_name at $smb2_mount_point"
   mkdir -p $smb2_mount_point
   # echo "mount -t cifs $smb2_full_mount_options $smb2_server_and_share_name $smb2_mount_point"
   mount -t cifs $smb2_full_mount_options $smb2_server_and_share_name $smb2_mount_point
fi

echo "Starting samba daemon: this will create samba share //<IP address raspberry pi>/data"
service smbd start

# Mounting external drive if appropriate device service variables are set.
# and running rsync if enabled.
if [ "$ext_dev_partition" != '' ]; then
   echo "Mounting external device partition: $ext_dev_partition at /data/to"
   mkdir -p /data/to
   mount $ext_dev_partition /data/to

   echo -e "\n******* Filesystem Statistics ******************************"
   df -h
   echo -e "************************************************************\n"

   if [ "$rsync_smb1_enable" = 1 ]; then
      rsync_smb1_from=$smb1_mount_point
      rsync_smb1_to=/data/to
      rsync_smb1_opts="-an --stats"  # default options
      if [ "$rsync_smb1_from_folder" != '' ]; then
        rsync_smb1_from=$rsync_smb1_from/$rsync_smb1_from_folder
      fi
      if [ "$rsync_smb1_to_folder" != '' ]; then
        rsync_smb1_to=$rsync_smb1_to/$rsync_smb1_to_folder
        mkdir -p "$rsync_smb1_to"
      fi
      if [ "$rsync_smb1_options" != '' ]; then
         rsync_smb1_opts=$rsync_smb1_options
      fi
      echo "launching: rsync $rsync_smb1_opts \"$rsync_smb1_from\" \"$rsync_smb1_to\""
      rsync $rsync_smb1_opts "$rsync_smb1_from" "$rsync_smb1_to"
   fi
fi

echo -e "\nSleeping for 1 hour..."
sleep 3600
exit 0
