//
//  MasterViewController.m
//  RichPresence
//
//  Created by Jensen Wan on 2/22/15.
//  Copyright (c) 2015 Jensen Wan. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "getSN.h"
//#import "getLocation.h"
#import <AVFoundation/AVAudioSession.h>


@interface MasterViewController ()

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [defaults objectForKey:@"currentuserid"];
    
    //get friends list
    NSError *error;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://aisdzt.elasticbeanstalk.com/get_friends_list?userID=%@", uid]]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSArray *friendsIdList = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error]];
    
    for(int i=0;i<[friendsIdList count];i++){
        [self.objects insertObject:[friendsIdList objectAtIndex:i] atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    //change background
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back5.png"]];
    [self.tableView setBackgroundView:imageView];
    
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    myDelegate.login = 1;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Add Friend" message:@"Enter user id:" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"Add"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {  //add button
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *uid = [defaults objectForKey:@"currentuserid"];
        
        UITextField *friendid = [alertView textFieldAtIndex:0].text;
        
        //add friend
        NSError *error;
        NSString *url =[NSString stringWithFormat:@"http://aisdzt.elasticbeanstalk.com/add_friend?MyUserID=%@&FriendUserID=%@", uid, friendid];
        NSLog(url);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@", Dic);
        if([[Dic objectForKey:@"status"]  isEqual: @"True"]){
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Success!" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
            [self.objects insertObject:friendid atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else{
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Error!" message:[Dic objectForKey:@"message"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        }
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        //[[segue destinationViewController] setDetailItem:object];
        
        //NSLog(object);
        id page2=segue.destinationViewController;
        [page2 setValue:object forKey:@"friendid"];
        [page2 setValue:[NSString stringWithFormat:@"%ld",indexPath.row] forKey:@"row"];
    
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = [object description];
    
    //get activity
    NSError *error;
    NSString *url =[NSString stringWithFormat:@"http://aisdzt.elasticbeanstalk.com/get_activity?userID=%@", [object description]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if([array count]!=0)
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", [[array objectAtIndex:0] objectForKey:@"activity"], [[array objectAtIndex:0] objectForKey:@"timestamp"]];
    else
        cell.detailTextLabel.text = @"";
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor yellowColor];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", self.objects[indexPath.row]]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *uid = [defaults objectForKey:@"currentuserid"];
        
        //remove friend
        NSError *error;
        NSString *friendid = [self.objects objectAtIndex:indexPath.row];
        NSLog(friendid);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://aisdzt.elasticbeanstalk.com/remove_friend?MyUserID=%@&FriendUserID=%@", uid, friendid]]];
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSArray *friendsIdList = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableContainers error:&error]];
        
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //DetailViewController *second = [[DetailViewController alloc] initWithNibName:@'DetailViewController'bundle:nil];
        //second.delegate = self;
        //second.flag = 0;
        //[self presentViewController:second animated:YES completion:nil];
        
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Success!" message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)passValue:(NSString *)value
{
    self.value.text = value;
    NSLog(@"the get value is %@", value);
}



@end
