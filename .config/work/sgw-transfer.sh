#!/bin/bash

ver=$1

# Get the directory of the currently executing script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables
source $DIR/.env

# Set variables
user="developer"
host="192.168.23.254"
#proj="$HOME/src/device-main/VG1.G710/VG1.G710.csproj"
#core="$HOME/src/device-main/VG1.Core/VG1.Core.csproj"
#repo="$HOME/src/device-main"
repo="/mnt/c/src/device-main"
proj="$repo/VG1.G710/VG1.G710.csproj"
core="$repo/VG1.Core/VG1.Core.csproj"
pubdir="$repo/publish"
sgwhome="/home/developer"

# SSH command function
ssh_command() {
	cmd="$1"
	ssh_options="-o LogLevel=QUIET -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
	remote_cmd="echo $SGW_PWD | sudo -S sh -c '$cmd'"

	if sshpass -p $SGW_PWD ssh $ssh_options $user@$host "$remote_cmd" >/dev/null 2>/dev/null; then
		echo "SSH Command Successful: $cmd"
	else
		echo "SSH Command Failed: $cmd"
		exit 1
	fi
}

# SCP command function
scp_command() {
	src="$1"
	dest="$2"
	ssh_options="-o LogLevel=QUIET -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"

	if sshpass -p "$SGW_PWD" scp $ssh_options -r $src $user@$host:$dest 2>/dev/null; then
		echo "SCP Command Successful"
	else
		echo "SCP Command Failed"
		exit 1
	fi
}

change_ver() {
	sed -i -e "s|<AssemblyVersion>.*</AssemblyVersion>|<AssemblyVersion>$ver</AssemblyVersion>|g" "$core"
}

# Prepare Publish Directory
prepare_pubdir() {
	rm -rf $pubdir/*
	dotnet publish $proj -c Release -r linux-musl-arm --no-self-contained -p:PublishSingleFile=false -o $pubdir
	printf "\nBuild finished sucessfully..\n"
}

# Main program execution starts here

if [ $# -gt 0 ]; then
  change_ver
fi

prepare_pubdir
printf "Deploying build version to remote:  $ver\n\n"
scp_command $pubdir $sgwhome
ssh_command "docker rm -f vg1"
ssh_command "rm -rf /overlay/vg1/app/Versions/dev"
ssh_command "mv $sgwhome/publish /overlay/vg1/app/Versions/dev"
ssh_command "echo dev > /overlay/vg1/app/Versions/Current.txt"
ssh_command "/etc/init.d/vg1 start"
