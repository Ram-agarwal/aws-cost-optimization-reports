#!/bin/bash

echo "================================================="
echo " SERVER HEALTH CHECK REPORT"
echo "================================================="
date
echo

############################
# CPU Usage
############################
echo "1️⃣ CPU USAGE (Top Snapshot)"
top -b -n1 | head -10
echo

############################
# Load Average
############################
echo "2️⃣ LOAD AVERAGE"
uptime
echo

############################
# Memory Usage
############################
echo "3️⃣ MEMORY USAGE (RAM)"
free -h
echo

############################
# Disk Usage (Partition Level)
############################
echo "4️⃣ DISK USAGE (Partition)"
df -h
echo

############################
# Top Disk Consuming Directories
##########################
echo "5️⃣ TOP DISK CONSUMING DIRECTORIES"
du -sh /var /home /opt 2>/dev/null | sort -hr
echo

############################
# Top CPU Consuming Processes
############################
echo "6️⃣ TOP CPU CONSUMING PROCESSES"
ps -eo pid,cmd,%cpu,%mem --sort=-%cpu | head
echo

############################
# Uptime Info
############################
echo "8️⃣ SERVER UPTIME"
uptime -p
echo

############################
# Zombie Processes
############################
echo "8️⃣ ZOMBIE PROCESSES"
ps aux | awk '{ if ($8 == "Z") print }'
echo

############################
# Failed Systemd Services
############################
echo "9️⃣ FAILED SYSTEMD SERVICES"
systemctl --failed
echo

############################
# Server Uptime
############################
echo "🔟 SERVER UPTIME"
uptime -p
echo

############################
# Last Reboot Info
############################
echo "1️⃣1️⃣ LAST REBOOT INFO"
last reboot | head -3
echo

############################
# Top Memory Consuming Processes
############################
echo "1️⃣2️⃣ TOP MEMORY CONSUMING PROCESSES"
ps -eo pid,cmd,%mem,%cpu --sort=-%mem | head
echo


echo "================================================="
echo " HEALTH CHECK COMPLETED SUCCESSFULLY"
echo "================================================="
