#!/bin/bash

echo "System Information"
echo "------------------"

echo "Hostname:"
hostname

echo "IP Address:"
hostname -I

echo "Disk usage:"
df -h

echo "Memory:"
free -h
