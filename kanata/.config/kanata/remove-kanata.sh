#!/bin/bash
sudo launchctl stop com.azharaiz.kanata
sudo launchctl stop com.azharaiz.karabiner-vhiddaemon 
sudo launchctl stop com.azharaiz.karabiner-vhidmanager 

sudo rm /Library/LaunchDaemons/com.azharaiz.*.plist

sudo launchctl bootout system /Library/LaunchDaemons/com.azharaiz.karabiner-vhidmanager.plist /Library/LaunchDaemons/com.azharaiz.karabiner-vhiddaemon.plist /Library/LaunchDaemons/com.azharaiz.kanata.plist

