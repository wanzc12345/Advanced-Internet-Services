//
//  MeDetailViewController.m
//  RichPresence
//
//  Created by Jensen Wan on 3/29/15.
//  Copyright (c) 2015 Jensen Wan. All rights reserved.
//

#import "MeDetailViewController.h"

@interface MeDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

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
