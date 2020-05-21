# (r)Sync data with a data center.

This bash script is intended to sync the local backup files with the data center.

## Requirements.
This bash script is very simple, but it is required to have the **rsync** tool installed on both the local and remote machine.

### Installation of rsync.
* Debian GNU/Linux.
```bash
apt install rsync
``` 

* CentOS Linux.
```bash
yum install rsync
```


----------------------------------------------------------------

# Usage.

## Command Line Options

The following is the output from `./rSyncBackups.sh --help`, providing an overview of the basic command line options:

```
------------------------------------------------------------------------------------------ 
rSyncBackups.sh [arguments]
 
Arguments:
--help 	Show brief help.
-u 	Remote username - Specify the username of remote host.
-r 	Destination domain name or IP Address.
-k 	SSH public key - Specify the SSH public key.
-f 	The file or directory path to be copied.
-t 	Specify the directory where the backup file will be saved.
------------------------------------------------------------------------------------------ 
Usage: ./rSyncBackups.sh -u user -r datacenter.gr -k ~/.ssh/supper-Key -f backup.tar.gz -t /home/debian/backups
```

## Examples.
* You can choose to copy a specific file :
```bash
├── backups
│   └── gcloud-VM_1
│       └── backup_01.tar.gz
└── secrets
    ├── top_secret_1.tar.gz
    ├── top_secret_2.tar.gz
    └── top_secret_3.tar.gz

3 directories, 4 files
```

```bash
./rSyncBackups.sh -u debian -r 192.168.0.56 -k ~/.ssh/gr-datacenter -f top_secret_4.tar.gz -t /home/debian/secrets
```

```bash
├── backups
│   └── gcloud-VM_1
│       └── backup_01.tar.gz
└── secrets
    ├── top_secret_1.tar.gz
    ├── top_secret_2.tar.gz
    ├── top_secret_3.tar.gz
    └── top_secret_4.tar.gz

3 directories, 5 files
```

* Multiple files can also be sent.

**Attention** : Should be separated the paths of the files or the directories with `:`.

```bash
├── backups
│   └── gcloud-VM_1
│       └── backup_01.tar.gz
└── secrets
    ├── top_secret_1.tar.gz
    ├── top_secret_2.tar.gz
    ├── top_secret_3.tar.gz
    └── top_secret_4.tar.gz

3 directories, 5 files
```

```bash
./rSyncBackups.sh -u debian -r 192.168.0.56 -k ~/.ssh/gr-datacenter -f backup_02.tar.gz:backup_03.tar.gz -t /home/debian/backups/$HOSTNAME
```


```bash
├── backups
│   └── gcloud-VM_1
│       ├── backup_01.tar.gz
│       ├── backup_02.tar.gz
│       └── backup_03.tar.gz
└── secrets
    ├── top_secret_1.tar.gz
    ├── top_secret_2.tar.gz
    ├── top_secret_3.tar.gz
    └── top_secret_4.tar.gz

3 directories, 7 files
```


* You can also choose to copy a directory :
```bash
./rSyncBackups.sh -u debian -r 192.168.0.56 -k ~/.ssh/gr-datacenter -f backups/ -t /home/debian/backups/$HOSTNAME/
```



# Logging.
The script sends logs for each of its actions in the system.

```bash
tail -f /var/log/messages
```

```
Apr 24 13:17:23 debianVM root: [rSyncBackups] Backup of files ( top_secret_10.tar.gz README.m4d ) to host 192.168.0.56 begins at Fri Apr 24 13:17:23 EEST 2020
Apr 24 13:17:25 debianVM root: [rSyncBackups] Backup procedure to host 192.168.0.56 was **failed** and stopped at Fri Apr 24 13:17:25 EEST 2020.

Apr 24 13:17:42 debianVM root: [rSyncBackups] Backup of files ( top_secret_10.tar.gz README.md ) to host 192.168.0.56 begins at Fri Apr 24 13:17:42 EEST 2020
Apr 24 13:17:44 debianVM root: [rSyncBackups] Backup procedure to host 192.168.0.56 was successfully completed at Fri Apr 24 13:17:44 EEST 2020.

Apr 24 13:22:56 debianVM root: [rSyncBackups] Backup of files ( top_secret_10.tar.gz ) to host 192.168.0.56 begins at Fri Apr 24 13:22:56 EEST 2020
Apr 24 13:22:58 debianVM root: [rSyncBackups] Backup procedure to host 192.168.0.56 was successfully completed at Fri Apr 24 13:22:58 EEST 2020.
```


