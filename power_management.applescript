on run eventArgs
	set ev_lib_filename to "event_lib.scpt"
	set ev_lib to load script (POSIX path of ((path to me as text) & "::" & ev_lib_filename))
	
	set thisTrigger to (trigger of eventArgs)
	
	if thisTrigger is "Power switched to battery" then
		power_by_battery() of ev_lib
		
	else if thisTrigger is "Power switched to mains" then
		power_by_mains() of ev_lib
		
	end if
end run