do shell script "eval \"$(/opt/homebrew/bin/brew shellenv)\"" & ";brew --version"

tell application "Tinderbox 10"
	activate
end tell

tell application "System Events"
	tell process "Tinderbox 10"
		tell menu bar 1
			pick menu item 26 of menu 1 of menu bar item 3
		end tell
		
		delay 1
		tell window 1
			click button "Export"
			delay 1.5
			if exists sheets then
				tell sheet 1
					click button "Replace"
				end tell
			end if
		end tell
		tell menu bar 1
			tell menu 8
				tell menu item 7
					tell menu 1
						pick menu item 3
					end tell
				end tell
			end tell
		end tell
	end tell
end tell

