#!/usr/bin/expect -f
set timeout 5
set host [lindex $argv 0]
set DIR [file dirname [info script]]
set usr_pwd [exec sh -c "grep 'USR_PWD=' $DIR/.env | cut -d'=' -f2"]
set ter_pwd [exec sh -c "grep 'TER_PWD=' $DIR/.env | cut -d'=' -f2"]

spawn scp /root/ConceptReader/target/aarch64-unknown-linux-musl/debug/reader $host:/home/terasic/rt

expect "*password: "
send "$usr_pwd\r"
expect "*password: "
send "$ter_pwd\r"

expect eof
