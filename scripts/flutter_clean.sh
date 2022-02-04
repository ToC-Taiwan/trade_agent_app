#!/bin/bash

flutter clean
flutter pub get

echo 'storePassword=asdf0000
keyPassword=asdf0000
keyAlias=upload
storeFile=/Users/timhsu/upload-keystore.jks' > ./android/key.properties

