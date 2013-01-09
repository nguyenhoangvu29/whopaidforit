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
@synthesize labelDate, labelTitle, labelPrice, status, editButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Active:(NSInteger)active
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
        NSString *statusTitle = @"";
        NSString *statusText = @"";
        if(active == 1){
            optionView.optionCellDraw = @"hasOptionAndBlueLine";
            statusTitle = @"ACTIEF";
            statusText = @"Open event om rekeningen toe te voegen.";
        }else{
            optionView.optionCellDraw = @"hasOptionAndGrayLine";
            statusTitle = @"NIET ACTIEF";
            statusText = @"Open event om te activeren.";
        }
        UILabel *lastUpdate = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, 82, 15)];
        [WidgetControl setLabelStyle:lastUpdate andText:statusTitle andTextAlignment:@"center" andFont:[UIFont systemFontOfSize:11.0f] andTextColor:[UIColor colorWithRed:0/255.0f green:116/255.0f blue:216/255.0f alpha:1.0] andBackgroundColor:[UIColor clearColor] andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(1,1)];
        [optionView addSubview:lastUpdate];
        [lastUpdate release];
        
        UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(4, 18, 82, 50)];
        statusLabel.lineBreakMode = UILineBreakModeWordWrap;
        statusLabel.numberOfLines = 0;
        [WidgetControl setLabelStyle:statusLabel andText:statusText andTextAlignment:@"left" andFont:[UIFont systemFontOfSize:11] andTextColor:[UIColor colorWithRed:167/255.0f green:166/255.0f blue:166/255.0f alpha:1.0] andBackgroundColor:nil andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(1,1)];
        [optionView addSubview:statusLabel];
        [statusLabel release];
        
        self.accessoryView = optionView;
        [optionView release];
        

         //for editingaccesory
         editButton = [UIButton buttonWithType:UIButtonTypeCustom];
         //[editButton setTitle:@"Edit" forState:UIControlStateNormal];
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
    self.accessoryView.frame = CGRectMake(x, 0, 101, self.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //[super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc {
    [super dealloc];
    //[labelDate release];
    //[labelTitle release];
}
@end
