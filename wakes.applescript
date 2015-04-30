on run eventArgs
	set ev_lib_filename to "event_lib.scpt"
	set ev_lib to load script (POSIX path of ((path to me as text) & "::" & ev_lib_filename))
	
	set thisTrigger to (trigger of eventArgs)
	if thisTrigger is "EventScripts launched" or thisTrigger is "Computer wakes" then
		wake() of ev_lib
	end if
end run
