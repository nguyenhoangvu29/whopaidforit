//
//  MemberViewController.h
//  Test
//
//  Created by Tonny Dam on 10/5/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Event.h"
#import "Member.h"
#import "NEventsViewController.h"
#import "EventsCell.h"

@class PopUpViewController;

@interface MemberViewController : UITableViewController  <UIAlertViewDelegate>
{
    PopUpViewController * showPopUp;
    NSMutableArray *listData;
}
@end
