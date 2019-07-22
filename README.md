# Hardware needed besides raspberry pi.
1. hard disk with sufficient space to write the files to.
2. cable to connect hard disk to one of the USB ports of the raspberry pi
3. Assure that you are hard disk sufficiently powered (for most 3.5 inch harddisk the power provided by the raspberry pi USB port is sufficient so that you don't need an external power source)

# Steps
## 1. Format the hard disk (disk partition) in ext4 format
If your hard disk is not yet properly formatted in ext4 format then follow the below instructions.

### 1.1. Partition the hard disk.
Create one partition on the hard disk using the `fdisk`command.
For more information see:
* https://www.2daygeek.com/linux-fdisk-command-to-manage-disk-partitions/

### 1.2. Format the partition in ext4 format
Format the partion in the ext4 format using the command `mkfs.ext4`
E.g. `mkfs.ext4 /dev/sda1`

 ### 1.3. Give the partition a meaningful label
 Give the ext4 partion a meaningful label using the command : `e2label`
E.g. `e2label /dev/sda1 hd01_ext4_700G`

# Steps
1. Format the hard disk using `fdisk` command.
2. Convert the partion to the ext4 format using the command `mkfs.ext4 /dev/sda1`
3. Give the ext4 partion a meaningful label using the command : `e2label /dev/sda1 hd01_ext4_700G`
4. Mount the partion using the command: `mount /dev/sda1 /data/hd`
5. The following command can be used to synchronise a folder using ssh: `rsync -avHe ssh root@192.168.1.150:/nfs/fotos_en_films/201[0-4] /data/hd/fotos_en_films`
6. The following command can be used to mount samba share: `mount -t cifs //192.168.1.150/jan /data/from -o user=jan`

# Interesting Links

* https://www.2daygeek.com/linux-fdisk-command-to-manage-disk-partitions/

