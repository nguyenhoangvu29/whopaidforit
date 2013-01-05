//
//  EntriesViewController.h
//  Test
//
//  Created by Tonny Dam on 10/8/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditEntryDetailViewController;
@class PopUpViewController;
@interface EntriesViewController : UITableViewController
{
    EditEntryDetailViewController *showPopUp;
    PopUpViewController * showPopUpEvent;
    NSMutableArray *listData;
    NSMutableArray *listMember;
}
@property (nonatomic,retain) NSMutableArray *arrayReceive;
@end
