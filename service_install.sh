#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root (run sudo bash)"
  exit
fi

echo "Service Installer"
echo -n "Enter description service: "
read description
echo -n "Enter user serivce: "
read user
echo -n "Enter working directory: "
read working_directory
echo -n "Enter exec start: "
read exec_start
echo " 
ExecStart: $exec_start 
WorkingDirectory:$working_directory 
User: $user 
Description: $description
-------------------------"
echo -n "Are you sure? [y/n]: "
read allow

if [[ $allow == "y" ]]; then
      true
  elif [[ $allow == "n" ]]; then
      exit
  else [[ $allow == "y" ]] && [[ $allow != "n" ]]
      exit
fi