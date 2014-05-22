//
//  ofxCoreLocation.h
//  A bare-bones example of how to use CoreLocation on OS X with openFrameworks
//
//  Created by Brett Renfer on 5/22/14.
//
//  SETUP
//  - add addon
//  - add CoreLocation framework to your project
//  (System/Library/Frameworks/CoreLocation.framework on Mavericks)

#pragma once

#import <CoreLocation/CoreLocation.h>
#include "ofMain.h"

/** */
class ofxCoreLocation;

@interface LocationGetter : NSObject <CLLocationManagerDelegate> {
    ofxCoreLocation * ofObjectRef;
    CLLocationManager *manager;
}

@property (nonatomic, retain) CLLocationManager *manager;

-(void)queryCurrentLocation;

@end

struct Location {
    double latitude;
    double longitude;
    double accuracy;
    string timestamp;
};

/** */
class ofxCoreLocation
{
public:
    
    ofxCoreLocation();
    ~ofxCoreLocation();
    
    // begins search; fires event when it gets something (or an error)
    void getLocation();
    
    ofEvent<Location> onLocationRetrieved;
    ofEvent<string> onError;
    
    // these are just called by the obj-c friend
    void dispatchError( string error );
    void disatchLocation( Location l );
    
protected:
    
    LocationGetter * locationGetter;
};

