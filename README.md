# Steps
1. Format the hard disk using `fdisk` command.
2. Convert the partion to the ext4 format using the command `mkfs.ext4 /dev/sda1`
3. Give the ext4 partion a meaningful label using the command : `e2label /dev/sda1 hd01_ext4_700G`
4. Mount the partion using the command: `mount /dev/sda1 /mnt/rsync_data/`
5. The following command can be used to synchronise a folder: `rsync -avHe ssh root@192.168.1.150:/nfs/fotos_en_films/2000 /mnt/rsync_data/test`

# Interesting Links

* https://www.2daygeek.com/linux-fdisk-command-to-manage-disk-partitions/

