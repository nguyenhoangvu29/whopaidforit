//
//  MemberCell.m
//  Test
//
//  Created by Tonny Dam on 10/9/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "MemberCell.h"
#import "GraphicDrawView.h"
#import "WidgetControl.h"

@implementation MemberCell
@synthesize editButton, labelPerson, labelPrice, labelEmail, activeFlag;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
        avatarView.image = [WidgetControl makeRoundCornerImage:[UIImage imageNamed:@"avatar"] :9 :9];
        avatarView.layer.cornerRadius = 9.0;
        avatarView.layer.borderWidth = 1;
        avatarView.layer.borderColor = [[UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1] CGColor];
        [avatarView.layer setShadowOffset:CGSizeMake(1, 1)];
        [avatarView.layer setShadowOpacity:1];
        [avatarView.layer setShadowRadius:0];
        [avatarView.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        [avatarView.layer setShouldRasterize:YES];
        [avatarView.layer setCornerRadius:9.0f];
        [avatarView.layer setShadowPath:[[UIBezierPath bezierPathWithRoundedRect:[avatarView bounds] cornerRadius:9.0f] CGPath]];
        
        [self.contentView addSubview:avatarView];
        [avatarView release];
        
        labelPerson = [[UILabel alloc]initWithFrame:CGRectMake(70, 8, 150, 21)];
        labelPerson.backgroundColor = [UIColor clearColor];
        labelPerson.font = [UIFont boldSystemFontOfSize:15.0f];
        labelPerson.shadowOffset = CGSizeMake(1,1);
        labelPerson.textColor = [UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:1.0];
        labelPerson.shadowColor = [UIColor whiteColor];
        
        [self.contentView addSubview:labelPerson];
        [labelPerson release];
        
        labelEmail = [[UILabel alloc]initWithFrame:CGRectMake(70, 28, 150, 21)];
        labelEmail.backgroundColor = [UIColor clearColor];
        labelEmail.font = [UIFont systemFontOfSize:15];
        labelEmail.shadowOffset = CGSizeMake(1,1);
        labelEmail.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
        labelEmail.shadowColor = [UIColor whiteColor];
        
        [self.contentView addSubview:labelEmail];
        [labelEmail release];
        
        
        //for background
        GraphicDrawView *cellView = [[GraphicDrawView alloc] init];
        cellView.optionDraw = @"cell";
        self.backgroundView = cellView;
        [cellView release];
        
        //for hover background
        GraphicDrawView *cellHView = [[GraphicDrawView alloc] init];
        cellHView.optionDraw = @"cell";
        cellHView.optionHover = YES;
        self.selectedBackgroundView = cellHView;
        [cellHView release];
        
        //for accesoryview
        labelPrice = [[UILabel alloc] init];
        labelPrice.backgroundColor = [UIColor clearColor];
        labelPrice.font = [UIFont fontWithName:@"Century Gothic" size:15];
        labelPrice.textAlignment = UITextAlignmentRight;
        labelPrice.shadowOffset = CGSizeMake(1,1);
        labelPrice.textColor = [UIColor colorWithRed:231/255.0f green:15/255.0f blue:20/255.0f alpha:1.0];
        if (activeFlag) {
            labelPrice.textColor = [UIColor colorWithRed:0/255.0f green:116/255.0f blue:216/255.0f alpha:1.0];
        }
        labelPrice.shadowColor = [UIColor whiteColor];
        
        self.accessoryView = labelPrice;
        [labelPrice release];
        
        //for editingaccesory
        editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [editButton setImage:[UIImage imageNamed:@"iconedit"] forState:UIControlStateNormal];
        [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        editButton.frame = CGRectMake(0, 0, 27, 27);
        
        self.editingAccessoryView = editButton;
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = self.accessoryView.frame.origin.x;
    self.accessoryView.frame = CGRectMake(x, 10, 80, 20);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
