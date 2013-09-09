#!/bin/bash

DOWNLOAD_DIR=/cache

OTA_ZIP=$(find -name b2g_apc8950_ota_*.zip)

if [[ ! -f "$OTA_ZIP" ]]; then
  echo "No ota package found, please run create_ota.sh first!"
  exit 1
fi

adb -d push "$OTA_ZIP" $DOWNLOAD_DIR/$OTA_ZIP &&
adb -d shell "mkdir -p /cache/recovery; echo --update_package=$DOWNLOAD_DIR/${OTA_ZIP} > /cache/recovery/command" &&
adb -d reboot recovery

