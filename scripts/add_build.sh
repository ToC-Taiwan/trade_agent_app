#!/bin/zsh

./scripts/new_build.py

mv temp_pubspec.yaml pubspec.yaml

flutter clean
flutter pub get
