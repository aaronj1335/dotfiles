#! /bin/bash

plist_update='<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string>Chrome Internal URLs</string>
    <key>CFBundleURLSchemes</key>
    <array>
        <string>chrome</string>
    </array>
    </dict>
</array>
</plist>'
tmp_file="/tmp/chrom_plist_update.plist"

if ! echo "$plist_update" > $tmp_file; then
	echo "ERROR: couldn't write temp file to $tmp_file"
	exit 1
fi

/usr/libexec/PlistBuddy \
	-c "Merge '$tmp_file' :CFBundleURLTypes" \
	"/Applications/Google Chrome Canary.app/Contents/Info.plist"

/usr/libexec/PlistBuddy \
	-c "Merge '$tmp_file' :CFBundleURLTypes" \
	"/Applications/Google Chrome.app/Contents/Info.plist"

mv 	"/Applications/Google Chrome Canary.app" ~/Desktop/
mv 	"/Applications/Google Chrome.app" ~/Desktop/

sleep 2

mv 	~/Desktop/Google\ Chrome\ Canary.app /Applications/
mv 	~/Desktop/Google\ Chrome.app /Applications/
