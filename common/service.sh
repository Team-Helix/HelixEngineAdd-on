#!/system/bin/sh
# Please don't hardcode /magisk/modname/... ; instead, please use $MODDIR/...
# This will make your scripts compatible even if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode
# More info in the main Magisk thread
#!/system/bin/sh
# AUTHOR: TEAM HELIX @ XDA-DEVELOPERS
# Template by @ZeroInfinity, adapted from @RogerF81, improved by @Asiier
# Helix-Engine profile script: Balanced

stop perfd

#Stune
echo 0 > /dev/stune/schedtune.prefer_idle
echo 0 > /proc/sys/kernel/sched_child_runs_first
echo 0 > /dev/stune/background/schedtune.prefer_idle
echo 1 > /dev/stune/foreground/schedtune.prefer_idle
echo 1 > /dev/stune/top-app/schedtune.prefer_idle
echo 1000 > /proc/sys/kernel/sched_select_prev_cpu_us

#Governor
if grep 'schedutil' /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors; then
	#LITTLE
	echo 1000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
	echo 5000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
	echo 1 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable
	#big
	echo 1000 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us
	echo 5000 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us
	echo 1 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/iowait_boost_enable
else
	if grep "msm8998" /system/build.prop || grep "msm8998" /vendor/build.prop; then
		#LITTLE
		echo 82 883200:85 1171200:87 1324800:91 1555200:95 > /sys/devices/system/cpu/cpufreq/policy0/interactive/target_loads
		echo 90000 > /sys/devices/system/cpu/cpufreq/policy0/interactive/timer_slack
		echo 30000 > /sys/devices/system/cpu/cpufreq/policy0/interactive/timer_rate
		echo 1248000 > /sys/devices/system/cpu/cpufreq/policy0/interactive/hispeed_freq
		echo 0 883200:20000 1555200:40000 > /sys/devices/system/cpu/cpufreq/policy0/interactive/above_hispeed_delay
		echo 400 > /sys/devices/system/cpu/cpufreq/policy0/interactive/go_hispeed_load
		echo 20000 > /sys/devices/system/cpu/cpufreq/policy0/interactive/min_sample_time
		echo 79000 > /sys/devices/system/cpu/cpufreq/policy0/interactive/max_freq_hysteresis
		echo 0 > /sys/devices/system/cpu/cpufreq/policy0/interactive/boost
		echo 0 > /sys/devices/system/cpu/cpufreq/policy0/interactive/fast_ramp_down
		echo 1 > /sys/devices/system/cpu/cpufreq/policy0/interactive/use_sched_load
		echo 80000 > /sys/devices/system/cpu/cpufreq/policy0/interactive/boostpulse_duration
		echo 0 > /sys/devices/system/cpu/cpufreq/policy0/interactive/io_is_busy
		echo 0 > /sys/devices/system/cpu/cpufreq/policy0/interactive/enable_prediction
		#big
		echo 84 979200:86 1344000:88 1574400:91 1804800:95 > /sys/devices/system/cpu/cpufreq/policy4/interactive/target_loads
		echo 90000 > /sys/devices/system/cpu/cpufreq/policy4/interactive/timer_slack
		echo 1574400 > /sys/devices/system/cpu/cpufreq/policy4/interactive/hispeed_freq
		echo 30000 > /sys/devices/system/cpu/cpufreq/policy4/interactive/timer_rate
		echo 0 979200:20000 1574400:40000 > /sys/devices/system/cpu/cpufreq/policy4/interactive/above_hispeed_delay
		echo 400 > /sys/devices/system/cpu/cpufreq/policy4/interactive/go_hispeed_load
		echo 20000 > /sys/devices/system/cpu/cpufreq/policy4/interactive/min_sample_time
		echo 79000 > /sys/devices/system/cpu/cpufreq/policy4/interactive/max_freq_hysteresis
		echo 0 > /sys/devices/system/cpu/cpufreq/policy4/interactive/boost
		echo 0 > /sys/devices/system/cpu/cpufreq/policy4/interactive/fast_ramp_down
		echo 1 > /sys/devices/system/cpu/cpufreq/policy4/interactive/use_sched_load
		echo 80000 > /sys/devices/system/cpu/cpufreq/policy4/interactive/boostpulse_duration
		echo 0 > /sys/devices/system/cpu/cpufreq/policy4/interactive/io_is_busy
		echo 0 > /sys/devices/system/cpu/cpufreq/policy4/interactive/enable_prediction
	elif grep "msm8996" /system/build.prop || grep "msm8996" /vendor/build.prop; then
		#LITTLE
		echo 76 729600:81 844800:84 1228800:86 1324800:92 1478400:99 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
		echo 90000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_slack
		echo 1228800 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/hispeed_freq
		echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
		echo 0 844800:40000 1228800:60000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
		echo 400 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
		echo 10000 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time	
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/max_freq_hysteresis
		echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
		#big
		echo 78 729600:80 806400:84 1248000:88 1324800:90 1785600:96 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/target_loads
		echo 90000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/timer_slack
		echo 1248000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/hispeed_freq
		echo 30000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/timer_rate
		echo 0 1248000:60000 1324800:80000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/above_hispeed_delay
		echo 400 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/go_hispeed_load
		echo 25000 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/min_sample_time	
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/min_sample_time		
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/max_freq_hysteresis
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/boost
		echo 1 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/use_sched_load
		echo 0 > /sys/devices/system/cpu/cpu2/cpufreq/interactive/boostpulse_duration
	elif grep "msm8994" /system/build.prop;then
		#LITTLE
		echo 76 600000:40 672000:58 768000:82 960000:89 1248000:94  1478000:99 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
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
		echo 76 633000:48 768000:57 1248000:74 1440000:86 1958400:99 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
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
		echo 76 672000:58 787200:82 960000:89 1248000:99 > /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
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
		echo 76 768000:57 1248000:74 1440000:86 1824000:99 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
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
		echo 0 > /sys/devices/system/cpu/cpu4/cpufreq/interactive/boost
	fi
fi

#Touchboost
echo 0 > /sys/module/msm_performance/parameters/touchboost
echo 0 > /sys/power/pnpmgr/touch_boost

#I/0
echo "cfq" > /sys/block/sda/queue/scheduler
echo 1024 > /sys/block/sda/queue/read_ahead_kb
echo 128 > /sys/block/sda/queue/nr_requests
echo 0 > /sys/block/sda/queue/add_random
echo 0 > /sys/block/sda/queue/iostats
echo 1 > /sys/block/sda/queue/nomerges
echo 0 > /sys/block/sda/queue/rotational
echo 1 > /sys/block/sda/queue/rq_affinity

#Graphics
echo 1 > /sys/devices/soc/5000000.qcom,kgsl-3d0/devfreq/5000000.qcom,kgsl-3d0/adrenoboost
echo 1 > /sys/devices/soc/b00000.qcom,kgsl-3d0/devfreq/b00000.qcom,kgsl-3d0/adrenoboost

#TCP
echo westwood > /proc/sys/net/ipv4/tcp_congestion_control
echo 2 > /proc/sys/net/ipv4/tcp_ecn
echo 1 > /proc/sys/net/ipv4/tcp_dsack
echo 0 > /proc/sys/net/ipv4/tcp_low_latency
echo 1 > /proc/sys/net/ipv4/tcp_timestamps
echo 1 > /proc/sys/net/ipv4/tcp_sack
echo 1 > /proc/sys/net/ipv4/tcp_window_scaling

#WQ
echo Y > /sys/module/workqueue/parameters/power_efficient

## FS, if on eMMC storage
echo 10 > /proc/sys/fs/lease-break-time
echo 32768 > /proc/sys/fs/inotify/max_queued_events
echo 256 > /proc/sys/fs/inotify/max_user_instances
echo 16384 > /proc/sys/fs/inotify/max_user_watches

#LMK
chown root /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
echo 0 > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
if grep 'OnePlus' /system/build.prop; then
	echo "12288,15360,18432,21504,36864,53760" > /sys/module/lowmemorykiller/parameters/minfree
else
	echo "18432,23040,27648,32256,64512,94080" > /sys/module/lowmemorykiller/parameters/minfree
fi
echo 0 > /sys/module/lowmemorykiller/parameters/debug_level

#zRAM, if present
if [ -e /sys/block/zram0 ]; then
	swapoff /dev/block/zram0 > /dev/null 2>&1
	echo 1 > /sys/block/zram0/reset
	echo lz4 > /sys/block/zram0/comp_algorithm
	echo 0 > /sys/block/zram0/disksize
	echo 0 > /sys/block/zram0/queue/add_random 
	echo 0 > /sys/block/zram0/queue/iostats 
	echo 2 > /sys/block/zram0/queue/nomerges 
	echo 0 > /sys/block/zram0/queue/rotational 
	echo 1 > /sys/block/zram0/queue/rq_affinity
	echo 64 > /sys/block/zram0/queue/nr_requests
	echo 4 > /sys/block/zram0/max_comp_streams
	chmod 644 /sys/block/zram0/disksize
	echo 1073741824 > /sys/block/zram0/disksize
	mkswap /dev/block/zram0 > /dev/null 2>&1
	swapon /dev/block/zram0 > /dev/null 2>&1
fi

#VM
echo 1500 > /proc/sys/vm/dirty_expire_centisecs
echo 1500 > /proc/sys/vm/dirty_writeback_centisecs
echo 0 > /proc/sys/vm/oom_kill_allocating_task
echo 3 > /proc/sys/vm/page-cluster
echo 30 > /proc/sys/vm/swappiness
echo 70 > /proc/sys/vm/vfs_cache_pressure
echo 15 > /proc/sys/vm/dirty_ratio
echo 10 > /proc/sys/vm/dirty_background_ratio
echo 0 > /proc/sys/vm/overcommit_memory
echo 80 > /proc/sys/vm/overcommit_ratio
if grep 'OnePlus' /system/build.prop; then
	echo 20480 > /proc/sys/vm/min_free_kbytes
else
	echo 10240 > /proc/sys/vm/min_free_kbytes
fi
echo 64 > /proc/sys/kernel/random/read_wakeup_threshold
echo 896 > /proc/sys/kernel/random/write_wakeup_threshold

#loop tweaks
for i in /sys/block/loop*; do
   echo 0 > $i/queue/add_random
   echo 0 > $i/queue/iostats
   echo 1 > $i/queue/nomerges
   echo 0 > $i/queue/rotational
   echo 1 > $i/queue/rq_affinity
done

#ram tweaks
for j in /sys/block/ram*; do
   echo 0 > $j/queue/add_random
   echo 0 > $j/queue/iostats
   echo 1 > $j/queue/nomerges
   echo 0 > $j/queue/rotational
   echo 1 > $j/queue/rq_affinity
done
