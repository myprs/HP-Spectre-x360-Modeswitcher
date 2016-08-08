This software is for use on HP Spectre x360 convertible laptops. You can use the device as a laptop as you would expect, but also you can flip over your display and use it as a tablet. HP calls the two states Laptop-Mode and Tablet-Mode.

Ubuntu 10.15 already is partially aware of this. If you enter Tablet-Mode, the keyboard is deactivated and the keyboard lights are switched off. To get the Tablet-Mode really working it requires some more tasks:

1. crucial:
  * flip the screen upside down to use it like a book stand;
  * disable the keypad;
2. nice to have would be:
  * open up the soft-keyboard, maybe only when typing is required, or
  * change the button on the left side (close to the volume buttons) from doing an "ALT"-keypress to e.g. opening and closing the soft keyboard;
  * enlarge some elements on the desktop to improve the usability on the touch screen;
  * define buttons on the soft keyboard to change orientation oof the screen, depending on your prefered position ; 

Of course these changes have to be reverted when switching back.

This software contains mainly two parts: 

1. A boot script to register the keys that indicate flip activity and hook the events to script actions
2. A bash script including a little infrastructure which is run on the flipping events. It comes with the scripts to flip the screen and disable the keypad but you can hook your own scripts int it easily. 

As it turned out that detecting the flip turned more complicated under Ubuntu 16.04, I first did try to get the main functionality and the packaging done. Dropping the automatic call, which seemed to produce a number of calls to the scripts in  a row, I could neglect the code for Queueing the calls and keeping track of states. I also had some learning curve to go through and finaly found out that the right order of execution of the scripts is absolutely crucial, which made some scripst, still included in the package, obsolete. Maybe it's of some use to somebody.  


Useful links:

* https://wiki.ubuntu.com/Multitouch/TouchpadSupport 
* http://ccm.net/faq/35051-ubuntu-how-to-enable-the-on-screen-keyboard
* http://askubuntu.com/questions/563809/change-only-one-display-orientation-from-terminal
* http://wiki.ubuntuusers.de/Touchpad/#Mit-der-Hilfe-von-syndaemon
