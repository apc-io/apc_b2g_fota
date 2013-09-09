#!/bin/bash

if [[ ! -n "$B2G_HOME" ]]; then
  echo "Error: B2G_HOME must be set to run this script"
  exit 1
fi

SOURCE_BOOT_IMG=$B2G_HOME/out/target/product/wmid/boot.img
KEYDIR=$B2G_HOME/build/target/product/security
OTA_SUFFIX=$(date +%Y%m%d.%H%M)
OTA_ZIP=apc8950_b2g_ota_${OTA_SUFFIX}.zip

if [[ ! -f "$SOURCE_BOOT_IMG" ]]; then
  echo "Warning: no source found for boot.img, try to use local boot.img."
else
  rm -f boot.img
  ln "$SOURCE_BOOT_IMG" .
fi

if [[ ! -f "boot.img" ]]; then
  echo "Warning: boot.img not found, please place it in the top level directory and try again if you want a kernel update."
fi

rm update*.zip
zip -r update.zip META-INF system boot.img
java -Xmx2048m -jar signapk.jar -w $KEYDIR/testkey.x509.pem $KEYDIR/testkey.pk8 update.zip $OTA_ZIP

