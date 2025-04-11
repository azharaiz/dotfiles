#!/bin/bash
sudo cp -n com.azharaiz.*.plist /Library/LaunchDaemons

sudo launchctl bootstrap system /Library/LaunchDaemons/com.azharaiz.karabiner-vhidmanager.plist /Library/LaunchDaemons/com.azharaiz.karabiner-vhiddaemon.plist /Library/LaunchDaemons/com.azharaiz.kanata.plist

sudo launchctl start com.azharaiz.karabiner-vhidmanager 
sudo launchctl start com.azharaiz.karabiner-vhiddaemon 
sudo launchctl start com.azharaiz.kanata
