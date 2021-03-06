//
//  KNSemiModalViewController.h
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//


#define kSemiModalAnimationDuration   0.5
#define kSemiModalDidShowNotification @"kSemiModalDidShowNotification"
#define kSemiModalDidHideNotification @"kSemiModalDidHideNotification"
#define kSemiModalWasResizedNotification @"kSemiModalWasResizedNotification"
@interface UIViewController (KNSemiModal)

-(void)presentSemiViewController:(UIViewController*)vc andHeight:(CGFloat)oHeight;
-(void)presentSemiView:(UIView*)vc andHeight:(CGFloat)oHeight;
-(void)dismissSemiModalView;
-(void)resizeSemiView:(CGSize)newSize;

@end

// Convenient category method to find actual ViewController that contains a view

@interface UIView (FindUIViewController)
- (UIViewController *) containingViewController;
- (id) traverseResponderChainForUIViewController;
@end