//
//  CheckoutDetailCell.h
//  Test
//
//  Created by Tonny Dam on 10/16/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CheckoutDetailCell : UITableViewCell
@property (nonatomic) BOOL flagEdit;
- (id)initWithStyleArray:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andArray:(NSArray*) arrayItems;
@end
