#include "ofApp.h"

string toDraw = "";
ofPoint gpsPoint;
Location currentLocation;

//--------------------------------------------------------------
void ofApp::setup(){
    ofBackground(0);
    ofAddListener(locationGetter.onLocationRetrieved, this, &ofApp::onLocation);
    ofAddListener(locationGetter.onError, this, &ofApp::onError);
    
    locationGetter.getLocation();
    toDraw = "Searching for location...";
    earth.loadImage("earth.jpg");
    
    float s = (float) ofGetWidth() / earth.width;
    ofSetWindowShape(earth.width * s, earth.height * s);
}

//--------------------------------------------------------------
void ofApp::update(){

}

//--------------------------------------------------------------
void ofApp::onLocation( Location & loc ){
    toDraw = "Latitude: " + ofToString(loc.latitude);
    toDraw += "\nLongitude: " + ofToString(loc.longitude);
    toDraw += "\nAccuracy (m): " + ofToString(loc.accuracy);
    toDraw += "\nTimestamp: " + ofToString(loc.timestamp);
    
    currentLocation = loc;
}

//--------------------------------------------------------------
void ofApp::onError( string & event ){
    toDraw = "Error "+event;
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofPushMatrix();
    float s = (float) ofGetWidth() / earth.width;
    ofScale(s,s);
    earth.draw(0,0);
    
    float x = ofMap(currentLocation.longitude, -180, 180, 0, earth.width);
    float y = ofMap(currentLocation.latitude, 90, -90, 0, earth.height);
    
    ofSetColor(0, 255, 0);
    ofCircle(x, y, 5);
    
    float rate = ofWrap( ofGetElapsedTimeMillis() * .001, 0.0, 1.0);
    float rad = rate * 50;
    
    if ( rate > 0 ){
        ofSetColor(255, 255 - rate * 255);
        ofCircle(x, y, rad);
    }
    
    ofPopMatrix();
    ofSetColor(255);
    ofDrawBitmapString(toDraw, 20,20);
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
    if ( key == 's' ){
        toDraw = "Searching for location...";
        locationGetter.getLocation();
    }
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
