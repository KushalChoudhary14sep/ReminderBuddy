#!/bin/bash
sh swiftgen_helper.sh
swiftgen
rm -rf ReminderBuddy.xcodeproj
rm -rf ReminderBuddy.xcworkspace
xcodegen
pod install
open -a Xcode ReminderBuddy.xcworkspace

