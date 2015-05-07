//
//  AppDelegate.m
//  RichPresence
//
//  Created by Jensen Wan on 2/22/15.
//  Copyright (c) 2015 Jensen Wan. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"

@interface AppDelegate ()
@property (assign, nonatomic) UIBackgroundTaskIdentifier bgTask;

@property (strong, nonatomic) dispatch_block_t expirationHandler;
@property (assign, nonatomic) BOOL jobExpired;
@property (assign, nonatomic) BOOL background;
@end

@implementation AppDelegate
@synthesize locationManager;
@synthesize login;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    
//     NSUserDefaults *accountDefaults = [NSUserDefaults standardUserDefaults];
//    NSString* str = [accountDefaults stringForKey:@"currentuserid"];
//    if (str != NULL) {
//        login = 1;
//    }
//    else login = 0;
    
    
    
    UIApplication* app = [UIApplication sharedApplication];
    
    
    __weak typeof(self) selfRef = self;
    
    self.expirationHandler = ^{
        [app endBackgroundTask:selfRef.bgTask];
        selfRef.bgTask = UIBackgroundTaskInvalid;
        selfRef.bgTask = [app beginBackgroundTaskWithExpirationHandler:selfRef.expirationHandler];
        NSLog(@"Expired");
        selfRef.jobExpired = YES;
        while(selfRef.jobExpired)
        {
            // spin while we wait for the task to actually end.
            NSLog(@"wait 180s loop end");
            [NSThread sleepForTimeInterval:1];
        }
        // Restart the background task so we can run forever.
        [selfRef startBackgroundTask];
    };
    
    // Assume that we're in background at first since we get no notification from device that we're in background when
    // app launches immediately into background (i.e. when powering on the device or when the app is killed and restarted)
    [self monitorBatteryStateInBackground];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    //[locationManager startUpdatingLocation];
    return YES;

}

-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    // Prepare the Device Token for Registration (remove spaces and < >)
    NSString *devToken = [[[[deviceToken description]
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    NSLog(@"My token is: %@", devToken);
}
-(void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error

{
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if(login)
    {
        self.bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:self.expirationHandler];
        NSLog(@"Entered background");
        [self monitorBatteryStateInBackground];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSLog(@"App is active");
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
    [locationManager stopUpdatingLocation];
    self.background = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



- (void)getInformation
{
    self.deviceName = [[UIDevice currentDevice] systemName];
    self.phoneVersion = [[UIDevice currentDevice] systemVersion];
    
    self.sn = [[UIDevice currentDevice] serialNumber];
    
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    UIDevice *myDevice = [UIDevice currentDevice];
    [myDevice setBatteryMonitoringEnabled:YES];
    double batLeft = (float)[myDevice batteryLevel];
    self.batLevel = [NSString stringWithFormat:@"%f", batLeft];
    
    float vol = [[AVAudioSession sharedInstance] outputVolume];
    self.volume = [NSString stringWithFormat:@"%f", vol];
    
    //location
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestAlwaysAuthorization];
    //[self.locationManager startUpdatingLocation];
    
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 1;
    //self.motionManager.delegate = self;
    
    if ([self.motionManager isAccelerometerAvailable])
    {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [self.motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.accX = [NSString stringWithFormat:@"%.2f",accelerometerData.acceleration.x];
                self.accY = [NSString stringWithFormat:@"%.2f",accelerometerData.acceleration.y];
                self.accZ = [NSString stringWithFormat:@"%.2f",accelerometerData.acceleration.z];
                
            });
        }];
    } else{
        NSLog(@"not active");
        self.accX = @"0";
        self.accY = @"0";
        self.accZ = @"0";
    }
    
    double br = [[UIScreen mainScreen] brightness];
    self.brs = [NSString stringWithFormat:@"%.2f", br];
    
    //load user info
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"currentuserid"];
    NSError *error;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://aisdzt.elasticbeanstalk.com/get_user_info?userID=%@", uid]]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    NSDictionary* Dic = [array objectAtIndex:0];
    self.firstName = [Dic objectForKey:@"firstName"];
    self.lastName = [Dic objectForKey:@"lastName"];
    self.add = [Dic objectForKey:@"homeAddress"];
    self.userId = uid;
    
}






- (void)startBackgroundTask
{
    NSLog(@"Restarting task");
    if(login)
    {
        // Start the long-running task.
        NSLog(@"background task started");
        
        // When the job expires it still keeps running since we never exited it. Thus have the expiration handler
        // set a flag that the job expired and use that to exit the while loop and end the task.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            NSInteger count=0;
            BOOL NoticeNoBackground=false;
            BOOL FlushBackgroundTime=false;
            locationManager.distanceFilter = kCLDistanceFilterNone;
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            
            NSString *post = @"";
            [locationManager startUpdatingLocation];
            NSLog(@"recording location");
            [NSThread sleepForTimeInterval:1];
            [self getInformation];
            [locationManager stopUpdatingLocation];
            NSLog(@"location recorded");
            FlushBackgroundTime=false;
            
            NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
            self.timestamp = [NSString stringWithFormat:@"%ld",lroundf(curTime*1000)];
            
            post = [post stringByAppendingString: [NSString stringWithFormat:@"{\"userID\":\"%@\",\"timestamp\":\"%@\",\"latitude\":\"%@\",\"longitude\":\"%@\",\"xAcc\":\"%@\",\"yAcc\":\"%@\",\"zAcc\":\"%@\", \"volume\":\"%@\",\"brightness\":\"%@\",\"batteryLevel\":\"%@\",\"OSType\":\"%@\",\"OSVersion\":\"%@\",\"serialNumber\":\"%@\"}", self.userId, self.timestamp, self.latitude, self.longitude, self.accX, self.accY, self.accZ, self.volume, self.brs, self.batLevel, self.deviceName, self.phoneVersion, self.sn]];
            
            while(self.background && !self.jobExpired)
            {
                
                NSLog(@"enter background task loop");
                [NSThread sleepForTimeInterval:1];
                count++;
                if(count>20)
                {
                    count=0;
                    int numofSent = 1;
                    
                    NSString *post = @"";
                    [locationManager startUpdatingLocation];
                    NSLog(@"start recording location");
                    [NSThread sleepForTimeInterval:1];
                    [self getInformation];
                    [locationManager stopUpdatingLocation];
                    NSLog(@"stop recording location");
                    FlushBackgroundTime=false;
                    
                    NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
                    self.timestamp = [NSString stringWithFormat:@"%ld",lroundf(curTime*1000)];
                    
                    post = [post stringByAppendingString: [NSString stringWithFormat:@"{\"userID\":\"%@\",\"timestamp\":\"%@\",\"latitude\":\"%@\",\"longitude\":\"%@\",\"xAcc\":\"%@\",\"yAcc\":\"%@\",\"zAcc\":\"%@\", \"volume\":\"%@\",\"brightness\":\"%@\",\"batteryLevel\":\"%@\",\"OSType\":\"%@\",\"OSVersion\":\"%@\",\"serialNumber\":\"%@\"}", self.userId, self.timestamp, self.latitude, self.longitude, self.accX, self.accY, self.accZ, self.volume, self.brs, self.batLevel, self.deviceName, self.phoneVersion, self.sn]];
                    
                    while (numofSent <= 4) {
                        [locationManager startUpdatingLocation];
                        NSLog(@"start recording location");
                        [NSThread sleepForTimeInterval:1];
                        [self getInformation];
                        [locationManager stopUpdatingLocation];
                        NSLog(@"stop recording location");
                        FlushBackgroundTime=false;
                        
                        [NSThread sleepForTimeInterval:0.1];
                        NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
                        NSLog(@"current timestamp:%f", curTime);
                        self.timestamp = [NSString stringWithFormat:@"%f", curTime*1000];
                        self.timestamp = [self.timestamp substringToIndex:13];
                        
                        NSLog(@"saved timestamp:%@", self.timestamp);
                        post = [post stringByAppendingString: @"#dean#"];
                        
                        post = [post stringByAppendingString: [NSString stringWithFormat:@"{\"userID\":\"%@\",\"timestamp\":\"%@\",\"latitude\":\"%@\",\"longitude\":\"%@\",\"xAcc\":\"%@\",\"yAcc\":\"%@\",\"zAcc\":\"%@\", \"volume\":\"%@\",\"brightness\":\"%@\",\"batteryLevel\":\"%@\",\"OSType\":\"%@\",\"OSVersion\":\"%@\",\"serialNumber\":\"%@\"}", self.userId, self.timestamp, self.latitude, self.longitude, self.accX, self.accY, self.accZ, self.volume, self.brs, self.batLevel, self.deviceName, self.phoneVersion, self.sn]];
                        
                        numofSent ++;
                    }
                    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long) [postData length]];
                    NSMutableURLRequest *request_pst = [[NSMutableURLRequest alloc] init];
                    [request_pst setURL:[NSURL URLWithString:@"http://aisdzt.elasticbeanstalk.com/upload_rich_presence"]];
                    [request_pst setHTTPMethod:@"POST"];
                    [request_pst setValue:postLength forHTTPHeaderField:@"Content-Length"];
                    [request_pst setHTTPBody:postData];
                    NSURLResponse *requestResponse;
                    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request_pst returningResponse:&requestResponse error:nil];
                    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
                    NSLog(post);
                    NSLog(@"updata information from background reply: %@", requestReply);
                    
                    UIAlertView *errorAlert = [[UIAlertView alloc]
                                               initWithTitle:@"Guess you just" message:requestReply delegate:nil cancelButtonTitle:@"Right" otherButtonTitles:nil];
                    [errorAlert show];
                    
                    
                    
                }
                if(!login)
                {
                    NSLog(@"exiting backgroun task");
                    [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
                    return;//exit loop
                }
                NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
                NSLog(@"Background Time Remaining = %.02f Seconds",backgroundTimeRemaining);
                if(backgroundTimeRemaining<30&&NoticeNoBackground==false)
                {
                    NoticeNoBackground=true;
                }
                //testing time refresh
                if(backgroundTimeRemaining>200&&FlushBackgroundTime==false)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageUpdate" object:@"time refresh succeed\n"];
                    FlushBackgroundTime=true;
                }
            }
            self.jobExpired = NO;
        });
    }
}


- (void)monitorBatteryStateInBackground
{
    self.background = YES;
    [self startBackgroundTask];
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"location error");
    if([error code]==kCLErrorDenied)
    {
        //Access denied by user
        NSLog(@"location not opened");
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"location changed");
    CLLocation *loc = [locations lastObject];
    //NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
    //NSLog(@"Background Time Remaining = %.02f Seconds",backgroundTimeRemaining);
    // Lat/Lon
    self.latitude = [NSString stringWithFormat:@"%f", loc.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", loc.coordinate.longitude];
    }






@end