//
//  MeDetailViewController.h
//  RichPresence
//
//  Created by Jensen Wan on 3/29/15.
//  Copyright (c) 2015 Jensen Wan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
@interface MeDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end
