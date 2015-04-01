//
//  DetailViewController.h
//  RichPresence
//
//  Created by Jensen Wan on 2/22/15.
//  Copyright (c) 2015 Jensen Wan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface DetailViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CMMotionManager *motionManager;
//@property (weak, nonatomic) IBOutlet UIButton *jsonAnalizer;
//- (IBAction)jsonAnalizer:(id)sender;

@end
