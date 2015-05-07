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
    
    self.expirationHandler = ^{  //创建后台自唤醒，当180s时间结束的时候系统会调用这里面的方法
        [app endBackgroundTask:selfRef.bgTask];
        selfRef.bgTask = UIBackgroundTaskInvalid;
        selfRef.bgTask = [app beginBackgroundTaskWithExpirationHandler:selfRef.expirationHandler];
        NSLog(@"Expired");
        selfRef.jobExpired = YES;
        while(selfRef.jobExpired)
        {
            // spin while we wait for the task to actually end.
            NSLog(@"等待180s循环进程的结束");
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
    
    if(login)//当登陆状态才启动后台操作
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
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;//取消应用程序通知脚标
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
    NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    
    self.firstName = [Dic objectForKey:@"firstName"];
    self.lastName = [Dic objectForKey:@"lastName"];
    self.add = [Dic objectForKey:@"homeAddress"];
    self.userId = uid;
    
}






- (void)startBackgroundTask
{
    NSLog(@"Restarting task");
    if(login)//当登陆状态才进入后台循环
    {
        // Start the long-running task.
        NSLog(@"登录状态后台进程开启");
        
        // When the job expires it still keeps running since we never exited it. Thus have the expiration handler
        // set a flag that the job expired and use that to exit the while loop and end the task.
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            NSInteger count=0;
            BOOL NoticeNoBackground=false;//只通知一次标志位
            BOOL FlushBackgroundTime=false;//只通知一次标志位
            locationManager.distanceFilter = kCLDistanceFilterNone;//任何运动均接受，任何运动将会触发定位更新
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;//定位精度
            while(self.background && !self.jobExpired)
            {
                
                NSLog(@"进入后台进程循环");
                [NSThread sleepForTimeInterval:1];
                count++;
                if(count>20)//每10s进行一次开启定位，刷新后台时间
                {
                    count=0;
                    int numofSent = 1;
                    NSString *post = @"#dean#";
                    while (numofSent <= 5) {
                        [locationManager startUpdatingLocation];
                        NSLog(@"开始位置服务");
                        [NSThread sleepForTimeInterval:1];
                        [self getInformation];
                        [locationManager stopUpdatingLocation];
                        NSLog(@"停止位置服务");
                        FlushBackgroundTime=false;
                        
                        NSTimeInterval curTime = [[NSDate date] timeIntervalSince1970];
                        self.timestamp = [NSString stringWithFormat:@"%ld",lroundf(curTime)];
                        
                        
                        post = [post stringByAppendingString: [NSString stringWithFormat:@"{\"userID\":\"%@\",\"timestamp\":\"%@\",\"latitude\":\"%@\",\"longitude\":\"%@\",\"xAcc\":\"%@\",\"yAcc\":\"%@\",\"zAcc\":\"%@\", \"volume\":\"%@\",\"brightness\":\"%@\",\"batteryLevel\":\"%@\",\"OSType\":\"%@\",\"OSVersion\":\"%@\",\"serialNumber\":\"%@\"}", self.userId, self.timestamp, self.latitude, self.longitude, self.accX, self.accY, self.accZ, self.volume, self.brs, self.batLevel, self.deviceName, self.phoneVersion, self.sn]];
                        post = [post stringByAppendingString: @"#dean#"];
                        
                        numofSent ++;
                    }
                    NSLog(post);
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
                                               initWithTitle:@"Error" message:requestReply delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [errorAlert show];
                    
                    
                    
                }
                if(!login)//未登录或者掉线状态下关闭后台
                {
                    NSLog(@"保持在线进程失效，退出后台进程");
                    //[InterfaceFuncation ShowLocalNotification:@"保持在线失效，登录已被注销，请重新登录"];
                    [[UIApplication sharedApplication] endBackgroundTask:self.bgTask];
                    return;//退出循环
                }
                NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
                NSLog(@"Background Time Remaining = %.02f Seconds",backgroundTimeRemaining);
                if(backgroundTimeRemaining<30&&NoticeNoBackground==false)
                {
                    //[InterfaceFuncation ShowLocalNotification:@"向系统申请长时间保持后台失败，请结束客户端重新登录"];
                    NoticeNoBackground=true;
                }
                //测试后台时间刷新
                if(backgroundTimeRemaining>200&&FlushBackgroundTime==false)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MessageUpdate" object:@"刷新后台时间成功\n"];
                    FlushBackgroundTime=true;
                    //[InterfaceFuncation ShowLocalNotification:@"刷新后台时间成功"];
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


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error//当定位服务不可用出错时，系统会自动调用该函数
{
    NSLog(@"定位服务出错");
    if([error code]==kCLErrorDenied)//通过error的code来判断错误类型
    {
        //Access denied by user
        NSLog(@"定位服务未打开");
        //[InterfaceFuncation ShowAlertWithMessage:@"错误" AlertMessage:@"未开启定位服务\n客户端保持后台功能需要调用系统的位置服务\n请到设置中打开位置服务" ButtonTitle:@"好"];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations//当用户位置改变时，系统会自动调用，这里必须写一点儿代码，否则后台时间刷新不管用
{
    NSLog(@"位置改变，必须做点儿事情才能刷新后台时间");
    CLLocation *loc = [locations lastObject];
    //NSTimeInterval backgroundTimeRemaining = [[UIApplication sharedApplication] backgroundTimeRemaining];
    //NSLog(@"Background Time Remaining = %.02f Seconds",backgroundTimeRemaining);
    // Lat/Lon
    self.latitude = [NSString stringWithFormat:@"%f", loc.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f", loc.coordinate.longitude];
    }






@end