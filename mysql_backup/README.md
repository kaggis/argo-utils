Agora Backup.
=============

This bash script is intended to create a tarball with all necessary files so that we have a complete backup for the **Agora** project.

## Requirements.
This bash script is very simple, but it is required to have the **mysql** tool installed.

### Installation of mysql.
* Debian GNU/Linux.
```bash
apt install mysql-client
``` 

* CentOS Linux.
```bash
yum install mysql
```


Usage.
======

## Command Line Options

The following is the output from `./mysqlBackup.sh -help`, providing an overview of the basic command line options:

```
Agora Backup.
------------------------------------------------------------------------------------------ 
mysqlBackup.sh [arguments]
 
Arguments:
--help 	Show brief help.
-u 	Database username - Specify the username that has rights in the database you want to back up.
-p 	Database password - Specify the database user password.
-d 	Database name	  - Specify the name of the database for which you want to back up.
-f 	Directories or files	  - Specify the name of the directories or files for which you want to back up.
	Note: If you want, you can also archive multiple directories or files by separating the paths of the files or directories with ':'.
------------------------------------------------------------------------------------------ 
Usage: ./mysqlBackup.sh -u user -p 'password' -d database -f file:directory
```

## Examples.

* Only Database
```bash
./mysqlBackup.sh -u 'agora_db_username' -p '!4@$6' -d 'agora_database'
```

* Database & Apache configuration file
```bash
./mysqlBackup.sh -u 'agora' -p 'i7Ms3Ih$j9n2C!R' -d 'Ag0ra' -f /etc/apache2/sites-available/agora.conf
```

* Database, Apache configuration file, website files & website configuration files
```bash
./mysqlBackup.sh -u 'agora' -p 'i7Ms3Ih$j9n2C!R' -d 'Ag0ra' -f /etc/apache2/sites-available/agora.conf:/srv/agora/:/etc/agora/
```



```bash
/var/backups/
└── agora
    ├── archives
    │   └── 2020-05-21_agora_demo.tar.gz
    └── database
        └── 2020-05-21_agora_demo_agora.sql

```



