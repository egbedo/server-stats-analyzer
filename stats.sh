#/bin/bash

# This script focuses on server performance stats, it gathers and displays essential server stats.


# Total CPU usage

echo "======= CPU Usage ======="

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8"%"}')
echo "Total CPU Usage: $CPU_USAGE"


# Memory Usage
echo "===== Memory Usage ======="
MEMORY=$(free -m | grep Mem)
TOTAL_MEM=$(echo $MEMORY | awk '{print $2}')  # Total memory in Megabytes
USED_MEM=$(echo $MEMORY | awk '{print $3}')   # used memory in MB
FREE_MEM=$(echo $MEMORY | awk '{print $4}')   # Free memory in MB
PERCENT_USED=$((USED_MEM * 100 / TOTAL_MEM))  # Used memory as a percentage
echo "Total Memory: ${TOTAL_MEM}MB"
echo "Used Memory: ${USED_MEM}MB ($PERCENT_USED%)"
echo "Free Memory: ${FREE_MEM}MB ($((100 - PERCENT_USED))%)"

# Disk usage
echo "==================== DISK USAGE ===================="
DISK_USAGE=$(df -h | grep "^/dev/" | awk '{print $1, $5, $4 " free"}')
echo "$DISK_USAGE"

# top 5 processes by cpu usage
echo "====== TOP 5 PROCESSES BY MEMORY USAGE ======"
ps -eo pid,comm,%mem --sort=-%mem | head -n 6 | awk '{printf "PID: %s, Command: %s, Memory: %s%%\n", $1, $2, $3}'

# The OS version
echo "OS Version:"
cat /etc/os-release | grep -e "^NAME" -e "^VERSION"

# 'uptime
echo "Uptime:"
uptime -p

echo "Load Average:"
uptime | awk -F'load average:' '{print $2}'

echo "Logged in Users:"
who | awk '{print $1}' | sort | uniq -c | awk '{print $2 ": " $1 " session(s)"}'

echo "Failed Login Attempts:"
grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l || echo "Log file not accessible"

