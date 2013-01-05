//
//  EventsCell.m
//  Test
//
//  Created by Tonny Dam on 10/7/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "EventsCell.h"
#import "GraphicDrawView.h"
#import "WidgetControl.h"

@implementation EventsCell
@synthesize labelDate, labelTitle, labelPrice, status;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    
        labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, 190, 21)];
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.font = [UIFont boldSystemFontOfSize:15.0f];
        labelTitle.shadowOffset = CGSizeMake(1,1);
        labelTitle.textColor = [UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:1.0];
        labelTitle.shadowColor = [UIColor whiteColor];
        
        [self.contentView addSubview:labelTitle];
        [labelTitle release];
        
        labelDate = [[UILabel alloc]initWithFrame:CGRectMake(12, 30, 82, 20)];
        [WidgetControl setLabelStyle:labelDate andText:nil andTextAlignment:@"left" andFont:[UIFont systemFontOfSize:12] andTextColor:[UIColor colorWithRed:167/255.0f green:166/255.0f blue:166/255.0f alpha:1.0] andBackgroundColor:nil andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(1,1)];
        [self.contentView addSubview:labelDate];
        [labelDate release];
        
        labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(12, 47, 82, 21)];
        [WidgetControl setLabelStyle:labelPrice andText:nil andTextAlignment:@"left" andFont:[UIFont systemFontOfSize:15] andTextColor:[UIColor colorWithRed:0/255.0f green:116/255.0f blue:216/255.0f alpha:1.0] andBackgroundColor:nil andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(1,1)];
        [self.contentView addSubview:labelPrice];
        [labelPrice release];
        
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
        GraphicDrawView *optionView = [[GraphicDrawView alloc] init];
        optionView.optionDraw = @"cell";
        //optionView.optionCellDraw = @"hasOptionAndBlueLine";
        optionView.optionCellDraw = @"hasOptionAndGrayLine";
        
        UILabel *lastUpdate = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 82, 15)];
        [WidgetControl setLabelStyle:lastUpdate andText:@"Status is actief" andTextAlignment:@"center" andFont:[UIFont systemFontOfSize:11.0f] andTextColor:[UIColor colorWithRed:0/255.0f green:116/255.0f blue:216/255.0f alpha:1.0] andBackgroundColor:[UIColor clearColor] andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(1,1)];
        [optionView addSubview:lastUpdate];
        [lastUpdate release];
        
        UILabel *statusText = [[UILabel alloc]initWithFrame:CGRectMake(4, 18, 82, 50)];
        statusText.lineBreakMode = UILineBreakModeWordWrap;
        statusText.numberOfLines = 0;
        [WidgetControl setLabelStyle:statusText andText:@"Swipe om rekeningen toe te voegen aan dit event" andTextAlignment:@"left" andFont:[UIFont systemFontOfSize:10] andTextColor:[UIColor colorWithRed:167/255.0f green:166/255.0f blue:166/255.0f alpha:1.0] andBackgroundColor:nil andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(1,1)];
        [optionView addSubview:statusText];
        [statusText release];
        
        
        /*
        labelPerson = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 50, 21)];
        labelPerson.textAlignment = UITextAlignmentRight;
        labelPerson.backgroundColor = [UIColor clearColor];
        labelPerson.font = [UIFont systemFontOfSize:15];
        labelPerson.shadowOffset = CGSizeMake(1,1);
        labelPerson.textColor = [UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:1.0];
        labelPerson.shadowColor = [UIColor whiteColor];
        
        [optionView addSubview:labelPerson];
        [labelPerson release];
        
        
        UIImageView *smallIconView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 33, 16, 16)];
        smallIconView.image = [UIImage imageNamed:@"icons1"];
        
        [optionView addSubview:smallIconView];
        [smallIconView release];
         */
        
        self.accessoryView = optionView;
        [optionView release];
        

         /*//for editingaccesory
         editButton = [UIButton buttonWithType:UIButtonTypeCustom];
         //[editButton setTitle:@"Edit" forState:UIControlStateNormal];
         [editButton setImage:[UIImage imageNamed:@"iconedit"] forState:UIControlStateNormal];
         [editButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         editButton.frame = CGRectMake(0, 0, 27, 27);
         
         self.editingAccessoryView = editButton;
        */
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = self.accessoryView.frame.origin.x;
    self.accessoryView.frame = CGRectMake(x, 0, 101, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [super dealloc];
}
@end
