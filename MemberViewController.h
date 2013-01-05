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

@class PopUpViewController;

@interface MemberViewController : UITableViewController
{
    PopUpViewController * showPopUp;
    NSMutableArray *listData;
}
@end
