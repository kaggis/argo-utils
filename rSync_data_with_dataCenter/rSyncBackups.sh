#!/bin/bash

#########################################################################################
# rSync Backaps - A simple script that transfers backups to a supposed data center.
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
#	* Kyriakos Gkinis <kyrginis@admin.grnet.gr>
#	* Anastasios Lisgaras <tasos@admin.grnet.gr>
#########################################################################################

# Bash colors.
red='\e[91m'
green='\e[92m'
blue='\e[34m'
bold_on='\e[1m'
bold_off='\e[0m'
white='\e[97m'
color_off='\e[0m'

set -u
set -f
set -o pipefail

while getopts h:u:r:k:f:t: option 
do
	case "${option}" in
	h|--help)
		echo -e "rSync Backups."
		echo -e "------------------------------------------------------------------------------------------ "
		echo -e "rSyncBackups.sh [arguments]"
		echo -e " "
		echo -e "Arguments:"
		echo -e "--help \tShow brief help."
		echo -e "-u \tRemote username - Specify the username of remote host."
		echo -e "-r \tDestination domain name or IP Address."
		echo -e "-k \tSSH public key - Specify the SSH public key."
		echo -e "-f \tThe file or directory path to be copied."
		echo -e "-t \tSpecify the directory where the backup file will be saved."
		echo -e "------------------------------------------------------------------------------------------ "
		echo -e "Usage: ./rSyncBackups.sh -u user -r datacenter.gr -k ~/.ssh/supper-Key -f backup.tar.gz -t /home/debian/backups "
		exit 0
		;;
	u) REMOTE_USER=${OPTARG} ;;
	r) REMOTE_HOST=${OPTARG} ;;
	k) SSH_KEY=${OPTARG} ;;
	f) FROM_DIR="${OPTARG//:/$' '}"	;;
	t) REMOTE_PARENT_DIR=${OPTARG} ;;
	esac
done

echo -e "\n---------------------------------------------------------------------------------"
echo -e "| Backup of files to host $red$bold_on$REMOTE_HOST$bold_off$color_off begins at $blue`date`$color_off \t|"
echo -e "---------------------------------------------------------------------------------"
logger "[rSyncBackups] Backup of files ( $FROM_DIR ) to host $REMOTE_HOST begins at `date`"

/usr/bin/rsync -zh -e "ssh -o StrictHostKeyChecking=no -i $SSH_KEY " $FROM_DIR $REMOTE_USER@$REMOTE_HOST:$REMOTE_PARENT_DIR 2>/dev/null

if [ "$?" -eq "0" ]
then
	echo -e "-----------------------------------------------------------------------------------------"
	echo -e "| Backup of files to host $red$REMOTE_HOST$color_off $green$bold_on completed $bold_off$color_off at $blue`date`$color_off \t|"
	echo -e "-----------------------------------------------------------------------------------------\n"
	logger "[rSyncBackups] Backup procedure to host $REMOTE_HOST was successfully completed at `date`."
else
	echo -e "-----------------------------------------------------------------------------------------"
	echo -e "| Backup of files to host $red$REMOTE_HOST$color_off $red$bold_on failed $bold_off$color_off at $blue`date`$color_off \t|"
	echo -e "-----------------------------------------------------------------------------------------\n"
	logger "[rSyncBackups] Backup procedure to host $REMOTE_HOST was **failed** and stopped at `date`."
fi

# vim: syntax=sh ts=4 sw=4 sts=4 sr noet
