//
//  AppDelegate.h
//  RichPresence
//
//  Created by Jensen Wan on 2/22/15.
//  Copyright (c) 2015 Jensen Wan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "getSN.h"
#import <AVFoundation/AVAudioSession.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property CLLocationManager* locationManager;
@property BOOL login;

@property (strong, nonatomic) id detailItem;
@property (nonatomic, strong) CMMotionManager *motionManager;


@property NSString* deviceName;
@property NSString* phoneVersion;
@property NSString* sn;
@property NSString* batLevel;
@property NSString* volume;
@property NSString* accX;
@property NSString* accY;
@property NSString* accZ;
@property NSString* brs;
@property NSString* firstName;
@property NSString* lastName;
@property NSString* add;
@property NSString* userId;
@property NSString* latitude;
@property NSString* longitude;
@property NSString* timestamp;

@end

