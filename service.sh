# YayServiceScriptYay

MODDIR=${0%/*}

# wait for boot to complete
while [ "$(getprop sys.boot_completed)" != 1 ]; do
    sleep 1
done

# ensure boot has actually completed
sleep 5

# if android 34 or above, use new way to install custom root CAs
# credit: https://httptoolkit.com/blog/android-14-install-system-ca-certificate/
yayandroidversionyay=$(getprop ro.build.version.sdk)
if [ $yayandroidversionyay -gt 33 ]; then
    # create temp dir
    mkdir -p -m 700 /data/local/tmp/yaytmpcayay

    # copy system CAs
    cp -f /apex/com.android.conscrypt/cacerts/* /data/local/tmp/yaytmpcayay/

    # mount temp directory into memory
    mount -t tmpfs tmpfs /system/etc/security/cacerts

    # copy system CAs into old CA directory
    cp -f /data/local/tmp/yaytmpcayay/* /system/etc/security/cacerts/

    # copy user CAs into old CA directory
    cp -f /data/misc/user/0/cacerts-added/* /system/etc/security/cacerts/

    # update permissions
    chown root:root /system/etc/security/cacerts/*
    chmod 644 /system/etc/security/cacerts/*
    chcon u:object_r:system_file:s0 /system/etc/security/cacerts/*

    # get zygote processes
    ZYGOTE_PID=$(pidof zygote || true)
    ZYGOTE64_PID=$(pidof zygote64 || true)

    # mount old CA directory into newly spawned process from zygote
    for Z_PID in "$ZYGOTE_PID" "$ZYGOTE64_PID"; do
    if [ -n "$Z_PID" ]; then
        nsenter --mount=/proc/$Z_PID/ns/mnt -- \
            /bin/mount --bind /system/etc/security/cacerts /apex/com.android.conscrypt/cacerts
    fi
    done

    # mount old CA directory into all already running zygote processes
    APP_PIDS=$(
    echo "$ZYGOTE_PID $ZYGOTE64_PID" | \
    xargs -n1 ps -o 'PID' -P | \
    grep -v PID
    )
    for PID in $APP_PIDS; do
    nsenter --mount=/proc/$PID/ns/mnt -- \
        /bin/mount --bind /system/etc/security/cacerts /apex/com.android.conscrypt/cacerts &
    done
    wait # Launched in parallel - wait for completion here

    echo "yaydoneyay"
fi

# start frida server / restart on crash
while true; do
    frida-server
    sleep 1
done
