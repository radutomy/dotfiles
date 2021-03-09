#!/bin/bash
if pidof -o %PPID -x “rclone-cron.sh”; then
	exit 1
fi

rclone sync gdrive:/ onedrive:/ --password-command="pass rclone/config"

exit
