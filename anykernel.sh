### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers
## Khaenriah Project v1.2 - Sentient Edition (Revised & Optimized)
## Developed & Designed by Abdallah ibrahim (@D_ai_n)

### AnyKernel setup
properties() { '
kernel.string=by @D_ai_n
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=RMX1971
device.name2=RMX1971CN
'; } # end properties

### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
BLOCK=/dev/block/bootdevice/by-name/boot;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import core functions
. tools/ak3-core.sh;

# --- UI Messages ---
ui_print " "; ui_print "Khaenriah Kernel Installer v1.2 - Sentient (Optimized)"; ui_print "by Abdallah ibrahim (@D_ai_n) for Realme 5 Pro"; ui_print " ";

# --- Kernel Installation ---
ui_print ">> Step 1/4: Installing Core Kernel...";
dump_boot;

# --- Tweak Engine Installation ---
ui_print ">> Step 2/4: Setting up Sentient Tweak Engine...";
MODULE_ID="khaenriah-kernel"; MODULE_PATH="/data/adb/modules/$MODULE_ID"
rm -rf $MODULE_PATH
mkdir -p $MODULE_PATH/system/bin

ui_print "  - Injecting Advanced & Interactive Tweak Profiles...";
# --- Cleaned up game list file ---
cat <<'EOF' > $MODULE_PATH/games_list_real.txt
age.of.civilizations2.jakowski.lukasz
com.activision.callofduty.shooter
com.activision.callofduty.warzone
com.albiononline
com.aligames.kuang.kybc
com.autumn.skullgirls
com.axlebolt.standoff2
com.bandainamcoent.imas_millionlive_theaterdays
com.bandainamcoent.opbrww
com.bandainamcoent.sao
com.bandainamcoent.shinycolorsprism
com.bhvr.deadbydaylight
com.bilibili.azurlane
com.bilibili.deadcells.mobile
com.bilibili.fatego
com.bilibili.star.bili
com.bilibili.warmsnow
com.bilibiligame.heglgp
com.bingkolo.kleins.cn
com.blizzard.diablo.immortal
com.bushiroad.d4dj
com.bushiroad.en.bangdreamgbp
com.bushiroad.lovelive.schoolidolfestival2
com.carxtech.sr
com.chillyroom.dungeonshooter
com.chillyroom.soulknightprequel
com.citra.emu
com.cnvcs.xiangqi
com.criticalforceentertainment.criticalops
com.dena.a12026801
com.denachina.g13002010
com.devsisters.ck
com.dfjz.moba
com.dgames.g15002002
com.dolphinemu.dolphinemu
com.dragonli.projectsnow.lhm
com.dts.freefireadv
com.dts.freefiremax
com.dts.freefireth
com.ea.gp.apexlegendsmobilefps
com.ea.gp.fifamobile
com.epicgames.fortnite
com.fantablade.icey
com.firsttouchgames.dls7
com.flanne.minutestilldawn.roguelike.shooting.gp
com.fosfenes.sonolus
com.gabama.monopostolite
com.gamecoaster.protectdungeon
com.gamedevltd.wwh
com.gameloft.android.anmp.glofta9hm
com.gameloft.android.anmp.gloftmvhm
com.garena.game.codm
com.garena.game.kgid
com.garena.game.kgtw
com.garena.game.kgvn
com.gryphline.exastris.gp
com.guyou.deadstrike
com.halo.windf.hero
com.heavenburnsred
com.hermes.j1game
com.hottapkgs.hotta
com.hoyoverse.hkrpgoversea
com.hoyoverse.nap
com.hypergryph.arknights
com.ignm.raspberrymash.jp
com.ilongyuan.implosion
com.jacksparrow.jpmajiang
com.je.supersus
com.kakaogames.eversoul
com.kakaogames.gdts
com.kakaogames.wdfp
com.kog.grandchaseglobal
com.komoe.kmumamusumegp
com.kurogame.gplay.punishing.grayraven.en
com.kurogame.haru
com.kurogame.haru.bilibili
com.kurogame.wutheringwaves.global
com.leiting.wf
com.levelinfinite.hotta.gp
com.levelinfinite.sgameglobal
com.levelinfinite.sgameglobal.midaspay
com.lilithgames.hgame.cn
com.linegames.sl
com.madfingergames.legends
com.mihoyo.bh3
com.mihoyo.bh3global
com.mihoyo.bh3oversea
com.mihoyo.bh3oversea_vn
com.mihoyo.enterprise.nghsod
com.mihoyo.genshinimpact
com.mihoyo.hkrpg
com.mihoyo.ys
com.mihoyo.yuanshen
com.miraclegames.farlight84
com.mobile.legends
com.mobilelegends.hwag
com.mojang.hostilegg
com.mojang.minecraftpe
com.mojang.minecraftpe.patch
com.nanostudios.games.twenty.minutes
com.nekki.shadowfight
com.nekki.shadowfight3
com.netease.aceracer
com.netease.avalon
com.netease.dfjs
com.netease.dwrg
com.netease.eve
com.netease.eve.en
com.netease.frxyna
com.netease.g78na.gb
com.netease.g93na
com.netease.h75na
com.netease.jddsaef
com.netease.lglr
com.netease.ma100asia
com.netease.ma84
com.netease.moba
com.netease.mrzh
com.netease.newspike
com.netease.nshm
com.netease.onmyoji
com.netease.party
com.netease.partyglobal
com.netease.race
com.netease.racerna
com.netease.sky
com.netease.soulofhunter
com.netease.tj
com.netease.tom
com.netease.wotb
com.netease.x19
com.netease.yhtj
com.netmarble.sololv
com.nexon.bluearchive
com.nexon.kartdrift
com.nianticlabs.monsterhunter
com.olzhass.carparking.multyplayer
com.pearlabyss.blackdesertm.gl
com.pinkcore.tkfm
com.playdigious.deadcells.mobile
com.proximabeta.mf.uamo
com.proximabeta.nikke
com.prpr.musedash
com.pubg.imobile
com.pubg.krmobile
com.pubg.newstate
com.pwrd.hotta.laohu
com.pwrd.huanta
com.pwrd.opmwsea
com.r2games.myhero.bilibili
com.rayark.implosion
com.rayark.sdorica
com.rekoo.pubgm
com.riotgames.league.teamfighttactics
com.riotgames.league.teamfighttacticsvn
com.riotgames.league.wildrift
com.roamingstar.bluearchive
com.roblox.client
com.rockstargames.gtasa
com.sega.colorfulstage.en
com.sega.pjsekai
com.shangyoo.neon
com.shenlan.m.reverse1999
com.shooter.modernwarship
com.shooter.modernwarships
com.smokoko.race
com.sofunny.sausage
com.soulgamechst.majsoul
com.sprduck.garena.vn
com.stove.epic7.google
com.sunborn.snqxexilium
com.supercell.brawlstars
com.supercell.clashofclans
com.supercell.clashroyale
com.supercell.hayday
com.sy.dldlhsdj
com.t2ksports.nba2k20and
com.tencent.ig
com.tencent.jkchess
com.tencent.kihan
com.tencent.lolm
com.tencent.mf.uam
com.tencent.tmgp.bh3
com.tencent.tmgp.cf
com.tencent.tmgp.cod
com.tencent.tmgp.dfjs
com.tencent.tmgp.ffom
com.tencent.tmgp.gnyx
com.tencent.tmgp.kr.codm
com.tencent.tmgp.pubgmhd
com.tencent.tmgp.sgame
com.tencent.tmgp.speedmobile
com.tencent.tmgp.wepop
com.tencent.tmgp.wuxia
com.tencent.tmgp.yys.zqb
com.tencent.toaa
com.tgc.sky.android
com.the10tons.dysmantle
com.ubisoft.rainbowsixmobile.r6.fps.pvp.shooter
com.unity.mmd
com.valvesoftware.cswgsm
com.valvesoftware.source
com.vng.mlbbvn
com.vng.pubgmobile
com.vng.speedvn
com.xd.rotaeno.googleplay
com.xd.rotaeno.tapcn
com.xd.tlglobal
com.xindong.torchlight
com.yongshi.tenojo
com.yostar.aethergazer
com.yostaren.arknights
com.yostaren.mahjongsoul
com.yostarjp.bluearchive
com.yostarjp.majsoul
com.zerocastlegamestudio.strikebusterprototype
com.zerocastlegamestudiointl.strikebusterprototype
com.zlongame.mhmnz
com.ztgame.bob
com.zy.wqmt.cn
id.rj01117883.liomeko
jp.co.craftegg.band
jp.konami.pesam
net.kdt.pojavlaunch
net.wargaming.wot.blitz
org.mm.jr
org.vita3k.emulator
org.yuzu.yuzu_emu
pro.archiemeng.waifu2x
skyline.emu
skynet.cputhrottlingtest
xyz.aethersx2.android
com.king.candycrushsaga
com.king.candycrushsodasaga
com.rovio.angrybirds
com.miniclip.eightballpool
com.miniclip.soccerstars
com.nianticlabs.pokemongo
EOF
# Create the main profile application script (apply_profile.sh)
cat <<'EOF' > $MODULE_PATH/apply_profile.sh
#!/system/bin/sh
# Khaenriah Tweak Engine v1.2 - Sentient Edition (Revised)
MODULE_PATH="/data/adb/modules/khaenriah-kernel"

apply_tweaks() {
    PROFILE=$1
    log -p i -t Khaenriah "Applying '$PROFILE' profile..."

    # --- Core System Paths ---
    LITTLE_CLUSTER_GOV="/sys/devices/system/cpu/cpufreq/policy0/scaling_governor"
    BIG_CLUSTER_GOV="/sys/devices/system/cpu/cpufreq/policy6/scaling_governor"
    LITTLE_CLUSTER_MAX_FREQ="/sys/devices/system/cpu/cpufreq/policy0/scaling_max_freq"
    BIG_CLUSTER_MAX_FREQ="/sys/devices/system/cpu/cpufreq/policy6/scaling_max_freq"
    IOWAIT_BOOST_LITTLE="/sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable"
    IOWAIT_BOOST_BIG="/sys/devices/system/cpu/cpufreq/policy6/schedutil/iowait_boost_enable"
    GPU_GOV_PATH="/sys/class/kgsl/kgsl-3d0/devfreq/governor"
    GPU_MIN_PWR="/sys/class/kgsl/kgsl-3d0/min_pwrlevel"
    GPU_MAX_PWR="/sys/class/kgsl/kgsl-3d0/max_pwrlevel"
    GPU_IDLE_TIMER="/sys/class/kgsl/kgsl-3d0/idle_timer"
    GPU_MIN_FREQ="/sys/class/kgsl/kgsl-3d0/devfreq/min_freq"
    WQ_POWER_EFFICIENT="/sys/module/workqueue/parameters/power_efficient"
    TCP_CONG="/proc/sys/net/ipv4/tcp_congestion_control"
    LMK_PATH="/sys/module/lowmemorykiller/parameters/minfree"
    KSM_PATH="/sys/kernel/mm/ksm/run"
    GPU_HWCG_PATH="/sys/class/kgsl/kgsl-3d0/hwcg"

    # --- Reset to a Safe Default State (with write checks) ---
    [ -w "$LITTLE_CLUSTER_GOV" ] && echo "schedutil" > $LITTLE_CLUSTER_GOV
    [ -w "$BIG_CLUSTER_GOV" ] && echo "schedutil" > $BIG_CLUSTER_GOV
    [ -w "$LITTLE_CLUSTER_MAX_FREQ" ] && cp /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_max_freq $LITTLE_CLUSTER_MAX_FREQ
    [ -w "$BIG_CLUSTER_MAX_FREQ" ] && cp /sys/devices/system/cpu/cpufreq/policy6/cpuinfo_max_freq $BIG_CLUSTER_MAX_FREQ
    [ -w "$WQ_POWER_EFFICIENT" ] && echo 1 > $WQ_POWER_EFFICIENT
    [ -w "/sys/class/kgsl/kgsl-3d0/force_rail_on" ] && echo 0 > /sys/class/kgsl/kgsl-3d0/force_rail_on
    [ -w "/sys/class/kgsl/kgsl-3d0/force_clk_on" ] && echo 0 > /sys/class/kgsl/kgsl-3d0/force_clk_on
    [ -w "$GPU_MIN_FREQ" ] && echo 0 > "$GPU_MIN_FREQ"
    [ -w "$GPU_MIN_PWR" ] && echo 5 > $GPU_MIN_PWR
    [ -w "$GPU_MAX_PWR" ] && echo 0 > $GPU_MAX_PWR
    [ -w "$KSM_PATH" ] && echo 1 > $KSM_PATH
    [ -w "$GPU_HWCG_PATH" ] && echo 1 > $GPU_HWCG_PATH
    
    # --- Define Default Profile Values (Based on 'adaptive') ---
    CPU_GOV="schedutil"; GPU_GOV="msm-adreno-tz"; IO_SCHEDULER="cfq"; READ_AHEAD_KB=512; WQ_PE=1; IO_BOOST=1
    GPU_MIN_PWR_VAL=5; GPU_MAX_PWR_VAL=0; GPU_IDLE_TIME=100; GPU_MIN_FREQ_VAL=0
    SWAPPINESS=160; VFS_PRESSURE=100; DIRTY_RATIO=20; DIRTY_BG_RATIO=10
    TCP_ALGO="cubic"; THERMAL_MODE="disabled"
    MINFREE_VALUES="18432,23040,27648,32256,46080,55296"; SCHED_BOOST=1; KSM_STATE=1; HWCG_STATE=1

    # --- Override Defaults Based on Selected Profile ---
    case "$PROFILE" in
    "gaming")
        CPU_GOV="performance"; GPU_GOV="performance"; IO_SCHEDULER="deadline"; READ_AHEAD_KB=2048; WQ_PE=0
        GPU_MIN_PWR_VAL=0; GPU_MAX_PWR_VAL=0; GPU_IDLE_TIME=600; GPU_MIN_FREQ_VAL=610000000
        SWAPPINESS=120; VFS_PRESSURE=50; DIRTY_RATIO=10; DIRTY_BG_RATIO=5
        THERMAL_MODE="disabled"
        [ -w "/sys/class/kgsl/kgsl-3d0/force_rail_on" ] && echo 1 > /sys/class/kgsl/kgsl-3d0/force_rail_on
        [ -w "/sys/class/kgsl/kgsl-3d0/force_clk_on" ] && echo 1 > /sys/class/kgsl/kgsl-3d0/force_clk_on
        MINFREE_VALUES="21816,29088,36360,43632,50904,65448"; KSM_STATE=0; HWCG_STATE=0
        ;;
    "performance")
        CPU_GOV="performance"; READ_AHEAD_KB=1024; WQ_PE=0
        GPU_MIN_PWR_VAL=0; GPU_MAX_PWR_VAL=0; GPU_IDLE_TIME=250
        SWAPPINESS=140; VFS_PRESSURE=70
        THERMAL_MODE="disabled"
        MINFREE_VALUES="20480,27306,34133,42666,51200,68266"; KSM_STATE=0; HWCG_STATE=0
        ;;
    "battery")
        GPU_GOV="powersave"; IO_SCHEDULER="cfq"; READ_AHEAD_KB=256; IO_BOOST=0
        GPU_IDLE_TIME=20
        SWAPPINESS=200; VFS_PRESSURE=150; DIRTY_RATIO=40; DIRTY_BG_RATIO=20
        [ -w "$LITTLE_CLUSTER_MAX_FREQ" ] && echo 998400 > $LITTLE_CLUSTER_MAX_FREQ
        [ -w "$BIG_CLUSTER_MAX_FREQ" ] && echo 1209600 > $BIG_CLUSTER_MAX_FREQ
        MINFREE_VALUES="8192,16384,24576,32768,40960,57344"; SCHED_BOOST=0
        ;;
    "custom")
        if [ -f "$MODULE_PATH/khaenriah_custom.conf" ]; then
            . $MODULE_PATH/khaenriah_custom.conf
            AVAILABLE_CPU_GOVS=$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors 2>/dev/null)
            if ! echo "$AVAILABLE_CPU_GOVS" | grep -q "$CPU_GOV"; then CPU_GOV="schedutil"; fi
        fi
        ;;
    "adaptive"|*) # Default case, values are already set
        ;;
    esac

    # --- Global Thermal Override ---
    THERMAL_CONFIG_FILE="$MODULE_PATH/thermal.conf"
    if [ -f "$THERMAL_CONFIG_FILE" ]; then
        THERMAL_OVERRIDE=$(cat "$THERMAL_CONFIG_FILE")
        case "$THERMAL_OVERRIDE" in "enabled") THERMAL_MODE="enabled";; "disabled") THERMAL_MODE="disabled";; esac
    fi
    
    # --- Apply All Settings ---
    log -p i -t Khaenriah "Applying core CPU/GPU/IO settings for '$PROFILE' profile..."
    for zone in /sys/class/thermal/thermal_zone*; do [ -w "$zone/mode" ] && echo "$THERMAL_MODE" > "$zone/mode"; done

    [ -w "$LITTLE_CLUSTER_GOV" ] && echo $CPU_GOV > $LITTLE_CLUSTER_GOV
    [ -w "$BIG_CLUSTER_GOV" ] && echo $CPU_GOV > $BIG_CLUSTER_GOV
    [ -w "$IOWAIT_BOOST_LITTLE" ] && echo $IO_BOOST > $IOWAIT_BOOST_LITTLE
    [ -w "$IOWAIT_BOOST_BIG" ] && echo $IO_BOOST > $IOWAIT_BOOST_BIG
    [ -w "$GPU_GOV_PATH" ] && echo $GPU_GOV > $GPU_GOV_PATH
    [ -w "$GPU_MIN_PWR" ] && echo $GPU_MIN_PWR_VAL > $GPU_MIN_PWR
    [ -w "$GPU_MAX_PWR" ] && echo $GPU_MAX_PWR_VAL > $GPU_MAX_PWR
    [ -w "$GPU_IDLE_TIMER" ] && echo $GPU_IDLE_TIME > $GPU_IDLE_TIMER
    [ -w "$GPU_MIN_FREQ" ] && echo $GPU_MIN_FREQ_VAL > "$GPU_MIN_FREQ"
    [ -w "$WQ_POWER_EFFICIENT" ] && echo $WQ_PE > $WQ_POWER_EFFICIENT
    [ -w "$TCP_CONG" ] && echo $TCP_ALGO > $TCP_CONG

    # --- [IMPROVED] I/O Scheduler Application Loop ---
    for block in /sys/block/sd[a-z] /sys/block/mmcblk[0-9] /sys/block/dm-[0-9]; do
        if [ -d "$block/queue" ]; then
            [ -w "$block/queue/scheduler" ] && echo $IO_SCHEDULER > "$block/queue/scheduler"
            [ -w "$block/queue/read_ahead_kb" ] && echo $READ_AHEAD_KB > "$block/queue/read_ahead_kb"
        fi
    done
    
    # --- Applying VM (Virtual Memory) Tweaks with write checks ---
    [ -w "/proc/sys/vm/swappiness" ] && echo $SWAPPINESS > /proc/sys/vm/swappiness
    [ -w "/proc/sys/vm/vfs_cache_pressure" ] && echo $VFS_PRESSURE > /proc/sys/vm/vfs_cache_pressure
    [ -w "/proc/sys/vm/dirty_ratio" ] && echo $DIRTY_RATIO > /proc/sys/vm/dirty_ratio
    [ -w "/proc/sys/vm/dirty_background_ratio" ] && echo $DIRTY_BG_RATIO > /proc/sys/vm/dirty_background_ratio
    
    log -p i -t Khaenriah "Applying advanced Memory/Scheduler tweaks..."
    [ -w "$LMK_PATH" ] && echo "$MINFREE_VALUES" > "$LMK_PATH"
    [ -w "$KSM_PATH" ] && echo "$KSM_STATE" > "$KSM_PATH"
    [ -w "$GPU_HWCG_PATH" ] && echo "$HWCG_STATE" > "$GPU_HWCG_PATH"
    for cpu in /sys/devices/system/cpu/cpu*/sched_load_boost; do [ -w "$cpu" ] && echo "$SCHED_BOOST" > "$cpu"; done
    
    log -p i -t Khaenriah "Profile '$PROFILE' with thermal mode '$THERMAL_MODE' applied successfully."
}

if [ -n "$1" ]; then apply_tweaks "$1"; else CONFIG_FILE="$MODULE_PATH/khaenriah.conf"; if [ -f "$CONFIG_FILE" ]; then PROFILE=$(cat "$CONFIG_FILE"); else PROFILE="adaptive"; fi; apply_tweaks "$PROFILE"; fi
EOF

# Create post-fs-data.sh for early ZRAM init
cat <<'EOF' > $MODULE_PATH/post-fs-data.sh
#!/system/bin/sh
# Use MODDIR which is set by Magisk/KernelSU
MODDIR=${0%/*}
CONFIG_FILE="$MODDIR/khaenriah.conf"
CUSTOM_CONFIG_FILE="$MODDIR/khaenriah_custom.conf"

DEFAULT_ZRAM_SIZE=3221225472
if [ -f "$CONFIG_FILE" ]; then PROFILE=$(cat "$CONFIG_FILE"); else PROFILE="adaptive"; fi

case "$PROFILE" in
    "gaming")      ZRAM_SIZE=1073741824 ;;
    "performance") ZRAM_SIZE=2147483648 ;;
    "battery")     ZRAM_SIZE=3221225472 ;;
    *)             ZRAM_SIZE=$DEFAULT_ZRAM_SIZE ;;
esac

if [ "$PROFILE" = "custom" ] && [ -f "$CUSTOM_CONFIG_FILE" ]; then
    . $CUSTOM_CONFIG_FILE
fi

if [ -e /dev/block/zram0 ]; then
    ( log -p i -t Khaenriah "Applying ZRAM size: $ZRAM_SIZE"; swapoff /dev/block/zram0; echo 1 >/sys/block/zram0/reset; echo $ZRAM_SIZE >/sys/block/zram0/disksize; mkswap /dev/block/zram0; swapon /dev/block/zram0; )&
fi
EOF

# --- [IMPROVED] Create the intelligent service.sh script ---
cat <<'EOF' > $MODULE_PATH/service.sh
#!/system/bin/sh
# Use MODDIR which is set by Magisk/KernelSU
MODDIR=${0%/*}
APPLY_SCRIPT="$MODDIR/apply_profile.sh"
CONFIG_FILE="$MODDIR/khaenriah.conf"
GAMES_LIST_FILE="$MODDIR/games_list_real.txt"

# --- Initial Profile Application on Boot ---
(
    sleep 60
    log -p i -t Khaenriah "Applying boot profile..."
    $APPLY_SCRIPT
)&

# --- Thermal Safety Net ---
(
    sleep 90
    THERMAL_LIMIT=95000
    while true; do
        sleep 20
        PROFILE=$(cat "$CONFIG_FILE" 2>/dev/null)
        THERMAL_OVERRIDE=$(cat "$MODDIR/thermal.conf" 2>/dev/null)
        if { [ "$PROFILE" = "gaming" ] || [ "$PROFILE" = "performance" ]; } && [ "$THERMAL_OVERRIDE" != "enabled" ]; then
            for temp_file in /sys/class/thermal/thermal_zone*/temp; do
                if [ -f "$temp_file" ] && [ "$(cat "$temp_file")" -gt "$THERMAL_LIMIT" ]; then
                    log -p w -t Khaenriah "SafetyNet: High temp! Re-enabling thermal control."
                    for zone in /sys/class/thermal/thermal_zone*; do [ -w "$zone/mode" ] && echo "enabled" > "$zone/mode"; done
                    break 2
                fi
            done
        fi
    done
) &

# --- Sentient Services (Screen State & App-Aware Logic) ---
(
    sleep 120
    screen_is_off=false; is_in_game_mode=false
    
    if [ -f "$GAMES_LIST_FILE" ]; then
        GAMES_LIST=$(cat "$GAMES_LIST_FILE")
    else
        GAMES_LIST="com.tencent.ig"; echo "$GAMES_LIST" > "$GAMES_LIST_FILE"
    fi

    while true; do
        sleep 10 # (Optimized from 8s to 10s for better battery)

        if dumpsys power | grep -q "mWakefulness=Asleep"; then
            if ! $screen_is_off; then
                log -p i -t Khaenriah "Screen OFF. Applying deep sleep profile."
                [ -w "/sys/devices/system/cpu/cpufreq/policy0/scaling_governor" ] && echo "powersave" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
                [ -w "/sys/devices/system/cpu/cpufreq/policy6/scaling_governor" ] && echo "powersave" > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
                [ -w "/sys/class/kgsl/kgsl-3d0/devfreq/governor" ] && echo "powersave" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
                screen_is_off=true; is_in_game_mode=false
            fi
            sleep 25; continue
        else
            if $screen_is_off; then
                log -p i -t Khaenriah "Screen ON. Restoring user profile."
                $APPLY_SCRIPT; screen_is_off=false; sleep 3
            fi
        fi
        
        if [ "$(cat "$CONFIG_FILE" 2>/dev/null)" = "adaptive" ]; then
            # --- [IMPROVED] Use pgrep for efficient game detection ---
            game_detected=false
            for game_pkg in $GAMES_LIST; do
                if pgrep -x "$game_pkg" >/dev/null; then
                    game_detected=true
                    current_app=$game_pkg
                    break
                fi
            done
            
            if $game_detected; then
                if ! $is_in_game_mode; then
                    log -p i -t Khaenriah "Adaptive: Game detected ($current_app)! Engaging light gaming boost."
                    [ -w "/sys/devices/system/cpu/cpufreq/policy0/scaling_governor" ] && echo "performance" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
                    [ -w "/sys/devices/system/cpu/cpufreq/policy6/scaling_governor" ] && echo "performance" > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
                    [ -w "/sys/class/kgsl/kgsl-3d0/devfreq/governor" ] && echo "performance" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
                    [ -w "/sys/class/kgsl/kgsl-3d0/devfreq/min_freq" ] && echo 500000000 > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
                    [ -w "/sys/module/workqueue/parameters/power_efficient" ] && echo 0 > /sys/module/workqueue/parameters/power_efficient
                    is_in_game_mode=true
                fi
            else
                if $is_in_game_mode; then
                    log -p i -t Khaenriah "Adaptive: Exited game. Reverting to normal adaptive profile."
                    $APPLY_SCRIPT "adaptive"; is_in_game_mode=false
                fi
            fi
        fi
    done
) &
EOF

# --- Companion Module Installation ---
ui_print ">> Step 3/4: Installing Companion Features...";
# module.prop
cat <<'EOF' > $MODULE_PATH/module.prop
id=khaenriah-kernel
name=Khaenriah Kernel for Realme 5 Pro
version=v1.2-Sentient
versionCode=3
author=Abdallah ibrahim (@D_ai_n)
description=The ultimate, sentient control script for Khaenriah Kernel. Use 'dain' or 'khaenriah' command in termux.
EOF
# Banner File
cat <<'EOF' > $MODULE_PATH/banner
  _  ___                           _       _     
 | |/ / |                         (_)     | |    
 | ' /| |__   __ _  ___ _ __  _ __ _  __ _| |__  
 |  < | '_ \ / _` |/ _ \ '_ \| '__| |/ _` | '_ \ 
 | . \| | | | (_| |  __/ | | | |  | | (_| | | | |
 |_|\_\_| |_|\__,_|\___|_| |_|_|  |_|\__,_|_| |_|
 
        v1.2 - Sentient Edition
EOF
# uninstall.sh
cat <<'EOF' > $MODULE_PATH/uninstall.sh
#!/system/bin/sh
rm -f /data/adb/modules/khaenriah-kernel/khaenriah.conf
rm -f /data/adb/modules/khaenriah-kernel/khaenriah_custom.conf
rm -f /data/adb/modules/khaenriah-kernel/.first_run_done
rm -f /data/adb/modules/khaenriah-kernel/thermal.conf
rm -f /data/adb/modules/khaenriah-kernel/games_list_real.txt
EOF

# --- [IMPROVED] Main Terminal UI Script (khaenriah) ---
cat <<'EOF' > $MODULE_PATH/system/bin/khaenriah
#!/system/bin/sh
MODULE_PATH="/data/adb/modules/khaenriah-kernel"; CONFIG_FILE="$MODULE_PATH/khaenriah.conf"; APPLY_SCRIPT="$MODULE_PATH/apply_profile.sh"; CUSTOM_CONFIG_FILE="$MODULE_PATH/khaenriah_custom.conf"; FIRST_RUN_FLAG="$MODULE_PATH/.first_run_done"; THERMAL_CONFIG_FILE="$MODULE_
