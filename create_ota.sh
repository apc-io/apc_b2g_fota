#!/bin/bash

if [[ ! -n "$B2G_HOME" ]]; then
  echo "Error: B2G_HOME must be set to run this script"
  exit 1
fi

SOURCE_BOOT_IMG=$B2G_HOME/out/target/product/wmid/boot.img
SOURCE_BUILD_PROP=$B2G_HOME/out/target/product/wmid/system/build.prop
KEYDIR=$B2G_HOME/build/target/product/security
OTA_PREFIX=apc8950_b2g_ota
OTA_SUFFIX=$(date +%Y%m%d.%H%M)
OTA_ZIP=${OTA_PREFIX}_${OTA_SUFFIX}.zip

if [[ ! -f "$SOURCE_BOOT_IMG" ]]; then
  echo "Warning: no source found for boot.img, try to use local boot.img."
else
  rm -f boot.img
  ln "$SOURCE_BOOT_IMG" .
fi

if [[ ! -f "boot.img" ]]; then
  echo "Warning: boot.img not found, please place it in the top level directory and try again if you want a kernel update."
fi

rm -f update*.zip
rm -f ${OTA_PREFIX}_*.{zip,stat}

rm -f system/build.prop
mkdir -p system
ln "$SOURCE_BUILD_PROP" system

zip -r update.zip META-INF system boot.img
java -Xmx2048m -jar signapk.jar -w $KEYDIR/testkey.x509.pem $KEYDIR/testkey.pk8 update.zip $OTA_ZIP

# get needed info for update.xml
echo "Generating archive file stats ..."
HASH_FUNC="sha512"
HASH_CMD="$HASH_FUNC"sum
#echo "Generating $HASH_CMD for $OTA_ZIP ..."
HASH_VALUE=$($HASH_CMD $OTA_ZIP)
#echo "value is $HASH_VALUE"

#echo "Getting file size of $OTA_ZIP ..."
ARCHIVE_SIZE=$(stat -c%s $OTA_ZIP)
#echo "value is $ARCHIVE_SIZE"

STAT_FILE=${OTA_PREFIX}_${OTA_SUFFIX}.stat
echo "File name: $OTA_ZIP" > $STAT_FILE
echo "File size: $ARCHIVE_SIZE" >> $STAT_FILE
echo "Hash function: ${HASH_FUNC^^}" >> $STAT_FILE
echo "Hash value: ${HASH_VALUE}" >> $STAT_FILE

echo "Done, look $STAT_FILE for the stats"
