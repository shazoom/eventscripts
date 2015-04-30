This project provides two features which are designed to preserve your MacBook's battery: stop/start Box Sync and migrate tabs between Chrome and Safari based if battery is powering the computer. It is designed to work with EventScripts but you could call the handlers in event_lib from anything. Only tabs with a URL using the HTTP protocol will be migrated to avoid topsite:// and chrome://. Perhaps processing other protocols, such as ftp:// and file:// makes sense; I haven't implemented that.

These are new scripts so I expect there are still some bugs but at the very least I'm sure somebody else will find them useful examples of working with Safari and Chrome. I would also like to mention that Safari really sucks for scripting. Most of its API seems to be non-blocking and will throw and error if it is not yet ready and I cannot see a way to test when it is ready. This means launching and manipulating Safari's windows, tabs and documents will fail unless, and at least, a delay is included before querying each thing you create or even objects one didn't create; really sucks hard.

In order to use these scripts you will need to compile them; open them with *Script Editor* and *File->Export* them with *File Format* set to *script*. To use them with EventScripts they should be put in *~/Library/Application Scipts/net.mousedown.EventScripts*.

The handler in the script *chrome_to_safari* called *get_defaultbrowser_path()* should probably be modified. It is used to provide the path to a binary program which can set and query the default browser. It compiled without problems for me but you will need Xcode installed for this. It can be downloaded [here.] (https://github.com/kerma/defaultbrowser)If you want to change the behaviour of these scripts a good place to look is *migrate_to_chrome()* or migrate_to_safari() which are both in the script *chrome_to_safari*.  Here you could comment or uncomment dialogs to check if you want to:
 
1. do a tab migration
2. change default browser
3. quit the old browser after the migration

You could also disable some behaviour:

1. changing the default browser
2. automatically confirm the change
3. quitting the old browser

There is no configuration section of this, just edit the code as you desire. 
 