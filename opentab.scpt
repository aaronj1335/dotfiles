#!/usr/bin/osascript

--tell application "Google Chrome"
tell application "Google Chrome Canary"
	activate
end tell

tell application "System Events"
	tell process "Google Chrome Canary"
		tell menu bar 1
			tell menu bar item "File"
				tell menu "File"
					click menu item "New Tab"
				end tell
			end tell
		end tell
	end tell
end tell

