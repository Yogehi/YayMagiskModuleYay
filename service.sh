# YayServiceScriptYay

MODDIR=${0%/*}

# wait for boot to complete
while [ "$(getprop sys.boot_completed)" != 1 ]; do
    sleep 1
done

# ensure boot has actually completed
sleep 5

# start frida server / restart on crash
while true; do
    frida-server
    sleep 1
done
