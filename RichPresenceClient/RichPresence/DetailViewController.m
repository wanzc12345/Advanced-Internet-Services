//
//  DetailViewController.m
//  RichPresence
//
//  Created by Jensen Wan on 2/22/15.
//  Copyright (c) 2015 Jensen Wan. All rights reserved.
//

#import "DetailViewController.h"
#import "getSN.h"
//#import "getLocation.h"
//#import "GraphicsServices.h"
//#import <GraphicsServices/GraphicsServices.h>
#import <AVFoundation/AVAudioSession.h>
#import <MediaPlayer/MediaPlayer.h>

@interface DetailViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *OsLabel;
@property (weak, nonatomic) IBOutlet UILabel *SNLabel;
@property (weak, nonatomic) IBOutlet UILabel *BatteryLabel;
@property (weak, nonatomic) IBOutlet UILabel *VolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *AccLabel;
@property (weak, nonatomic) IBOutlet UILabel *BrightnessLabel;

//@property (weak, nonatomic) IBOutlet UIButton *jsonAnalizer;
//@property (weak, nonatomic) IBOutlet UIButton *jsonAnalizer;

@end

@implementation DetailViewController


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
        //location
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
        
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    NSString *latitudeValue, *longtitudeValue;
    latitudeValue = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
    longtitudeValue = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
    self.LocationLabel.text = [latitudeValue stringByAppendingString:longtitudeValue];
}


- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    NSString* deviceName = [[UIDevice currentDevice] systemName];
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    self.OsLabel.text = [deviceName stringByAppendingString:phoneVersion];
    NSString* sn = [[UIDevice currentDevice] serialNumber];
    self.SNLabel.text = sn;
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    double batLeft = (float)[myDevice batteryLevel];
    NSString *batLevel = [NSString stringWithFormat:@"%f", batLeft];
    self.BatteryLabel.text = batLevel;
    
    float vol = [[MPMusicPlayerController applicationMusicPlayer] volume];
    NSString *volume = [NSString stringWithFormat:@"%f", vol];
    self.VolumeLabel.text = volume;
    
    // current time since 1970
    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];

    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 1;
    //self.motionManager.delegate = self;
    
    if ([self.motionManager isAccelerometerAvailable])
    {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *x, *y, *z;
                x = [NSString stringWithFormat:@"%.2f",accelerometerData.acceleration.x];
                y = [NSString stringWithFormat:@"%.2f",accelerometerData.acceleration.y];
                z = [NSString stringWithFormat:@"%.2f",accelerometerData.acceleration.z];
                self.AccLabel.text = [x stringByAppendingString: y];
                self.AccLabel.text = [self.AccLabel.text stringByAppendingString: z];
                
            });
        }];
    } else
        NSLog(@"not active");
    
    double br = [[UIScreen mainScreen] brightness];
    NSString *brs = [NSString stringWithFormat:@"%.2f", br];
    self.BrightnessLabel.text = brs;

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@synthesize delegate;
@synthesize value = _value;




@end
