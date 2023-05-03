# YayBootScriptYay

MODDIR=${0%/*}

# copy certificates from User Store to System Store

cp -f /data/misc/user/0/cacerts-added/* $MODDIR/system/etc/security/cacerts
chown -R 0:0 $MODDIR/system/etc/security/cacerts

[ "$(getenforce)" = "Enforcing" ] || exit 0

default_selinux_context=u:object_r:system_file:s0
selinux_context=$(ls -Zd /system/etc/security/cacerts | awk '{print $1}')

if [ -n "$selinux_context" ] && [ "$selinux_context" != "?" ]; then
    chcon -R $selinux_context $MODDIR/system/etc/security/cacerts
else
    chcon -R $default_selinux_context $MODDIR/system/etc/security/cacerts
fi

rm $MODDIR/system/etc/security/cacerts/yayplaceholderyay

# put frida-server on device

case $ARCH in
    arm64) YayArchYay=$ARCH;;
    arm)   YayArchYay=$ARCH;;
    x64)   YayArchYay=x86_64;;
    x86)   YayArchYay=$ARCH;;
    *)     YayArchYay=yayunsupportedyay;;
esac

if [ $YayArchYay = "yayunsupportedyay" ]; then
    ui_print "[-] Unsupported architecture, Frida will not work"
    ui_print "[-] Manually download and run frida-server from https://github.com/frida/frida/releases"
else
    YayTargetDirYay="$MODPATH/system/bin"
    YayUnzipYay="/data/adb/magisk/busybox unzip"
    YayXzYay="/data/adb/magisk/busybox xz"

    mkdir -p "$YayTargetDirYay"
    $YayUnzipYay -qq -o "$ZIPFILE" "files/frida-server-$YayArchYay.xz" -j -d "$YayTargetDirYay"

    $YayXzYay -d "$YayTargetDirYay/frida-server-$YayArchYay.xz"

    mv "$YayTargetDirYay/frida-server-$YayArchYay" "$YayTargetDirYay/frida-server"
    
    set_perm $YayTargetDirYay/frida-server 0 2000 0755 u:object_r:system_file:s0
fi