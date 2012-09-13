#!/bin/sh

if [[ ! -n "$B2G_HOME" ]]; then
  echo "Error: B2G_HOME must be set to run this script"
  exit 1
fi

if [[ ! -f "boot.img" ]]; then
  echo "Error: boot.img not found, please place it in the top level directory and try again"
  exit 1
fi

KEYDIR=$B2G_HOME/build/target/product/security

rm update*.zip
zip -r update.zip META-INF system boot.img
java -Xmx2048m -jar signapk.jar -w $KEYDIR/testkey.x509.pem $KEYDIR/testkey.pk8 update.zip update-signed.zip
adb -d push update-signed.zip /cache/update.zip
adb -d shell 'mkdir -p /cache/recovery; echo --update_package=/cache/update.zip > /cache/recovery/command'
adb -d reboot recovery
