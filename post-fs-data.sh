# YayBootScriptYay

MODDIR=${0%/*}

# copy certificates from User Store to System Store

yayandroidversionyay=$(getprop ro.build.version.sdk)

if [ $yayandroidversionyay -lt 34 ]; then
    # android version is 33 or lower
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
fi

# put frida-server on device

ARCH=$(/data/adb/magisk/busybox arch)

case $ARCH in
    aarch64) YayArchYay=arm64;;
    aarch32)   YayArchYay=arm;;
    x64)   YayArchYay=x86_64;;
    x86)   YayArchYay=$ARCH;;
    *)     YayArchYay=yayunsupportedyay;;
esac

if [ $YayArchYay = "yayunsupportedyay" ]; then
    ui_print "[-] Unsupported architecture, Frida will not work"
    ui_print "[-] Manually download and run frida-server from https://github.com/frida/frida/releases"
else
    YayTargetDirYay="$MODDIR/system/bin"
    YayUnzipYay="/data/adb/magisk/busybox unzip"
    YayXzYay="/data/adb/magisk/busybox xz"

    cp -f $MODDIR/files/frida-server-$YayArchYay.xz "$YayTargetDirYay"

    $YayXzYay -d "$YayTargetDirYay/frida-server-$YayArchYay.xz"

    mv "$YayTargetDirYay/frida-server-$YayArchYay" "$YayTargetDirYay/frida-server"

    chown root.shell $YayTargetDirYay/frida-server
    chmod 755 $YayTargetDirYay/frida-server
    chcon u:object_r:system_file:s0 $YayTargetDirYay/frida-server
fi