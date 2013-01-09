//
//  Main2ViewController.h
//  Test
//
//  Created by Tonny Dam on 10/6/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Event.h"
#import "Member.h"
@interface PopUpViewController : UIViewController 

@property (retain, nonatomic) IBOutlet UITextField *txtName;
@property (retain, nonatomic) IBOutlet UITextField *txtEmail;
@property (nonatomic, retain) NSArray *arrayContent;
@end
