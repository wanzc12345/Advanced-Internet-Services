//
//  MeDetailViewController.m
//  RichPresence
//
//  Created by Jensen Wan on 3/29/15.
//  Copyright (c) 2015 Jensen Wan. All rights reserved.
//

#import "MeDetailViewController.h"
#import "getSN.h"
//#import "getLocation.h"
//#import "GraphicsServices.h"
//#import <GraphicsServices/GraphicsServices.h>
#import <AVFoundation/AVAudioSession.h>

@interface MeDetailViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *lastnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstnameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *OsLabel;
@property (weak, nonatomic) IBOutlet UILabel *SNLabel;
@property (weak, nonatomic) IBOutlet UILabel *BatteryLabel;
//@property (weak, nonatomic) IBOutlet UILabel *VolumeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
//@property (weak, nonatomic) IBOutlet UILabel *AccLabel;
//@property (weak, nonatomic) IBOutlet UILabel *BrightnessLabel;
//@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *OsLabel;
@property (weak, nonatomic) IBOutlet UILabel *VolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *BrightnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *AccLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@end

@implementation MeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    //location
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    
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
    
    //load user info
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"currentuserid"];
    self.profileImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", uid]];
    NSError *error;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://aisdzt.elasticbeanstalk.com/get_user_info?userID=%@", uid]]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    self.firstnameLabel.text = [Dic objectForKey:@"firstName"];
    self.lastnameLabel.text = [Dic objectForKey:@"lastName"];
    self.addressLabel.text = [Dic objectForKey:@"homeAddress"];
    self.idLabel.text = uid;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

@end
