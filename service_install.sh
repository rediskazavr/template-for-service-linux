#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (run sudo bash)"
    exit 1
fi

echo "Service Installer"
echo -n "Enter name for service (example.service): "
read name
echo -n "Enter description service: "
read description
echo -n "Enter user serivce: "
read user
echo -n "Enter working directory: "
read working_directory
echo -n "Enter exec start: "
read exec_start

echo "
Name Service: $name
ExecStart: $exec_start 
WorkingDirectory:$working_directory 
User: $user 
Description: $description
-------------------------"
echo -n "Are you sure? [y/n]: "
read allow

if [[ "$allow" == "y" ]]; then
    true
elif [[ "$allow" == "n" ]]; then
    exit 0
else
    echo "Aborted."
    exit 1
fi

if [[ "$user" == "root" ]]; then
    echo "Attention, your user ROOT, it's not safe!"
    echo -n "Are you sure? [y/n]: "
    read sure
    if [[ "$sure" == "y" ]]; then
        true
    elif [[ "$sure" == "n" ]]; then
        exit 0
    else
        echo "Aborted."
        exit 1
    fi
fi 

cat << EOF > "/etc/systemd/system/${name}.service"
[Unit]
Description=$description
After=network.target

[Service]
Type=simple
User=$user
Group=$user
WorkingDirectory=$working_directory
ExecStart=$exec_start
Restart=on-failure
RestartSec=5
ProtectSystem=full
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable "$name"
systemctl start "$name"

echo "Service Activated. Check status (systemctl status $name)"