//
//  ofxCoreLocation.cpp
//  example
//
//  Created by Brett Renfer on 5/22/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <CoreWLAN/CoreWLAN.h>
#import <CoreLocation/CoreLocation.h>

#include "ofxCoreLocation.h"

@interface LocationGetter ()

@property (readwrite) ofxCoreLocation * ofObjectRef;

@end

@implementation LocationGetter

@synthesize ofObjectRef;
@synthesize manager;

-(id)init {
    self = [super init];
    if (self != nil) {
        self.manager = [[[CLLocationManager alloc] init] autorelease];
        self.manager.delegate = self; // send loc updates to myself
    }
    self.ofObjectRef = NULL;
    
    return self;
}

-(void)setup:(ofxCoreLocation*) ofRef{
    self.ofObjectRef = ofRef;
}

-(void)queryCurrentLocation {
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    self.manager.distanceFilter = kCLDistanceFilterNone;
    
    if (![CLLocationManager locationServicesEnabled]) {
        self.ofObjectRef->dispatchError("Location services are not enabled.");
        return;
    }
    else if (
             ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) ||
             ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)) {
        self.ofObjectRef->dispatchError("Location services are not authorized.");
        return;
    }
    else {
        [self.manager startUpdatingLocation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSTimeInterval ageInSeconds = -[newLocation.timestamp timeIntervalSinceNow];
    if (ageInSeconds > 60.0) return;   // Ignore data more than a minute old
    
    IFPrint(@"Latitude: %f", newLocation.coordinate.latitude);
    IFPrint(@"Longitude: %f", newLocation.coordinate.longitude);
    IFPrint(@"Accuracy (m): %f", newLocation.horizontalAccuracy);
    IFPrint(@"Timestamp: %@", [NSDateFormatter localizedStringFromDate:newLocation.timestamp dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterLongStyle]);
    
    [self.manager stopUpdatingLocation];
    
    Location loc;
    loc.latitude = newLocation.coordinate.latitude;
    loc.longitude = newLocation.coordinate.longitude;
    loc.accuracy = newLocation.horizontalAccuracy;
    loc.timestamp = [[NSDateFormatter localizedStringFromDate:newLocation.timestamp dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterLongStyle] UTF8String];
    
    self.ofObjectRef->disatchLocation(loc);
    
    // FIRE OF EVENT
}

-(BOOL)isWifiEnabled {
    CWInterface *wifi = [CWInterface interface];
    return wifi.powerOn;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.manager stopUpdatingLocation];
    if ([error code] == kCLErrorLocationUnknown) {
        if (![self isWifiEnabled])
            self.ofObjectRef->dispatchError("Wi-Fi is not enabled. Please enable it to gather location data.");
        else
            self.ofObjectRef->dispatchError("Location could not be determined right now. Try again later. Check if Wi-Fi is enabled.");
    }
    else if ([error code] == kCLErrorDenied) {
        self.ofObjectRef->dispatchError("Access to location services was denied. You may need to enable access in System Preferences.");
    }
    else {
        self.ofObjectRef->dispatchError("Error getting location data.");
        IFPrint(@"Error getting location data. %@", error);
    }
}

// NSLog replacement from http://stackoverflow.com/a/3487392/1376063
void IFPrint (NSString *format, ...) {
    va_list args;
    va_start(args, format);
    
    fputs([[[NSString alloc] initWithFormat:format arguments:args] UTF8String], stdout);
    fputs("\n", stdout);
    
    va_end(args);
}
@end

#pragma mark ofxCoreLocation

ofxCoreLocation::ofxCoreLocation(){
    locationGetter = [[LocationGetter alloc] init];
    [locationGetter setup:this];
}

ofxCoreLocation::~ofxCoreLocation(){
    [locationGetter dealloc];
}

void ofxCoreLocation::getLocation(){
    [locationGetter queryCurrentLocation];
}

void ofxCoreLocation::dispatchError( string error ){
    ofNotifyEvent(onError, error, this);
}
void ofxCoreLocation::disatchLocation( Location l ){
    ofNotifyEvent(onLocationRetrieved, l, this);
}
