DBSmartPanels
=============

About
-----

DBSmartPanels is a simple panel manager plugin for Xcode 6 which optimizes screen real estate by making common sense decisions on handling what's displayed in the editor window based on what you're currently doing. The point of this plugin is to get everything out of the way so you can focus only on what you need.

There are currently 3 events with which the plugin is concerned, with multiple behavior tweaks for each:
* <b>When you begin typing in a text document...</b>
    * <i>Hide debugger</i>: hides the bottom panel
    * <i>Hide utilities</i>: hides the right-hand panel
* <b>When you open a text document...</b>
    * <i>Restore editor mode</i>: if applicable, switches you back to whichever editor mode you were in (Standard, Assistant, or Version Editor) before you opened an interface file
    * <i>Restore debugger state</i>: if applicable, un-hides the debugger if it was visible before you opened an interface file
    * <i>Hide utilities</i>: hides the right-hand panel
* <b>When you open an interface file...</b> (XIB or Storyboard)
    * <i>Switch to standard editor</i>: the Assistant Editor takes up valuable screen real estate, so hide it
    * <i>Hide debugger</i>: hides the bottom panel
    * <i>Show utilities</i>: shows the right-hand panel, since you generally tweak values in here when dealing with UI elements

Configuration
-------------

Since one size does not necessarily fit all, the plugin installs a new option in the Xcode menu, from which you can tweak the behavior to whatever works best for you:

<img src="https://raw.githubusercontent.com/chaingarden/DBSmartPanels/master/Screenshots/DemoScreenshot.png" />

Installation
------------

The easiest way to install is via <a href="http://alcatraz.io">Alcatraz</a>. Once installed, restart Xcode.

Alternatively, you can install manually by following these steps:

1. Clone this repository.
2. Open and run the project.
3. Restart Xcode.

Feedback
--------

Everybody has a different workflow in Xcode. If you run into problems with this plugin, please let me know; I'll be happy to take a look to see if I can make it work better for you. Alternatively, if you have ideas on how to improve the plugin, that feedback is welcome as well. You can email me at davidblundelldev at Gmail.

Thanks
------

I'd like to give a HUGE thanks to the folks behind <a href="http://alcatraz.io">Alcatraz</a>, an amazing plugin manager for Xcode, and all the plugin developers who have made my daily development work easier and less frustrating.

More specifically however, I'd like to thank <a href="https://github.com/neonichu">Boris Bügling</a>, whose instructional video taught me how to write plugins, and whose <a href="https://github.com/neonichu/BBUDebuggerTuckAway">BBUDebuggerTuckAway plugin</a> I used as a starting-off point for this project.

If you're interested in writing your own plugins, see this <a href="http://alcatraz.io/blog/writing-plugins/">blog post</a> for more info, including the aforementioned videos from Boris.

Happy coding!
