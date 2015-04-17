//
//  SignupViewController.m
//  RichPresence
//
//  Created by Jensen Wan on 4/16/15.
//  Copyright (c) 2015 Jensen Wan. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userid;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *homeAddress;
@property (weak, nonatomic) IBOutlet UITextField *workAddress;

@end

@implementation SignupViewController
- (IBAction)onOkClicked:(id)sender {
    //post request to sign up
    NSString *post = [NSString stringWithFormat:@"{\"userID\":\"%@\",\"firstName\":\"%@\",\"lastName\":\"%@\",\"password\":\"%@\",\"homeAddr\":\"%@\",\"workAddr\":\"%@\"}", self.userid.text, self.firstName.text, self.lastName.text, self.password.text, self.homeAddress.text, self.workAddress.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long) [postData length]];
    NSMutableURLRequest *request_pst = [[NSMutableURLRequest alloc] init];
    [request_pst setURL:[NSURL URLWithString:@"http://aisdzt.elasticbeanstalk.com/sign_up"]];
    [request_pst setHTTPMethod:@"POST"];
    [request_pst setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request_pst setHTTPBody:postData];
    NSURLResponse *requestResponse;
    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request_pst returningResponse:&requestResponse error:nil];
    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
    NSLog(post);
    NSLog(@"signup request reply: %@", requestReply);
    
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:requestReply delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

@end
