#!/bin/bash

if [[ ! -n "$B2G_HOME" ]]; then
  echo "Error: B2G_HOME must be set to run this script"
  exit 1
fi

(adb shell vdc volume list | grep '110 sdcard .* 4') > /dev/null || \
  (echo "Error: /sdcard must be mounted"; exit 1)

if [[ ! -f "boot.img" ]]; then
  echo "Warning: boot.img not found, please place it in the top level directory and try again if you want a kernel update."
fi

KEYDIR=$B2G_HOME/build/target/product/security
DOWNLOAD_DIR=/sdcard

rm update*.zip
zip -r update.zip META-INF system boot.img
java -Xmx2048m -jar signapk.jar -w $KEYDIR/testkey.x509.pem $KEYDIR/testkey.pk8 update.zip update-signed.zip
adb -d push update-signed.zip $DOWNLOAD_DIR/update.zip
adb -d shell "mkdir -p /cache/recovery; echo --update_package=$DOWNLOAD_DIR/update.zip > /cache/recovery/command"
adb -d reboot recovery
