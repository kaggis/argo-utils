GOCDB Backup.
=============

This bash script is intended to create a tarball with all necessary files so that we have a complete backup for the **GOCDB** project.

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

The following is the output from `./gocdbBackup.sh -help`, providing an overview of the basic command line options:

```
GOCDB Backup.
------------------------------------------------------------------------------------------ 
gocdbBackup.sh [arguments]
 
Arguments:
--help  Show brief help.
-u  Database username - Specify the username that has rights in the database you want to back up.
-p  Database password - Specify the database user password.
-d  Database name     - Specify the name of the database for which you want to back up.
------------------------------------------------------------------------------------------ 
Usage: ./gocdbBackup.sh -u user -p 'password' -d database
```

## Examples.

```bash
./gocdbBackup.sh -u 'gocdb_db_username' -p '!4@$6' -d 'gocdbDatabase'
```

```bash
/var/backups/
└── gocdb
    ├── archives
    │   └── 2020-05-21_gocdb_demo.tar.gz
    ├── database
    │   └── 2020-05-21_gocdb_demo_gocdbDatabase.sql
    └── site
        └── 2020-05-21_gocdb_demo_gocdbFiles_sha256sum
```

