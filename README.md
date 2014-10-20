DBSmartPanels
=============

About
-----

DBSmartPanels is a simple panel manager plugin for Xcode 6 which optimizes screen real estate usage by making common sense decisions on handling what's displayed in the editor window based on what you're currently doing. The point of this plugin is to get everything out of the way so you can focus only on what you need.

There are currently 3 events that the plugin is concerned with, and multiple behavior tweaks for each:
* When you begin typing in a text document
    * Hide debugger: hides the bottom panel
    * Hide utilities: hides the right-hand panel
* When you open a text document
    * Restore editor mode: if applicable, switches you back to whichever editor mode you were in (Standard, Assistant, or Version Editor) before you opened an interface file
    * Restore debugger state: if applicable, un-hides the debugger if it was visible before you opened an interface file
    * Hide utilities: hides the right-hand panel
* When you open an interface file (XIB or Storyboard)
    * Switch to standard editor: the Assistant Editor takes up valuable screen real estate, so hide it
    * Hide debugger: hides the bottom panel
    * Show utilities: shows the right-hand panel, since you generally tweak values in here when dealing with UI elements

Configuration
-------------

Since one size does not necessarily fit all, the plugin installs a new option in the Xcode menu:
<img src="https://www.dropbox.com/s/hwx5rijy1vuh04t/Smart%20Panels%20Menu%20Item.png?dl=0" />

From there, you can tweak the behavior to whatever works best for you:
<img src="https://www.dropbox.com/s/xkrpv5s3ahyr3qd/Smart%20Panels%20Preferences.png?dl=0" />

Installation
------------

I'll be submitting this plugin to Alcatraz for easy installation and will update these instructions if/when it's approved.

In the meantime, if you'd like to install manually, you can do so by following these steps:
1. Clone this repository.
2. Open and run the project.

That's it! When you run the project, it should start up a second instance of Xcode with the plugin installed. Try it out, and please let me know what you think.

Feedback
--------

Everybody has a different workflow in Xcode. If you run into problems with this plugin, please let me know and I'll be happy to take a look to see if I can make it work better for you. Alternatively, if you have ideas on how to improve the plugin, that feedback is welcome as well. You can email me at davidblundelldev at Gmail.

Thanks
------

I'd like to give a HUGE thanks to the folks behind <a href="http://alcatraz.io">Alcatraz</a>, an amazing plugin manager for Xcode, and all the plugin developers who have made my daily development work easier and less frustrating. More specifically however, I'd like to thank Boris Bügling, whose instructional video taught me how to write plugins, and whose BBUDebuggerTuckAway plugin I used as a starting-off point for this project.

If you're interested in writing your own plugins, see this <a href="http://alcatraz.io/blog/writing-plugins/">blog post</a> for more info, including the aforementioned videos from Boris.
