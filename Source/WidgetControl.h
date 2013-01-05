//
//  WidgetControl.h
//  Test
//
//  Created by Tonny Dam on 10/11/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface WidgetControl : NSObject
+ (void) setLabelStyle:(UILabel *) label andText:(NSString *) text andTextAlignment:(NSString *) textalignment andFont:(UIFont *) font andTextColor:(UIColor *) textcolor andBackgroundColor:(UIColor *) backgroundcolor andShadowColor:(UIColor *) shadowcolor andShadowOffset:(CGSize) shadowoffset;

+ (UIImage *)gradientImage: (CGFloat) height andTopColor:(UIColor *)topColor andBottomColor:(UIColor *) bottomColor;

+(UIImage *)makeRoundCornerImage:(UIImage*)img :(int) cornerWidth :(int) cornerHeight;

+(void)setBackgroundImageNavigationBar:(UINavigationBar*) navigationBar andImage:(UIImage *)image;

+(UIButton*)makeButton:(NSString*)title andFont:(UIFont*) font andColor:(UIColor*)color andImage:(UIImage*)image andBackground:(UIImage*) backgroundImage andHightlightBackground:(UIImage*)hoverImage;
+(NSString*) formatCurrency:(NSString*) string addCurency:(BOOL)currency;
//personal style
+(void)setPersonalStyle:(id)sender;

+(UIButton*)makePersonalBarButton;

+(UIButton*)makePersonalBackBarButton;

+(void)setPersonalTextfieldStyle:(UITextField*)textfield;

@end
