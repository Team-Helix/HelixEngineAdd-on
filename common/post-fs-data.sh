#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in post-fs-data mode

#Disable BCL
if [ -e "/sys/devices/soc/soc:qcom,bcl/mode" ]; then
	chmod 644 /sys/devices/soc/soc:qcom,bcl/mode
	echo -n disable > /sys/devices/soc/soc:qcom,bcl/mode
fi

#Stopping perfd
stop perfd

# Disable sysctl.conf to Prevent ROM Interference
if [ -e /system/etc/sysctl.conf ]; then
  mount -o remount,rw /system
  mv /system/etc/sysctl.conf /system/etc/sysctl.conf.bak
  mount -o remount,ro /system
fi
