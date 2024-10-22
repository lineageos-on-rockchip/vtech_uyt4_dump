#!/system/bin/sh

module_path_bcmdhd=/pcba/lib/modules/rkwifi/bcmdhd/bcmdhd.ko
module_path_8188eu=/pcba/lib/modules/rtl8188eu/8188eu.ko
module_path_8723bu=/pcba/lib/modules/rtl8723bu/8723bu.ko
module_path_8723bs=/pcba/lib/modules/rtl8723bs/8723bs.ko
module_path_8723cs=/pcba/lib/modules/rtl8723cs/8723cs.ko
module_path_8723ds=/pcba/lib/modules/rtl8723ds/8723ds.ko
module_path_8188fu=/pcba/lib/modules/rtl8188fu/8188fu.ko
module_path_8822bs=/pcba/lib/modules/rtl8822bs/8822bs.ko
module_path_8189es=/pcba/lib/modules/rtl8189es/8189es.ko
module_path_8189fs=/pcba/lib/modules/rtl8189fs/8189fs.ko
module_path_atbm6011b=/pcba/lib/modules/atbm6011b/hal_apollo/atbm6011b.ko
result_file=/data/scan_result.txt
result_file2=/data/scan_result2.txt
chip_type_path=/data/wifi_chip
driver_node=/sys/class/rkwifi/driver
pcba_node=/sys/class/rkwifi/pcba
version_path=/proc/version
module_path=$module_path_wlan
chip_broadcom=false
driver_buildin=false
interface_up=true
version=.3.0.36+
mt5931_kitkat=false
android_kitkat=false

jmax=3

if busybox cat $chip_type_path | busybox grep AP; then
  module_path=$module_path_bcmdhd
  chip_broadcom=true
  echo 1 > $pcba_node
fi
if busybox cat $chip_type_path | busybox grep ATBM6011B; then
  jmax=6
  module_path=$module_path_atbm6011b
fi

if busybox cat $chip_type_path | busybox grep RTL8188EU; then
  jmax=6
  module_path=$module_path_8188eu
fi

if busybox cat $chip_type_path | busybox grep RTL8723AU; then
  module_path=$module_path_8723bu
fi

if busybox cat $chip_type_path | busybox grep RTL8723BS; then
  module_path=$module_path_8723bs
fi

if busybox cat $chip_type_path | busybox grep RTL8723CS; then
  module_path=$module_path_8723cs
fi

if busybox cat $chip_type_path | busybox grep RTL8723DS; then
  module_path=$module_path_8723ds
fi

if busybox cat $chip_type_path | busybox grep RTL8188FU; then
  jmax=6
  module_path=$module_path_8188fu
fi

if busybox cat $chip_type_path | busybox grep RTL8822BS; then
  module_path=$module_path_8822bs
fi

if busybox cat $chip_type_path | busybox grep RTL8189ES; then
  module_path=$module_path_8189es
fi

if busybox cat $chip_type_path | busybox grep RTL8189FS; then
  module_path=$module_path_8189fs
fi

if busybox cat $version_path | busybox grep 3.0.36+; then
  echo "kernel version 3.0.36+"
  if [ -e $module_path$version ]; then
    module_path=$module_path$version
  fi
fi

if busybox ls /dev/wmtWifi | busybox grep wmtWifi; then
  echo "mt5931_kitkat=true"
  mt5931_kitkat=true
fi

if busybox ifconfig wlan0; then
  echo "android_kitkat=true"
  android_kitkat=true
fi

#if busybox ls $driver_node; then
#  echo "wifi driver is buildin"
#  driver_buildin=true
#fi

echo "touch $result_file"
touch $result_file

j=0

echo "get scan results"
while [ $j -lt $jmax ]; 
do
    echo "insmod wifi driver"
    if [ $mt5931_kitkat = "true" ]; then
        echo "echo 1 > /dev/wmtWifi"
        echo 1 > /dev/wmtWifi
    else
      if [ $android_kitkat = "false" ]; then
        if [ $driver_buildin = "true" ]; then
          echo "echo 1 > $driver_node"
          echo 1 > "$driver_node"
        else
          echo "insmod $module_path"
          insmod "$module_path"
        fi
      fi
    fi
    if [ $? -ne 0 ]; then
        echo "insmod failed"
        exit 0
    fi

    echo "sleep 3s"
    busybox sleep 3

    if busybox ifconfig wlan0; then
        if [ $interface_up = "true" ]; then
            busybox ifconfig wlan0 up
        fi
        #if [ $? -ne 0 ]; then
        #    echo "ifconfig wlan0 up failed"
        #    exit 0
        #fi
    
        iwlist wlan0 scanning > $result_file
        if [ $chip_broadcom = "true" ]; then
            echo "sleep 3s"
            busybox sleep 3    
        fi
        iwlist wlan0 scanning last | busybox grep SSID > $result_file
        busybox cat $result_file
        iwlist wlan0 scanning last | busybox grep "Signal level" > $result_file2
        busybox cat $result_file2
        echo "success"
        exit 1
    fi

    echo "remove wifi driver"
    if [ $mt5931_kitkat = "true" ]; then
        echo "echo 0 > /dev/wmtWifi"
        echo 0 > /dev/wmtWifi
    else
      if [ $android_kitkat = "false" ]; then
        if [ $driver_buildin = "true" ]; then
          echo "echo 0 > $driver_node"
          echo 0 > "$driver_node"
        else
          echo "rmmod wlan"
          rmmod wlan
        fi
      fi
    fi
    busybox sleep 1
    
    j=$((j+1))
done

echo "wlan test failed"
exit 0


