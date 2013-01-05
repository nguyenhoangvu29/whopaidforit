//
//  EditEntryDetailViewController.h
//  Test
//
//  Created by Tonny Dam on 10/11/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@class PopUpViewController;
@interface EditEntryDetailViewController : UIViewController
{
    PopUpViewController *showPopUp;
}
@property (nonatomic, retain) NSString *selectPerson;
@property(nonatomic )int *selectPersonId;
@property(nonatomic)int paidForId;
@property (nonatomic, retain) UITextField *dateTextField;
@property (nonatomic, retain) UITextField *desTextField;
@property (nonatomic, retain) UITextField *priceTextField;
@property (nonatomic, retain) NSMutableArray *arrayPersons;
@property(nonatomic, retain) UIScrollView *scrollView;
@end
