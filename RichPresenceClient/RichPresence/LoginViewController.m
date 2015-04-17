//
//  LoginViewController.m
//  RichPresence
//
//  Created by Jensen Wan on 4/1/15.
//  Copyright (c) 2015 Jensen Wan. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)loginClicked:(id)sender;

@end

@implementation LoginViewController

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

- (IBAction)loginClicked:(id)sender {
    
    //post request to check username and password
    NSString *post = [NSString stringWithFormat:@"{\"userID\":\"%@\",\"password\":\"%@\"}", self.idTextField.text, self.passwordTextField.text];
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
    NSLog(@"login request reply: %@", requestReply);
    
    if([requestReply hasPrefix:@"welcome"]){
        
        //set current user to this user
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.idTextField.text forKey:@"currentuserid"];
        [defaults synchronize];
        
        UIViewController *wc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]
                                instantiateViewControllerWithIdentifier:@"TabBarController"];
        [self presentViewController:wc animated:YES completion:nil];
        
    }else{
        UIAlertView *errorAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Error" message:@"Wrong username or password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        
    }
}
@end
