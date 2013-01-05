//
//  WidgetControl.m
//  Test
//
//  Created by Tonny Dam on 10/11/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "WidgetControl.h"

@implementation WidgetControl

// ======================== ||
// // Internal method
// ======================== ||

UIImageView* makeImageViewForBackground(UIImage* image, id sender, int num){
    
    //ios5
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) num = num +1;
    
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:image] autorelease];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [sender insertSubview:imageView atIndex:num];
    return imageView;
}

void tabBarFontStyle(UITabBarController* customTabBarController, UIFont* font, float topheight, UIColor* color, CGSize size)
{
    for(UIView* controlLevelFirst in [customTabBarController.tabBar subviews])
    {
        
        if(![controlLevelFirst isKindOfClass:NSClassFromString(@"UITabBarButton")])
            continue;
        
        for(id controlLevelSecond in [controlLevelFirst subviews])
        {
            //[controlLevelSecond setBounds: CGRectMake(0, 0, 100, 48)];
            
            if(![controlLevelSecond isKindOfClass:NSClassFromString(@"UITabBarButtonLabel")])
                continue;
            [controlLevelSecond setShadowColor:color];
            [controlLevelSecond setShadowOffset:size];
              
            [controlLevelSecond setFont: font]; 
            [controlLevelSecond setFrame: CGRectMake(0, 0, customTabBarController.tabBar.bounds.size.width, customTabBarController.tabBar.bounds.size.height- topheight)];
            [controlLevelSecond setTextAlignment:UITextAlignmentCenter];
        }
    }
}
// ======================== ||
// // Common method
// ======================== ||

+ (void) setLabelStyle:(UILabel *) label andText:(NSString *) text andTextAlignment:(NSString *) textalignment andFont:(UIFont *) font andTextColor:(UIColor *) textcolor andBackgroundColor:(UIColor *) backgroundcolor andShadowColor:(UIColor *) shadowcolor andShadowOffset:(CGSize) shadowoffset {
    if(text) label.text = text;
    if([textalignment isEqualToString:@"left"]){
        label.textAlignment = UITextAlignmentLeft;
    } else if([textalignment isEqualToString:@"right"]){
        label.textAlignment = UITextAlignmentRight;
    } else if([textalignment isEqualToString:@"center"]){
        label.textAlignment = UITextAlignmentCenter;
    }
    if(font) label.font = font;
    if(textcolor) label.textColor = textcolor;
    label.backgroundColor = [UIColor clearColor];
    if (backgroundcolor) label.backgroundColor = backgroundcolor;
    if(shadowcolor) label.shadowColor = shadowcolor;
    label.shadowOffset = shadowoffset;
}
+ (UIImage *)gradientImage: (CGFloat) height andTopColor:(UIColor *)topColor andBottomColor:(UIColor *) bottomColor{
    CGFloat width = 2;
    //CGFloat height = height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // push context to make it current (need to do this manually because we are not drawing in a UIView)
    UIGraphicsPushContext(context);
    
    //draw gradient
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    //size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    //CGFloat components[8] = { gradientcolor }; // End color
    NSArray* components = [NSArray arrayWithObjects:
                           (id)topColor.CGColor,
                           (id)bottomColor.CGColor, nil];
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColors(rgbColorspace, (CFArrayRef)components, locations);
    CGPoint topCenter = CGPointMake(0, 0);
    CGPoint bottomCenter = CGPointMake(0, height);
    CGContextDrawLinearGradient(context, glossGradient, topCenter, bottomCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    // pop context
    UIGraphicsPopContext();
    
    // get a UIImage from the image context
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // clean up drawing environment
    UIGraphicsEndImageContext();
    
    return  gradientImage;
}
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+(UIImage *)makeRoundCornerImage : (UIImage*) img : (int) cornerWidth : (int) cornerHeight
{
	UIImage * newImage = nil;
    
	if( nil != img)
	{
		int w = img.size.width;
		int h = img.size.height;
        
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
        
		CGContextBeginPath(context);
		CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
		addRoundedRectToPath(context, rect, cornerWidth, cornerHeight);
		CGContextClosePath(context);
		CGContextClip(context);
        
		CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
        
		CGImageRef imageMasked = CGBitmapContextCreateImage(context);
		CGContextRelease(context);
		CGColorSpaceRelease(colorSpace);
		[img release];
        
		newImage = [[[UIImage imageWithCGImage:imageMasked] retain] autorelease];
		CGImageRelease(imageMasked);
	}
    
    return newImage;
}
+(void)setBackgroundImageNavigationBar:(UINavigationBar*) navigationBar andImage:(UIImage *)image{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        //ios5+
        [navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        //ios4
        UIImageView *imageView = makeImageViewForBackground(image, navigationBar, 0);
        imageView.frame = navigationBar.bounds;
       
    }
}
+(UIButton*)makeButton:(NSString*)title andFont:(UIFont*) font andColor:(UIColor*)color andImage:(UIImage*)image andBackground:(UIImage*) backgroundImage andHightlightBackground:(UIImage*)hoverImage {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    if(hoverImage) [button setBackgroundImage:hoverImage forState:UIControlStateHighlighted];
    if(image) [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    [button sizeToFit];
    return button;
}
+(NSString*) formatCurrency:(NSString*) string addCurency:(BOOL)currency{
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSLocale *locale_input = [[NSLocale alloc] initWithLocaleIdentifier:@"us_US"];
    NSLocale *locale_output = [[NSLocale alloc] initWithLocaleIdentifier:@"nl_NL"];
    [formatter setLocale:locale_input];
    currency == YES ? [formatter setCurrencySymbol:@"€"] : [formatter setCurrencySymbol:@""];
    [formatter setLenient:YES];
    [formatter setGeneratesDecimalNumbers:YES];
    NSDecimalNumber *amount = (NSDecimalNumber*) [formatter numberFromString:[string stringByReplacingOccurrencesOfString:@"€ " withString:@""]];
    [formatter setLocale:locale_output];
    [locale_output release];
    [locale_input release];
    string = [formatter stringFromNumber:amount];
    [formatter release];
    return string;
}
// ======================== ||
// // Personal style
// ======================== ||

+(void)setPersonalStyle:(id)sender{
    if ([sender isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController*)sender;
        UIImageView *imageView = makeImageViewForBackground([UIImage imageNamed:@"tabbar"], tabBarController.tabBar, 0);
        imageView.frame = tabBarController.tabBar.bounds;
        for (UIViewController *obj in tabBarController.viewControllers) {
            obj.tabBarItem.imageInsets = UIEdgeInsetsMake(2, 0, -2, 0);
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
                //ios5+
                [obj.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Ubuntu" size:12.5], UITextAttributeFont, [UIColor blackColor], UITextAttributeTextShadowColor, [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset, nil] forState:UIControlStateNormal];
            }
            
        }
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.9) {
            //ios4
            tabBarFontStyle(tabBarController, [UIFont fontWithName:@"Ubuntu" size:12.5], 32, [UIColor blackColor], CGSizeMake(0, 1));
        }
    }
    if ([sender isKindOfClass:[UITableViewController class]]) {
        UITableViewController *tableController = (UITableViewController*)sender;
        tableController.tableView.backgroundView = nil;
        tableController.tableView.backgroundColor = [UIColor whiteColor];
        //[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtb"]];
    }
    if ([sender isKindOfClass:[UIViewController class]]) {
        UIViewController *viewController = (UIViewController*)sender;
        //viewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtb"]];
        viewController.view.backgroundColor = [UIColor whiteColor];
    }
}

+(UIButton*)makePersonalBarButton{
    UIButton *button = [self makeButton:nil andFont:[UIFont boldSystemFontOfSize:12] andColor:[UIColor whiteColor] andImage:nil andBackground:[[UIImage imageNamed:@"btnnav"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] andHightlightBackground:nil];
    return button;
}
+(UIButton*)makePersonalBackBarButton{
    UIButton *button = [self makeButton:nil andFont:[UIFont boldSystemFontOfSize:12] andColor:[UIColor whiteColor] andImage:nil andBackground:[[UIImage imageNamed:@"btnnavback"] stretchableImageWithLeftCapWidth:15 topCapHeight:0] andHightlightBackground:nil];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    return button;
}

+(void)setPersonalTextfieldStyle:(UITextField*)textfield{
    textfield.borderStyle = UITextBorderStyleNone;
    textfield.layer.cornerRadius=4.0f;
    textfield.layer.masksToBounds = NO;
    textfield.backgroundColor=[UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1];
    textfield.layer.borderColor=[[UIColor colorWithRed:185/255.0f green:185/255.0f blue:185/255.0f alpha:1]CGColor];
    textfield.layer.borderWidth= 1.0f;
    
    UIView *paddingLeft = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    textfield.leftView = paddingLeft;
    textfield.leftViewMode = UITextFieldViewModeAlways;
    [paddingLeft release];
    
    UIView *behindView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, textfield.frame.size.width, textfield.frame.size.height)];
    behindView.backgroundColor = [UIColor whiteColor];
    behindView.layer.cornerRadius = 4;
    behindView.userInteractionEnabled = NO;
    [textfield insertSubview:behindView belowSubview:textfield];
    [behindView release];
}

@end
