//
//  ActivityViewController.m
//  RichPresence
//
//  Created by Jensen Wan on 5/5/15.
//  Copyright (c) 2015 Jensen Wan. All rights reserved.
//

#import "ActivityViewController.h"
#import "DetailViewController.h"
#import "getSN.h"
//#import "getLocation.h"
//#import "GraphicsServices.h"
//#import <GraphicsServices/GraphicsServices.h>
#import <AVFoundation/AVAudioSession.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ActivityViewController ()  <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *OsLabel;
@property (weak, nonatomic) IBOutlet UILabel *SpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *VolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *BrightnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *AccLabel;
@property (weak, nonatomic) IBOutlet UILabel *SNLabel;
@property (weak, nonatomic) IBOutlet UILabel *BatteryLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;



@end

@implementation ActivityViewController


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
    // Do any additional setup after loading the view.
    
    [self configureView];

    

    self.NameLabel.text = self.fid;
    

    NSError *error;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://aisdzt.elasticbeanstalk.com/get_user_info?userID=%@", self.fid]]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];

    NSString* temp1 = [Dic objectForKey:@"OSType"];
    NSString* temp2 = [Dic objectForKey:@"OSVersion"];
    NSString* temp3;
    self.OsLabel.text = [temp1 stringByAppendingString:temp2];
    self.VolumeLabel.text = [Dic objectForKey:@"volume"];
    self.BrightnessLabel.text = [Dic objectForKey:@"brightness"];
    
    temp1 = [Dic objectForKey:@"xAcc"];
    temp2 = [Dic objectForKey:@"yAcc"];
    temp3 = [Dic objectForKey:@"zAcc"];
    self.AccLabel.text = [[temp1 stringByAppendingString:temp2] stringByAppendingString:temp3];
    self.SNLabel.text = [Dic objectForKey:@"serialNumber"];
    self.BatteryLabel.text = [Dic objectForKey:@"batteryLevel"];
    temp1 = [Dic objectForKey:@"latitude"];
    temp2 = [Dic objectForKey:@"longitude"];
    self.LocationLabel.text = [temp1 stringByAppendingString:temp2];
    self.AddressLabel.text = [Dic objectForKey:@"homeAddre"];
    
    NSLog([NSString stringWithUTF8String:[response bytes]]);
    
    

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




//@synthesize delegate;
//@synthesize friendid = _friendid;
//@synthesize row = _row;

@end
