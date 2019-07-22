#!/bin/bash

if [ "$SAMBA_SHARE_1" != '' ]; then
   echo "Mounting samba share 1 - TBD"
   mkdir -p /data/from/smb1
   mount -t cifs $SAMBA_SHARE_1 /data/from/smb1
fi

sleep 3600
exit 0
