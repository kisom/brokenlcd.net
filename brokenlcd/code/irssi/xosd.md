xosd-notify.pl
--------------

**xosd-notify:** irssi script to display hilights and PMs via xosd    
**author:** kyle isom <coder@kyleisom.net>    
**license:** isc / public domain - select whichever is less restrictive in your
locale     

dependencies:
* libxosd2
* libxosd-dev
* X::Osd

usage:
* `/load /path/to/xosd-notify.pl`    
* it is now loaded; you can play with the settings to find a font you like

commands (enter using /xosd): 
* enable: enable on-screen display
* disable: disable on-screen display
* reconfigure: require to reload settings after changing them
* test: puts a test message on the screen for verifying settings
* load_settings <config file>: load settings from the config file. if no 
config file is specified, loads from ~/.irssi/.xosd-notifyrc
* save_settings <config file>: save settings to the config file. if no
config file is specified, saves to ~/.irssi/.xosd-notifyrc
* clear: clear screen

example commands: 
    /xosd clear
    /xosd save ~/.xosdrc

the current settings may be viewed using `/set xosd_*`

**setting the position**:
* the current position is controlled by `xosd_position`
* the script checks the beginning of the setting string to get the vertical
position, and the end of the setting string to get the horizontal position
* vertical values may be: top, middle, center, bottom
* horizontal values may be: left, middle, center, right
* for example: `/set xosd_position $position`, valid `$position` values 
include:
0. `top_center`
1. `bottom-left`
2. `center-right`
3. `center`


**screenshot:**    

![screenshot: xosd-notify.pl](/images/screenshots/irssi-xosd_small.png)    
[larger version](/images/screenshots/irssi-xosd.png)

