#!/bin/bash

#########################################################################################
# GOCDB Backup - A simple script that compresses all the necessary files needed for
# a complete backup.
#
# Copyright (C) 2020 GRNET.
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# Along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.   
#
# Contributor(s):
#	* Anastasios Lisgaras <tasos@admin.grnet.gr>
#########################################################################################

set -u
set -f
set -o pipefail

while getopts h:u:p:d: option 
do
	case "${option}" in
	h|--help)
		echo -e "GOCDB Backup."
		echo -e "------------------------------------------------------------------------------------------ "
		echo -e "gocdbBackup.sh [arguments]"
		echo -e " "
		echo -e "Arguments:"
		echo -e "--help \tShow brief help."
		echo -e "-u \tDatabase username - Specify the username that has rights in the database you want to back up."
		echo -e "-p \tDatabase password - Specify the database user password."
		echo -e "-d \tDatabase name\t  - Specify the name of the database for which you want to back up."
		echo -e "------------------------------------------------------------------------------------------ "
		echo -e "Usage: ./gocdbBackup.sh -u user -p 'password' -d database"
		exit 0
		;;
	u) DATABASE_USER=${OPTARG} ;;
	p) DATABASE_PASSWORD=${OPTARG} ;;
	d) DATABASE_NAME=${OPTARG} ;;
	esac
done


timestamp=$(date +%Y-%m-%d)
web_server_conf_files="/etc/httpd/"
gocdb_files="/var/backups/gocdb/site"
database_dumps="/var/backups/gocdb/database"
archives="/var/backups/gocdb/archives"


## Create directories if doesn't exist.
[ ! -d $gocdb_files		] && mkdir -p ${gocdb_files}
[ ! -d $database_dumps	] && mkdir -p ${database_dumps}
[ ! -d $archives		] && mkdir -p ${archives}


# Backup files 
## SQL.
mysqldumb="/usr/bin/mysqldump --user='$DATABASE_USER'  --password='$DATABASE_PASSWORD'  --lock-tables --databases ${DATABASE_NAME} > ${database_dumps}/${timestamp}_${HOSTNAME}_${DATABASE_NAME}.sql"
eval "$mysqldumb"


## Server files.
find /var/www/gocdb/ -type f -exec sha256sum {} + > ${gocdb_files}/${timestamp}_${HOSTNAME}_gocdbFiles_sha256sum


# Archive
cp ${gocdb_files}/${timestamp}_${HOSTNAME}_gocdbFiles_sha256sum ${database_dumps}

## Archive the hashing file of gocdb files, web server configuration files, web server logs and database.
cd ${database_dumps} && \
tar -zcvf ${archives}/${timestamp}_${HOSTNAME}.tar.gz \
	${timestamp}_${HOSTNAME}_${DATABASE_NAME}.sql \
	${timestamp}_${HOSTNAME}_gocdbFiles_sha256sum \
	${web_server_conf_files} \

rm ${database_dumps}/${timestamp}_${HOSTNAME}_gocdbFiles_sha256sum

# Delete old files
rm -rf ${database_dumps}
find ${archives} -type f -mtime +60 -exec rm {} \;




# vim: syntax=sh ts=4 sw=4 sts=4 sr noet
