## Rationale behind this repository

The idea is to use harddisks recuperated from old laptops and desktops as backup storage for my extensive photo and video collection (and other data).  Once the backup is taken, I plan to unplug those harddisks and get them safely stored at a different location.

## Goals achieved

1. make it easy to format a harddisk connected to a USB port of a raspberry pi (or other balena compatible device) in the ext4 format (ext4 = popular filesystem format for linux systems)
2. mount this harddisk (ext4 partition) so that the raspberry pi can write to it.
3. create a windows share (samba) so that I can read the contents written to this harddisk from my laptop by simply mounting this windows share on my laptop.
4. mount on the raspberry pi the external windows share holding my photo/video collection as read only.
5. take a backup of specific folders of the windows share (see point 4) on the mounted harddisk (see step 2) using [rsync](https://en.wikipedia.org/wiki/Rsync).

## Hardware needed besides raspberry pi

1. harddisk(s) with sufficient space for the backup
2. cable to connect harddisk to one of the USB ports of the raspberry pi (I have used a SATA to USB cable for my 3.5 inch SATA disks)
3. Assure that you are harddisk is sufficiently powered (for most 3.5 inch harddisk the power provided by the raspberry pi USB port is sufficient so you don't need an external power source)

## STEPS

### 1. Balena Setup

So as you might have guessed this is indeed a balena application.  So follow all standard instructions for setting up and deploying this balena application. (e.g. see [getting started raspberry pi example](https://www.balena.io/docs/learn/getting-started/raspberrypi3/nodejs/))

### Format the hard disk (disk partition) in ext4 format

If your hard disk is not yet properly formatted in ext4 format then follow the below instructions.

### 1.1. Partition the hard disk

Create one partition on the hard disk using the `fdisk`command.
For more information see:

* https://www.2daygeek.com/linux-fdisk-command-to-manage-disk-partitions/

### 1.2. Format the partition in ext4 format

Format the partion in the ext4 format using the command `mkfs.ext4`
E.g. `mkfs.ext4 /dev/sda1`

### 1.3. Give the partition a meaningful label

 Give the ext4 partion a meaningful label using the command : `e2label`
E.g. `e2label /dev/sda1 hd01_ext4_700G`

# Steps (obsolete)

1. Mount the partion using the command: `mount /dev/sda1 /data/to`
2. The following command can be used to synchronise a folder using ssh: `rsync -avHe ssh root@192.168.1.150:/nfs/fotos_en_films/201[0-4] /data/hd/fotos_en_films`
3. The following command can be used to mount samba share: `mount -t cifs //192.168.1.150/jan /data/from -o user=jan`
`mount -t cifs -o user=jan,password=xxx //192.168.1.150/jan /data/from/smb1

rsync -av /data/from/fotos_en_films/2000 /data/to/fotos_en_films
