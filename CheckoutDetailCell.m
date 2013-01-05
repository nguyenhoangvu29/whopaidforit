//
//  CheckoutDetailCell.m
//  Test
//
//  Created by Tonny Dam on 10/16/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "CheckoutDetailCell.h"
#import "GraphicDrawView.h"
#import "WidgetControl.h"
#import "RCSwitchOnOff.h"
#define RED_COLOR [UIColor colorWithRed:225/255.0f green:44/255.0f blue:0/255.0f alpha:1]
#define BLUE_COLOR [UIColor colorWithRed:63/255.0f green:134/255.0f blue:196/255.0f alpha:1]

@implementation CheckoutDetailCell
@synthesize flagEdit;
- (UIColor*) switchColor: (NSString *) str{
    UIColor *color = nil;
    if ([str isEqualToString:@"0"]) {
        color = RED_COLOR;
    } else if ([str isEqualToString:@"1"]) {
        color = BLUE_COLOR;
    }
    return color;
}
- (NSString*) switchTextPattern: (NSString *) str{
    if ([str isEqualToString:@"0"]) {
        str = @"Betaalt aan %@ €%@";
    } else if ([str isEqualToString:@"1"]) {
        str = @"Ontvangt van %@ €%@";
    }
    return str;
}
- (BOOL) switchBool: (NSString *) str {
    if ([str isEqualToString:@"0"]) {
        return NO;
    } else {
        return YES;
    }
}
-(void)switchOnOffValues: (RCSwitchOnOff*) item {
    [UIView animateWithDuration:0.3 animations:^{
        UIView *lineView = [self viewWithTag:item.tag-10];
        UILabel *lineLabel = (UILabel*)[self viewWithTag:item.tag-20];
        CGFloat lineLabelWidth = [lineLabel.text sizeWithFont:lineLabel.font].width;
        if ( lineView.frame.size.width < lineLabelWidth) {
            lineView.frame = CGRectMake(lineView.frame.origin.x, lineView.frame.origin.y, lineLabelWidth, lineView.frame.size.height);
        } else {
            lineView.frame = CGRectMake(lineView.frame.origin.x, lineView.frame.origin.y, 0, lineView.frame.size.height);
        }
        
    }completion:^(BOOL finished) {
        
    }];
}
- (id)initWithStyleArray:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andArray:(NSMutableArray*) arrayItems andTitle:(NSString *)arrTitle
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //data
        //obj at index 2: 0: red, 1:blue, 2: green
        //obj at index 3: 0: no, 1: yes
        //NSArray *arrayItems = [NSArray arrayWithObjects:@"David#100#0#0", @"Kevin#50#1#1", @"Mark#50#1#0", nil];
        NSArray *column = [arrTitle componentsSeparatedByString:@"#"];
#pragma -mark main Person
        UILabel *personLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 12, 150, 20)];
        [WidgetControl setLabelStyle:personLabel andText:[column objectAtIndex:1]  andTextAlignment:@"left" andFont:[UIFont boldSystemFontOfSize:18] andTextColor:[UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:1] andBackgroundColor:[UIColor clearColor] andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(0, 1)];
        [self.contentView addSubview:personLabel];
        [personLabel release];
        
#pragma -mark main Price
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-110, 12, 100, 20)];
        if ([[column objectAtIndex:3] intValue] == 0) {
            [WidgetControl setLabelStyle:priceLabel andText:[NSString stringWithFormat:@"€%@", [column objectAtIndex:2]]  andTextAlignment:@"right" andFont:[UIFont fontWithName:@"Century Gothic" size:15] andTextColor:RED_COLOR andBackgroundColor:[UIColor clearColor] andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(0, 1)];
        }else {
            [WidgetControl setLabelStyle:priceLabel andText:[NSString stringWithFormat:@"€%@", [column objectAtIndex:2]]  andTextAlignment:@"right" andFont:[UIFont fontWithName:@"Century Gothic" size:15] andTextColor:BLUE_COLOR andBackgroundColor:[UIColor clearColor] andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(0, 1)];
        }
        
        priceLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:priceLabel];
        [priceLabel release];
        
        for (int i=0; i<[arrayItems count]; i++) {
            NSArray *arrayString = [[arrayItems objectAtIndex:i] componentsSeparatedByString:@"#"];
            UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(1, 40+(35*i), self.frame.size.width-2, 35)];
            //define background color
            if (i < [arrayItems count]-1) {
                itemView.backgroundColor = [self switchColor:[arrayString objectAtIndex:3]];
            } else {
                //set background in last item
                GraphicDrawView *cellView = [[GraphicDrawView alloc] init];
                cellView.optionDraw = @"checkoutCell";
                cellView.lastColor = [self switchColor:[arrayString objectAtIndex:3]];
                self.backgroundView = cellView;
                [cellView release];
            }
            itemView.backgroundColor = [self switchColor:[arrayString objectAtIndex:3]];
            itemView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            UIView *itemViewPartern = [[UIView alloc] initWithFrame:CGRectMake(0, 0, itemView.frame.size.width, itemView.frame.size.height)];
            itemViewPartern.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellpattern"]];
            itemViewPartern.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            itemViewPartern.alpha = 0.35;
            [itemViewPartern setOpaque:NO];
            [itemView addSubview:itemViewPartern];
            [itemViewPartern release];
            
            GraphicDrawView *itemLine = [[GraphicDrawView alloc] initWithFrame:CGRectMake(0, 0, itemView.frame.size.width, 30)];
            if (i == 0) {
                itemLine.optionDraw = @"checkoutFirstCellLine";
            } else {
                itemLine.optionDraw = @"checkoutCellLine";
            }
            itemLine.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            [itemView addSubview:itemLine];
            [itemLine release];
            
            
#pragma -mark text for each line
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 6, self.frame.size.width - 50, 20)];
            [WidgetControl setLabelStyle:textLabel andText:[NSString stringWithFormat:[self switchTextPattern:[self switchTextPattern:[arrayString objectAtIndex:3]]], [arrayString objectAtIndex:1], [arrayString objectAtIndex:2]] andTextAlignment:@"left" andFont:[UIFont systemFontOfSize:15] andTextColor:[UIColor whiteColor] andBackgroundColor:[UIColor clearColor] andShadowColor:[UIColor colorWithWhite:0 alpha:0.5] andShadowOffset:CGSizeMake(0, 1)];
            textLabel.tag = 10+i;
            textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            
            CGSize priceLabelTextSize = [textLabel.text sizeWithFont:textLabel.font];
            CGFloat priceLabelWidth = 0;
            if ([self switchBool:[arrayString objectAtIndex:4]]) {
                priceLabelWidth = priceLabelTextSize.width;
            }
            UIView *strikeLine = [[UIView alloc] initWithFrame:CGRectMake(0, textLabel.frame.size.height/2, priceLabelWidth, 2)];
            strikeLine.tag = 20+i;
            strikeLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
            [textLabel addSubview:strikeLine];
            [strikeLine release];
            
            [itemView addSubview:textLabel];
            [textLabel release];
            
            RCSwitchOnOff *switchOnOff = [[RCSwitchOnOff alloc] initWithFrame:CGRectMake(itemView.frame.size.width-82, 3, 80, 54)];
            [switchOnOff setOn:[self switchBool:[arrayString objectAtIndex:4]]];
            [switchOnOff addTarget:self action:@selector(switchOnOffValues:) forControlEvents:UIControlEventValueChanged];
            switchOnOff.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            switchOnOff.tag = 30+i;
            [itemView addSubview:switchOnOff];
            [switchOnOff release];
            
            [self.contentView addSubview:itemView];
            [itemView release];
        }
        
        UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 50, 50)];
        avatarView.image = [WidgetControl makeRoundCornerImage:[UIImage imageNamed:@"avatar"] :9 :9];
        avatarView.layer.cornerRadius = 9.0;
        avatarView.layer.borderWidth = 1;
        avatarView.layer.borderColor = [[UIColor colorWithRed:189/255.0f green:189/255.0f blue:189/255.0f alpha:1] CGColor];
        [avatarView.layer setShadowOffset:CGSizeMake(1, 1)];
        [avatarView.layer setShadowOpacity:0.4];
        [avatarView.layer setShadowRadius:0];
        [avatarView.layer setShadowColor:[[UIColor whiteColor] CGColor]];
        [avatarView.layer setShouldRasterize:YES];
        [avatarView.layer setCornerRadius:7.0f];
        [avatarView.layer setShadowPath:
         [[UIBezierPath bezierPathWithRoundedRect:[avatarView bounds] cornerRadius:7.0f] CGPath]];
        
        [self.contentView addSubview:avatarView];
        [avatarView release];
        
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) { 

    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    //self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 300);
    //NSLog(@"%f", self.contentView.frame.size.width);
    //self.widthItem = self.contentView.frame.size.width;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
