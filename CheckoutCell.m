//
//  CheckoutCell.m
//  Test
//
//  Created by Tonny Dam on 10/16/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "CheckoutCell.h"
#import "GraphicDrawView.h"
#import "WidgetControl.h"

@implementation CheckoutCell
@synthesize stringDate, stringPerson;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //for background
        GraphicDrawView *cellView = [[GraphicDrawView alloc] init];
        cellView.optionDraw = @"cell";
        cellView.optionCellDraw = @"hasCheckout";
        self.backgroundView = cellView;
        [cellView release];
        
        //for hover background
        GraphicDrawView *cellHView = [[GraphicDrawView alloc] init];
        cellHView.optionDraw = @"cell";
        cellHView.optionHover = YES;
        cellHView.optionCellDraw = @"hasCheckout";
        self.selectedBackgroundView = cellHView;
        [cellHView release];
        
        //for accesoryview
        GraphicDrawView *optionView = [[GraphicDrawView alloc] init];
        optionView.optionDraw = @"cell";
        optionView.optionCellDraw = @"hasBlueLine";
        self.accessoryView = optionView;
        [optionView release];
        
        //Data
        self.stringDate = [[[UILabel alloc] initWithFrame:CGRectMake(105, 16, 100, 30)] autorelease];
        [WidgetControl setLabelStyle:self.stringDate andText:nil andTextAlignment:@"left" andFont:[UIFont systemFontOfSize:14] andTextColor:[UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:1] andBackgroundColor:[UIColor clearColor] andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(0, 1)];
        [self.contentView addSubview:stringDate];
        
        self.stringPerson = [[[UILabel alloc] initWithFrame:CGRectMake(0, 22, 100, 30)] autorelease];
        [WidgetControl setLabelStyle:self.stringPerson andText:nil andTextAlignment:@"center" andFont:[UIFont boldSystemFontOfSize:15] andTextColor:[UIColor colorWithRed:126/255.0f green:95/255.0f blue:12/255.0f alpha:1] andBackgroundColor:[UIColor clearColor] andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(0, 1)];
        [self.contentView addSubview:stringPerson];
        
        UILabel *labelCheckBy = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 100, 30)];
        [WidgetControl setLabelStyle:labelCheckBy andText:@"Controle door" andTextAlignment:@"center" andFont:[UIFont systemFontOfSize:12] andTextColor:[UIColor colorWithRed:175/255.0f green:148/255.0f blue:40/255.0f alpha:1] andBackgroundColor:[UIColor clearColor] andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(0, 1)];
        [self.contentView addSubview:labelCheckBy];
        [labelCheckBy release];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat x = self.accessoryView.frame.origin.x;
    self.accessoryView.frame = CGRectMake(x, 0, 24, self.frame.size.height);
    //self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, self.frame.size.width, self.frame.size.height);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
