function mqtt_watcher
    if test (count $argv) -eq 0
        echo "Usage: mqtt_watcher SERIAL_NUMBER1 [SERIAL_NUMBER2 ...]"
        return 1
    end

    set topics
    for serial in $argv
        set -a topics -t "ticketer/device/sgw/$serial/service/watcher"
    end

    mosquitto_sub -v $topics | while read -l line
        set parts (string split -m 1 " " $line)
        set topic $parts[1]
        set message $parts[2]
        set serial (string match -r 'IVF[0-9]+' $topic)
        echo "$serial: $message"
    end
end
