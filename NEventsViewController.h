//
//  NEventsViewController.h
//  Test
//
//  Created by Tonny Dam on 10/10/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "User.h"
@class PopUpViewController;

@interface NEventsViewController : UITableViewController
{
    PopUpViewController *showPopUp;
    NSMutableArray *listData;
}
@end
