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
#import <AVFoundation/AVAudioSession.h>

@interface DetailViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *OsLabel;
@property (weak, nonatomic) IBOutlet UILabel *SNLabel;
@property (weak, nonatomic) IBOutlet UILabel *BatteryLabel;
@property (weak, nonatomic) IBOutlet UILabel *VolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;

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
    
    float vol = [[AVAudioSession sharedInstance] outputVolume];
    NSString *volume = [NSString stringWithFormat:@"%f", vol];
    self.VolumeLabel.text = volume;
    
    
    
    
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
