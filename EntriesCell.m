//
//  EntriesCell.m
//  Test
//
//  Created by Tonny Dam on 10/7/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "EntriesCell.h"
#import "GraphicDrawView.h"

@implementation EntriesCell
@synthesize labelDate, labelTitle, labelPerson, labelPrice, editButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        labelDate = [[UILabel alloc]initWithFrame:CGRectMake(12, 8, 190, 21)];;
        labelDate.backgroundColor = [UIColor clearColor];
        labelDate.font = [UIFont systemFontOfSize:15];
        labelDate.shadowOffset = CGSizeMake(1,1);
        labelDate.textColor = [UIColor colorWithRed:167/255.0f green:166/255.0f blue:166/255.0f alpha:1.0];
        labelDate.shadowColor = [UIColor whiteColor];
        
        [self.contentView addSubview:labelDate];
        [labelDate release];
        
        labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(12, 30, 190, 21)];
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.font = [UIFont boldSystemFontOfSize:15.0f];
        labelTitle.shadowOffset = CGSizeMake(1,1);
        labelTitle.textColor = [UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:1.0];
        labelTitle.shadowColor = [UIColor whiteColor];
        
        [self.contentView addSubview:labelTitle];
        [labelTitle release];
        
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
        optionView.optionCellDraw = @"hasOptionAndBlueLine";
        
        labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(4, 8, 82, 21)];
        labelPrice.backgroundColor = [UIColor clearColor];
        labelPrice.font = [UIFont fontWithName:@"Century Gothic" size:15];
        labelPrice.shadowOffset = CGSizeMake(1,1);
        labelPrice.textAlignment = UITextAlignmentCenter;
        labelPrice.textColor = [UIColor colorWithRed:0/255.0f green:116/255.0f blue:216/255.0f alpha:1.0];
        labelPrice.shadowColor = [UIColor whiteColor];
        
        [optionView addSubview:labelPrice];
        [labelPrice release];
        
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
        
        self.accessoryView = optionView;
        [optionView release];
        
        
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
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [super dealloc];
}
@end
