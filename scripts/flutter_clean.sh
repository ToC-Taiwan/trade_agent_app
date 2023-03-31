#!/bin/bash

flutter clean
flutter pub get

echo 'storePassword=2@ZdP-V&Z7xNBwc!wdNDSquH' >./android/key.properties
echo 'keyPassword=2@ZdP-V&Z7xNBwc!wdNDSquH' >>./android/key.properties
echo 'keyAlias=play_console_upload' >>./android/key.properties
echo "storeFile=$HOME/android_key/upload-keystore.jks" >>./android/key.properties

# genky path: /Applications/Android Studio.app/Contents/jre/Contents/Home/bin
# ./keytool -genkey -v -keystore /Users/timhsu/dev_projects/key/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias play_console_upload
