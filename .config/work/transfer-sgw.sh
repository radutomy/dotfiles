#!/bin/bash

# need to define host first in ~/.ssh/config
host=$1
ver=$2

# Get the directory of the currently executing script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment variables
source $DIR/.env

# Set variables
repo="/mnt/x/device-sgw"
proj="$repo/src/VG1.G710/VG1.G710.csproj"
core="$repo/src/VG1.Core/VG1.Core.csproj"
pubdir="$repo/publish"
sgwhome="/home/developer"

# SSH command function
ssh_command() {
	cmd="$1"
	ssh_options="-o LogLevel=QUIET -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
	remote_cmd="echo $SGW_PWD | sudo -S sh -c '$cmd'"

	if sshpass -p $SGW_PWD ssh $ssh_options $host "$remote_cmd" >/dev/null 2>/dev/null; then
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
	ssh_options="-o LogLevel=QUIET -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -O"

	if sshpass -p "$SGW_PWD" scp $ssh_options -r $src $host:$dest 2>/dev/null; then
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
build_proj() {
	rm -rf $pubdir/*
	#dotnet.exe publish $proj -c Release -r linux-musl-arm --no-self-contained -p:PublishSingleFile=false -o $pubdir
	dotnet.exe publish X:/device-sgw/src/VG1.G710/VG1.G710.csproj -c Release -r linux-musl-arm --no-self-contained -p:PublishSingleFile=false -o X:/device-sgw/publish
	printf "\nBuild finished sucessfully..\n"
}

# Main program execution starts here

if [ $# -gt 1 ]; then
	change_ver
fi

build_proj
printf "Deploying build version to remote:  $ver\n\n"
scp_command $pubdir $sgwhome
ssh_command "docker rm -f vg1"
ssh_command "rm -rf /overlay/vg1/app/Versions/dev"
ssh_command "mv $sgwhome/publish /overlay/vg1/app/Versions/dev"
ssh_command "echo dev > /overlay/vg1/app/Versions/Current.txt"
ssh_command "/etc/init.d/vg1 start"

# hack; delete after full WSL transition
#dotnet.exe restore X:/device-main/SmartHub.sln
#dotnet.exe restore X:/device-main/VG1.Mock/VG1.Mock.csproj
#dotnet.exe restore X:/device-main/VG1.G710/VG1.G710.csproj
