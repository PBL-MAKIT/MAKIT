#!/bin/bash

# Snort alert log location
alert_file="/var/log/snort/snort.alert.fast"

# Backup script location
backup_script="/home/qqq/backup_script.sh"

# Tail the log file and search for the pattern, only for new lines
tail -f --lines=0 $alert_file | while read line; do
  if echo "$line" | grep -q "Brute"; then
    echo "Alert found: $line"
    
    # Call the backup script with a flag indicating a malicious backup
    bash "$backup_script" malicious &

    # Flag for malicious activity
    touch /tmp/malicious_activity

    # Loop until the backup_complete signal file is found
    while true; do
      if [ -f /tmp/backup_complete ]; then
        echo "Malicious backup completed. Rebooting system..."
        sudo reboot
      fi
      sleep 1 # Wait for a short period before checking again to avoid high CPU usage
    done

    # Remove the signal files for next time
    rm -f /tmp/backup_complete
    rm -f /tmp/malicious_activity
  fi
done
