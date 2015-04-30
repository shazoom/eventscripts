on quit_box()
	-- return true if action was taken, false otherwise
	if application "Box Sync" is running then
		tell application "Box Sync" to quit
		return true
	end if
	return false
end quit_box

on start_box()
	-- return true if action was taken, false otherwise
	if application "Box Sync" is not running then
		run application "Box Sync"
		return true
	end if
	return false
end start_box

on power_by_battery()
	quit_box()
	to_safari()
end power_by_battery

on power_by_mains()
	start_box()
	to_chrome()
end power_by_mains

on to_safari()
	set ctos_lib_filename to "chrome_to_safari.scpt"
	set ctos_lib to load script (POSIX path of ((path to me as text) & "::" & ctos_lib_filename))
	set browser to current_default_browser() of ctos_lib
	
	try
		if application "Google Chrome" is running then
			migrate_to_safari() of ctos_lib
		else if browser is "chrome" then
			try
				display dialog "Do you want to migrate tabs to Safari?"
				change_default_browser("Safari") of ctos_lib
			end try
		end if
	on error err_msg number err_num
		log err_msg & " " & err_num
	end try
end to_safari

on to_chrome()
	set ctos_lib_filename to "chrome_to_safari.scpt"
	set ctos_lib to load script (POSIX path of ((path to me as text) & "::" & ctos_lib_filename))
	set browser to current_default_browser() of ctos_lib
	
	try
		if application "Safari" is running then
			migrate_to_chrome() of ctos_lib
		else if browser is "safari" then
			try
				display dialog "Do you want to change default browser to Chrome?"
				change_default_browser("Chrome") of ctos_lib
			end try
		end if
	on error err_msg number err_num
		log err_msg & " " & err_num
	end try
end to_chrome

on wake()
	-- If mains power is available, connected will be "Yes", otherwise "No"
	set connected to (do shell script "/usr/sbin/system_profiler SPPowerDataType -detaillevel mini | grep Connected: | awk '{print $2}'")
	-- If connected, start box
	-- Else, if disconnected to charger, assume box may start in the near future, 
	-- then try to quit box, backing off longer each time until the timeout becomes too long.
	-- So, if Box Sync isn't running when the charger is unplugged the script will hang around 
	-- for just over a minute waiting to see if it was still to start up.
	if connected is "Yes" then
		to_chrome()
		start_box()
	else
		to_safari()
		set m_longest_wait to 32
		set m_timeout to 1
		repeat while (m_timeout ² m_longest_wait)
			delay (m_timeout)
			
			if quit_box() then
				exit repeat
			end if
			
			set m_timeout to m_timeout * 2
		end repeat
	end if
end wake