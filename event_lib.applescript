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

on wake()
	-- If mains power is available, connected will be "Yes", otherwise "No"
	set connected to (do shell script "/usr/sbin/system_profiler SPPowerDataType -detaillevel mini | grep Connected: | awk '{print $2}'")
	-- If connected, start box
	-- Else, if disconnected to charger, assume box may start in the near future, 
	-- then try to quit box, backing off longer each time until the timeout becomes too long.
	if connected is "Yes" then
		start_box()
	else
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
