### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers
## Khaenriah Project V2.8 - Celestial Edict
## Developed by Abdallah ibrahim (@D_ai_n)

#================================================================
#== 1. Global Properties & Variables
#================================================================
properties() { '
kernel.string=by @D_ai_n
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=RMX1971
device.name2=RMX1971CN
'; }

MODULE_ID="khaenriah-kernel"
MODULE_PATH="/data/adb/modules/$MODULE_ID"

#================================================================
#== 2. File Generation Functions
#================================================================

create_apply_script() {
cat <<'EOF' > $MODULE_PATH/apply_profile.sh
#!/system/bin/sh
# Khaenriah Tweak Engine V2.8
MODULE_PATH="/data/adb/modules/khaenriah-kernel"

apply_tweaks() {
    PROFILE=$1
    log -p i -t Khaenriah "Applying '$PROFILE' profile (Live Tweaks)..."
    log -p i -t Khaenriah "Kernel Version: $(uname -r)"

    if [ "$PROFILE" = "custom" ] && [ -f "$MODULE_PATH/khaenriah_custom.conf" ]; then . $MODULE_PATH/khaenriah_custom.conf; fi
    LITTLE_CLUSTER_GOV="/sys/devices/system/cpu/cpufreq/policy0/scaling_governor"; BIG_CLUSTER_GOV="/sys/devices/system/cpu/cpufreq/policy6/scaling_governor"
    LITTLE_CLUSTER_MAX_FREQ="/sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq"; BIG_CLUSTER_MAX_FREQ="/sys/devices/system/cpu/cpufreq/policy6/scaling_max_freq"
    LITTLE_CLUSTER_MIN_FREQ="/sys/devices/system/cpu/cpufreq/policy0/scaling_min_freq"; BIG_CLUSTER_MIN_FREQ="/sys/devices/system/cpu/cpufreq/policy6/scaling_min_freq"
    GPU_GOV_PATH="/sys/class/kgsl/kgsl-3d0/devfreq/governor"; WQ_POWER_EFFICIENT="/sys/module/workqueue/parameters/power_efficient"
    TCP_CONG="/proc/sys/net/ipv4/tcp_congestion_control"; KSM_PATH="/sys/kernel/mm/ksm/run"; GPU_HWCG_PATH="/sys/class/kgsl/kgsl-3d0/hwcg"

    # Reset frequencies to kernel default before applying profile settings
    for p in 0 6; do
        [ -e "/sys/devices/system/cpu/cpufreq/policy$p/cpuinfo_max_freq" ] && cat "/sys/devices/system/cpu/cpufreq/policy$p/cpuinfo_max_freq" > "/sys/devices/system/cpu/cpufreq/policy$p/scaling_max_freq"
        [ -e "/sys/devices/system/cpu/cpufreq/policy$p/cpuinfo_min_freq" ] && cat "/sys/devices/system/cpu/cpufreq/policy$p/cpuinfo_min_freq" > "/sys/devices/system/cpu/cpufreq/policy$p/scaling_min_freq"
        [ -w "/sys/devices/system/cpu/cpufreq/policy$p/scaling_governor" ] && echo "schedutil" > "/sys/devices/system/cpu/cpufreq/policy$p/scaling_governor"
    done
    
    [ -w "$GPU_GOV_PATH" ] && echo "msm-adreno-tz" > $GPU_GOV_PATH; [ -w "$WQ_POWER_EFFICIENT" ] && echo "N" > $WQ_POWER_EFFICIENT
    [ -w "$KSM_PATH" ] && echo 1 > $KSM_PATH; [ -w "$GPU_HWCG_PATH" ] && echo 1 > $GPU_HWCG_PATH; settings put global private_dns_mode off
    for block in /sys/block/sd[a-z] /sys/block/mmcblk[0-9]; do if [ -d "$block/queue" ]; then [ -w "$block/queue/scheduler" ] && echo "cfq" > "$block/queue/scheduler"; fi; done
    CPU_GOV="schedutil"; GPU_GOV="msm-adreno-tz"; IO_SCHEDULER="cfq"; READ_AHEAD_KB=512; WQ_PE="N"; SWAPPINESS=160; VFS_PRESSURE=100; DIRTY_RATIO=20
    DIRTY_BG_RATIO=10; TCP_ALGO="cubic"; KSM_STATE=1; HWCG_STATE=1; THERMAL_MODE="enabled"

    case "$PROFILE" in
    "gaming+")
        CPU_GOV="performance"; GPU_GOV="performance"; IO_SCHEDULER="deadline"; READ_AHEAD_KB=2048; WQ_PE="Y"; SWAPPINESS=100; VFS_PRESSURE=50
        KSM_STATE=0; HWCG_STATE=0; THERMAL_MODE="disabled"; [ -w "$BIG_CLUSTER_MIN_FREQ" ] && echo 1843200 > $BIG_CLUSTER_MIN_FREQ
        settings put global private_dns_mode hostname; settings put global private_dns_specifier one.one.one.one ;;
    "gaming")
        CPU_GOV="performance"; GPU_GOV="performance"; IO_SCHEDULER="deadline"; READ_AHEAD_KB=2048; WQ_PE="Y"; SWAPPINESS=100; VFS_PRESSURE=50
        KSM_STATE=0; HWCG_STATE=0; THERMAL_MODE="disabled"; settings put global private_dns_mode hostname; settings put global private_dns_specifier one.one.one.one ;;
    "performance")
        CPU_GOV="performance"; GPU_GOV="performance"; IO_SCHEDULER="deadline"; READ_AHEAD_KB=1024; WQ_PE="Y"; SWAPPINESS=120; VFS_PRESSURE=70
        KSM_STATE=0; HWCG_STATE=0; THERMAL_MODE="disabled" ;;
    "balanced")
        CPU_GOV="schedutil"; GPU_GOV="msm-adreno-tz"; IO_SCHEDULER="deadline"; READ_AHEAD_KB=1024; WQ_PE="Y"; SWAPPINESS=100; VFS_PRESSURE=80
        KSM_STATE=1; THERMAL_MODE="enabled" ;;
    "battery")
        CPU_GOV="schedutil"; GPU_GOV="powersave"; IO_SCHEDULER="cfq"; READ_AHEAD_KB=256; [ -w "$LITTLE_CLUSTER_MAX_FREQ" ] && echo 1209600 > $LITTLE_CLUSTER_MAX_FREQ
        [ -w "$BIG_CLUSTER_MAX_FREQ" ] && echo 1536000 > $BIG_CLUSTER_MAX_FREQ; WQ_PE="N"; SWAPPINESS=200; VFS_PRESSURE=150 ;;
    "adaptive"|*)
        CPU_GOV="schedutil"; GPU_GOV="msm-adreno-tz"; IO_SCHEDULER="cfq"; READ_AHEAD_KB=512 ;;
    esac

    if [ -f "$MODULE_PATH/overrides.conf" ]; then
        log -p i -t Khaenriah "Applying user profile overrides..."
        . "$MODULE_PATH/overrides.conf"
    fi

    THERMAL_CONFIG_FILE="$MODULE_PATH/thermal.conf"; if [ -f "$THERMAL_CONFIG_FILE" ]; then THERMAL_OVERRIDE=$(cat "$THERMAL_CONFIG_FILE"); case "$THERMAL_OVERRIDE" in "enabled") THERMAL_MODE="enabled";; "disabled") THERMAL_MODE="disabled";; esac; fi
    log -p i -t Khaenriah "Core settings: Profile='$PROFILE', Thermal='$THERMAL_MODE', CPU_Gov='$CPU_GOV', GPU_Gov='$GPU_GOV'"
    
    for zone in /sys/class/thermal/thermal_zone*; do [ -w "$zone/mode" ] && echo "$THERMAL_MODE" > "$zone/mode"; done
    log -p i -t Khaenriah "Thermal mode set to '$THERMAL_MODE'"

    [ -w "$LITTLE_CLUSTER_GOV" ] && echo $CPU_GOV > $LITTLE_CLUSTER_GOV; [ -w "$BIG_CLUSTER_GOV" ] && echo $CPU_GOV > $BIG_CLUSTER_GOV
    [ -w "$GPU_GOV_PATH" ] && echo $GPU_GOV > $GPU_GOV_PATH; [ -w "$WQ_POWER_EFFICIENT" ] && echo $WQ_PE > $WQ_POWER_EFFICIENT
    [ -w "$TCP_CONG" ] && echo $TCP_ALGO > $TCP_CONG; [ -w "$KSM_PATH" ] && echo "$KSM_STATE" > "$KSM_PATH"; [ -w "$GPU_HWCG_PATH" ] && echo "$HWCG_STATE" > "$GPU_HWCG_PATH"
    log -p i -t Khaenriah "Applied CPU_Gov:'$CPU_GOV', GPU_Gov:'$GPU_GOV', TCP:'$TCP_ALGO', KSM:'$KSM_STATE'"
    
    if [ "$CPU_GOV" = "schedutil" ] && [ "$PROFILE" = "custom" ]; then
        if [ -n "$SCHEDUTIL_UP_RATE" ]; then for p in /sys/devices/system/cpu/cpufreq/policy*; do [ -w "$p/schedutil/up_rate_limit_us" ] && echo "$SCHEDUTIL_UP_RATE" > "$p/schedutil/up_rate_limit_us"; done; fi
        if [ -n "$SCHEDUTIL_DOWN_RATE" ]; then for p in /sys/devices/system/cpu/cpufreq/policy*; do [ -w "$p/schedutil/down_rate_limit_us" ] && echo "$SCHEDUTIL_DOWN_RATE" > "$p/schedutil/down_rate_limit_us"; done; fi
        if [ -n "$SCHEDUTIL_HISPEED" ]; then for p in /sys/devices/system/cpu/cpufreq/policy*; do [ -w "$p/schedutil/hispeed_freq" ] && echo "$SCHEDUTIL_HISPEED" > "$p/schedutil/hispeed_freq"; done; fi
    fi
    for block in /sys/block/sd[a-z] /sys/block/mmcblk[0-9]; do if [ -d "$block/queue" ]; then [ -w "$block/queue/scheduler" ] && echo $IO_SCHEDULER > "$block/queue/scheduler"; [ -w "$block/queue/read_ahead_kb" ] && echo $READ_AHEAD_KB > "$block/queue/read_ahead_kb"; fi; done
    [ -w "/proc/sys/vm/swappiness" ] && echo $SWAPPINESS > /proc/sys/vm/swappiness; [ -w "/proc/sys/vm/vfs_cache_pressure" ] && echo $VFS_PRESSURE > /proc/sys/vm/vfs_cache_pressure
    [ -w "/proc/sys/vm/dirty_ratio" ] && echo $DIRTY_RATIO > /proc/sys/vm/dirty_ratio; [ -w "/proc/sys/vm/dirty_background_ratio" ] && echo $DIRTY_BG_RATIO > /proc/sys/vm/dirty_background_ratio
    
    if [ -f "$MODULE_PATH/cpu_freq_big.conf" ]; then
        CUSTOM_MAX_FREQ=$(cat "$MODULE_PATH/cpu_freq_big.conf")
        if [ "$CUSTOM_MAX_FREQ" != "default" ]; then
            log -p i -t Khaenriah "Applying custom max BIG CPU freq: $CUSTOM_MAX_FREQ"
            [ -w "$BIG_CLUSTER_MAX_FREQ" ] && echo "$CUSTOM_MAX_FREQ" > "$BIG_CLUSTER_MAX_FREQ"
        fi
    fi
    if [ -f "$MODULE_PATH/cpu_freq_little.conf" ]; then
        CUSTOM_MAX_FREQ=$(cat "$MODULE_PATH/cpu_freq_little.conf")
        if [ "$CUSTOM_MAX_FREQ" != "default" ]; then
            log -p i -t Khaenriah "Applying custom max Little CPU freq: $CUSTOM_MAX_FREQ"
            [ -w "$LITTLE_CLUSTER_MAX_FREQ" ] && echo "$CUSTOM_MAX_FREQ" > "$LITTLE_CLUSTER_MAX_FREQ"
        fi
    fi

    log -p i -t Khaenriah "Applied I/O:'$IO_SCHEDULER', ReadAhead:'$READ_AHEAD_KB', Swappiness:'$SWAPPINESS'"
    log -p i -t Khaenriah "Profile '$PROFILE' applied successfully."
}
CONFIG_FILE="$MODULE_PATH/khaenriah.conf"; if [ -n "$1" ]; then apply_tweaks "$1"; else if [ -f "$CONFIG_FILE" ]; then PROFILE=$(cat "$CONFIG_FILE"); else PROFILE="adaptive"; fi; apply_tweaks "$PROFILE"; fi
EOF
}

create_postfs_script() {
cat <<'EOF' > $MODULE_PATH/post-fs-data.sh
#!/system/bin/sh
MODULE_PATH="/data/adb/modules/khaenriah-kernel"
log -p i -t Khaenriah "post-fs-data script started."
CONFIG_FILE="$MODULE_PATH/khaenriah.conf"

(
    sleep 20
    if [ -f "$CONFIG_FILE" ]; then PROFILE=$(cat "$CONFIG_FILE"); else PROFILE="adaptive"; fi
    log -p i -t Khaenriah "Boot Profile: '$PROFILE'. Initializing ZRAM."
    DEFAULT_ZRAM_SIZE=3221225472
    case "$PROFILE" in
        "gaming"|"gaming+") ZRAM_SIZE=1073741824;;
        "performance") ZRAM_SIZE=2147483648;;
        "balanced") ZRAM_SIZE=2147483648;;
        "battery") ZRAM_SIZE=3221225472;;
        *) ZRAM_SIZE=$DEFAULT_ZRAM_SIZE;;
    esac
    if [ "$PROFILE" = "custom" ] && [ -f "$MODULE_PATH/khaenriah_custom.conf" ]; then . $MODULE_PATH/khaenriah_custom.conf; fi
    if [ -e /dev/block/zram0 ]; then
        log -p i -t Khaenriah "Applying ZRAM size at boot: $ZRAM_SIZE"
        swapoff /dev/block/zram0
        echo 1 >/sys/block/zram0/reset
        echo $ZRAM_SIZE >/sys/block/zram0/disksize
        mkswap /dev/block/zram0
        swapon /dev/block/zram0
        log -p i -t Khaenriah "ZRAM setup complete."
    else
        log -p e -t Khaenriah "ZRAM device not found at /dev/block/zram0."
    fi
)&

log -p i -t Khaenriah "post-fs-data script finished."
EOF
}

create_health_monitor_script() {
cat <<'EOF' > $MODULE_PATH/health_monitor.sh
#!/system/bin/sh
MODDIR=${0%/*}
HEALTH_LOG="$MODDIR/battery_health.log"
LAST_CHECK_FLAG="$MODDIR/.last_health_check"

if [ -f "$LAST_CHECK_FLAG" ]; then
    LAST_CHECK_TIME=$(cat "$LAST_CHECK_FLAG")
    CURRENT_TIME=$(date +%s)
    if [ $((CURRENT_TIME - LAST_CHECK_TIME)) -lt 604800 ]; then
        exit 0
    fi
fi

DATE=$(date +"%Y-%m-%d")
CYCLE_COUNT=$(cat /sys/class/power_supply/battery/cycle_count 2>/dev/null || echo "N/A")
CAPACITY=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null || echo "N/A")

echo "$DATE | Cycle Count: $CYCLE_COUNT | Capacity: $CAPACITY%" >> "$HEALTH_LOG"
echo $(date +%s) > "$LAST_CHECK_FLAG"
log -p i -t Khaenriah "Health Monitor: Battery stats for $DATE recorded."
EOF
}

create_service_script() {
cat <<'EOF' > $MODULE_PATH/service.sh
#!/system/bin/sh
MODDIR=${0%/*}; APPLY_SCRIPT="$MODDIR/apply_profile.sh"; CONFIG_FILE="$MODDIR/khaenriah.conf"; GAMES_LIST_FILE="$MODDIR/games_list_real.txt"; CUSTOM_CONFIG_FILE="$MODDIR/khaenriah_custom.conf"
. $MODDIR/common_functions.sh

( 
    sleep 30
    log -p i -t Khaenriah "Boot completed. Applying boot profile via service..."
    $APPLY_SCRIPT
    BOOT_PROFILE=$(cat "$CONFIG_FILE" 2>/dev/null || echo "adaptive")
    log_event "Service started. Boot profile '$BOOT_PROFILE' applied."
    send_notification "Khaenriah Engine" "Started successfully. Profile '$BOOT_PROFILE' is active."
    sh $MODDIR/health_monitor.sh
)&

(
    sleep 45; THERMAL_LIMIT=98000
    while true; do
        sleep 20; PROFILE=$(cat "$CONFIG_FILE" 2>/dev/null); THERMAL_OVERRIDE=$(cat "$MODDIR/thermal.conf" 2>/dev/null)
        if { [ "$PROFILE" = "gaming" ] || [ "$PROFILE" = "gaming+" ] || [ "$PROFILE" = "performance" ]; } && [ "$THERMAL_OVERRIDE" != "enabled" ]; then
            for temp_file in $(grep -lE 'cpu|gpu' /sys/class/thermal/thermal_zone*/type | sed 's/type/temp/'); do
                if [ -f "$temp_file" ] && [ "$(cat "$temp_file")" -gt "$THERMAL_LIMIT" ] 2>/dev/null; then
                    log_event "SafetyNet: High temp detected! Re-enabling thermal control."
                    send_notification "Thermal Safety Net" "CRITICAL TEMP! Performance limited to cool down."
                    for zone in /sys/class/thermal/thermal_zone*; do [ -w "$zone/mode" ] && echo "enabled" > "$zone/mode"; done; break 2
                fi
            done
        fi
    done
) &

(
    sleep 60; screen_is_off=false; is_in_game_mode=false; is_in_charge_mode=false; current_app_profile=""
    
    ADAPTIVE_LOOP_SPEED=1
    if [ -f "$CUSTOM_CONFIG_FILE" ]; then
        . $CUSTOM_CONFIG_FILE
        [ -n "$ADAPTIVE_LOOP_SPEED" ] && [ "$ADAPTIVE_LOOP_SPEED" -eq "$ADAPTIVE_LOOP_SPEED" ] 2>/dev/null || ADAPTIVE_LOOP_SPEED=1
    fi
    log -p i -t Khaenriah "Main service loop started with speed: $ADAPTIVE_LOOP_SPEED second(s)."
    
    while true; do
        sleep $ADAPTIVE_LOOP_SPEED
        
        BATTERY_LEVEL=$(cat /sys/class/power_supply/battery/capacity)
        BATTERY_STATUS=$(cat /sys/class/power_supply/battery/status)

        # Per-App profile logic is now run first to give it priority
        if [ "$(cat "$CONFIG_FILE" 2>/dev/null)" = "adaptive" ]; then
            current_app_pkg=$(dumpsys window | grep mCurrentFocus | cut -d'/' -f1 | awk '{print $NF}' | sed 's/[{}]//g')
            
            if echo "$current_app_pkg" | grep -qE 'SystemUI|NotificationShade|StatusBar|NavigationBar|launcher'; then
                : # Do nothing and let the current game mode persist
            else
                app_profile_line=$(grep -F "$current_app_pkg" "$GAMES_LIST_FILE" || echo "")
                if [ -n "$app_profile_line" ] && [[ ! "$app_profile_line" =~ ^# ]]; then
                    app_profile=$(echo "$app_profile_line" | cut -d'=' -f2)
                    if ! $is_in_game_mode || [ "$app_profile" != "$current_app_profile" ]; then
                        log_event "App detected ($current_app_pkg). Applied '$app_profile' profile."
                        send_toast "Khaenriah: '$app_profile' profile activated"
                        su -c "sh $APPLY_SCRIPT $app_profile"
                        is_in_game_mode=true
                        current_app_profile="$app_profile"
                    fi
                else
                    if $is_in_game_mode; then
                        log_event "Exited app. Restored 'adaptive' profile."
                        $APPLY_SCRIPT "adaptive"
                        send_toast "Khaenriah: Restored adaptive profile"
                        is_in_game_mode=false
                        current_app_profile=""
                    fi
                fi
            fi
        fi

        if [ "$BATTERY_LEVEL" -le 20 ] && [ "$BATTERY_STATUS" != "Charging" ] && [ "$(cat "$CONFIG_FILE")" != "battery" ]; then
            log_event "Low battery ($BATTERY_LEVEL%). Switched to 'battery' profile."
            send_notification "Low Battery" "Applying battery saving profile."
            su -c "sh $APPLY_SCRIPT battery"
            echo "battery" > "$CONFIG_FILE"
        elif [ "$BATTERY_LEVEL" -le 15 ] && [ "$BATTERY_STATUS" != "Charging" ]; then
            if [ ! -f "$MODDIR/.low_batt_warned" ]; then
                send_notification "Critical Battery!" "Battery is at $BATTERY_LEVEL%. Performance is limited."
                touch "$MODDIR/.low_batt_warned"
            fi
        else
            rm -f "$MODDIR/.low_batt_warned"
        fi
        
        if [ "$BATTERY_LEVEL" -ge 100 ] && [ "$BATTERY_STATUS" = "Full" ]; then
            if [ ! -f "$MODDIR/.full_charge_notified" ]; then
                log_event "Battery full. Sending reminder to unplug."
                send_toast "Battery is full. Consider unplugging."
                touch "$MODDIR/.full_charge_notified"
            fi
        else
            rm -f "$MODDIR/.full_charge_notified"
        fi
        
        case "$BATTERY_STATUS" in
            "Charging"|"Full")
                # Only apply charge profile if NOT in game mode
                if ! $is_in_game_mode && ! $is_in_charge_mode; then
                    CHARGE_PROFILE="performance"; if [ -f "$CUSTOM_CONFIG_FILE" ]; then . $CUSTOM_CONFIG_FILE; fi
                    log_event "Charging detected. Applying '$CHARGE_PROFILE' profile."
                    send_notification "Charging Mode" "Applying '$CHARGE_PROFILE' profile."
                    su -c "sh $APPLY_SCRIPT $CHARGE_PROFILE"
                    is_in_charge_mode=true
                fi
                ;;
            *)
                if $is_in_charge_mode; then
                    log_event "Device unplugged. Restoring user profile."
                    # If we are in a game, the next loop will re-apply the game profile automatically
                    $APPLY_SCRIPT
                    send_notification "Charging Mode" "Restored user profile."
                    is_in_charge_mode=false
                fi
                ;;
        esac

        if dumpsys power | grep -q "mWakefulness=Asleep"; then
            if ! $screen_is_off; then
                # RE-IMPLEMENTED: Aggressive "Enhanced Idle Mode"
                log_event "Screen OFF. Enhanced Idle Mode activated."
                if [ -w /sys/devices/system/cpu/cpu6/online ]; then echo 0 > /sys/devices/system/cpu/cpu6/online; fi
                if [ -w /sys/devices/system/cpu/cpu7/online ]; then echo 0 > /sys/devices/system/cpu/cpu7/online; fi

                if [ "$(cat "$MODDIR/notifications.conf" 2>/dev/null)" = "true" ]; then
                    TERMUX_CMD_ON="PATH=/data/data/com.termux/files/usr/bin:\$PATH /data/data/com.termux/files/usr/bin/termux-notification --title \"Enhanced Idle Mode\" --content \"Aggressive power saving is active.\" --id khaenriah-idle-status"
                    su -c "$TERMUX_CMD_ON" >/dev/null 2>&1
                fi
                
                # Standard deep sleep tweaks
                for p in /sys/devices/system/cpu/cpufreq/policy*; do [ -w "$p/scaling_max_freq" ] && echo 998400 > "$p/scaling_max_freq"; done
                [ -w "/sys/class/kgsl/kgsl-3d0/devfreq/governor" ] && echo "powersave" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
                [ -w "/sys/module/workqueue/parameters/power_efficient" ] && echo "Y" > /sys/module/workqueue/parameters/power_efficient
                [ -w "/sys/kernel/mm/ksm/run" ] && echo 0 > /sys/kernel/mm/ksm/run
                screen_is_off=true; is_in_game_mode=false;
            fi; sleep 10; continue
        else
            if $screen_is_off; then
                # RE-IMPLEMENTED: Bring cores back online first
                log_event "Screen ON. Restoring CPU cores before applying profile."
                if [ -w /sys/devices/system/cpu/cpu6/online ]; then echo 1 > /sys/devices/system/cpu/cpu6/online; fi
                if [ -w /sys/devices/system/cpu/cpu7/online ]; then echo 1 > /sys/devices/system/cpu/cpu7/online; fi
                sleep 0.5 # Give a moment for cores to come online

                log_event "Screen ON. Restored user profile."
                $APPLY_SCRIPT
                (
                    su -c "PATH=/data/data/com.termux/files/usr/bin:\$PATH /data/data/com.termux/files/usr/bin/termux-notification-remove khaenriah-idle-status" >/dev/null 2>&1
                    
                    TERMUX_CMD_OFF="PATH=/data/data/com.termux/files/usr/bin:\$PATH /data/data/com.termux/files/usr/bin/termux-notification --title \"Enhanced Idle Mode\" --content \"Exited power saving mode.\" --id khaenriah-temp"
                    su -c "$TERMUX_CMD_OFF" >/dev/null 2>&1
                    sleep 5
                    su -c "PATH=/data/data/com.termux/files/usr/bin:\$PATH /data/data/com.termux/files/usr/bin/termux-notification-remove khaenriah-temp" >/dev/null 2>&1
                ) &
                screen_is_off=false; sleep 1
            fi
        fi
    done
) &
EOF
}

create_terminal_ui() {
cat <<'EOF' > $MODULE_PATH/system/bin/khaenriah
#!/data/data/com.termux/files/usr/bin/bash
MODULE_PATH="/data/adb/modules/khaenriah-kernel"; CONFIG_FILE="$MODULE_PATH/khaenriah.conf"; APPLY_SCRIPT="$MODULE_PATH/apply_profile.sh"; CUSTOM_CONFIG_FILE="$MODULE_PATH/khaenriah_custom.conf"; FIRST_RUN_FLAG="$MODULE_PATH/.first_run_done"; THERMAL_CONFIG_FILE="$MODULE_PATH/thermal.conf"; NOTIFS_CONFIG_FILE="$MODULE_PATH/notifications.conf"; GAMES_LIST_FILE="$MODULE_PATH/games_list_real.txt"; HEALTH_LOG_FILE="$MODULE_PATH/battery_health.log"; OVERRIDES_CONFIG_FILE="$MODULE_PATH/overrides.conf"; BENCH_FLAG_FILE="$MODULE_PATH/.bench_running"; BENCH_LOG_FILE="$MODULE_PATH/bench.log"; EVENTS_LOG_FILE="$MODULE_PATH/events.log"; CPU_FREQ_BIG_CONFIG_FILE="$MODULE_PATH/cpu_freq_big.conf"; CPU_FREQ_LITTLE_CONFIG_FILE="$MODULE_PATH/cpu_freq_little.conf"; BANNER_CONFIG_FILE="$MODULE_PATH/banner.conf"; STEALTH_MODE_FILE="$MODULE_PATH/.stealth"; CHANGELOG_FILE="$MODULE_PATH/changelog.txt"
. $MODULE_PATH/common_functions.sh

if [ -f "$STEALTH_MODE_FILE" ]; then
    C_CYAN='\033[0;37m'; C_GREEN='\033[0;37m'; C_YELLOW='\033[0;37m'; C_RED='\033[0;37m'; C_WHITE='\033[0;37m'; C_GRAY='\033[0;37m'
else
    C_CYAN='\033[1;36m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_WHITE='\033[1;37m'; C_GRAY='\033[0;37m'
fi
NC='\033[0m'

TPUT_AVAILABLE=false
if command -v tput >/dev/null 2>&1; then
    TPUT_AVAILABLE=true
fi

if [ -n "$1" ]; then
    case "$1" in
        "gaming"|"gaming+"|"performance"|"battery"|"adaptive"|"custom"|"balanced")
            echo -e "${C_YELLOW}Applying '$1' profile instantly...${NC}"; echo "$1" > "$CONFIG_FILE"; su -c "sh $APPLY_SCRIPT $1" >/dev/null 2>&1; echo -e "${C_GREEN}Done.${NC}"; exit 0 ;;
    esac
fi

draw_bar() { local label=$1; local current_val=$2; local max_val=$3; local bar_width=25; if [ "$max_val" -le 0 ] || [ -z "$current_val" ] || [ "$current_val" -le 0 ]; then percentage=0; else percentage=$((current_val * 100 / max_val)); fi; local filled_width=$((percentage * bar_width / 100)); printf "%-12s [%s" "$label"; for i in $(seq 1 $bar_width); do if [ $i -le $filled_width ]; then printf "${C_GREEN}❚"; else printf "${C_GRAY}─"; fi; done; printf "${NC}] ${C_GREEN}%s%%${NC}\n" "$percentage"; }

show_live_log() {
    clear
    echo -e "${C_CYAN}--- Live Log Viewer ---${NC}"
    echo -e "\n${C_WHITE}The log will start in 3 seconds...${NC}"
    echo -e "${C_YELLOW}Press 'q' at any time to exit the viewer.${NC}"
    sleep 3
    clear
    echo -e "${C_CYAN}--- Live Log Viewer (Press 'q' to exit) ---${NC}\n"
    (stty -echo -icanon; logcat -s Khaenriah) &
    LOGCAT_PID=$!
    trap 'kill $LOGCAT_PID 2>/dev/null; stty echo icanon; exit' INT TERM
    while true; do
        read -s -N 1 -t 0.1 key
        if [[ "$key" == "q" || "$key" == "Q" ]]; then
            kill $LOGCAT_PID
            break
        fi
    done
    stty echo icanon
    echo -e "\n${C_YELLOW}Log viewer exited. Press Enter to return.${NC}"; read
}

show_status() {
    trap 'if $TPUT_AVAILABLE; then tput cnorm; fi; clear; exit' INT TERM
    if $TPUT_AVAILABLE; then tput civis; fi
    while true; do
        clear; echo -e "${C_CYAN}--- Live System Status (Press 'q' to quit) ---${NC}"
        ## MODIFIED: Fix for parsing error ##
        local current_app=$(dumpsys window | grep mCurrentFocus | cut -d'/' -f1 | awk '{print $NF}' | sed 's/[{}]//g' || echo "N/A")
        
        local big_freq_khz=$(cat /sys/devices/system/cpu/cpufreq/policy6/scaling_cur_freq 2>/dev/null||echo 0); local little_freq_khz=$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq 2>/dev/null||echo 0)
        local gpu_freq_hz=$(cat /sys/class/kgsl/kgsl-3d0/devfreq/cur_freq 2>/dev/null||echo 0); local big_mhz=$((big_freq_khz/1000)); local little_mhz=$((little_freq_khz/1000)); local gpu_mhz=$((gpu_freq_hz/1000000))
        echo -e "${C_WHITE}CPU Freq (Big|Little): ${C_GREEN}$big_mhz MHz${NC}|${C_GREEN}$little_mhz MHz${NC}"; echo -e "${C_WHITE}GPU Freq:              ${C_GREEN}$gpu_mhz MHz${NC}"; echo -e "${C_WHITE}Active App:            ${C_CYAN}$current_app${NC}"
        
        local max_temp_mc=0; for zone in /sys/class/thermal/thermal_zone*/temp; do if [ -r "$zone" ]; then current_temp=$(cat "$zone" 2>/dev/null); if [ "$current_temp" -gt "$max_temp_mc" ] 2>/dev/null; then max_temp_mc=$current_temp; fi; fi; done
        local max_temp_c=$((max_temp_mc/1000))
        local temp_color=$C_GREEN
        if [ "$max_temp_c" -ge 85 ]; then temp_color=$C_RED; elif [ "$max_temp_c" -ge 70 ]; then temp_color=$C_YELLOW; fi
        
        local current_ma=$(( $(cat /sys/class/power_supply/battery/current_now 2>/dev/null || echo 0) / 1000 ))
        local charge_status_text=""
        if [ $current_ma -lt 0 ]; then charge_status_text="${C_RED}$((current_ma * -1))mA${NC}"; elif [ $current_ma -gt 0 ]; then charge_status_text="${C_GREEN}${current_ma}mA${NC}"; else charge_status_text="${C_GRAY}N/A${NC}"; fi
        echo -e "${C_WHITE}Max System Temp:       ${temp_color}$max_temp_c°C${NC}"; echo -e "${C_WHITE}Battery Flow:          $charge_status_text\n"

        local max_big_khz=$(cat /sys/devices/system/cpu/cpufreq/policy6/cpuinfo_max_freq); local max_little_khz=$(cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_max_freq)
        local max_gpu_hz=$(cat /sys/class/kgsl/kgsl-3d0/devfreq/max_freq 2>/dev/null || echo 1); local mem_info=$(cat /proc/meminfo)
        local ram_total_kb=$(echo "$mem_info" | grep "MemTotal" | awk '{print $2}'); local ram_available_kb=$(echo "$mem_info" | grep "MemAvailable" | awk '{print $2}')
        local ram_used_kb=$((ram_total_kb-ram_available_kb)); draw_bar "CPU (Big)" "$big_freq_khz" "$max_big_khz"; draw_bar "CPU (Little)" "$little_freq_khz" "$max_little_khz"
        draw_bar "GPU" "$gpu_freq_hz" "$max_gpu_hz"; draw_bar "RAM" "$ram_used_kb" "$ram_total_kb"
        local zram_stats=$(cat /sys/block/zram0/mm_stat 2>/dev/null); local zram_used=$(echo $zram_stats | awk '{print $3}'); local zram_total=$(cat /sys/block/zram0/disksize); draw_bar "ZRAM" "$zram_used" "$zram_total"; echo ""
        local cpu_gov=$(cat /sys/devices/system/cpu/cpufreq/policy6/scaling_governor 2>/dev/null||echo "N/A"); local io_sched=$(cat /sys/block/sda/queue/scheduler 2>/dev/null | sed 's/.*\[\([^]]*\)\].*/\1/' || echo "N/A")
        echo -e "${C_WHITE}CPU Governor: ${C_GREEN}$cpu_gov${NC}  |  ${C_WHITE}I/O Scheduler: ${C_GREEN}$io_sched${NC}"; read -s -n 1 -t 3 key; if [ "$key" = "q" ] || [ "$key" = "Q" ]; then break; fi
    done; if $TPUT_AVAILABLE; then tput cnorm; fi
}

show_specific_detail() { clear; echo -e "${C_YELLOW}--- Profile Details ---${NC}"; echo -e "${C_WHITE}1) Gaming/Gaming+:${NC}\n${C_GRAY}   Maximum stable performance for games. Enables Gaming DNS.${NC}\n"; echo -e "${C_WHITE}2) Performance:${NC}\n${C_GRAY}   Unleashes the device for benchmarks & heavy tasks.${NC}\n"; echo -e "${C_WHITE}3) Balanced:${NC}\n${C_GRAY}   A smart blend of performance and battery for smooth daily usage.${NC}\n"; echo -e "${C_WHITE}4) Battery:${NC}\n${C_GRAY}   For maximum endurance, may reduce performance slightly.${NC}\n"; echo -e "${C_WHITE}5) Adaptive:${NC}\n${C_GRAY}   The intelligent default. Uses per-app profiles from your game list.${NC}\n"; echo -e "${C_WHITE}6) Custom:${NC}\n${C_GRAY}   Applies your tweaks from the custom config file.${NC}\n"; echo -n "Press Enter to return..."; read; }

manage_app_profiles() {
    while true; do
        clear; echo -e "${C_CYAN}--- Per-App Profile Manager ---${NC}\n"
        
        local app_list=()
        while IFS= read -r line || [[ -n "$line" ]]; do
            [[ "$line" =~ ^# ]] || [[ -z "$line" ]] || app_list+=("$line")
        done < "$GAMES_LIST_FILE"

        if [ ${#app_list[@]} -eq 0 ]; then
            echo -e "${C_GRAY}Your per-app list is empty.${NC}\n"
        else
            echo -e "${C_YELLOW}Current App Profiles:${NC}"
            for i in "${!app_list[@]}"; do
                local package=$(echo "${app_list[$i]}" | cut -d'=' -f1)
                local profile=$(echo "${app_list[$i]}" | cut -d'=' -f2)
                printf "  ${C_WHITE}%2d)${NC} %-35s ${C_GREEN}%s${NC}\n" "$((i+1))" "$package" "$profile"
            done
            echo ""
        fi

        echo -e "${C_WHITE}Choose an option:${NC}"
        echo -e "  ${C_YELLOW}[1-${#app_list[@]}]${NC} Edit or Delete an App"
        echo -e "  ${C_GREEN}[a]${NC}     Add a New App (from Recents)"
        echo -e "  ${C_WHITE}[b]${NC}     Back to Main Menu\n"
        echo -n "Enter your choice: "; read choice

        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#app_list[@]} ]; then
            local index=$(($choice - 1))
            local line_to_edit="${app_list[$index]}"
            local line_num=$(grep -nF "$line_to_edit" "$GAMES_LIST_FILE" | head -n 1 | cut -d: -f1)
            local package=$(echo "$line_to_edit" | cut -d'=' -f1)

            clear; echo -e "${C_CYAN}--- Edit App ---${NC}"
            echo -e "${C_WHITE}Selected App: ${C_GREEN}$package${NC}\n"
            echo -e "  ${C_WHITE}1)${NC} Change Profile"
            echo -e "  ${C_RED}2)${NC} Delete from List"
            echo -e "  ${C_WHITE}b)${NC} Back\n"
            echo -n "Enter your choice: "; read edit_choice

            case $edit_choice in
                1)
                    echo -e "\nWhich new profile for ${C_GREEN}$package${NC}?"
                    echo -e "  ${C_WHITE}1)${NC} gaming"; echo -e "  ${C_WHITE}2)${NC} gaming+"; echo -e "  ${C_WHITE}3)${NC} performance"; echo -e "  ${C_WHITE}4)${NC} battery"
                    echo -n "Enter choice (1-4): "; read profile_choice
                    local new_profile
                    case $profile_choice in
                        1) new_profile="gaming";; 2) new_profile="gaming+";; 3) new_profile="performance";; 4) new_profile="battery";;
                        *) echo -e "\n${C_RED}Invalid choice. Cancelled.${NC}"; sleep 2; continue;;
                    esac
                    sed -i "${line_num}s/=.*/=$new_profile/" "$GAMES_LIST_FILE"
                    echo -e "\n${C_GREEN}Success! Profile for $package updated to '$new_profile'.${NC}"; sleep 2
                    ;;
                2)
                    echo -n -e "\n${C_RED}Are you sure you want to delete ${C_YELLOW}$package${NC}? (y/n): "; read confirm
                    if [ "$confirm" = "y" ]; then
                        sed -i "${line_num}d" "$GAMES_LIST_FILE"
                        echo -e "\n${C_GREEN}App deleted successfully.${NC}"; sleep 2
                    else
                        echo -e "\n${C_GRAY}Cancelled.${NC}"; sleep 1
                    fi
                    ;;
                b|B) continue ;;
                *) echo -e "\n${C_RED}Invalid choice.${NC}"; sleep 1 ;;
            esac
        elif [ "$choice" = "a" ]; then
            add_new_app
        elif [ "$choice" = "b" ]; then
            break
        else
            echo -e "\n${C_RED}Invalid choice.${NC}"; sleep 1
        fi
    done
}

add_new_app() {
    clear; echo -e "${C_CYAN}--- Add New App ---${NC}"
    local recent_apps=($(dumpsys activity recents | grep 'realActivity=' | cut -d'/' -f1 | sed 's/.*=//' | grep -vE 'com.termux|launcher' | head -n 5 | nl))
    
    if [ ${#recent_apps[@]} -eq 0 ]; then
        echo -e "${C_RED}No recent user apps found. Open the app you want to add, then come back.${NC}"; sleep 3; return;
    fi

    echo -e "${C_WHITE}Select an app from your recent list to add:${NC}"
    local app_list_add=()
    for item in "${recent_apps[@]}"; do
        if [[ $item =~ ^[0-9]+$ ]]; then index=$item; else
            package=$item
            echo -e "  ${C_WHITE}$index)${NC} $package"
            app_list_add+=("$package")
        fi
    done
    echo -e "  ${C_WHITE}b)${NC} Back\n"
    echo -n "Enter your choice: "; read choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#app_list_add[@]} ]; then
        local selected_app=${app_list_add[$((choice-1))]}
    elif [ "$choice" = "b" ]; then return; else
        echo -e "\n${C_RED}Invalid choice.${NC}"; sleep 2; return;
    fi

    if grep -qF "$selected_app" "$GAMES_LIST_FILE"; then 
        echo -e "\n${C_YELLOW}This app is already in the list!${NC}"; sleep 2; return;
    fi

    echo -e "\nWhich profile for ${C_GREEN}$selected_app${NC}?"
    echo -e "  ${C_WHITE}1)${NC} gaming"; echo -e "  ${C_WHITE}2)${NC} gaming+"; echo -e "  ${C_WHITE}3)${NC} performance"; echo -e "  ${C_WHITE}4)${NC} battery"
    echo -n "Enter choice (1-4): "; read profile_choice
    local profile_to_set
    case $profile_choice in
        1) profile_to_set="gaming";; 2) profile_to_set="gaming+";; 3) profile_to_set="performance";; 4) profile_to_set="battery";;
        *) echo -e "\n${C_RED}Invalid choice. Cancelled.${NC}"; sleep 2; return;;
    esac
    echo "$selected_app=$profile_to_set" >> "$GAMES_LIST_FILE"
    echo -e "\n${C_GREEN}Success! $selected_app added with '$profile_to_set' profile.${NC}"; sleep 2
}

generate_debug_report() {
    clear; DEBUG_FILE="/sdcard/Khaenriah/khaenriah_debug_$(date +%Y%m%d_%H%M%S).txt"; echo -e "${C_YELLOW}Generating debug report...${NC}"; mkdir -p /sdcard/Khaenriah
    { echo "--- Khaenriah Debug Report ---"; echo "Date: $(date)"; echo "Version: $(cat $MODULE_PATH/module.prop | grep 'version=' | cut -d'=' -f2)"; echo "Kernel: $(uname -r)"; echo "================================="; echo "Active Profile: $(cat $CONFIG_FILE)"; echo "Thermal Override: $(cat $THERMAL_CONFIG_FILE)"; echo "Notifications: $(cat $NOTIFS_CONFIG_FILE)"; echo "CPU Freq Limit (Big): $(cat $CPU_FREQ_BIG_CONFIG_FILE)"; echo "CPU Freq Limit (Little): $(cat $CPU_FREQ_LITTLE_CONFIG_FILE)"; echo "CPU Gov (Big): $(cat /sys/devices/system/cpu/cpufreq/policy6/scaling_governor)"; echo "GPU Gov: $(cat /sys/class/kgsl/kgsl-3d0/devfreq/governor)"; echo "I/O Scheduler: $(cat /sys/block/sda/queue/scheduler | sed 's/.*\[\([^]]*\)\].*/\1/')"; echo "================================="; echo "Intelligent Event Log:"; cat "$EVENTS_LOG_FILE"; echo "================================="; echo "Last 100 Khaenriah Logs:"; logcat -d -b all -s Khaenriah | tail -n 100; } > $DEBUG_FILE
    echo -e "\n${C_GREEN}Report saved to:${NC} ${C_WHITE}$DEBUG_FILE${NC}"; sleep 4
}

export_backup() {
    clear; BACKUP_FILE="/sdcard/Khaenriah/Khaenriah_Backup_$(date +%Y%m%d).kbackup"; echo -e "${C_YELLOW}Exporting full backup...${NC}"; mkdir -p /sdcard/Khaenriah
    { echo "### KH_CONFIG ###"; cat $CONFIG_FILE; echo "### KH_GAMES_LIST ###"; cat $GAMES_LIST_FILE; echo "### KH_THERMAL_CONF ###"; cat $THERMAL_CONFIG_FILE; echo "### KH_NOTIFS_CONF ###"; cat $NOTIFS_CONFIG_FILE; echo "### KH_OVERRIDES_CONF ###"; cat $OVERRIDES_CONFIG_FILE; echo "### KH_CPU_FREQ_BIG_CONF ###"; cat $CPU_FREQ_BIG_CONFIG_FILE; echo "### KH_CPU_FREQ_LITTLE_CONF ###"; cat $CPU_FREQ_LITTLE_CONFIG_FILE; echo "### KH_CUSTOM_CONF ###"; cat $CUSTOM_CONFIG_FILE 2>/dev/null; echo "### END_KH_BACKUP ###"; } > $BACKUP_FILE
    echo -e "\n${C_GREEN}Backup successful! Saved to:${NC}\n${C_WHITE}$BACKUP_FILE${NC}"; sleep 4
}

import_backup() {
    clear; echo -e "${C_YELLOW}Select a backup file to import:${NC}"; BACKUP_DIR="/sdcard/Khaenriah"
    if [ ! -d "$BACKUP_DIR" ] || [ -z "$(ls -A $BACKUP_DIR/*.kbackup 2>/dev/null)" ]; then echo -e "${C_RED}No backup files found in $BACKUP_DIR${NC}"; sleep 3; return; fi
    local i=1; local files=(); for f in $BACKUP_DIR/*.kbackup; do echo -e "  ${C_WHITE}$i)${NC} $(basename "$f")"; files+=("$f"); i=$((i+1)); done
    echo -e "  ${C_WHITE}b)${NC} Back\n"; echo -n "Enter your choice: "; read choice;
    if [ "$choice" = "b" ] || [ "$choice" = "B" ]; then return; fi
    if [ "$choice" -gt 0 ] && [ "$choice" -le "${#files[@]}" ]; then
        SELECTED_FILE="${files[$((choice-1))]}"; echo -e "\n${C_YELLOW}Importing from $(basename "$SELECTED_FILE")...${NC}"
        sed -n '/### KH_CONFIG ###/,/### KH_GAMES_LIST ###/p' "$SELECTED_FILE" | sed '1d;$d' > $CONFIG_FILE
        sed -n '/### KH_GAMES_LIST ###/,/### KH_THERMAL_CONF ###/p' "$SELECTED_FILE" | sed '1d;$d' > $GAMES_LIST_FILE
        sed -n '/### KH_THERMAL_CONF ###/,/### KH_NOTIFS_CONF ###/p' "$SELECTED_FILE" | sed '1d;$d' > $THERMAL_CONFIG_FILE
        sed -n '/### KH_NOTIFS_CONF ###/,/### KH_OVERRIDES_CONF ###/p' "$SELECTED_FILE" | sed '1d;$d' > $NOTIFS_CONFIG_FILE
        sed -n '/### KH_OVERRIDES_CONF ###/,/### KH_CPU_FREQ_BIG_CONF ###/p' "$SELECTED_FILE" | sed '1d;$d' > $OVERRIDES_CONFIG_FILE
        sed -n '/### KH_CPU_FREQ_BIG_CONF ###/,/### KH_CPU_FREQ_LITTLE_CONF ###/p' "$SELECTED_FILE" | sed '1d;$d' > $CPU_FREQ_BIG_CONFIG_FILE
        sed -n '/### KH_CPU_FREQ_LITTLE_CONF ###/,/### KH_CUSTOM_CONF ###/p' "$SELECTED_FILE" | sed '1d;$d' > $CPU_FREQ_LITTLE_CONFIG_FILE
        sed -n '/### KH_CUSTOM_CONF ###/,/### END_KH_BACKUP ###/p' "$SELECTED_FILE" | sed '1d;$d' > $CUSTOM_CONFIG_FILE
        echo -e "\n${C_GREEN}Import successful!${NC}"
        echo -n "Do you want to apply the imported profile now? (y/n): "; read apply_choice
        if [ "$apply_choice" = "y" ] || [ "$apply_choice" = "Y" ]; then
            IMPORTED_PROFILE=$(cat $CONFIG_FILE); su -c "sh $APPLY_SCRIPT $IMPORTED_PROFILE" >/dev/null 2>&1
            echo -e "\n${C_GREEN}Profile '$IMPORTED_PROFILE' is now active!${NC}"
        fi; sleep 3
    else echo -e "${C_RED}Invalid choice.${NC}"; sleep 2; fi
}

show_battery_stats() {
    clear; echo -e "${C_CYAN}--- Battery Health & History ---${NC}\n"
    local bat_path="/sys/class/power_supply/battery"
    echo -e "${C_YELLOW}Live Stats:${NC}"
    [ -f "$bat_path/status" ] && echo -e "  ${C_WHITE}Status: ${C_GREEN}$(cat $bat_path/status)${NC}"
    [ -f "$bat_path/health" ] && echo -e "  ${C_WHITE}Health: ${C_GREEN}$(cat $bat_path/health)${NC}"
    if [ -f "$bat_path/temp" ]; then local temp=$(($(cat $bat_path/temp) / 10)); echo -e "  ${C_WHITE}Temperature: ${C_YELLOW}${temp}°C${NC}"; fi
    if [ -f "$bat_path/voltage_now" ]; then local volt=$(($(cat $bat_path/voltage_now) / 1000)); echo -e "  ${C_WHITE}Voltage: ${C_GREEN}${volt}mV${NC}"; fi
    if [ -f "$bat_path/current_now" ]; then 
        local current=$(( $(cat $bat_path/current_now 2>/dev/null || echo 0) / 1000 ))
        if [ $current -lt 0 ]; then 
            echo -e "  ${C_WHITE}Discharge Rate: ${C_RED}$((current * -1))mA${NC}"
        elif [ $current -gt 0 ]; then
            echo -e "  ${C_WHITE}Charge Rate: ${C_GREEN}${current}mA${NC}"
        fi
    fi
    [ -f "$bat_path/capacity" ] && echo -e "  ${C_WHITE}Capacity: ${C_GREEN}$(cat $bat_path/capacity)%${NC}"
    [ -f "$bat_path/cycle_count" ] && echo -e "  ${C_WHITE}Cycle Count: ${C_GREEN}$(cat $bat_path/cycle_count)${NC}\n"
    
    echo -e "${C_YELLOW}Historical Health Log (Weekly):${NC}"
    if [ -f "$HEALTH_LOG_FILE" ] && [ -s "$HEALTH_LOG_FILE" ]; then
        echo -e "${C_GRAY}$(cat "$HEALTH_LOG_FILE")${NC}"
    else
        echo -e "${C_GRAY}  No health data recorded yet. Data is logged weekly.${NC}"
    fi

    echo -e "\n"; echo -n "Press Enter to return..."; read
}

instant_cooldown() {
    clear; echo -e "${C_YELLOW}--- Instant Cooldown Activated ---${NC}";
    echo -e "${C_GRAY}Applying extreme power saving for 90 seconds to cool down...${NC}";
    local previous_profile=$(cat "$CONFIG_FILE" 2>/dev/null || echo "adaptive");
    su -c "sh $APPLY_SCRIPT battery" >/dev/null 2>&1;
    for i in $(seq 90 -1 1); do
        echo -ne "${C_WHITE}Returning to '$previous_profile' profile in: ${C_GREEN}$i seconds\r${NC}";
        sleep 1;
    done;
    echo -e "\n\n${C_GREEN}Cooldown finished. Restoring previous profile...${NC}";
    su -c "sh $APPLY_SCRIPT $previous_profile" >/dev/null 2>&1; sleep 2;
}

run_ping_test() {
    clear; echo -e "${C_CYAN}--- Network Ping Test ---${NC}"; echo -e "${C_GRAY}Pinging 1.1.1.1 (Cloudflare)... Press Ctrl+C to stop.${NC}\n"
    ping -c 10 1.1.1.1; echo -e "\n${C_YELLOW}Test finished. Press Enter to return.${NC}"; read
}

edit_games_list() {
    if ! [ -f /data/data/com.termux/files/usr/bin/nano ]; then
        clear; echo -e "${C_RED}Error: 'nano' text editor is not installed in Termux.${NC}"
        echo -e "${C_YELLOW}Please install it by running this command in Termux:${NC}"
        echo -e "${C_WHITE}pkg install nano${NC}"; echo -n -e "\nPress Enter to return..."; read
        return
    fi
    clear; echo -e "${C_CYAN}--- Raw Per-App Profile Editor ---${NC}"
    echo -e "${C_WHITE}Opening the app list with nano editor.${NC}"
    echo -e "${C_GRAY}Format: com.package.name=profile (e.g., com.tencent.ig=gaming)${NC}"
    echo -e "${C_GRAY}Controls: Ctrl+O to save. Ctrl+X to exit.${NC}"; sleep 4
    /data/data/com.termux/files/usr/bin/nano "$GAMES_LIST_FILE"; echo -e "\n${C_GREEN}Editor closed.${NC}"; sleep 1
}

edit_overrides() {
    if ! [ -f /data/data/com.termux/files/usr/bin/nano ]; then
        clear; echo -e "${C_RED}Error: 'nano' text editor is not installed in Termux.${NC}"; sleep 3; return; fi
    if ! [ -f "$OVERRIDES_CONFIG_FILE" ]; then
        echo -e "# Profile Overrides\n#\n# Example:\n# if [ \"\$PROFILE\" = \"gaming\" ]; then\n#     IO_SCHEDULER=\"cfq\"\n# fi" > "$OVERRIDES_CONFIG_FILE"
    fi
    clear; echo -e "${C_CYAN}--- Profile Overrides Editor ---${NC}"
    echo -e "${C_WHITE}You can tweak parts of any profile here.${NC}"
    echo -e "${C_GRAY}Changes will apply the next time a profile is set.${NC}"; sleep 4
    /data/data/com.termux/files/usr/bin/nano "$OVERRIDES_CONFIG_FILE"; echo -e "\n${C_GREEN}Editor closed.${NC}"; sleep 1
}

toggle_notifications() {
    clear; local notif_status="Disabled"; local current_setting=$(cat "$NOTIFS_CONFIG_FILE" 2>/dev/null)
    if [ "$current_setting" = "true" ]; then notif_status="Enabled"; fi
    echo -e "${C_YELLOW}--- Notification Control ---${NC}"; echo -e "Notifications are currently: ${C_GREEN}${notif_status}${NC}\n"
    echo -e "  ${C_WHITE}1)${NC} Enable Notifications"
    echo -e "  ${C_WHITE}2)${NC} Disable Notifications\n"
    echo -e "  ${C_WHITE}b)${NC} Back\n"; echo -n "Enter your choice: "; read choice
    case $choice in
        1) echo "true" > "$NOTIFS_CONFIG_FILE"; echo -e "\n${C_GREEN}Notifications have been enabled.${NC}";;
        2) echo "false" > "$NOTIFS_CONFIG_FILE"; echo -e "\n${C_RED}Notifications have been disabled.${NC}";;
        b|B) return;;
        *) echo -e "\n${C_RED}Invalid choice.${NC}";;
    esac; sleep 2
}

toggle_stealth_mode() {
    clear
    echo -e "${C_YELLOW}--- Stealth Mode ---${NC}"
    echo -e "${C_GRAY}This will disable all colors in the UI for a minimal look.${NC}\n"
    if [ -f "$STEALTH_MODE_FILE" ]; then
        echo -e "Stealth Mode is currently ${C_GREEN}Enabled${NC}."
        echo -n "Do you want to disable it? (y/n): "; read choice
        if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
            rm -f "$STEALTH_MODE_FILE"
            echo -e "\n${C_GREEN}Stealth Mode disabled.${NC}"
        fi
    else
        echo -e "Stealth Mode is currently ${C_RED}Disabled${NC}."
        echo -n "Do you want to enable it? (y/n): "; read choice
        if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
            touch "$STEALTH_MODE_FILE"
            echo -e "\n${C_GREEN}Stealth Mode enabled.${NC}"
        fi
    fi
    echo -n "Restart the UI now to apply the change? (y/n): "; read restart_choice
    if [ "$restart_choice" = "y" ] || [ "$restart_choice" = "Y" ]; then
        echo -e "${C_YELLOW}Restarting...${NC}"; sleep 1; exec "$0" "$@"
    fi
    sleep 1
}

advanced_task_killer() {
    clear
    echo -e "${C_YELLOW}--- Advanced Task Killer ---${NC}"
    echo -e "${C_GRAY}This will stop background apps to free up RAM.${NC}"
    echo -n "Are you sure you want to proceed? (y/n): "; read confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo -e "${C_RED}Cancelled.${NC}"; sleep 2; return
    fi
    echo -e "\n${C_YELLOW}Killing background processes...${NC}"
    local running_apps=$(pm list packages -3 | cut -d':' -f2)
    local whitelist="com.termux"
    for app in $running_apps; do
        is_whitelisted=false
        for safe_app in $whitelist; do
            if [ "$app" = "$safe_app" ]; then is_whitelisted=true; break; fi
        done
        if ! $is_whitelisted; then
            echo -e "${C_GRAY}Stopping: $app${NC}"
            su -c "am force-stop $app"
        fi
    done
    echo -e "\n${C_GREEN}Task killing complete.${NC}"; sleep 3
}

show_memory_menu() {
    while true; do
        if $TPUT_AVAILABLE; then tput cnorm; fi; clear
        echo -e "${C_YELLOW}--- Memory Management Toolkit ---${NC}"
        echo -e "  ${C_WHITE}1) Trim Caches:${NC} ${C_GRAY}Clear app cached data to free up storage.${NC}"
        echo -e "  ${C_WHITE}2) Drop Caches:${NC} ${C_GRAY}Force flush RAM caches. Useful before gaming.${NC}"
        echo -e "  ${C_WHITE}3) Compact Memory:${NC} ${C_GRAY}Defragment RAM to improve efficiency.${NC}"
        echo -e "  ${C_WHITE}4) Advanced Task Killer:${NC} ${C_RED}Force-stop background apps.${NC}"
        echo -e "\n  ${C_WHITE}b) Back to Utilities\n"
        echo -n "Enter your choice: "; read choice
        case $choice in
            1) clear; echo -e "${C_YELLOW}Trimming caches...${NC}"; su -c "pm trim-caches 9999G" >/dev/null 2>&1; echo -e "${C_GREEN}Done.${NC}"; sleep 2;;
            2) clear; echo -e "${C_YELLOW}Dropping caches...${NC}"; su -c "sync; echo 3 > /proc/sys/vm/drop_caches"; echo -e "${C_GREEN}RAM caches dropped.${NC}"; sleep 2;;
            3) clear; echo -e "${C_YELLOW}Compacting memory...${NC}"; su -c "echo 1 > /proc/sys/vm/compact_memory"; echo -e "${C_GREEN}Memory compacted.${NC}"; sleep 2;;
            4) advanced_task_killer;;
            b|B) break;;
            *) echo -e "${C_RED}Invalid option.${NC}"; sleep 1;;
        esac
    done
}

start_benchmark() {
    rm -f $BENCH_LOG_FILE
    touch $BENCH_FLAG_FILE
    echo $(date +%s) > $BENCH_FLAG_FILE
    (
        while [ -f "$BENCH_FLAG_FILE" ]; do
            ts=$(date +%s)
            b_freq=$(cat /sys/devices/system/cpu/cpufreq/policy6/scaling_cur_freq 2>/dev/null || echo 0)
            l_freq=$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq 2>/dev/null || echo 0)
            g_freq=$(cat /sys/class/kgsl/kgsl-3d0/devfreq/cur_freq 2>/dev/null || echo 0)
            temp=$(cat /sys/class/thermal/thermal_zone2/temp 2>/dev/null || echo 0)
            echo "$ts $b_freq $l_freq $g_freq $temp" >> $BENCH_LOG_FILE
            sleep 1
        done
    ) &
    clear; echo -e "${C_GREEN}Benchmarking session started!${NC}"; echo -e "${C_WHITE}Play your game now. When you're done, come back and choose 'Stop & Get Report'.${NC}"; sleep 5
}

stop_and_report_benchmark() {
    local start_time=$(cat $BENCH_FLAG_FILE)
    rm -f $BENCH_FLAG_FILE
    sleep 1.5
    clear; echo -e "${C_YELLOW}Generating report...${NC}"
    
    if [ ! -f "$BENCH_LOG_FILE" ]; then
        echo -e "${C_RED}Log file not found. Session was too short?${NC}"; sleep 3; return;
    fi

    local lines=$(wc -l < $BENCH_LOG_FILE)
    if [ "$lines" -lt 5 ]; then
        echo -e "${C_RED}Session too short for a meaningful report (less than 5 seconds).${NC}"; rm -f $BENCH_LOG_FILE; sleep 4; return;
    fi

    local results=$(awk '
        {
            b_sum += $2;
            l_sum += $3;
            g_sum += $4;
            if ($5 > t_max) t_max = $5;
        }
        END {
            printf "%.0f %.0f %.0f %.0f", b_sum/NR, l_sum/NR, g_sum/NR, t_max
        }' $BENCH_LOG_FILE
    )
    
    local avg_b_mhz=$(( $(echo $results | cut -d' ' -f1) / 1000 ))
    local avg_l_mhz=$(( $(echo $results | cut -d' ' -f2) / 1000 ))
    local avg_g_mhz=$(( $(echo $results | cut -d' ' -f3) / 1000000 ))
    local max_temp_c=$(( $(echo $results | cut -d' ' -f4) / 1000 ))
    local duration=$(( $(date +%s) - start_time ))

    clear
    echo -e "${C_CYAN}--- Benchmarking Session Report ---${NC}"
    echo -e "${C_WHITE}Session Duration:${C_GREEN} $duration seconds${NC}\n"
    echo -e "${C_WHITE}Average Big Core Freq:  ${C_GREEN}$avg_b_mhz MHz${NC}"
    echo -e "${C_WHITE}Average Little Core Freq: ${C_GREEN}$avg_l_mhz MHz${NC}"
    echo -e "${C_WHITE}Average GPU Freq:         ${C_GREEN}$avg_g_mhz MHz${NC}"
    echo -e "${C_WHITE}Maximum Temperature:      ${C_YELLOW}$max_temp_c°C${NC}\n"
    
    rm -f $BENCH_LOG_FILE
    echo -n "Press Enter to return..."; read
}

show_benchmark_menu() {
    while true; do
        clear
        echo -e "${C_YELLOW}--- Performance Benchmarking ---${NC}\n"
        if [ -f "$BENCH_FLAG_FILE" ]; then
            echo -e "  ${C_RED}A session is currently running!${NC}\n"
            echo -e "  ${C_WHITE}1) Stop Session & Get Report${NC}"
        else
            echo -e "  ${C_WHITE}1) Start New Session${NC}"
        fi
        echo -e "\n  ${C_WHITE}b) Back to Utilities\n"
        echo -n "Enter your choice: "; read choice
        case $choice in
            1)
                if [ -f "$BENCH_FLAG_FILE" ]; then
                    stop_and_report_benchmark
                else
                    start_benchmark
                fi
                ;;
            b|B) break;;
            *) echo -e "${C_RED}Invalid option.${NC}"; sleep 1;;
        esac
    done
}

show_cpu_tuner_menu() {
    while true; do
        clear
        echo -e "${C_YELLOW}--- CPU Frequency Tuner ---${NC}"
        echo -e "${C_GRAY}Set a maximum frequency limit for CPU clusters.${NC}\n"
        local big_limit=$(cat "$CPU_FREQ_BIG_CONFIG_FILE" 2>/dev/null || echo "default")
        local little_limit=$(cat "$CPU_FREQ_LITTLE_CONFIG_FILE" 2>/dev/null || echo "default")
        echo -e "  ${C_WHITE}Current Big Core Limit:     ${C_GREEN}${big_limit}${NC}"
        echo -e "  ${C_WHITE}Current Little Core Limit:  ${C_GREEN}${little_limit}${NC}\n"
        echo -e "  ${C_WHITE}1) Set Big Core Limit"
        echo -e "  ${C_WHITE}2) Set Little Core Limit"
        echo -e "\n  ${C_WHITE}b) Back to Utilities\n"
        echo -n "Enter your choice: "; read main_choice
        case $main_choice in
            1) cluster="big";;
            2) cluster="little";;
            b|B) break;;
            *) echo -e "${C_RED}Invalid option.${NC}"; sleep 1; continue;;
        esac

        local policy_path=""; local config_file=""; local cluster_name=""
        if [ "$cluster" = "big" ]; then
            policy_path="/sys/devices/system/cpu/cpufreq/policy6"
            config_file="$CPU_FREQ_BIG_CONFIG_FILE"
            cluster_name="Big"
        else
            policy_path="/sys/devices/system/cpu/cpufreq/policy0"
            config_file="$CPU_FREQ_LITTLE_CONFIG_FILE"
            cluster_name="Little"
        fi

        clear
        echo -e "${C_YELLOW}--- Set ${cluster_name} Core Frequency Limit ---${NC}"
        local available_freqs=$(cat $policy_path/scaling_available_frequencies)
        local current_limit=$(cat "$config_file" 2>/dev/null || echo "default")
        echo -e "${C_WHITE}Current Limit: ${C_GREEN}${current_limit}${NC}\n"
        
        local freqs_array=($available_freqs)
        local i=1
        for freq in "${freqs_array[@]}"; do
            echo -e "  ${C_WHITE}$i)${NC} $((freq/1000)) MHz"
            i=$((i+1))
        done
        echo -e "  ${C_WHITE}d)${NC} Default (No limit)"
        echo -e "  ${C_WHITE}b)${NC} Back\n"
        echo -n "Enter your choice: "; read choice

        case $choice in
            b|B) continue ;;
            d|D) echo "default" > "$config_file"; echo -e "\n${C_GREEN}${cluster_name} core frequency limit reset to default.${NC}" ;;
            *)
                if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -gt 0 ] && [ "$choice" -le "${#freqs_array[@]}" ]; then
                    local selected_freq=${freqs_array[$((choice-1))]}
                    echo "$selected_freq" > "$config_file"
                    echo -e "\n${C_GREEN}Max ${cluster_name} core frequency set to $((selected_freq/1000)) MHz.${NC}"
                else
                    echo -e "\n${C_RED}Invalid choice.${NC}"; sleep 2; continue
                fi
                ;;
        esac
        echo -e "${C_YELLOW}Applying setting now...${NC}"
        su -c "sh $APPLY_SCRIPT" >/dev/null 2>&1
        echo -e "${C_GREEN}Done.${NC}"; sleep 3
    done
}

show_event_log() {
    clear
    echo -e "${C_CYAN}--- Intelligent Event Log ---${NC}\n"
    if [ -f "$EVENTS_LOG_FILE" ]; then
        echo -e "${C_GRAY}$(cat "$EVENTS_LOG_FILE")${NC}"
    else
        echo -e "${C_GRAY}No events recorded yet.${NC}"
    fi
    echo -e "\n"; echo -n "Press Enter to return..."; read
}

show_changelog() {
    clear; echo -e "${C_CYAN}--- What's New in Khaenriah Project ---${NC}\n";
    if [ -f "$CHANGELOG_FILE" ]; then
      echo -e "${C_GRAY}$(cat "$CHANGELOG_FILE")${NC}"
    else
      echo -e "${C_RED}Changelog file not found!${NC}"
    fi;
    echo -e "\n"; echo -n "Press Enter to return..."; read
}

show_performance_menu() {
    while true; do
        clear; echo -e "${C_YELLOW}--- Performance Tools ---${NC}";
        echo -e "  ${C_WHITE}1) Performance Benchmarking"
        echo -e "  ${C_WHITE}2) CPU Frequency Tuner"
        echo -e "  ${C_WHITE}3) ${C_RED}Instant Cooldown${NC}"
        echo -e "\n  ${C_WHITE}b) Back to Utilities\n";
        echo -n "Enter your choice: "; read choice
        case $choice in
            1) show_benchmark_menu;;
            2) show_cpu_tuner_menu;;
            3) instant_cooldown; break;;
            b|B) break;;
            *) echo -e "${C_RED}Invalid option.${NC}"; sleep 1;;
        esac
    done
}

show_customization_menu() {
    while true; do
        clear; echo -e "${C_YELLOW}--- Customization & Config ---${NC}"
        echo -e "  ${C_WHITE}1) ${C_GREEN}Manage Per-App Profiles${NC}"
        echo -e "  ${C_WHITE}2) Edit Profile Overrides ${C_GRAY}(Advanced)${NC}"
        echo -e "  ${C_WHITE}3) Toggle Stealth Mode (UI Colors)"
        echo -e "  ${C_WHITE}4) Export/Import Full Backup"
        echo -e "  ${C_WHITE}5) Edit App List with Nano ${C_GRAY}(Raw Edit)${NC}"
        echo -e "\n  ${C_WHITE}b) Back to Utilities\n"
        echo -n "Enter your choice: "; read choice
        case $choice in
            1) manage_app_profiles;;
            2) edit_overrides;;
            3) toggle_stealth_mode;;
            4) show_backup_menu;;
            5) edit_games_list;;
            b|B) break;;
            *) echo -e "${C_RED}Invalid option.${NC}"; sleep 1;;
        esac
    done
}

show_diagnostics_menu() {
    while true; do
        clear; echo -e "${C_YELLOW}--- System & Diagnostics ---${NC}"
        echo -e "  ${C_WHITE}1) Battery Health & History"
        echo -e "  ${C_WHITE}2) View Intelligent Event Log"
        echo -e "  ${C_WHITE}3) Network Ping Test"
        echo -e "  ${C_WHITE}4) Toggle Notifications ${C_GRAY}(Termux:API)${NC}"
        echo -e "  ${C_WHITE}5) ${C_YELLOW}Generate Debug Report${NC}"
        echo -e "\n  ${C_WHITE}b) Back to Utilities\n"
        echo -n "Enter your choice: "; read choice
        case $choice in
            1) show_battery_stats;;
            2) show_event_log;;
            3) run_ping_test;;
            4) toggle_notifications;;
            5) generate_debug_report; break;;
            b|B) break;;
            *) echo -e "${C_RED}Invalid option.${NC}"; sleep 1;;
        esac
    done
}

show_backup_menu() {
    while true; do
        clear; echo -e "${C_YELLOW}--- Backup & Restore ---${NC}"
        echo -e "  ${C_WHITE}e) Export Full Backup"
        echo -e "  ${C_WHITE}i) Import Full Backup"
        echo -e "\n  ${C_WHITE}b) Back\n"
        echo -n "Enter your choice: "; read choice
        case $choice in
            e|E) export_backup; break;;
            i|I) import_backup; break;;
            b|B) break;;
            *) echo -e "${C_RED}Invalid option.${NC}"; sleep 1;;
        esac
    done
}

show_utilities_menu() { 
    while true; do 
        if $TPUT_AVAILABLE; then tput cnorm; fi; clear
        echo -e "${C_YELLOW}--- Utilities Menu ---${NC}"
        echo -e "  ${C_WHITE}1) ${C_CYAN}Performance Tools${NC}"
        echo -e "  ${C_WHITE}2) ${C_CYAN}Memory Management${NC}"
        echo -e "  ${C_WHITE}3) ${C_CYAN}Customization & Config${NC}"
        echo -e "  ${C_WHITE}4) ${C_CYAN}System & Diagnostics${NC}"
        echo -e "\n  ${C_WHITE}b) Back to Main Menu\n"
        echo -n "Enter your choice: "; read choice
        case $choice in 
            1) show_performance_menu;; 
            2) show_memory_menu;; 
            3) show_customization_menu;; 
            4) show_diagnostics_menu;;
            b|B) break ;; 
            *) echo -e "${C_RED}Invalid option.${NC}"; sleep 1 ;; 
        esac
    done 
}

show_thermal_menu() { while true; do if $TPUT_AVAILABLE; then tput cnorm; fi; clear; current_thermal_mode=$(cat "$THERMAL_CONFIG_FILE" 2>/dev/null || echo "auto"); first_char=$(echo "$current_thermal_mode" | cut -c1 | tr 'a-z' 'A-Z'); rest_of_string=$(echo "$current_thermal_mode" | cut -c2-); capitalized_thermal="$first_char$rest_of_string"; echo -e "${C_YELLOW}--- Thermal Control ---${NC}"; echo -e "${C_GRAY}Override the default thermal behavior of profiles.${NC}"; echo -e "${C_WHITE}Current setting: ${C_GREEN}${capitalized_thermal}${NC}\n"; echo -e "  ${C_WHITE}1) ${C_CYAN}Auto (Recommended):${NC} Let profile decide."; echo -e "  ${C_WHITE}2) ${C_GREEN}Force Enabled:${NC} Thermals always ON."; echo -e "  ${C_WHITE}3) ${C_RED}Force Disabled:${NC} Thermals always OFF. ${C_YELLOW}RISKY!${NC}"; echo -e "  ${C_WHITE}b) Back to Main Menu\n"; echo -n "Enter choice: "; read choice; local new_thermal_mode=""; case $choice in 1) new_thermal_mode="auto" ;; 2) new_thermal_mode="enabled" ;; 3) new_thermal_mode="disabled" ;; b|B) break ;; *) echo -e "${C_RED}Invalid option.${NC}"; sleep 1; continue ;; esac; if [ -n "$new_thermal_mode" ]; then echo "$new_thermal_mode" > "$THERMAL_CONFIG_FILE"; echo -e "\n${C_YELLOW}Applying new thermal setting...${NC}"; local current_profile=$(cat "$CONFIG_FILE" 2>/dev/null || echo "adaptive"); su -c "sh $APPLY_SCRIPT $current_profile" >/dev/null 2>&1; echo -e "${C_GREEN}New thermal setting is now active!${NC}"; sleep 2; fi; done; }

edit_custom_profile() {
    if $TPUT_AVAILABLE; then tput cnorm; fi; clear; echo -e "${C_CYAN}--- Custom Profile Editor ---${NC}"; echo -e "${C_GRAY}Press Enter to keep the current value.${NC}\n"; [ -f "$CUSTOM_CONFIG_FILE" ] && . "$CUSTOM_CONFIG_FILE"; CPU_GOV=${CPU_GOV:-"schedutil"}; GPU_GOV=${GPU_GOV:-"msm-adreno-tz"}; IO_SCHEDULER=${IO_SCHEDULER:-"cfq"}; TCP_ALGO=${TCP_ALGO:-"cubic"}; ZRAM_SIZE=${ZRAM_SIZE:-3221225472}; CHARGE_PROFILE=${CHARGE_PROFILE:-"performance"}; ADAPTIVE_LOOP_SPEED=${ADAPTIVE_LOOP_SPEED:-1}
    
    local available_cpu_govs=$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors 2>/dev/null || echo "performance schedutil")
    local available_gpu_govs=$(cat /sys/class/kgsl/kgsl-3d0/devfreq/available_governors 2>/dev/null || echo "msm-adreno-tz powersave performance")
    local available_io_scheds=$(cat /sys/block/sda/queue/scheduler 2>/dev/null | sed 's/\[//g; s/\]//g' || echo "noop deadline cfq")

    echo -e "${C_YELLOW}Available CPU Governors:${NC} ${C_WHITE}$available_cpu_govs${NC}"; echo -n "CPU Governor [current: $CPU_GOV]: "; read new_cpu_gov; new_cpu_gov=${new_cpu_gov:-$CPU_GOV}
    if [ "$new_cpu_gov" = "schedutil" ]; then
        echo -n "Do you want to fine-tune schedutil parameters? (y/n): "; read tune_choice
        if [ "$tune_choice" = "y" ]; then echo -n "up_rate_limit_us [current: ${SCHEDUTIL_UP_RATE:-default}]: "; read SCHEDUTIL_UP_RATE; echo -n "down_rate_limit_us [current: ${SCHEDUTIL_DOWN_RATE:-default}]: "; read SCHEDUTIL_DOWN_RATE; echo -n "hispeed_freq [current: ${SCHEDUTIL_HISPEED:-default}]: "; read SCHEDUTIL_HISPEED
        else SCHEDUTIL_UP_RATE=""; SCHEDUTIL_DOWN_RATE=""; SCHEDUTIL_HISPEED=""; fi
    fi
    echo -e "\n${C_YELLOW}Available GPU Governors:${NC} ${C_WHITE}$available_gpu_govs${NC}"; echo -n "GPU Governor [current: $GPU_GOV]: "; read new_gpu_gov
    echo -e "\n${C_YELLOW}Available I/O Schedulers:${NC} ${C_WHITE}$available_io_scheds${NC}"; echo -n "I/O Scheduler [current: $IO_SCHEDULER]: "; read new_io_sched
    echo -e "\n${C_YELLOW}Available TCP Algorithms:${NC} ${C_WHITE}cubic reno${NC}"; echo -n "TCP Algorithm [current: $TCP_ALGO]: "; read new_tcp_algo
    echo -e "\n${C_YELLOW}ZRAM Size:${NC} ${C_GRAY}(Applied on next boot)${NC}"; echo -n "ZRAM Size (bytes) [current: $ZRAM_SIZE]: "; read new_zram_size
    echo -e "\n${C_YELLOW}Profile to apply on charge:${NC}"; echo -n "Charging Profile [current: $CHARGE_PROFILE]: "; read new_charge_profile
    echo -e "\n${C_YELLOW}Adaptive Mode Responsiveness:${NC} ${C_GRAY}(in seconds, e.g., 1 or 0.5. Applied on next boot)${NC}"; echo -n "Loop Speed [current: $ADAPTIVE_LOOP_SPEED]: "; read new_loop_speed
    
    NEW_CONFIG="# Khaenriah Kernel Custom Profile (v2.7)\n"; NEW_CONFIG+="CPU_GOV=\"${new_cpu_gov}\"\n"
    [ -n "$SCHEDUTIL_UP_RATE" ] && NEW_CONFIG+="SCHEDUTIL_UP_RATE=\"$SCHEDUTIL_UP_RATE\"\n"
    [ -n "$SCHEDUTIL_DOWN_RATE" ] && NEW_CONFIG+="SCHEDUTIL_DOWN_RATE=\"$SCHEDUTIL_DOWN_RATE\"\n"
    [ -n "$SCHEDUTIL_HISPEED" ] && NEW_CONFIG+="SCHEDUTIL_HISPEED=\"$SCHEDUTIL_HISPEED\"\n"
    NEW_CONFIG+="GPU_GOV=\"${new_gpu_gov:-$GPU_GOV}\"\n"; NEW_CONFIG+="IO_SCHEDULER=\"${new_io_sched:-$IO_SCHEDULER}\"\n"
    NEW_CONFIG+="TCP_ALGO=\"${new_tcp_algo:-$TCP_ALGO}\"\n"; NEW_CONFIG+="ZRAM_SIZE=${new_zram_size:-$ZRAM_SIZE}\n"
    NEW_CONFIG+="CHARGE_PROFILE=\"${new_charge_profile:-$CHARGE_PROFILE}\"\n"
    NEW_CONFIG+="ADAPTIVE_LOOP_SPEED=${new_loop_speed:-$ADAPTIVE_LOOP_SPEED}\n"

    echo -e "$NEW_CONFIG" > "$CUSTOM_CONFIG_FILE"; echo -e "\n${C_GREEN}Custom profile saved! A reboot is needed for some changes to apply.${NC}"; sleep 4
}

show_main_menu() {
    clear; echo -e "${C_CYAN}$(cat $MODULE_PATH/banner)${NC}";
    echo -e "${C_WHITE}    V2.7 - Stellar Terminus    ${NC}";
    echo -e "${C_WHITE}    Developed by Abdallah ibrahim (@D_ai_n)      ${NC}\n";
    local current_profile=$(cat "$CONFIG_FILE" 2>/dev/null || echo "adaptive"); local active_gov=$(cat /sys/devices/system/cpu/cpufreq/policy6/scaling_governor 2>/dev/null || echo "N/A");
    local max_temp_mc=$(cat /sys/class/thermal/thermal_zone2/temp 2>/dev/null || echo 0); local max_temp_c=$((max_temp_mc / 1000));
    local temp_color=$C_GREEN; if [ "$max_temp_c" -ge 85 ]; then temp_color=$C_RED; elif [ "$max_temp_c" -ge 70 ]; then temp_color=$C_YELLOW; fi;
    local battery_level=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null || echo "N/A"); local battery_health=$(cat /sys/class/power_supply/battery/health 2>/dev/null || echo "N/A");
    echo ""; echo -e "${C_YELLOW}--- System Status ---${NC}";
    printf "  ${C_WHITE}%-12s ${C_GREEN}%-15s ${C_WHITE}%-12s ${C_GREEN}%s\n" "Profile:" "$current_profile" "Governor:" "$active_gov";
    printf "  ${C_WHITE}%-12s ${temp_color}%-15s ${C_WHITE}%-12s ${C_GREEN}%s%% (%s)\n\n" "Temperature:" "${max_temp_c}°C" "Battery:" "$battery_level" "$battery_health";
    echo -e "${C_YELLOW}--- Set Profile ${C_GRAY}(prefix 'a' to apply instantly)${NC} ---";
    printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n" "1) Gaming" "2) Gaming+ (Extreme)"; printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n" "3) Performance" "4) Balanced";
    printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n" "5) Battery" "6) Adaptive (Smart)"; printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n" "7) Custom" "";
    echo -e "  ${C_CYAN}c) Edit Custom Profile${NC}\n"; echo -e "${C_YELLOW}--- Actions & Control ---${NC}";
    printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n" "s) Full Live Status" "u) Utilities Menu"; printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n" "d) Learn about profiles" "t) Thermal Control";
    printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n" "l) View Live Log" "w) What's New?"; printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n" "p) Manage App Profiles" "r) Reset to Defaults"; printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n\n" "" "x) Exit";
    echo -n "Enter your choice: ";
}

run_first_time_wizard() { 
    if $TPUT_AVAILABLE; then tput cnorm; fi; clear
    echo -e "${C_CYAN}Welcome to Khaenriah Kernel V2.7!${NC}"
    echo -e "${C_WHITE}This one-time setup helps you choose the best profile for your needs.${NC}\n"
    echo -e "  ${C_WHITE}1) ${C_CYAN}Adaptive (Recommended):${NC} Balances perf and battery."
    echo -e "  ${C_WHITE}2) ${C_GREEN}Gaming:${NC} Max performance for games."
    echo -e "  ${C_WHITE}3) ${C_YELLOW}Battery:${NC} Max battery life.\n"
    echo -n -e "Choose an option, or press ${C_GREEN}Enter${NC} for Adaptive: "; read wizard_choice
    if [ -z "$wizard_choice" ]; then wizard_choice=1; fi
    case $wizard_choice in 
        2) chosen_profile="gaming" ;; 
        3) chosen_profile="battery" ;; 
        1|*) chosen_profile="adaptive" ;; 
    esac
    echo "$chosen_profile" > "$CONFIG_FILE"
    echo "auto" > "$THERMAL_CONFIG_FILE"
    echo "true" > "$NOTIFS_CONFIG_FILE"
    touch "$EVENTS_LOG_FILE"
    touch "$GAMES_LIST_FILE"
    echo "default" > "$CPU_FREQ_BIG_CONFIG_FILE"
    echo "default" > "$CPU_FREQ_LITTLE_CONFIG_FILE"
    echo -e "\n${C_GREEN}Great! '$chosen_profile' has been set as default.${NC}"
    echo "1" > "$FIRST_RUN_FLAG"; sleep 4
}

handle_choice() {
    local choice=$1; target_profile=""; apply_now=false
    case $choice in
        1) target_profile="gaming";; 2) target_profile="gaming+";; 3) target_profile="performance";; 4) target_profile="balanced";; 5) target_profile="battery";; 6) target_profile="adaptive";; 7) target_profile="custom";;
        a1) apply_now=true; target_profile="gaming";; a2) apply_now=true; target_profile="gaming+";; a3) apply_now=true; target_profile="performance";; a4) apply_now=true; target_profile="balanced";; a5) apply_now=true; target_profile="battery";; a6) apply_now=true; target_profile="adaptive";; a7) apply_now=true; target_profile="custom";;
        c|C) edit_custom_profile;; s|S) show_status;; u|U) show_utilities_menu;; d|D) show_specific_detail;; t|T) show_thermal_menu;; l|L) show_live_log;; w|W) show_changelog;;
        p|P) manage_app_profiles;;
        r|R) echo -e "\n${C_YELLOW}Resetting all settings to recommended defaults...${NC}"; echo "adaptive" > "$CONFIG_FILE"; echo "auto" > "$THERMAL_CONFIG_FILE"; echo "true" > "$NOTIFS_CONFIG_FILE"; rm -f "$CUSTOM_CONFIG_FILE" "$HEALTH_LOG_FILE" "$OVERRIDES_CONFIG_FILE" "$EVENTS_LOG_FILE" "$CPU_FREQ_BIG_CONFIG_FILE" "$CPU_FREQ_LITTLE_CONFIG_FILE" "$GAMES_LIST_FILE"; su -c "sh $APPLY_SCRIPT adaptive" >/dev/null 2>&1; echo -e "${C_GREEN}Reset complete. Profile set to 'Adaptive'. Reboot for ZRAM to reset.${NC}"; sleep 3;;
        x|X) return 99;;
        *) return 1;;
    esac
    
    if [ -n "$target_profile" ]; then
        echo "$target_profile" > "$CONFIG_FILE"
        if [ "$apply_now" = true ]; then 
            echo -e "\n${C_YELLOW}Applying '$target_profile' profile now...${NC}"; su -c "sh $APPLY_SCRIPT $target_profile" 2>/dev/null; 
            echo -e "${C_GREEN}Done. '$target_profile' is now active.${NC}\n${C_YELLOW}Note: ZRAM size for this profile will apply on next boot.${NC}";
            send_notification "Khaenriah Project" "Profile activated: $target_profile"
        else 
            echo -e "\n${C_GREEN}OK. '$target_profile' profile & its ZRAM size will be applied on next boot.${NC}"; 
        fi
        if [ "$target_profile" = "custom" ] && ! [ -f "$CUSTOM_CONFIG_FILE" ]; then echo -e "\n${C_YELLOW}Creating template for Custom profile...${NC}"; echo -e "# Khaenriah Kernel Custom Profile (v2.7)\nCPU_GOV=\"schedutil\"\nGPU_GOV=\"msm-adreno-tz\"\nIO_SCHEDULER=\"cfq\"\nTCP_ALGO=\"cubic\"\nZRAM_SIZE=3221225472\nCHARGE_PROFILE=\"performance\"\nADAPTIVE_LOOP_SPEED=1" > "$CUSTOM_CONFIG_FILE"; echo -e "${C_GREEN}Template created at: ${C_GRAY}$CUSTOM_CONFIG_FILE${NC}"; fi
        echo -e "\n${C_WHITE}Press Enter to return to main menu...${NC}"; read
    fi
    return 0
}

if ! [ -f "$FIRST_RUN_FLAG" ]; then run_first_time_wizard; fi

trap 'if $TPUT_AVAILABLE; then tput cnorm; fi; clear; exit' INT TERM
while true; do
    show_main_menu
    read choice
    
    clear
    handle_choice "$choice"; exit_code=$?
    if [ $exit_code -eq 99 ]; then
        break
    fi
done

if $TPUT_AVAILABLE; then tput cnorm; fi
clear; echo -e "\n${C_YELLOW}Exiting.${NC}"; exit 0
EOF
}

create_companion_files() {
cat <<'EOF' > $MODULE_PATH/module.prop
id=khaenriah-kernel
name=Khaenriah Kernel for Realme 5 Pro
version=V2.7-StellarTerminus
versionCode=24
author=Abdallah ibrahim (@D_ai_n)
description=The ultimate, sentient control script for Khaenriah Kernel. Use 'dain' or 'khaenriah' command in termux.
EOF
cat <<'EOF' > $MODULE_PATH/banner
 | |/ / |                         (_)     | |    
 | ' /| |__   __ _  ___ _ __  _ __ _  __ _| |__  
 |  < | '_ \ / _` |/ _ \ '_ \| '__| |/ _` | '_ \ 
 | . \| | | | (_| |  __/ | | | |  | | (_| | | | |
 |_|\_\_| |_|\__,_|\___|_| |_|_|  |_|\__,_|_| |_|
 
EOF
cat <<'EOF' > $MODULE_PATH/uninstall.sh
#!/system/bin/sh
rm -f /data/adb/modules/khaenriah-kernel/khaenriah.conf
rm -f /data/adb/modules/khaenriah-kernel/khaenriah_custom.conf
rm -f /data/adb/modules/khaenriah-kernel/overrides.conf
rm -f /data/adb/modules/khaenriah-kernel/.first_run_done
rm -f /data/adb/modules/khaenriah-kernel/thermal.conf
rm -f /data/adb/modules/khaenriah-kernel/games_list_real.txt
rm -f /data/adb/modules/khaenriah-kernel/notifications.conf
rm -f /data/adb/modules/khaenriah-kernel/battery_health.log
rm -f /data/adb/modules/khaenriah-kernel/events.log
rm -f /data/adb/modules/khaenriah-kernel/cpu_freq_big.conf
rm -f /data/adb/modules/khaenriah-kernel/cpu_freq_little.conf
rm -f /data/adb/modules/khaenriah-kernel/.last_health_check
rm -f /data/adb/modules/khaenriah-kernel/.full_charge_notified
rm -f /data/adb/modules/khaenriah-kernel/.bench_running
rm -f /data/adb/modules/khaenriah-kernel/bench.log
rm -f /data/adb/modules/khaenriah-kernel/.stealth
rm -f /data/adb/modules/khaenriah-kernel/changelog.txt
rm -f /data/adb/modules/khaenriah-kernel/.low_batt_warned
EOF
}

create_common_functions() {
cat <<'EOF' > $MODULE_PATH/common_functions.sh
#!/system/bin/sh
MODULE_PATH="/data/adb/modules/khaenriah-kernel"

log_event() {
    EVENT_MSG=$1
    DATE_FORMAT=$(date "+%Y-%m-%d %H:%M:%S")
    LOG_FILE="$MODULE_PATH/events.log"
    echo "[$DATE_FORMAT] $EVENT_MSG" >> "$LOG_FILE"
    line_count=$(wc -l < "$LOG_FILE")
    if [ "$line_count" -gt 500 ]; then
        tail -n 500 "$LOG_FILE" > "${LOG_FILE}.tmp" && mv "${LOG_FILE}.tmp" "$LOG_FILE"
    fi
    log -p i -t Khaenriah "EVENT: $EVENT_MSG"
}

send_notification() {
    if [ "$(cat $MODULE_PATH/notifications.conf 2>/dev/null)" = "true" ]; then
        TITLE=$1
        CONTENT=$2
        log -p i -t Khaenriah "Notification: Title='$TITLE', Content='$CONTENT'"
        COMMAND="PATH=/data/data/com.termux/files/usr/bin:\$PATH /data/data/com.termux/files/usr/bin/termux-notification --title \"$TITLE\" --content \"$CONTENT\" --id khaenriah --priority min"
        su -c "$COMMAND" >/dev/null 2>&1
    else
        log -p i -t Khaenriah "Notification Skipped: Disabled by user."
    fi
}

send_toast() {
    if [ "$(cat $MODULE_PATH/notifications.conf 2>/dev/null)" = "true" ]; then
        TEXT=$1
        log -p i -t Khaenriah "Toast: Text='$TEXT'"
        COMMAND="PATH=/data/data/com.termux/files/usr/bin:\$PATH /data/data/com.termux/files/usr/bin/termux-toast \"$TEXT\""
        su -c "$COMMAND" >/dev/null 2>&1
    else
        log -p i -t Khaenriah "Toast Skipped: Disabled by user."
    fi
}
EOF
}

create_changelog_file() {
cat <<'EOF' > $MODULE_PATH/changelog.txt
 [1;33m--- V2.7 - Stellar Terminus --- [0m
-  [1;32m[FIXED] [0m Fixed a critical bug causing camera freezes in apps like WhatsApp by removing the aggressive 'Enhanced Idle Mode'. System stability is now prioritized.
-  [1;32m[FIXED] [0m Fixed a parsing bug that showed '{' or '}' characters before or after package names in the UI.
-  [1;36m[IMPROVED] [0m Greatly improved the reliability of app detection by creating a more robust system UI ignore list (fixes the notification shade issue again, for good).

 [1;33m--- V2.6 - Elysian Requiem --- [0m
-  [1;32m[FIXED] [0m The App Profile Manager now updates the list instantly after any change, fixing the visual bug.
-  [1;31m[REMOVED] [0m Fully removed the 'Focus Mode' (DND) feature for a more streamlined experience.
-  [1;36m[IMPROVED] [0m The 'Profile Hunter' has been upgraded to a full 'App Profile Manager', allowing you to view, edit, and delete apps from your list.
-  [1;36m[IMPROVED] [0m Added more helpful notifications for profile changes and critical battery levels.

 [1;33m--- V2.5 - Divine Retribution --- [0m
-  [1;32m[FIXED] [0m Solved the issue where pulling down the notification shade would exit gaming mode by intelligently ignoring SystemUI.
-  [1;36m[IMPROVED] [0m Initial major overhaul of the Profile Hunter.
 [1;33m--- V2.4 - Abyssal Coronation --- [0m
-  [1;32m[FIXED] [0m App Hunter now uses a recent apps menu to fix the "Termux" detection issue.
-  [1;32m[FIXED] [0m Added a robust DND function and a 'DND Help' section.
-  [1;36m[IMPROVED] [0m Stealth Mode now offers an instant UI restart option.
EOF
}

create_game_list() { cat <<'EOF' > $MODULE_PATH/games_list_real.txt
# This is your Per-App Profile list.
# The script will automatically apply the specified profile when the app is detected.
# Format: com.package.name=profile
# Available profiles: gaming, gaming+, performance, battery
#
#================================================
#== Ultra Demanding Games (Highest Performance)
#================================================
com.kurogame.wutheringwaves.global=gaming+
com.hoyoverse.genshinimpact=gaming+
com.mihoyo.genshinimpact=gaming+
com.hoyoverse.hkrpgoversea=gaming+
com.mihoyo.hkrpg=gaming+
com.levelinfinite.hotta.gp=gaming+
com.netease.avalon=gaming+
com.ea.gp.apexlegendsmobilefps=gaming+
com.netmarble.sololv=gaming+
xyz.aethersx2.android=gaming+
org.yuzu.yuzu_emu=gaming+

#================================================
#== Competitive & FPS Games (High & Stable Perf)
#================================================
com.activision.callofduty.shooter=gaming
com.activision.callofduty.warzone=gaming
com.garena.game.codm=gaming
com.tencent.tmgp.cod=gaming
com.pubg.imobile=gaming
com.tencent.ig=gaming
com.pubg.krmobile=gaming
com.pubg.newstate=gaming
com.riotgames.league.wildrift=gaming
com.mobile.legends=gaming
com.dts.freefiremax=gaming
com.dts.freefireth=gaming
com.miraclegames.farlight84=gaming
com.axlebolt.standoff2=gaming
com.criticalforceentertainment.criticalops=gaming
com.ubisoft.rainbowsixmobile.r6.fps.pvp.shooter=gaming
com.kurogame.gplay.punishing.grayraven.en=gaming
com.bandainamcoent.opbrww=gaming
com.garena.game.kgid=gaming
com.bhvr.deadbydaylight=gaming
com.netease.moba=gaming

#================================================
#== Open World & High Graphics Games
#================================================
com.blizzard.diablo.immortal=performance
com.netease.eve.en=performance
com.pearlabyss.blackdesertm.gl=performance
com.rockstargames.gtasa=performance
com.netease.aceracer=performance
com.carxtech.sr=performance
com.gameloft.android.anmp.glofta9hm=performance
com.archosaur.dragonraja.en.sea=performance
com.netease.lglr=performance
com.proximabeta.nikke=performance
com.yostar.aethergazer=performance
com.the10tons.dysmantle=performance
com.netease.sky=performance

#================================================
#== Light & Casual Games (Battery Saving)
#================================================
com.king.candycrushsaga=battery
com.king.candycrushsodasaga=battery
com.supercell.clashofclans=battery
com.supercell.clashroyale=battery
com.supercell.brawlstars=battery
com.roblox.client=battery
com.mojang.minecraftpe=battery
com.miniclip.eightballpool=battery
com.amongus=battery
com.autumn.skullgirls=battery
com.prpr.musedash=battery
com.chillyroom.soulknightprequel=battery
com.shangyoo.neon=battery
com.stove.epic7.google=battery
com.yostaren.mahjongsoul=battery

#================================================
#== Emulators & Simulators (Can be customized)
#================================================
org.vita3k.emulator=gaming+
com.citra.emu=gaming
net.kdt.pojavlaunch=gaming
com.dolphinemu.dolphinemu=gaming
skyline.emu=gaming+
id.co.pkg.skyline=gaming+

#================================================
#== Other Popular Games (Defaulting to 'gaming')
#================================================
com.albiononline=gaming
com.bilibili.azurlane=gaming
com.bilibili.deadcells.mobile=gaming
com.playdigious.deadcells.mobile=gaming
com.bilibili.fatego=gaming
com.bushiroad.en.bangdreamgbp=gaming
com.dena.a12026801=gaming
com.devsisters.ck=gaming
com.ea.gp.fifamobile=gaming
com.epicgames.fortnite=gaming
com.garena.game.kgtw=gaming
com.hypergryph.arknights=gaming
com.kakaogames.gdts=gaming
com.madfingergames.legends=gaming
com.mihoyo.bh3global=gaming
com.nekki.shadowfight3=gaming
com.nexon.bluearchive=gaming
com.nianticlabs.pokemongo=battery
com.riotgames.league.teamfighttactics=gaming
com.sega.pjsekai=gaming
com.sofunny.sausage=gaming
com.yostaren.arknights=gaming
EOF
}

#================================================================
#== 3. AnyKernel Core Logic
#================================================================

boot_attributes() {
  set_perm_recursive 0 0 755 644 $RAMDISK/*;
  set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
}

BLOCK=/dev/block/bootdevice/by-name/boot; IS_SLOT_DEVICE=0; RAMDISK_COMPRESSION=auto; PATCH_VBMETA_FLAG=auto;
. tools/ak3-core.sh;

#================================================================
#== 4. Main Installation Flow
#================================================================

ui_print " "; ui_print "Khaenriah Kernel Installer V2.7 - Stellar Terminus"; ui_print "by Abdallah ibrahim (@D_ai_n) for Realme 5 Pro"; ui_print " ";

if [ -d "$MODULE_PATH" ]; then
    ui_print "  - Backing up user settings...";
    [ -f "$MODULE_PATH/khaenriah.conf" ] && cp $MODULE_PATH/khaenriah.conf /data/local/tmp/khaenriah.conf.bak
    [ -f "$MODULE_PATH/games_list_real.txt" ] && cp $MODULE_PATH/games_list_real.txt /data/local/tmp/games_list.bak
    [ -f "$MODULE_PATH/thermal.conf" ] && cp $MODULE_PATH/thermal.conf /data/local/tmp/thermal.conf.bak
    [ -f "$MODULE_PATH/khaenriah_custom.conf" ] && cp $MODULE_PATH/khaenriah_custom.conf /data/local/tmp/custom.conf.bak
    [ -f "$MODULE_PATH/notifications.conf" ] && cp $MODULE_PATH/notifications.conf /data/local/tmp/notifications.conf.bak
    [ -f "$MODULE_PATH/overrides.conf" ] && cp $MODULE_PATH/overrides.conf /data/local/tmp/overrides.conf.bak
    [ -f "$MODULE_PATH/cpu_freq_big.conf" ] && cp $MODULE_PATH/cpu_freq_big.conf /data/local/tmp/cpu_freq_big.conf.bak
    [ -f "$MODULE_PATH/cpu_freq_little.conf" ] && cp $MODULE_PATH/cpu_freq_little.conf /data/local/tmp/cpu_freq_little.conf.bak
    [ -f "$MODULE_PATH/.stealth" ] && cp $MODULE_PATH/.stealth /data/local/tmp/stealth.bak
fi

ui_print ">> Step 1/4: Installing Core Kernel..."; dump_boot;

ui_print ">> Step 2/4: Setting up Sentient Tweak Engine...";
rm -rf $MODULE_PATH; mkdir -p $MODULE_PATH/system/bin; ui_print "  - Injecting Advanced & Interactive Tweak Profiles...";
create_apply_script; create_postfs_script; create_service_script; create_terminal_ui; create_companion_files; create_game_list; create_common_functions; create_health_monitor_script; create_changelog_file;

if [ -f "/data/local/tmp/khaenriah.conf.bak" ]; then
    ui_print "  - Restoring user settings...";
    mv /data/local/tmp/khaenriah.conf.bak $MODULE_PATH/khaenriah.conf
    mv /data/local/tmp/games_list.bak $MODULE_PATH/games_list_real.txt
    mv /data/local/tmp/thermal.conf.bak $MODULE_PATH/thermal.conf
    [ -f "/data/local/tmp/custom.conf.bak" ] && mv /data/local/tmp/custom.conf.bak $MODULE_PATH/khaenriah_custom.conf
    [ -f "/data/local/tmp/notifications.conf.bak" ] && mv /data/local/tmp/notifications.conf.bak $MODULE_PATH/notifications.conf
    [ -f "/data/local/tmp/overrides.conf.bak" ] && mv /data/local/tmp/overrides.conf.bak $MODULE_PATH/overrides.conf
    [ -f "/data/local/tmp/cpu_freq_big.conf.bak" ] && mv /data/local/tmp/cpu_freq_big.conf.bak $MODULE_PATH/cpu_freq_big.conf
    [ -f "/data/local/tmp/cpu_freq_little.conf.bak" ] && mv /data/local/tmp/cpu_freq_little.conf.bak $MODULE_PATH/cpu_freq_little.conf
    [ -f "/data/local/tmp/stealth.bak" ] && mv /data/local/tmp/stealth.bak $MODULE_PATH/.stealth
fi

ui_print ">> Step 3/4: Installing Companion Features...";
cp $MODULE_PATH/system/bin/khaenriah $MODULE_PATH/system/bin/dain

ui_print "  - Setting permissions...";
set_perm_recursive $MODULE_PATH 0 0 755 0644
chmod 755 $MODULE_PATH/*.sh $MODULE_PATH/system/bin/*

ui_print " "
ui_print "-----------------------------------------"
ui_print "  ✔ Installation Complete: V2.7 Stellar Terminus!"
ui_print "-----------------------------------------"
ui_print " "
ui_print  "- The Instant Control module is at your command."
ui_print "- Use 'su' then 'dain' or 'khaenriah' in terminal."
ui_print " "
ui_print ">> Reboot to awaken the monarch intelligence."
ui_print " "

write_boot;