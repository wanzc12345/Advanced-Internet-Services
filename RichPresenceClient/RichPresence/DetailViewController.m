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
//#import "ActivityViewController.h"

@interface DetailViewController () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *ProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *OsLabel;
@property (weak, nonatomic) IBOutlet UILabel *SNLabel;
@property (weak, nonatomic) IBOutlet UILabel *BatteryLabel;
@property (weak, nonatomic) IBOutlet UILabel *VolumeLabel;
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *AccLabel;
@property (weak, nonatomic) IBOutlet UILabel *BrightnessLabel;
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;



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
    
    NSLog(@"%@", self.row);
    
    NSError *error;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://aisdzt.elasticbeanstalk.com/get_user_info?userID=%@", self.friendid]]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    self.ProfileImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.friendid]];
    
    if([array count]!=0){
    NSDictionary* Dic = [array objectAtIndex:0];

    self.NameLabel.text = [NSString stringWithFormat:@"%@ %@", [Dic objectForKey:@"firstName"], [Dic objectForKey:@"lastName"]];
    
//    ActivityViewController* act;
//    act.friendid = self.friendid.text;
   // NSString* bbb = _friendid.text;
    
        NSError *error;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://aisdzt.elasticbeanstalk.com/get_activity?userID=%@", self.friendid]]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSArray *array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
        if([array count]!=0){
            NSDictionary* Dic = [array objectAtIndex:0];
            if([[Dic objectForKey:@"activity"] hasPrefix:@"eating"]){
                self.activityImage.image = [UIImage imageNamed:@"eating.png"];
                self.activityLabel.text = @"Eating";
            }
            if([[Dic objectForKey:@"activity"] hasPrefix:@"entertaining"]){
                self.activityImage.image = [UIImage imageNamed:@"entertainment.png"];
                self.activityLabel.text = @"Entertainment";
            }
            if([[Dic objectForKey:@"activity"] hasPrefix:@"intransit"]){
                self.activityImage.image = [UIImage imageNamed:@"intransit.png"];
                self.activityLabel.text = @"In Transit";
            }
            if([[Dic objectForKey:@"activity"] hasPrefix:@"running"]){
                self.activityImage.image = [UIImage imageNamed:@"running.png"];
                self.activityLabel.text = @"Running";
            }
            if([[Dic objectForKey:@"activity"] hasPrefix:@"shopping"]){
                self.activityImage.image = [UIImage imageNamed:@"shop.png"];
                self.activityLabel.text = @"Shopping";
            }
            if([[Dic objectForKey:@"activity"] hasPrefix:@"sleeping"]){
                self.activityImage.image = [UIImage imageNamed:@"sleeping.png"];
                self.activityLabel.text = @"Sleeping";
            }
            if([[Dic objectForKey:@"activity"] hasPrefix:@"walking"]){
                self.activityImage.image = [UIImage imageNamed:@"walking.png"];
                self.activityLabel.text = @"Walking";
            }
            if([[Dic objectForKey:@"activity"] hasPrefix:@"worshiping"]){
                self.activityImage.image = [UIImage imageNamed:@"worship.png"];
                self.activityLabel.text = @"Worshiping";
            }
            if([[Dic objectForKey:@"activity"] hasPrefix:@"working"]){
                self.activityImage.image = [UIImage imageNamed:@"working.png"];
                self.activityLabel.text = @"Working";
            }
        }
    }

    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detail"]) {

        id page2 = segue.destinationViewController;
        [page2 setValue:self.friendid forKey:@"fid"];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@synthesize delegate;
@synthesize friendid = _friendid;
@synthesize row = _row;




@end
