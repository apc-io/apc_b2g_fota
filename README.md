fxos-fota
=========

A proof of concept for applying various partition images (FOTA) for Firefox OS.

Instructions
============

To try this proof of concept:

- export `B2G_HOME` to the B2G directory in your environment
- copy a valid boot.img for your device into the fxos-fota top level directory
- make sure your device is connected via USB and visible with `adb devices`
- finally, run `test_update.sh`

After the phone has rebooted and the update has applied, you should be able to
see /system/bin/itworks.txt, and the new boot.img should also be flashed.

Acknowledgements
================
META-INF/com/google/android/update-binary is built from AOSP in bootable/recovery/updater
signapk.jar is built from AOSP in build/tools/signapk
