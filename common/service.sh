#!/system/bin/sh
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode

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

sleep 60

## Kernel Entropy, very experimental! If you run into issues, set it back to stock values!
echo 128 > /proc/sys/kernel/random/read_wakeup_threshold # stock is 64
echo 2048 > /proc/sys/kernel/random/write_wakeup_threshold # stock is 896

#FS
echo 10 > /proc/sys/fs/lease-break-time # stock is 45

#Workqueue
echo Y > /sys/module/workqueue/parameters/power_efficient

#Governor
if grep "schedutil" /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors; then
	#LITTLE
	echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable
	#big
	echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/iowait_boost_enable
	echo 0 /sys/module/cpu-boost/parameters/dynamic_stune_boost
	echo 0:0 4:0 >/sys/module/cpu-boost/parameters/input_boost_freq
	echo 0 >/sys/module/cpu-boost/parameters/input_boost_ms
	echo 5 >/dev/stune/top-app/schedtune.boost
	echo 0 >/dev/stune/top-app/schedtune.sched_boost
	echo 1 >/dev/stune/top-app/schedtune.prefer_idle
	echo 0 >/dev/stune/foreground/schedtune.prefer_idle
else
	if grep "msm8998" /system/build.prop || grep "msm8998" /vendor/build.prop; then
		#LITTLE
		echo 82 883200:86 1094400:89 1324800:92 1555200:95 > /sys/devices/system/cpu/cpufreq/policy0/interactive/target_loads
		echo 90000 > /sys/devices/system/cpu/cpufreq/policy0/interactive/timer_slack
		echo 20000 > /sys/devices/system/cpu/cpufreq/policy0/interactive/timer_rate
		echo 109440 > /sys/devices/system/cpu/cpufreq/policy0/interactive/hispeed_freq
		echo 0 1094400:20000 1555200:40000 > /sys/devices/system/cpu/cpufreq/policy0/interactive/above_hispeed_delay
		echo 400 > /sys/devices/system/cpu/cpufreq/policy0/interactive/go_hispeed_load
		echo 10000 > /sys/devices/system/cpu/cpufreq/policy0/interactive/min_sample_time
		echo 0 > /sys/devices/system/cpu/cpufreq/policy0/interactive/max_freq_hysteresis
		echo 0 > /sys/devices/system/cpu/cpufreq/policy0/interactive/boost
		echo 0 > /sys/devices/system/cpu/cpufreq/policy0/interactive/fast_ramp_down
		echo 1 > /sys/devices/system/cpu/cpufreq/policy0/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpufreq/policy0/interactive/boostpulse_duration
		echo 0 > /sys/devices/system/cpu/cpufreq/policy0/interactive/io_is_busy
		echo 0 > /sys/devices/system/cpu/cpufreq/policy0/interactive/enable_prediction
		#big
		echo 84 806400:87 1267200:90 1574400:93 1958400:96 > /sys/devices/system/cpu/cpufreq/policy4/interactive/target_loads
		echo 90000 > /sys/devices/system/cpu/cpufreq/policy4/interactive/timer_slack
		echo 1267200 > /sys/devices/system/cpu/cpufreq/policy4/interactive/hispeed_freq
		echo 20000 > /sys/devices/system/cpu/cpufreq/policy4/interactive/timer_rate
		echo 0 806400:40000 1267200:80000 > /sys/devices/system/cpu/cpufreq/policy4/interactive/above_hispeed_delay
		echo 400 > /sys/devices/system/cpu/cpufreq/policy4/interactive/go_hispeed_load
		echo 10000 > /sys/devices/system/cpu/cpufreq/policy4/interactive/min_sample_time
		echo 0 > /sys/devices/system/cpu/cpufreq/policy4/interactive/max_freq_hysteresis
		echo 0 > /sys/devices/system/cpu/cpufreq/policy4/interactive/boost
		echo 1 > /sys/devices/system/cpu/cpufreq/policy4/interactive/fast_ramp_down
		echo 1 > /sys/devices/system/cpu/cpufreq/policy4/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpufreq/policy4/interactive/boostpulse_duration
		echo 0 > /sys/devices/system/cpu/cpufreq/policy4/interactive/io_is_busy
		echo 0 > /sys/devices/system/cpu/cpufreq/policy4/interactive/enable_prediction
	elif grep "msm8996" /system/build.prop || grep "msm8996" /vendor/build.prop; then
		#LITTLE
		echo 78 729600:81 844800:84 1228800:86 1324800:92 1478400:99 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
		echo 90000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
		echo 1228800 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
		echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
		echo 0 844800:40000 1228800:60000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
		echo 400 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time	
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
		#big
		echo 80 806400:84 1248000:88 1324800:90 1785600:96 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/target_loads
		echo 90000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/timer_slack
		echo 1248000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/hispeed_freq
		echo 20000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/timer_rate
		echo 0 1248000:60000 1324800:80000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/above_hispeed_delay
		echo 400 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/go_hispeed_load
		echo 10000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/min_sample_time	
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/min_sample_time		
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/max_freq_hysteresis
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/boost
		echo 1 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/boostpulse_duration
	elif grep "msm8994" /system/build.prop;then
		#LITTLE
		echo 76 672000:64 768000:82 960000:89 1248000:94  1478000:99 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
		echo 356940 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
		echo 600000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
		echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
		echo 20000 460000:0 600000:60000 960000:100000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
		echo 400 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/ignore_hispeed_on_notif
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/fast_ramp_down
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/align_windows
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_migration_notif
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
		#big
		echo 76 768000:72 1248000:74 1440000:86 1958400:99 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
		echo 178470 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack
		echo 1958400 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
		echo 20000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
		echo 10000 1440000:120000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
		echo 400 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
		echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
		echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis
		echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/ignore_hispeed_on_notif
		echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boost
		echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/fast_ramp_down
		echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/align_windows
		echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_migration_notif
		echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
	elif grep "msm8992" /system/build.prop;then
		#LITTLE
		echo 76 787200:82 960000:89 1248000:99 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
		echo 356940 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
		echo 600000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
		echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
		echo 20000 460000:0 600000:60000 672000:100000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
		echo 400 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/fast_ramp_down
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
		#big
		echo 76 768000:72 1248000:74 1440000:86 1824000:99 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
		echo 178470 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_slack
		echo 1824000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/hispeed_freq
		echo 20000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
		echo 10000 1440000:120000 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
		echo 400 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
		echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
		echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/max_freq_hysteresis
		echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boost
		echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/fast_ramp_down
		echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
	else
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boost
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
	fi
fi

#Touchboost
echo 0 > /sys/module/msm_performance/parameters/touchboost
echo 0 > /sys/power/pnpmgr/touch_boost

#Graphics
echo 1 > /sys/devices/soc/5000000.qcom,kgsl-3d0/devfreq/5000000.qcom,kgsl-3d0/adrenoboost
echo 1 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/adrenoboost

#TCP
echo westwood > /proc/sys/net/ipv4/tcp_congestion_control
echo 1 > /proc/sys/net/ipv4/tcp_ecn #stock is 2
echo 1 > /proc/sys/net/ipv4/tcp_dsack
echo 0 > /proc/sys/net/ipv4/tcp_low_latency
echo 1 > /proc/sys/net/ipv4/tcp_timestamps
echo 1 > /proc/sys/net/ipv4/tcp_sack
echo 1 > /proc/sys/net/ipv4/tcp_window_scaling

#VM
#echo 1000 > /proc/sys/vm/dirty_expire_centisecs #value used before
#echo 1500 > /proc/sys/vm/dirty_writeback_centisecs # value used before
echo 6000 > /proc/sys/vm/dirty_expire_centisecs # stock is 200 android, 3000 linux
echo 2000 > /proc/sys/vm/dirty_writeback_centisecs # stock is 500 android and linux, 0 disables
echo 0 > /proc/sys/vm/oom_kill_allocating_task
echo 2 > /proc/sys/vm/page-cluster
echo 1 > /proc/sys/vm/overcommit_memory
echo 0 > /proc/sys/vm/oom_dump_tasks # stock is 1
echo 60 > /proc/sys/vm/stat_interval # stock is 1
echo 0 > /proc/sys/vm/drop_caches # reset normal caching

# Tweak Block-level Scheduler Queue
for i in /sys/block/*/queue; do
  echo 0 > $i/add_random # stock varies
  echo 0 > $i/iostats # stock is 1
  echo 0 > $i/nomerges # stock varies, was 1 up to now
  echo 64 > $i/nr_requests # stock is 128 for all blocks
  echo 1536 > $i/read_ahead_kb # mostly 128, sometimes 1024
  echo 0 > $i/rotational # stock varies
  echo 1 > $i/rq_affinity # stock is 0 or 1
  echo "cfq" > $i/scheduler # stock is cfq, sometimes (none)
done

#Tuning zRAM additionally afterwards, if present, + LMK & VM
chown root /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo 0 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
sync; # sync caches
echo 3 > /proc/sys/vm/drop_caches # drop caches
mem=$(cat /proc/meminfo | grep MemTotal | awk '{print $2}' );
if (( $mem < '3145728' )); then
	swapoff /dev/block/zram0 > /dev/null 2>&1
	echo 1 > /sys/block/zram0/reset
	echo 0 > /sys/block/zram0/disksize
	echo zstd > /sys/block/zram0/comp_algorithm
	echo lz4 > /sys/block/zram0/comp_algorithm
	echo 4 > /sys/block/zram0/max_comp_streams
	echo 8 > /sys/block/zram0/swappiness
	zRamMem=$(( $mem / 3 ));
	echo "$zRamMem" > /sys/block/zram0/disksize
	mkswap /dev/block/zram0 > /dev/null 2>&1
	swapon /dev/block/zram0 > /dev/null 2>&1
	echo "41472,48384,72192,84224,105280,126336" > /sys/module/lowmemorykiller/parameters/minfree
	echo 20 > /proc/sys/vm/swappiness
	echo 100 > /proc/sys/vm/vfs_cache_pressure
	echo 20 > /proc/sys/vm/dirty_ratio
	echo 2 > /proc/sys/vm/dirty_background_ratio
	echo 50 > /proc/sys/vm/overcommit_ratio
	echo 7542 > /proc/sys/vm/min_free_kbytes
elif (( $mem < '4194304' )); then
	if [ -e /sys/block/zram0 ]; then
		swapoff /dev/block/zram0 > /dev/null 2>&1
		echo 1 > /sys/block/zram0/reset
		echo 0 > /sys/block/zram0/disksize
		echo zstd > /sys/block/zram0/comp_algorithm
		echo lz4 > /sys/block/zram0/comp_algorithm
		echo 4 > /sys/block/zram0/max_comp_streams
		echo 8 > /sys/block/zram0/swappiness
		zRamMem=$(( $mem / 4 ));
		echo "$zRamMem" > /sys/block/zram0/disksize
		mkswap /dev/block/zram0 > /dev/null 2>&1
		swapon /dev/block/zram0 > /dev/null 2>&1
	fi
		echo "27648,41472,48384,72192,84224,121856" > /sys/module/lowmemorykiller/parameters/minfree
		echo 8 > /proc/sys/vm/swappiness
		echo 100 > /proc/sys/vm/vfs_cache_pressure
		echo 20 > /proc/sys/vm/dirty_ratio
		echo 2 > /proc/sys/vm/dirty_background_ratio
		echo 50 > /proc/sys/vm/overcommit_ratio
		echo 7542 > /proc/sys/vm/min_free_kbytes
elif (( $mem < '6291456' )); then
	if [ -e /sys/block/zram0 ]; then
		swapoff /dev/block/zram0 > /dev/null 2>&1
		echo 1 > /sys/block/zram0/reset
		echo 0 > /sys/block/zram0/disksize
		echo zstd > /sys/block/zram0/comp_algorithm
		echo lz4 > /sys/block/zram0/comp_algorithm
		echo 4 > /sys/block/zram0/max_comp_streams
		echo 5 > /sys/block/zram0/swappiness
		zRamMem=$(( $mem / 6 ));
		echo "$zRamMem" > /sys/block/zram0/disksize
		mkswap /dev/block/zram0 > /dev/null 2>&1
		swapon /dev/block/zram0 > /dev/null 2>&1
	fi
		echo "18432,23040,32256,48128,52640,76160" > /sys/module/lowmemorykiller/parameters/minfree
		echo 5 > /proc/sys/vm/swappiness
		echo 100 > /proc/sys/vm/vfs_cache_pressure
		echo 20 > /proc/sys/vm/dirty_ratio
		echo 2 > /proc/sys/vm/dirty_background_ratio
		echo 50 > /proc/sys/vm/overcommit_ratio
		echo 7542 > /proc/sys/vm/min_free_kbytes		
else
	swapoff /dev/block/zram0 > /dev/null 2>&1
	echo 0 > /sys/block/zram0/disksize
	echo "18432,23040,32256,48128,52640,76160" > /sys/module/lowmemorykiller/parameters/minfree
	echo 5 > /proc/sys/vm/swappiness
	echo 70 > /proc/sys/vm/vfs_cache_pressure
	echo 50 > /proc/sys/vm/dirty_ratio
	echo 5 > /proc/sys/vm/dirty_background_ratio
	echo 80 > /proc/sys/vm/overcommit_ratio
	echo 11088 > /proc/sys/vm/min_free_kbytes
fi
echo 0 > /sys/module/lowmemorykiller/parameters/debug_level

# Tweak Transmission Queue Buffer
for i in $(find /sys/class/net -type l); do
  echo 128 > $i/tx_queue_len
done
