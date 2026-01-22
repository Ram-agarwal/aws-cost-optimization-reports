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
du -sh /* 2>/dev/null | sort -hr | head -10
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

echo "================================================="
echo " HEALTH CHECK COMPLETED SUCCESSFULLY"
echo "================================================="
