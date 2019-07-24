# Balena application "samba-rsync"

## Rationale behind this repository

The idea is to use harddisks recuperated from old laptops and desktops as backup storage for my extensive photo and video collection (and other data).  Once the backup is taken, I plan to unplug those harddisks and get them safely stored at a different location.

## Goals achieved

1. make it easy to format a harddisk connected to a USB port of a raspberry pi (or other balena compatible device) in the ext4 format (ext4 = popular filesystem format for linux systems)
2. mount this harddisk (ext4 partition) so that the raspberry pi can write to it.
3. create a windows share (samba) so that I can read the contents written to this harddisk from my laptop by simply mounting this windows share on my laptop.
4. mount on the raspberry pi the external windows share holding my photo/video collection as read only.
5. take a backup of specific folders from the windows share (see point 4) to the mounted harddisk (see step 2) using [rsync](https://en.wikipedia.org/wiki/Rsync).

## Hardware needed besides raspberry pi

1. harddisk(s) with sufficient space for the backup
2. cable to connect harddisk to one of the USB ports of the raspberry pi (I have used a SATA to USB cable for my 3.5 inch SATA disks)
3. Assure that you are harddisk is sufficiently powered (for most 3.5 inch harddisk the power provided by the raspberry pi USB port is sufficient so you don't need an external power source)

## STEPS

### 1. Deploy Balena application

So as you might have guessed this is indeed a balena application.  So follow all standard instructions for setting up and deploying this balena application. (e.g. see [getting started raspberry pi example](https://www.balena.io/docs/learn/getting-started/raspberrypi3/nodejs/))

After this step: this balena application should be running on your raspberry pi.

### 2. Format the harddisk (disk partition) in ext4 format

If your hard disk is not yet properly formatted in ext4 format then:

1. connect the harddisk to one of the USB ports.  
2. Open in your balenacloud dashboard a terminal window for the `samba-rsync` container and execute the following steps:
3. Create one partition on the hard disk using the `fdisk`command.  For more information see [here](https://www.2daygeek.com/linux-fdisk-command-to-manage-disk-partitions/)
4. Format the partition in ext4 format using the command `mkfs.ext4` (e.g. `mkfs.ext4 /dev/sda1`)
5. Optionally you can give the partition a meaningful label using the command : `e2label` (e.g. `e2label /dev/sda1 hd01_ext4_700G`)

### 3. Set Device Service Variables for the samba-rsync container

Within your balenacloud dashboard you must set the following device service variables for the `samba-rsync` container.

#### 3.1 specify external harddisk to mount

| Namee                     | Description                                  |
|------------------------- | ---------------------------------------------|
| **ext_dev_partition**    |  This is the linux device name of the ext4 partition created in step 2 (E.g. `/dev/sda1` ).  Note that this is the partition where all the files will be written to by the rsync command (see further). |

#### 3.2 specify 
2. The following command can be used to synchronise a folder using ssh: `rsync -avHe ssh root@192.168.1.150:/nfs/fotos_en_films/201[0-4] /data/hd/fotos_en_films`
3. The following command can be used to mount samba share: `mount -t cifs //192.168.1.150/jan /data/from -o user=jan`
`mount -t cifs -o user=jan,password=xxx //192.168.1.150/jan /data/from/smb1

rsync -av /data/from/fotos_en_films/2000 /data/to/fotos_en_films
