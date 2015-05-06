//
//  ActivityViewController.h
//  RichPresence
//
//  Created by Jensen Wan on 5/5/15.
//  Copyright (c) 2015 Jensen Wan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "ViewDelegate.h"


@interface ActivityViewController : UIViewController <CLLocationManagerDelegate>

//{
//    NSObject<ViewDelegate> * delegate;
//    UITextField *_friendid;
//    UITextField *_row;
//}

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property(nonatomic) NSInteger flag;
//@property (weak, nonatomic) IBOutlet UIButton *jsonAnalizer;
//- (IBAction)jsonAnalizer:(id)sender;

@property NSString* fid;

//@property(nonatomic, retain)IBOutlet UITextField *friendid;
//@property(nonatomic, retain)IBOutlet UITextField *row;
//@property(nonatomic, retain) NSObject<ViewDelegate> * delegate;

@end
