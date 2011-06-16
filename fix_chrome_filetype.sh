#! /bin/bash

browsa="/Applications/Google Chrome.app"

USAGE="USAGE: `basename $0` [-hv] [-o opt] <arg1> <arg2>

Add 'chrome:newtab' to the list of acceptable file types for Chrome

Options:
	-b	Set the browsa path (like /Applications/Opera.app)
	-c	Use Google Chrome Canary
	-h	Show this help message"

# Parse command line options.
while getopts hbc: OPT; do
	case "$OPT" in
		h)
			echo "$USAGE"
			exit 0
			;;
		b)
			if [ ! -d "$OPTARG" ]; then
				echo "ERROR: couldn't find $OPTARG" 1>&2
				echo "$USAGE" 1>&2
				exit 1
			fi
			browsa=$OPTARG
			;;
		c)
			browsa="/Applications/Google Chrome Canary.app"
			;;
		\?)
			# getopts issues an error message
			echo "$USAGE" >&2
			exit 1
			;;
	esac
done

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
	"$browsa/Contents/Info.plist"

