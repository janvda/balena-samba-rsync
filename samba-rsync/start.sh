#!/bin/bash

# Mounting samba share 1 if appropriate device service variables are set.
if [ "$smb1_mount_server_share" != '' ]; then

   if [ "$smb1_mount_folder" = '' ]; then
      smb1_mount_folder=smb1 # default mount folder for samba share 1
   fi
   smb1_mount_point="/data/from/$smb1_mount_folder" 

   # prefix the mount options with -o if specified
   if [ "$smb1_mount_options" != '' ]; then
      smb1_full_mount_options="-o $smb1_mount_options"
   fi

   echo "STEP 1: Mounting samba share 1: $smb1_mount_server_share at $smb1_mount_point"
   mkdir -p "$smb1_mount_point"
   # echo "mount -t cifs $smb1_full_mount_options $smb1_mount_server_share $smb1_mount_point"
   mount -t cifs $smb1_full_mount_options "$smb1_mount_server_share" "$smb1_mount_point"
fi

# Mounting samba share 2 if appropriate device service variables are set.
if [ "$smb2_mount_server_share" != '' ]; then

   if [ "$smb2_mount_folder" = '' ]; then
      smb2_mount_folder=smb2 # default mount folder for samba share 2
   fi
   smb2_mount_point="/data/from/$smb2_mount_folder" 

   # prefix the mount options with -o if specified
   if [ "$smb2_mount_options" != '' ]; then
      smb2_full_mount_options="-o $smb2_mount_options"
   fi

   echo "STEP 1: Mounting samba share 2: $smb2_mount_server_share at $smb2_mount_point"
   mkdir -p "$smb2_mount_point"
   # echo "mount -t cifs $smb2_full_mount_options $smb2_mount_server_share $smb2_mount_point"
   mount -t cifs $smb2_full_mount_options "$smb2_mount_server_share" "$smb2_mount_point"
fi

echo "STEP 2: Starting samba daemon: this will create samba share //<IP address raspberry pi>/data"
service smbd start

# Mounting external drive if appropriate device service variables are set.
# and running rsync if enabled.
if [ "$ext_dev_partition" != '' ]; then
   echo "STEP 3: Mounting external device partition: $ext_dev_partition at /data/to"
   if [ "$ext_dev_passphrase" != '' ]; then
      echo "Env variable \$ext_dev_passphrase is specified so partition must be encrypted."
      partition_to_mount=/dev/mapper/encrypted_partition
      if [ -L "$partition_to_mount" ]; then
         echo "$partition_to_mount already exists, closing it first ..."
         cryptsetup luksClose encrypted_partition
      fi
      echo "Opening encrypted partition and mapping it to $partition_to_mount ..."
      echo $ext_dev_passphrase | sudo -S cryptsetup luksOpen $ext_dev_partition encrypted_partition
  
   else
      partition_to_mount=$ext_dev_partition
   fi
   mkdir -p /data/to
   mount $partition_to_mount /data/to

   label=`e2label $partition_to_mount`
   echo "        Label of $partition_to_mount=$label"

   echo -e "******* Filesystem Statistics ******************************"
   df -h
   echo -e "************************************************************\n"

   # processing the rsync options for 1st samba share (smb1)
   if [ "$smb1_rsync_enable" = 1 -a "$smb1_mount_server_share" != "" ]; then
      smb1_rsync_from=$smb1_mount_point
      smb1_rsync_to=/data/to
      smb1_rsync_opts="-an --stats"  # default options
      if [ "$smb1_rsync_from_folder" != '' ]; then
        smb1_rsync_from="$smb1_rsync_from/$smb1_rsync_from_folder"
      fi

      if [ "$smb1_rsync_to_folder" != '' ]; then
        smb1_rsync_to="$smb1_rsync_to/$smb1_rsync_to_folder"
        mkdir -p "$smb1_rsync_to"
      fi
      if [ "$smb1_rsync_options" != '' ]; then
         smb1_rsync_opts=$smb1_rsync_options
      fi

      #see https://superuser.com/questions/355437/bash-script-dealing-with-spaces-when-running-indirectly-commands
      if [ "$smb1_rsync_from_enable_expansion" = 1 ]; then
         # this only works if there are no spaces in $smb1_rsync_from - of course in that case you replace any space by ?
         rsync_cmd=(rsync $smb1_rsync_opts $smb1_rsync_from "$smb1_rsync_to")
      else
         rsync_cmd=(rsync $smb1_rsync_opts "$smb1_rsync_from" "$smb1_rsync_to")
      fi
      echo -e  "STEP 4: ${rsync_cmd[@]}"
      "${rsync_cmd[@]}"
   fi


   # processing the rsync options for 2st samba share (smb2)
   if [ "$smb2_rsync_enable" = 1  -a "$smb2_mount_server_share" != "" ]; then
      smb2_rsync_from=$smb2_mount_point
      smb2_rsync_to=/data/to
      smb2_rsync_opts="-an --stats"  # default options
      if [ "$smb2_rsync_from_folder" != '' ]; then
        smb2_rsync_from="$smb2_rsync_from/$smb2_rsync_from_folder"
      fi

      if [ "$smb2_rsync_to_folder" != '' ]; then
        smb2_rsync_to="$smb2_rsync_to/$smb2_rsync_to_folder"
        mkdir -p "$smb2_rsync_to"
      fi
      if [ "$smb2_rsync_options" != '' ]; then
         smb2_rsync_opts=$smb2_rsync_options
      fi

      #see https://superuser.com/questions/355437/bash-script-dealing-with-spaces-when-running-indirectly-commands
      if [ "$smb2_rsync_from_enable_expansion" = 1 ]; then
         # this only works if there are no spaces in $smb2_rsync_from - of course in that case you replace any space by ?
         rsync_cmd=(rsync $smb2_rsync_opts $smb2_rsync_from "$smb2_rsync_to")
      else
         rsync_cmd=(rsync $smb2_rsync_opts "$smb2_rsync_from" "$smb2_rsync_to")
      fi
      echo -e "STEP 4: ${rsync_cmd[@]}"
      "${rsync_cmd[@]}"
   fi
else # "$ext_dev_partition" == ''
   echo -e "\nERROR: environment variable \$ext_dev_partition must be set !"
   echo -e "       FYI the output of \"fdisk -l /dev/sd?\":"
   echo "======================================================================="
   fdisk -l /dev/sd?
   echo "======================================================================="
fi

echo -e "\nSTEP 5: Sleeping forever"
while true; do
   # every hour a "zzz" is put into the log files.
   echo "    zzz"
   sleep 3600
done
