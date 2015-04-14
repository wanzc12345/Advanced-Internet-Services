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
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
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

@end

@implementation MeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSString *urlString = [NSString stringWithFormat:@"http://www.google.com"];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"GET"];
//    
//    NSHTTPURLResponse * urlResponse = nil;
//    NSError* error = [[NSError alloc]init];
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error: &error];
//    NSMutableString *result = [[NSMutableString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    
//    NSLog(@"%@",result);
//    
//    self.nameLabel.text = result;
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
    
    //post request
    NSString *post = [NSString stringWithFormat:@"{\"userID\":\"zw2291@columbia.edu\",\"password\":\"123\"}"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long) [postData length]];
    NSMutableURLRequest *request_pst = [[NSMutableURLRequest alloc] init];
    [request_pst setURL:[NSURL URLWithString:@"http://aisdzt.elasticbeanstalk.com/login"]];
    [request_pst setHTTPMethod:@"POST"];
    [request_pst setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request_pst setHTTPBody:postData];
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request_pst returningResponse:&requestResponse error:nil];
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSLog(@"requestReply: %@", requestReply);
 
    
    
    
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
    //[self.view addSubview:_jsonAnalizer];
    //[self.jsonAnalizer addTarget:self action:@selector(jsonAnalizer:) forControlEvents:UIControlEventTouchUpInside];
    
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://aisdzt.elasticbeanstalk.com/GetUserInfo?userID=qy2152@columbia.edu"]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
    NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    NSDictionary *Info = [Dic objectForKey:@"firstName"];
    NSLog([NSString stringWithFormat:@"first name: %@, last name: %@, home Address: %@ ",[Dic objectForKey:@"firstName"],[Dic objectForKey:@"lastName"],[Dic objectForKey:@"homeAddress"]]);
    NSLog(@"weatherInfo字典里面的内容为--》%@", Dic );
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
