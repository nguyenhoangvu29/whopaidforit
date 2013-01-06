//
//  MemberCell.h
//  Test
//
//  Created by Tonny Dam on 10/9/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberCell : UITableViewCell
@property (nonatomic,retain) IBOutlet UILabel *labelPerson;
@property (nonatomic,retain) IBOutlet UILabel *labelPrice;
@property (nonatomic,retain) IBOutlet UILabel *labelEmail;
@property (nonatomic,retain) IBOutlet UIButton *editButton;
@property (nonatomic) BOOL activeFlag;

@property (nonatomic,retain) IBOutlet UILabel *labelDate;
@property (nonatomic,retain) IBOutlet UILabel *labelTitle;
//@property (nonatomic,retain) IBOutlet UILabel *labelPrice;
//@property (nonatomic,retain) IBOutlet UIButton *editButton;

@property(nonatomic) int active;
@property(nonatomic) NSInteger status;

@end
