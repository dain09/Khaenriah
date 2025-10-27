### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers
## Khaenriah Project v1.2 - Sentient Edition
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
ui_print " "; ui_print "Khaenriah Kernel Installer v1.2 - Sentient"; ui_print "by Abdallah ibrahim (@D_ai_n) for Realme 5 Pro"; ui_print " ";

# --- Kernel Installation ---
ui_print ">> Step 1/4: Installing Core Kernel...";
dump_boot;

# --- Tweak Engine Installation ---
ui_print ">> Step 2/4: Setting up Sentient Tweak Engine...";
MODULE_ID="khaenriah-kernel"; MODULE_PATH="/data/adb/modules/$MODULE_ID"
rm -rf $MODULE_PATH
mkdir -p $MODULE_PATH/system/bin

ui_print "  - Injecting Advanced & Interactive Tweak Profiles...";
# --- NEW: Copy game list file ---
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
com.tencent.ig
com.tencent.pubgmhd
com.garena.game.kgvn
com.dts.freefireth
com.dts.freefiremax
com.activision.callofduty.shooter
com.epicgames.fortnite
com.miHoYo.GenshinImpact
com.supercell.clashofclans
com.supercell.clashroyale
com.supercell.brawlstars
com.roblox.client
com.mojang.minecraftpe
com.king.candycrushsaga
com.king.candycrushsodasaga
com.rovio.angrybirds
com.miniclip.eightballpool
com.miniclip.soccerstars
com.nianticlabs.pokemongo
com.rockstargames.gtasa
EOF
# Create the main profile application script (apply_profile.sh)
cat <<'EOF' > $MODULE_PATH/apply_profile.sh
#!/system/bin/sh
# Khaenriah Tweak Engine v1.2 - Sentient Edition (Optimized)
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

    # --- Reset to a Safe Default State ---
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
        echo 1 > /sys/class/kgsl/kgsl-3d0/force_rail_on; echo 1 > /sys/class/kgsl/kgsl-3d0/force_clk_on
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

    [ -w "$LITTLE_CLUSTER_GOV" ] && echo $CPU_GOV > $LITTLE_CLUSTER_GOV; [ -w "$BIG_CLUSTER_GOV" ] && echo $CPU_GOV > $BIG_CLUSTER_GOV
    [ -w "$IOWAIT_BOOST_LITTLE" ] && echo $IO_BOOST > $IOWAIT_BOOST_LITTLE; [ -w "$IOWAIT_BOOST_BIG" ] && echo $IO_BOOST > $IOWAIT_BOOST_BIG
    [ -w "$GPU_GOV_PATH" ] && echo $GPU_GOV > $GPU_GOV_PATH; [ -w "$GPU_MIN_PWR" ] && echo $GPU_MIN_PWR_VAL > $GPU_MIN_PWR
    [ -w "$GPU_MAX_PWR" ] && echo $GPU_MAX_PWR_VAL > $GPU_MAX_PWR; [ -w "$GPU_IDLE_TIMER" ] && echo $GPU_IDLE_TIME > $GPU_IDLE_TIMER
    [ -w "$GPU_MIN_FREQ" ] && echo $GPU_MIN_FREQ_VAL > "$GPU_MIN_FREQ"
    [ -w "$WQ_POWER_EFFICIENT" ] && echo $WQ_PE > $WQ_POWER_EFFICIENT; [ -w "$TCP_CONG" ] && echo $TCP_ALGO > $TCP_CONG
    for block in /sys/block/sd*; do [ -w "$block/queue/scheduler" ] && echo $IO_SCHEDULER > "$block/queue/scheduler"; [ -w "$block/queue/read_ahead_kb" ] && echo $READ_AHEAD_KB > "$block/queue/read_ahead_kb"; done
    [ -w "/proc/sys/vm/swappiness" ] && echo $SWAPPINESS > /proc/sys/vm/swappiness; [ -w "/proc/sys/vm/vfs_cache_pressure" ] && echo $VFS_PRESSURE > /proc/sys/vm/vfs_cache_pressure
    [ -w "/proc/sys/vm/dirty_ratio" ] && echo $DIRTY_RATIO > /proc/sys/vm/dirty_ratio; [ -w "/proc/sys/vm/dirty_background_ratio" ] && echo $DIRTY_BG_RATIO > /proc/sys/vm/dirty_background_ratio
    
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
MODULE_PATH="/data/adb/modules/khaenriah-kernel"
CONFIG_FILE="$MODULE_PATH/khaenriah.conf"
CUSTOM_CONFIG_FILE="$MODULE_PATH/khaenriah_custom.conf"

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

# --- NEW: Create the intelligent service.sh script ---
cat <<'EOF' > $MODULE_PATH/service.sh
#!/system/bin/sh
MODULE_PATH="/data/adb/modules/khaenriah-kernel"
APPLY_SCRIPT="/data/adb/modules/khaenriah-kernel/apply_profile.sh"
CONFIG_FILE="$MODULE_PATH/khaenriah.conf"
GAMES_LIST_FILE="$MODULE_PATH/games_list_real.txt"

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
        THERMAL_OVERRIDE=$(cat "$MODULE_PATH/thermal.conf" 2>/dev/null)
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
        GAMES_LIST=$(cat "$GAMES_LIST_FILE" | tr '\n' ' ')
    else
        GAMES_LIST=""; echo "com.tencent.ig" > "$GAMES_LIST_FILE"
    fi

    while true; do
        sleep 8 # (Optimized from 5s to 8s)

        if dumpsys power | grep -q "mWakefulness=Asleep"; then
            if [ "$screen_is_off" = false ]; then
                log -p i -t Khaenriah "Screen OFF. Applying deep sleep profile."
                [ -w "/sys/devices/system/cpu/cpufreq/policy0/scaling_governor" ] && echo "powersave" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
                [ -w "/sys/devices/system/cpu/cpufreq/policy6/scaling_governor" ] && echo "powersave" > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
                [ -w "/sys/class/kgsl/kgsl-3d0/devfreq/governor" ] && echo "powersave" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
                screen_is_off=true; is_in_game_mode=false
            fi
            sleep 25; continue
        else
            if [ "$screen_is_off" = true ]; then
                log -p i -t Khaenriah "Screen ON. Restoring user profile."
                $APPLY_SCRIPT; screen_is_off=false; sleep 3
            fi
        fi
        
        if [ "$(cat "$CONFIG_FILE" 2>/dev/null)" = "adaptive" ]; then
            current_app=$(dumpsys window windows | grep -E 'mCurrentFocus' | cut -d'/' -f1 | sed 's/.* //g')
            game_detected=false
            for game in $GAMES_LIST; do if [ "$current_app" = "$game" ]; then game_detected=true; break; fi; done
            
            if [ "$game_detected" = true ]; then
                if [ "$is_in_game_mode" = false ]; then
                    log -p i -t Khaenriah "Adaptive: Game detected ($current_app)! Engaging light gaming boost."
                    [ -w "/sys/devices/system/cpu/cpufreq/policy0/scaling_governor" ] && echo "performance" > /sys/devices/system/cpu/cpufreq/policy0/scaling_governor
                    [ -w "/sys/devices/system/cpu/cpufreq/policy6/scaling_governor" ] && echo "performance" > /sys/devices/system/cpu/cpufreq/policy6/scaling_governor
                    [ -w "/sys/class/kgsl/kgsl-3d0/devfreq/governor" ] && echo "performance" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
                    [ -w "/sys/class/kgsl/kgsl-3d0/devfreq/min_freq" ] && echo 500000000 > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq
                    [ -w "/sys/module/workqueue/parameters/power_efficient" ] && echo 0 > /sys/module/workqueue/parameters/power_efficient
                    is_in_game_mode=true
                fi
            else
                if [ "$is_in_game_mode" = true ]; then
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

# --- NEW: Main Terminal UI Script (khaenriah) ---
cat <<'EOF' > $MODULE_PATH/system/bin/khaenriah
#!/system/bin/sh
MODULE_PATH="/data/adb/modules/khaenriah-kernel"; CONFIG_FILE="$MODULE_PATH/khaenriah.conf"; APPLY_SCRIPT="$MODULE_PATH/apply_profile.sh"; CUSTOM_CONFIG_FILE="$MODULE_PATH/khaenriah_custom.conf"; FIRST_RUN_FLAG="$MODULE_PATH/.first_run_done"; THERMAL_CONFIG_FILE="$MODULE_PATH/thermal.conf"
C_CYAN='\033[1;36m'; C_GREEN='\033[1;32m'; C_YELLOW='\033[1;33m'; C_RED='\033[1;31m'; C_WHITE='\033[1;37m'; C_GRAY='\033[0;37m'; NC='\033[0m'

draw_bar() { local label=$1; local current_val=$2; local max_val=$3; local bar_width=25; if [ "$max_val" -le 0 ]; then max_val=1; fi; local percentage=$((current_val * 100 / max_val)); local filled_width=$((percentage * bar_width / 100)); printf "%-12s [%s" "$label"; for i in $(seq 1 $bar_width); do if [ $i -le $filled_width ]; then printf "${C_GREEN}❚"; else printf "${C_GRAY}─"; fi; done; printf "${NC}] ${C_GREEN}%s%%${NC}\n" "$percentage"; }
run_ping_test() { clear; echo -e "${C_CYAN}--- Network Ping Test ---${NC}"; echo -e "${C_WHITE}Pinging Google DNS...${NC}\n"; PING_RESULT=$(ping -c 4 8.8.8.8); if [ $? -eq 0 ]; then echo -e "${C_GRAY}$PING_RESULT${NC}\n"; AVG_PING=$(echo "$PING_RESULT" | grep "avg" | cut -d'/' -f5); echo -e "${C_WHITE}Average Latency: ${C_GREEN}${AVG_PING} ms${NC}"; else echo -e "${C_RED}Ping failed.${NC}"; fi; echo " "; echo -n "Press Enter to return..."; read; }
show_status() { trap 'tput cnorm; clear; exit' INT TERM; tput civis; while true; do clear; echo -e "${C_CYAN}--- Live System Status (Press 'q' to quit) ---${NC}"; local big_freq_khz=$(cat /sys/devices/system/cpu/cpufreq/policy6/scaling_cur_freq 2>/dev/null||echo 0); local little_freq_khz=$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_cur_freq 2>/dev/null||echo 0); local gpu_freq_hz=$(cat /sys/class/kgsl/kgsl-3d0/devfreq/cur_freq 2>/dev/null||echo 0); local gpu_min_freq_hz=$(cat /sys/class/kgsl/kgsl-3d0/devfreq/min_freq 2>/dev/null||echo 0); local big_mhz=$((big_freq_khz/1000)); local little_mhz=$((little_freq_khz/1000)); local gpu_mhz=$((gpu_freq_hz/1000000)); local gpu_min_mhz=$((gpu_min_freq_hz/1000000)); local cpu_gov_big=$(cat /sys/devices/system/cpu/cpufreq/policy6/scaling_governor 2>/dev/null||echo "N/A"); local cpu_gov_little=$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_governor 2>/dev/null||echo "N/A"); local gpu_gov=$(cat /sys/class/kgsl/kgsl-3d0/devfreq/governor 2>/dev/null||echo "N/A"); echo -e "${C_WHITE}CPU Freq (Big|Little): ${C_GREEN}$big_mhz MHz${NC}|${C_GREEN}$little_mhz MHz${NC}"; echo -e "${C_WHITE}CPU Gov (Big|Little): ${C_GREEN}$cpu_gov_big${NC}|${C_GREEN}$cpu_gov_little${NC}"; echo -e "${C_WHITE}GPU Freq (Cur|Min):  ${C_GREEN}$gpu_mhz MHz${NC}|${C_GREEN}$gpu_min_mhz MHz${NC}"; echo -e "${C_WHITE}GPU Governor:        ${C_GREEN}$gpu_gov${NC}"; local max_temp_mc=0; for zone in /sys/class/thermal/thermal_zone*/temp; do if [ -r "$zone" ]; then current_temp=$(cat "$zone" 2>/dev/null); if [ "$current_temp" -gt "$max_temp_mc" ] 2>/dev/null; then max_temp_mc=$current_temp; fi; fi; done; local max_temp_c=$((max_temp_mc/1000)); echo -e "${C_WHITE}Max System Temp:     ${C_YELLOW}$max_temp_c°C${NC}\n"; local max_big_khz=$(cat /sys/devices/system/cpu/cpufreq/policy6/cpuinfo_max_freq); local max_little_khz=$(cat /sys/devices/system/cpu/cpufreq/policy0/cpuinfo_max_freq); local max_gpu_hz=$(cat /sys/class/kgsl/kgsl-3d0/devfreq/max_freq 2>/dev/null || echo 1); local mem_info=$(cat /proc/meminfo); local ram_total_kb=$(echo "$mem_info" | grep "MemTotal" | awk '{print $2}'); local ram_available_kb=$(echo "$mem_info" | grep "MemAvailable" | awk '{print $2}'); local ram_used_kb=$((ram_total_kb-ram_available_kb)); draw_bar "CPU (Big)" "$big_freq_khz" "$max_big_khz"; draw_bar "CPU (Little)" "$little_freq_khz" "$max_little_khz"; draw_bar "GPU" "$gpu_freq_hz" "$max_gpu_hz"; draw_bar "RAM" "$ram_used_kb" "$ram_total_kb"; draw_bar "Temp" "$max_temp_c" "90"; echo ""; local thermal_mode=$(cat /sys/class/thermal/thermal_zone0/mode 2>/dev/null||echo "N/A"); local io_sched=$(cat /sys/block/sda/queue/scheduler 2>/dev/null | sed 's/.*\[\([^]]*\)\].*/\1/' || echo "N/A"); echo -e "${C_WHITE}Thermal Throttling: ${C_GRAY}$thermal_mode${NC}"; echo -e "${C_WHITE}I/O Scheduler: ${C_GREEN}$io_sched${NC}"; read -s -n 1 -t 3 key; if [ "$key" = "q" ] || [ "$key" = "Q" ]; then break; fi; done; tput cnorm; }
show_specific_detail() { clear; echo -e "${C_YELLOW}--- Profile Details ---${NC}"; echo -e "${C_WHITE}1) Gaming:${NC}\n${C_GRAY}   For extreme performance. Locks CPU/GPU to max & disables thermals. Use with caution.${NC}\n"; echo -e "${C_WHITE}2) Performance:${NC}\n${C_GRAY}   Unleashes the device for benchmarks. Disables thermals for max scores.${NC}\n"; echo -e "${C_WHITE}3) Dynamic:${NC}\n${C_GRAY}   Best balance for daily use. Uses 'schedutil' for a smooth experience.${NC}\n"; echo -e "${C_WHITE}4) Battery:${NC}\n${C_GRAY}   For max endurance. Limits frequencies with a smooth governor to prevent lag.${NC}\n"; echo -e "${C_WHITE}5) Custom:${NC}\n${C_GRAY}   Your playground. Applies your tweaks from the custom config file.${NC}\n"; echo -e "${C_WHITE}6) Adaptive:${NC}\n${C_GRAY}   The intelligent default. Automatically boosts for heavy tasks & saves power when idle.${NC}\n"; echo -n "Press Enter to return..."; read; }
edit_games_list() { tput cnorm; if [ -f "$MODULE_PATH/games_list_real.txt" ]; then echo -e "${C_YELLOW}Opening Game List for editing...${NC}"; echo -e "${C_GRAY}Add the package name of each game on a new line.\nSave and exit when you are done.${NC}\n"; sleep 2; if command -v nano >/dev/null 2>&1; then nano "$MODULE_PATH/games_list_real.txt"; else vi "$MODULE_PATH/games_list_real.txt"; fi; echo -e "\n${C_GREEN}Game list saved.${NC}"; else echo -e "${C_RED}Game list file not found!${NC}"; fi; sleep 2; }
show_utilities_menu() { while true; do tput cnorm; clear; echo -e "${C_YELLOW}--- Utilities Menu ---${NC}"; echo -e "  ${C_WHITE}1)${NC} Clear System Caches"; echo -e "  ${C_WHITE}2)${NC} Backup Custom Profile"; echo -e "  ${C_WHITE}3)${NC} Restore Custom Profile"; echo -e "  ${C_WHITE}4)${NC} Network Ping Test"; echo -e "  ${C_WHITE}5)${C_CYAN} Edit Game List for Adaptive Profile${NC}"; echo -e "  ${C_WHITE}b)${NC} Back to Main Menu\n"; echo -n "Enter your choice: "; read util_choice; case $util_choice in 1) clear; echo -e "${C_YELLOW}Clearing system caches...${NC}"; pm trim-caches 9999G >/dev/null 2>&1; echo -e "${C_GREEN}Caches cleared.${NC}"; sleep 2;; 2) clear; if [ -f "$CUSTOM_CONFIG_FILE" ]; then mkdir -p /sdcard/Khaenriah; cp "$CUSTOM_CONFIG_FILE" /sdcard/Khaenriah/custom_profile_backup.conf; echo -e "${C_GREEN}Backup successful! Saved to /sdcard/Khaenriah/${NC}"; else echo -e "${C_RED}No custom profile found.${NC}"; fi; sleep 3;; 3) clear; if [ -f "/sdcard/Khaenriah/custom_profile_backup.conf" ]; then cp "/sdcard/Khaenriah/custom_profile_backup.conf" "$CUSTOM_CONFIG_FILE"; echo -e "${C_GREEN}Restore successful!${NC}"; else echo -e "${C_RED}No backup file found.${NC}"; fi; sleep 3;; 4) run_ping_test;; 5) edit_games_list;; b|B) break ;; *) echo -e "${C_RED}Invalid option.${NC}"; sleep 1 ;; esac; done; }
show_thermal_menu() { while true; do tput cnorm; clear; current_thermal_mode=$(cat "$THERMAL_CONFIG_FILE" 2>/dev/null || echo "auto"); first_char=$(echo "$current_thermal_mode" | cut -c1 | tr 'a-z' 'A-Z'); rest_of_string=$(echo "$current_thermal_mode" | cut -c2-); capitalized_thermal="$first_char$rest_of_string"; echo -e "${C_YELLOW}--- Thermal Control ---${NC}"; echo -e "${C_GRAY}Override the default thermal behavior of profiles.${NC}"; echo -e "${C_WHITE}Current setting: ${C_GREEN}${capitalized_thermal}${NC}\n"; echo -e "  ${C_WHITE}1) ${C_CYAN}Auto (Recommended):${NC} Let profile decide."; echo -e "  ${C_WHITE}2) ${C_GREEN}Force Enabled:${NC} Thermals always ON."; echo -e "  ${C_WHITE}3) ${C_RED}Force Disabled:${NC} Thermals always OFF. ${C_YELLOW}RISKY!${NC}"; echo -e "  ${C_WHITE}b) Back to Main Menu\n"; echo -n "Enter choice: "; read thermal_choice; local new_thermal_mode=""; case $thermal_choice in 1) new_thermal_mode="auto" ;; 2) new_thermal_mode="enabled" ;; 3) new_thermal_mode="disabled" ;; b|B) break ;; *) echo -e "${C_RED}Invalid option.${NC}"; sleep 1; continue ;; esac; if [ -n "$new_thermal_mode" ]; then echo "$new_thermal_mode" > "$THERMAL_CONFIG_FILE"; echo -e "\n${C_YELLOW}Applying new thermal setting instantly...${NC}"; local current_profile=$(cat "$CONFIG_FILE" 2>/dev/null || echo "adaptive"); su -c "sh $APPLY_SCRIPT $current_profile" >/dev/null 2>&1; echo -e "${C_GREEN}New thermal setting is now active!${NC}"; sleep 2; fi; done; }

edit_custom_profile() {
    tput cnorm # Always ensure cursor is visible here
    clear
    echo -e "${C_CYAN}--- Custom Profile Editor ---${NC}"
    echo -e "${C_GRAY}Press Enter to keep the current value.${NC}\n"
    
    [ -f "$CUSTOM_CONFIG_FILE" ] && . "$CUSTOM_CONFIG_FILE"
    
    CPU_GOV=${CPU_GOV:-"schedutil"}
    GPU_GOV=${GPU_GOV:-"msm-adreno-tz"}
    IO_SCHEDULER=${IO_SCHEDULER:-"cfq"}
    TCP_ALGO=${TCP_ALGO:-"cubic"}
    ZRAM_SIZE=${ZRAM_SIZE:-3221225472}

    AVAILABLE_CPU_GOVS=$(cat /sys/devices/system/cpu/cpufreq/policy0/scaling_available_governors)
    echo -e "${C_YELLOW}Available CPU Governors:${NC} ${C_WHITE}$AVAILABLE_CPU_GOVS${NC}"
    echo -n "CPU Governor [current: $CPU_GOV]: "
    read new_cpu_gov

    AVAILABLE_GPU_GOVS="msm-adreno-tz performance powersave simple_ondemand schedutil"
    echo -e "\n${C_YELLOW}Available GPU Governors:${NC} ${C_WHITE}$AVAILABLE_GPU_GOVS${NC}"
    echo -n "GPU Governor [current: $GPU_GOV]: "
    read new_gpu_gov

    AVAILABLE_IO_SCHEDS=$(cat /sys/block/sda/queue/scheduler | sed 's/\[//g; s/\]//g')
    echo -e "\n${C_YELLOW}Available I/O Schedulers:${NC} ${C_WHITE}$AVAILABLE_IO_SCHEDS${NC}"
    echo -n "I/O Scheduler [current: $IO_SCHEDULER]: "
    read new_io_sched

    AVAILABLE_TCP_ALGOS="cubic reno bbr westwood"
    echo -e "\n${C_YELLOW}Available TCP Algorithms:${NC} ${C_WHITE}$AVAILABLE_TCP_ALGOS${NC}"
    echo -n "TCP Algorithm [current: $TCP_ALGO]: "
    read new_tcp_algo

    echo -e "\n${C_YELLOW}ZRAM Size:${NC} ${C_GRAY}(Enter value in bytes, e.g., 2147483648 for 2GB)${NC}"
    echo -n "ZRAM Size (bytes) [current: $ZRAM_SIZE]: "
    read new_zram_size

    NEW_CONFIG="
# Khaenriah Kernel Custom Profile (v1.1)
# Saved on $(date)
CPU_GOV=\"${new_cpu_gov:-$CPU_GOV}\"
GPU_GOV=\"${new_gpu_gov:-$GPU_GOV}\"
IO_SCHEDULER=\"${new_io_sched:-$IO_SCHEDULER}\"
TCP_ALGO=\"${new_tcp_algo:-$TCP_ALGO}\"
ZRAM_SIZE=${new_zram_size:-$ZRAM_SIZE}
"
    echo "$NEW_CONFIG" > "$CUSTOM_CONFIG_FILE"
    echo -e "\n${C_GREEN}Custom profile saved!${NC}"
    echo -e "${C_GRAY}These settings will be applied when you select the 'Custom' profile.${NC}"
    sleep 4
}

show_main_menu() { clear; echo -e "${C_CYAN}$(cat $MODULE_PATH/banner)${NC}"; echo -e "${C_WHITE}    Developed by Abdallah ibrahim (@D_ai_n)     ${NC}\n"; current_profile_file=$(cat "$CONFIG_FILE" 2>/dev/null || echo "adaptive"); first_char=$(echo "$current_profile_file" | cut -c1 | tr 'a-z' 'A-Z'); rest_of_string=$(echo "$current_profile_file" | cut -c2-); capitalized_profile="$first_char$rest_of_string"; active_gov=$(cat /sys/devices/system/cpu/cpufreq/policy6/scaling_governor 2>/dev/null || echo "N/A"); active_temp_mc=$(cat /sys/class/thermal/thermal_zone1/temp 2>/dev/null || echo 0); active_temp_c=$((active_temp_mc / 1000)); echo -e "${C_YELLOW}--- Live Status ---${NC}"; printf "  ${C_WHITE}%-20s ${C_GREEN}%s\n" "Profile on boot:" "$capitalized_profile"; printf "  ${C_WHITE}%-20s ${C_GREEN}%s\n" "Active Governor:" "$active_gov"; printf "  ${C_WHITE}%-20s ${C_YELLOW}%s\n\n" "Temperature:" "${active_temp_c}°C"; echo -e "${C_YELLOW}--- Set Profile ${C_GRAY}(prefix 'a' to apply instantly)${NC} ---"; printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n" "1) Gaming" "2) Performance"; printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n" "3) Dynamic" "4) Battery"; printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n" "5) Custom" "6) Adaptive (Smart)"; echo -e "  ${C_CYAN}c) Edit Custom Profile${NC}\n"; echo -e "${C_YELLOW}--- Actions & Control ---${NC}"; printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n" "s) Full Live Status" "u) Utilities Menu"; printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n" "d) Learn about profiles" "t) Thermal Control"; printf "  ${C_WHITE}%-25s ${C_WHITE}%s\n\n" "r) Reset to Defaults" "x) Exit"; }
run_first_time_wizard() { tput cnorm; clear; echo -e "${C_CYAN}Welcome to Khaenriah Kernel v1.2!${NC}"; echo -e "${C_WHITE}This one-time setup helps you choose the best profile for your needs.${NC}\n"; echo -e "${C_WHITE}What is your main priority?${NC}"; echo -e "  ${C_WHITE}1) ${C_CYAN}Adaptive (Recommended):${NC} Automatically balances performance and battery."; echo -e "  ${C_WHITE}2) ${C_WHITE}Dynamic:${NC} A great balance for everyday smooth usage."; echo -e "  ${C_WHITE}3) ${C_GREEN}Gaming:${NC} Max performance (causes heat)."; echo -e "  ${C_WHITE}4) ${C_YELLOW}Battery:${NC} Max battery life with reduced performance.\n"; echo -n -e "Choose an option, or press ${C_GREEN}Enter${NC} for Adaptive: "; read wizard_choice; if [ -z "$wizard_choice" ]; then wizard_choice=1; fi; case $wizard_choice in 2) chosen_profile="dynamic" ;; 3) chosen_profile="gaming" ;; 4) chosen_profile="battery" ;; 1|*) chosen_profile="adaptive" ;; esac; echo "$chosen_profile" > "$CONFIG_FILE"; echo "auto" > "$THERMAL_CONFIG_FILE"; echo -e "\n${C_GREEN}Great! '$chosen_profile' has been set as default.${NC}"; echo -e "${C_GRAY}You can change it anytime.${NC}"; echo "1" > "$FIRST_RUN_FLAG"; sleep 4; }

if ! [ -f "$FIRST_RUN_FLAG" ]; then run_first_time_wizard; fi
while true; do tput cnorm; show_main_menu; echo -n "Enter your choice: "; read choice; clear; target_profile=""; apply_now=false; case $choice in 1) target_profile="gaming";; 2) target_profile="performance";; 3) target_profile="dynamic";; 4) target_profile="battery";; 5) target_profile="custom";; 6) target_profile="adaptive";; a1) apply_now=true; target_profile="gaming";; a2) apply_now=true; target_profile="performance";; a3) apply_now=true; target_profile="dynamic";; a4) apply_now=true; target_profile="battery";; a5) apply_now=true; target_profile="custom";; a6) apply_now=true; target_profile="adaptive";; c|C) edit_custom_profile; continue;; s|S) show_status; continue;; u|U) show_utilities_menu; continue;; d|D) show_specific_detail; continue;; t|T) show_thermal_menu; continue;; r|R) echo -e "\n${C_YELLOW}Resetting all settings to recommended defaults...${NC}"; echo "adaptive" > "$CONFIG_FILE"; echo "auto" > "$THERMAL_CONFIG_FILE"; su -c "sh $APPLY_SCRIPT adaptive" >/dev/null 2>&1; echo -e "${C_GREEN}Reset complete. Profile set to 'Adaptive'.${NC}"; echo -e "${C_GRAY}Settings are now active and will be fully applied on reboot.${NC}"; echo -e "\n${C_WHITE}Press Enter to return to main menu...${NC}"; read; continue ;; x|X) echo -e "\n${C_YELLOW}Exiting.${NC}"; break;; *) echo -e "\n${C_RED}Invalid option.${NC}"; sleep 1; continue;; esac; if [ -n "$target_profile" ]; then echo "$target_profile" > "$CONFIG_FILE"; if [ "$apply_now" = true ]; then echo -e "\n${C_YELLOW}Applying '$target_profile' profile now...${NC}"; su -c "sh $APPLY_SCRIPT $target_profile" 2>/dev/null; echo -e "${C_GREEN}Done. '$target_profile' is now active.${NC}"; echo -e "${C_GRAY}---------------------------------------\n${C_YELLOW}Note:${NC} ${C_WHITE}For full effect, some settings may require a ${C_GREEN}reboot.${NC}\n${C_GRAY}---------------------------------------"; else echo -e "\n${C_GREEN}OK. '$target_profile' will be applied on next boot.${NC}"; fi; if [ "$target_profile" = "custom" ] && ! [ -f "$CUSTOM_CONFIG_FILE" ]; then echo -e "\n${C_YELLOW}Creating template for Custom profile...${NC}"; cat <<'TEMPLATE_EOF' > "$CUSTOM_CONFIG_FILE"
# Khaenriah Kernel Custom Profile (v1.2)
# You can edit this file manually or using the 'c' option in the main menu.
CPU_GOV="schedutil"; GPU_GOV="msm-adreno-tz"; IO_SCHEDULER="cfq"; TCP_ALGO="cubic"; ZRAM_SIZE=3221225472
TEMPLATE_EOF
echo -e "${C_GREEN}Template created at: ${C_GRAY}$CUSTOM_CONFIG_FILE${NC}"; fi; echo -e "\n${C_WHITE}Press Enter to return to main menu...${NC}"; read; fi; done; tput cnorm; exit 0
EOF

# Create the alias for 'dain'
cp $MODULE_PATH/system/bin/khaenriah $MODULE_PATH/system/bin/dain

# --- Finalizing ---
ui_print "  - Setting permissions...";
set_perm_recursive $MODULE_PATH 0 0 755 0644
chmod 755 $MODULE_PATH/post-fs-data.sh $MODULE_PATH/service.sh $MODULE_PATH/apply_profile.sh $MODULE_PATH/uninstall.sh $MODULE_PATH/system/bin/khaenriah $MODULE_PATH/system/bin/dain

ui_print ">> Step 4/4: Repacking Boot Image...";
write_boot;
## end install

ui_print " "; ui_print "-----------------------------------------"; ui_print "  ✔ Installation Complete: Sentient v1.2!"; ui_print "-----------------------------------------"; ui_print " "; ui_print  "- The Instant Control module is at your command."; ui_print "- Use 'su' then 'dain' or 'khaenriah' in terminal."; ui_print " "; ui_print ">> Reboot to awaken the new intelligence."; ui_print " ";