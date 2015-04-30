on get_defaultbrowser_path()
	-- You will need to do something here, probably install and build this using Xcode, then put the binary
	-- somewhere and alter the path below to reflect where you put it.
	-- The sourcecode can be found here: https://github.com/kerma/defaultbrowser
	
	-- Setting for path to defaultbrowser (globals don't work when scripts are loaded, it seems)
	return POSIX path of ((path to home folder as text) & "bin:defaultbrowser")
end get_defaultbrowser_path

on to_safari()
	set m_urls to {}
	
	if application "Google Chrome" is running then
		tell application "Google Chrome"
			
			repeat with m_window in every window
				repeat with m_tab in every tab of m_window
					ignoring case
						if URL of m_tab starts with "http" then
							set end of m_urls to URL of m_tab
						end if
					end ignoring
				end repeat
			end repeat
			
		end tell
		
		if length of m_urls > 0 then
			-- The applescript API for Safari really, really sucks. Most of the calls are non-blocking and fail if the thing we want is missing. 
			-- So, ensuring that only HTTP tabs are opened is really, really difficult and ultimately not worth the complexity. It is possible 
			-- to work around this by using a repeat look to keep asking for the value until it becomes available but it is just way, way to 
			-- complex for the pay-off.
			tell application "Safari"
				activate
				repeat with m_url in m_urls
					tell front window to make new tab with properties {URL:m_url}
				end repeat
			end tell
		end if
	end if
end to_safari

on to_chrome()
	if application "Safari" is running then
		set m_urls to {}
		tell application "Safari"
			try
				repeat with m_window in every window
					try
						repeat with m_tab in every tab of m_window
							try
								set m_url to URL of m_tab
								ignoring case
									if m_url starts with "http" then
										set end of m_urls to m_url
									end if
								end ignoring
							on error err_msg number err_num
								if err_num ­ -2753 then -- not defined.
									log "Rerasing: " & err_msg & " " & err_msg
									error err_msg number err_num
								end if
							end try
						end repeat
					on error err_msg number err_num
						if err_num ­ -1728 then -- errAENoSuchObject
							log "Rerasing: " & err_msg & " " & err_num
							error err_msg number err_num
						end if
					end try
				end repeat
			on error err_msg number err_num
				if err_num is not -1728 then -- errAENoSuchObject
					log "Rerasing: " & err_msg & " " & err_num
					error err_msg number err_num
				end if
			end try
		end tell
	end if
	
	if length of m_urls > 0 then
		tell application "Google Chrome"
			activate
			
			repeat with m_url in m_urls
				ignoring case
					if URL of front tab of front window starts with "http" then
						tell front window
							make new tab
						end tell
					end if
					set URL of active tab of window 1 to m_url
				end ignoring
			end repeat
			
		end tell
	end if
end to_chrome

on change_default_browser(browser)
	set m_path to get_defaultbrowser_path()
	set shell_cmd to (m_path & " -set " & browser)
	do shell script shell_cmd
end change_default_browser

on current_default_browser()
	set m_path to get_defaultbrowser_path()
	set shell_cmd to (m_path & " | grep Current: | awk '{print $2}'")
	set current to (do shell script shell_cmd)
	return current
end current_default_browser

on migrate_to_chrome()
	display dialog "Do you want to migrate tabs to Chrome?"
	change_default_browser("Chrome")
	tell application "System Events"
		delay 0.5
		keystroke tab
		keystroke space
		delay 1
	end tell
	to_chrome()
	--display dialog "Do you want to quit Safari?"
	tell application "Safari" to quit
end migrate_to_chrome

on migrate_to_safari()
	display dialog "Do you want to migrate tabs to Safari?"
	change_default_browser("Safari")
	tell application "System Events"
		delay 0.5
		keystroke tab
		keystroke space
		delay 1
	end tell
	to_safari()
	-- display dialog "Do you want to quit Chrome?"
	tell application "Google Chrome" to quit
end migrate_to_safari