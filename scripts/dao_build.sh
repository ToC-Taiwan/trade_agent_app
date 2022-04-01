#!/bin/bash

rm ./lib/database.g.dart
flutter packages pub run build_runner build --delete-conflicting-outputs
