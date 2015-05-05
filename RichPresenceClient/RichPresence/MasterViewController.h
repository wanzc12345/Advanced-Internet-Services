//
//  MasterViewController.h
//  RichPresence
//
//  Created by Jensen Wan on 2/22/15.
//  Copyright (c) 2015 Jensen Wan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewDelegate.h"
#import "AppDelegate.h"

@interface MasterViewController : UITableViewController<ViewDelegate>
{
    UITextField *_value;
}
@property(nonatomic, retain) IBOutlet UITextField *value;
@end

