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

@synthesize labelDate, labelTitle, active;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Active:(NSInteger)active
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
        
        //[self.contentView addSubview:avatarView];
        [avatarView release];
        
        labelPerson = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 150, 21)];
        labelPerson.backgroundColor = [UIColor clearColor];
        labelPerson.font = [UIFont boldSystemFontOfSize:15.0f];
        labelPerson.shadowOffset = CGSizeMake(1,1);
        labelPerson.textColor = [UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:1.0];
        labelPerson.shadowColor = [UIColor whiteColor];
        
        [self.contentView addSubview:labelPerson];
        [labelPerson release];
        
        labelEmail = [[UILabel alloc]initWithFrame:CGRectMake(10, 28, 150, 21)];
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
        //UIView *optionView = [[UIView alloc] init];
        //optionView.frame =CGRectMake(180, 0, 150, 50);
        GraphicDrawView *optionView = [[GraphicDrawView alloc] init];
        optionView.optionDraw = @"cell";
        
        UILabel *labelStatus = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, 50, 21)];
        labelStatus.backgroundColor = [UIColor clearColor];
        labelStatus.font = [UIFont systemFontOfSize:14];
        labelStatus.shadowOffset = CGSizeMake(1,1);
        labelStatus.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
        labelStatus.shadowColor = [UIColor whiteColor];
        labelStatus.text = @"Status:";
        [optionView addSubview:labelStatus];
        [labelStatus release];
        
        UILabel *labelStatusText = [[UILabel alloc]initWithFrame:CGRectMake(5, 28, 140, 21)];
        labelStatusText.backgroundColor = [UIColor clearColor];
        labelStatusText.font = [UIFont systemFontOfSize:14];
        labelStatusText.shadowOffset = CGSizeMake(1,1);
        labelStatusText.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
        if(active){
            labelStatusText.textColor = [UIColor colorWithRed:0/255.0f green:116/255.0f blue:216/255.0f alpha:1.0];
        }
        labelStatusText.shadowColor = [UIColor whiteColor];
        labelStatusText.text = @"Geaccepteerd";
        [optionView addSubview:labelStatusText];
        [labelStatusText release];
        
        /*UILabel *lastUpdate = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 82, 15)];
        [WidgetControl setLabelStyle:lastUpdate andText:@"Status is actief" andTextAlignment:@"center" andFont:[UIFont systemFontOfSize:11.0f] andTextColor:[UIColor colorWithRed:0/255.0f green:116/255.0f blue:216/255.0f alpha:1.0] andBackgroundColor:[UIColor clearColor] andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(1,1)];
        [optionView addSubview:lastUpdate];
        [lastUpdate release];
        
        UILabel *statusText = [[UILabel alloc]initWithFrame:CGRectMake(4, 18, 82, 50)];
        statusText.lineBreakMode = UILineBreakModeWordWrap;
        statusText.numberOfLines = 0;
        [WidgetControl setLabelStyle:statusText andText:@"Swipe om rekeningen toe te voegen aan dit event" andTextAlignment:@"left" andFont:[UIFont systemFontOfSize:10] andTextColor:[UIColor colorWithRed:167/255.0f green:166/255.0f blue:166/255.0f alpha:1.0] andBackgroundColor:nil andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(1,1)];
        [optionView addSubview:statusText];
        [statusText release];
        */
        /*labelPrice = [[UILabel alloc] init];
        labelPrice.backgroundColor = [UIColor clearColor];
        labelPrice.font = [UIFont fontWithName:@"Century Gothic" size:15];
        labelPrice.textAlignment = UITextAlignmentRight;
        labelPrice.shadowOffset = CGSizeMake(1,1);
        labelPrice.textColor = [UIColor colorWithRed:231/255.0f green:15/255.0f blue:20/255.0f alpha:1.0];
        if (activeFlag) {
            labelPrice.textColor = [UIColor colorWithRed:0/255.0f green:116/255.0f blue:216/255.0f alpha:1.0];
        }
        labelPrice.shadowColor = [UIColor whiteColor];
        labelPrice.text = @"Status";
        */
        self.accessoryView = optionView;
        //[labelPrice release];
        
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
    //self.accessoryView.frame = CGRectMake(x, 10, 80, 20);
    self.accessoryView.frame = CGRectMake(x, 0, 101, self.frame.size.height);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
