# ofxCoreLocation
===
A simple example of using CoreLocation with openFrameworks on OS X

## Setting up
* Clone this addon into openFrameworks/addons
* Open the example project
* Turn on WiFi (crucial!)
* Run the app
* Say "Yes" to the dialog box
* Wow!

## Adding to a new app
* Add ofxCoreLocation into your Xcode project
* Make your app into an objective-C++ app: change main.cpp and ofApp.cpp to main.mm and ofApp.mm
	* Check in the sidebar that they're being compiled as Objective-C++
* Add CoreLocation and CoreWLAN to your project
	* System/Library/Frameworks/CoreLocation.framework
	* System/Library/Frameworks/CoreWLAN.framework

## Notes
* This is basically a mash-up of two nice examples:
	* http://mobileorchard.com/hello-there-a-corelocation-tutorial/
	* https://github.com/robmathers/WhereAmI
* Objective-C is not something I'm good at. Please let me know in issues or PRs where things can be improved!
* Tested with OS X 10.9, ostensibly should work 10.7+