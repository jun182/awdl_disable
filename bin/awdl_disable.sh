#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

check_and_disable_awdl() {
  echo "$(date): Checking piece of shit awdl0 interface..."
  ifconfig_output=$(ifconfig awdl0)
  echo "$(date): ifconfig output: $ifconfig_output"
  
  if echo "$ifconfig_output" | grep -q "status: active"; then
    echo "$(date): awdl0 interface is fucking active. Will kill child process."
    /sbin/ifconfig awdl0 down
    if [ $? -eq 0 ]; then
      echo "$(date): awdl0 interface aborted successfully."
    else
      echo "$(date): Unfortunately, failed to abort the awdl0 interface."
    fi
  else
    echo "$(date): Thank heavens, the awdl0 interface is not alive."
  fi
}

while true; do
  check_and_disable_awdl
  sleep 5 # Reduced sleep time for quicker response
done
