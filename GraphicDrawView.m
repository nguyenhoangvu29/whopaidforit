
#import "GraphicDrawView.h"

@implementation GraphicDrawView
@synthesize optionDraw, optionCellDraw, optionHover, lastColor;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)didMoveToSuperview
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
}
- (void)drawRect:(CGRect)rect
{
    if ([optionDraw isEqualToString:@"checkoutCellLine"]) {
        //// General Declarations
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* white50 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.5];
        UIColor* whiteShadowColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
        
        //// Shadow Declarations
        UIColor* blackShadow = whiteShadowColor;
        CGSize blackShadowOffset = CGSizeMake(0.1, 1.1);
        CGFloat blackShadowBlurRadius = 0;
        
        //// Frames
        CGRect frame = rect;
        
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame) - 0, 2)];
        [white50 setFill];
        [rectanglePath fill];
        
        ////// Rectangle Inner Shadow
        CGRect rectangleBorderRect = CGRectInset([rectanglePath bounds], -blackShadowBlurRadius, -blackShadowBlurRadius);
        rectangleBorderRect = CGRectOffset(rectangleBorderRect, -blackShadowOffset.width, -blackShadowOffset.height);
        rectangleBorderRect = CGRectInset(CGRectUnion(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
        
        UIBezierPath* rectangleNegativePath = [UIBezierPath bezierPathWithRect: rectangleBorderRect];
        [rectangleNegativePath appendPath: rectanglePath];
        rectangleNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = blackShadowOffset.width + round(rectangleBorderRect.size.width);
            CGFloat yOffset = blackShadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        blackShadowBlurRadius,
                                        blackShadow.CGColor);
            
            [rectanglePath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rectangleBorderRect.size.width), 0);
            [rectangleNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [rectangleNegativePath fill];
        }
        CGContextRestoreGState(context);
        
    }
    else if ([optionDraw isEqualToString:@"checkoutFirstCellLine"]) {
        //// General Declarations
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* white50 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 0.5];
        
        //// Shadow Declarations
        UIColor* shadow = [UIColor blackColor];
        CGSize shadowOffset = CGSizeMake(0.1, 2.1);
        CGFloat shadowBlurRadius = 10;
        UIColor* whiteShadow = [UIColor whiteColor];
        CGSize whiteShadowOffset = CGSizeMake(0.1, 1.1);
        CGFloat whiteShadowBlurRadius = 0;
        
        //// Frames
        CGRect frame = rect;
        
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame) - 0, 3)];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
        [white50 setFill];
        [rectanglePath fill];
        
        ////// Rectangle Inner Shadow
        CGRect rectangleBorderRect = CGRectInset([rectanglePath bounds], -whiteShadowBlurRadius, -whiteShadowBlurRadius);
        rectangleBorderRect = CGRectOffset(rectangleBorderRect, -whiteShadowOffset.width, -whiteShadowOffset.height);
        rectangleBorderRect = CGRectInset(CGRectUnion(rectangleBorderRect, [rectanglePath bounds]), -1, -1);
        
        UIBezierPath* rectangleNegativePath = [UIBezierPath bezierPathWithRect: rectangleBorderRect];
        [rectangleNegativePath appendPath: rectanglePath];
        rectangleNegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = whiteShadowOffset.width + round(rectangleBorderRect.size.width);
            CGFloat yOffset = whiteShadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        whiteShadowBlurRadius,
                                        whiteShadow.CGColor);
            
            [rectanglePath addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rectangleBorderRect.size.width), 0);
            [rectangleNegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [rectangleNegativePath fill];
        }
        CGContextRestoreGState(context);
        
        CGContextRestoreGState(context);


    }
    else if ([optionDraw isEqualToString:@"checkoutCell"]) {
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* strokeColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.2];
        UIColor* shadowColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.09];
        UIColor* titleBottom = [UIColor colorWithRed: 0.87 green: 0.87 blue: 0.87 alpha: 1];
        UIColor* lastCellColor = [UIColor colorWithRed: 0 green: 0.527 blue: 0.822 alpha: 1];
        
        //// Gradient Declarations
        NSArray* gradientTitleColors = [NSArray arrayWithObjects:
                                        (id)[UIColor whiteColor].CGColor,
                                        (id)titleBottom.CGColor, nil];
        CGFloat gradientTitleLocations[] = {0, 1};
        CGGradientRef gradientTitle = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientTitleColors, gradientTitleLocations);
        
        //// Shadow Declarations
        UIColor* mainShadow = shadowColor2;
        CGSize mainShadowOffset = CGSizeMake(0.1, 3.1);
        CGFloat mainShadowBlurRadius = 3;
        
        //// Frames
        CGRect frame = rect;
        
        
        //// mainShape Drawing
        UIBezierPath* mainShapePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 0.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 10) cornerRadius: 4];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, mainShadowOffset, mainShadowBlurRadius, mainShadow.CGColor);
        [[UIColor whiteColor] setFill];
        [mainShapePath fill];
        CGContextRestoreGState(context);
        
        [strokeColor setStroke];
        mainShapePath.lineWidth = 1;
        [mainShapePath stroke];
        
        
        //// titleCell Drawing
        CGRect titleCellRect = CGRectMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 2, CGRectGetWidth(frame) - 4, 39);
        UIBezierPath* titleCellPath = [UIBezierPath bezierPathWithRoundedRect: titleCellRect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii: CGSizeMake(4, 4)];
        CGContextSaveGState(context);
        [titleCellPath addClip];
        CGContextDrawLinearGradient(context, gradientTitle,
                                    CGPointMake(CGRectGetMidX(titleCellRect), CGRectGetMinY(titleCellRect)),
                                    CGPointMake(CGRectGetMidX(titleCellRect), CGRectGetMaxY(titleCellRect)),
                                    0);
        CGContextRestoreGState(context);
        
        
        //// lastCell Drawing
        UIBezierPath* lastCellPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 2, CGRectGetMinY(frame) + 41, CGRectGetWidth(frame) - 4, CGRectGetHeight(frame) - 52) byRoundingCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii: CGSizeMake(4, 4)];
        [lastCellColor setFill];
        [lastCellPath fill];
        
        
        //// Cleanup
        CGGradientRelease(gradientTitle);
        CGColorSpaceRelease(colorSpace);

    } else if ([optionDraw isEqualToString:@"viewStyle1"]) {
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* colorStroke = [UIColor colorWithRed: 0.727 green: 0.727 blue: 0.727 alpha: 1];
        UIColor* upColor = [UIColor colorWithRed: 0.994 green: 0.994 blue: 0.994 alpha: 1];
        UIColor* downColor = [UIColor colorWithRed: 0.931 green: 0.931 blue: 0.931 alpha: 1];
        UIColor* shadowColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.2];
        
        //// Gradient Declarations
        NSArray* mainGradientColors = [NSArray arrayWithObjects:
                                       (id)upColor.CGColor,
                                       (id)downColor.CGColor, nil];
        CGFloat mainGradientLocations[] = {0, 1};
        CGGradientRef mainGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)mainGradientColors, mainGradientLocations);
        
        //// Shadow Declarations
        UIColor* mainShadow = [UIColor whiteColor];
        CGSize mainShadowOffset = CGSizeMake(1.1, 1.1);
        CGFloat mainShadowBlurRadius = 0;
        UIColor* shadow = shadowColor2;
        CGSize shadowOffset = CGSizeMake(1.1, 1.1);
        CGFloat shadowBlurRadius = 2;
        
        //// Frames
        CGRect frame = rect;
        
        
        //// Rectangle Drawing
        CGRect rectangleRect = CGRectMake(CGRectGetMinX(frame) + 3.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 7, CGRectGetHeight(frame) - 5);
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: rectangleRect];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
        CGContextBeginTransparencyLayer(context, NULL);
        [rectanglePath addClip];
        CGContextDrawLinearGradient(context, mainGradient,
                                    CGPointMake(CGRectGetMidX(rectangleRect), CGRectGetMinY(rectangleRect)),
                                    CGPointMake(CGRectGetMidX(rectangleRect), CGRectGetMaxY(rectangleRect)),
                                    0);
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);
        
        
        
        //// Rectangle 1 Drawing
        CGRect rectangle1Rect = CGRectMake(CGRectGetMinX(frame) + 3.5, CGRectGetMinY(frame) + 0.5, CGRectGetWidth(frame) - 7, floor((CGRectGetHeight(frame) - 0.5) * 0.47934 + 0.5));
        UIBezierPath* rectangle1Path = [UIBezierPath bezierPathWithRect: rectangle1Rect];
        CGContextSaveGState(context);
        [rectangle1Path addClip];
        CGContextDrawLinearGradient(context, mainGradient,
                                    CGPointMake(CGRectGetMidX(rectangle1Rect), CGRectGetMinY(rectangle1Rect)),
                                    CGPointMake(CGRectGetMidX(rectangle1Rect), CGRectGetMaxY(rectangle1Rect)),
                                    0);
        CGContextRestoreGState(context);
        
        ////// Rectangle 1 Inner Shadow
        CGRect rectangle1BorderRect = CGRectInset([rectangle1Path bounds], -mainShadowBlurRadius, -mainShadowBlurRadius);
        rectangle1BorderRect = CGRectOffset(rectangle1BorderRect, -mainShadowOffset.width, -mainShadowOffset.height);
        rectangle1BorderRect = CGRectInset(CGRectUnion(rectangle1BorderRect, [rectangle1Path bounds]), -1, -1);
        
        UIBezierPath* rectangle1NegativePath = [UIBezierPath bezierPathWithRect: rectangle1BorderRect];
        [rectangle1NegativePath appendPath: rectangle1Path];
        rectangle1NegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = mainShadowOffset.width + round(rectangle1BorderRect.size.width);
            CGFloat yOffset = mainShadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        mainShadowBlurRadius,
                                        mainShadow.CGColor);
            
            [rectangle1Path addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rectangle1BorderRect.size.width), 0);
            [rectangle1NegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [rectangle1NegativePath fill];
        }
        CGContextRestoreGState(context);
        
        [colorStroke setStroke];
        rectangle1Path.lineWidth = 1;
        [rectangle1Path stroke];
        
        
        //// Rectangle 2 Drawing
        CGRect rectangle2Rect = CGRectMake(CGRectGetMinX(frame) + 3.5, CGRectGetMinY(frame) + floor((CGRectGetHeight(frame) - 3.5) * 0.49565) + 0.5, CGRectGetWidth(frame) - 7, CGRectGetHeight(frame) - 4 - floor((CGRectGetHeight(frame) - 3.5) * 0.49565));
        UIBezierPath* rectangle2Path = [UIBezierPath bezierPathWithRect: rectangle2Rect];
        CGContextSaveGState(context);
        [rectangle2Path addClip];
        CGContextDrawLinearGradient(context, mainGradient,
                                    CGPointMake(CGRectGetMidX(rectangle2Rect), CGRectGetMinY(rectangle2Rect)),
                                    CGPointMake(CGRectGetMidX(rectangle2Rect), CGRectGetMaxY(rectangle2Rect)),
                                    0);
        CGContextRestoreGState(context);
        
        ////// Rectangle 2 Inner Shadow
        CGRect rectangle2BorderRect = CGRectInset([rectangle2Path bounds], -mainShadowBlurRadius, -mainShadowBlurRadius);
        rectangle2BorderRect = CGRectOffset(rectangle2BorderRect, -mainShadowOffset.width, -mainShadowOffset.height);
        rectangle2BorderRect = CGRectInset(CGRectUnion(rectangle2BorderRect, [rectangle2Path bounds]), -1, -1);
        
        UIBezierPath* rectangle2NegativePath = [UIBezierPath bezierPathWithRect: rectangle2BorderRect];
        [rectangle2NegativePath appendPath: rectangle2Path];
        rectangle2NegativePath.usesEvenOddFillRule = YES;
        
        CGContextSaveGState(context);
        {
            CGFloat xOffset = mainShadowOffset.width + round(rectangle2BorderRect.size.width);
            CGFloat yOffset = mainShadowOffset.height;
            CGContextSetShadowWithColor(context,
                                        CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                        mainShadowBlurRadius,
                                        mainShadow.CGColor);
            
            [rectangle2Path addClip];
            CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(rectangle2BorderRect.size.width), 0);
            [rectangle2NegativePath applyTransform: transform];
            [[UIColor grayColor] setFill];
            [rectangle2NegativePath fill];
        }
        CGContextRestoreGState(context);
        
        [colorStroke setStroke];
        rectangle2Path.lineWidth = 1;
        [rectangle2Path stroke];
        
        
        //// Cleanup
        CGGradientRelease(mainGradient);
        CGColorSpaceRelease(colorSpace);


    }
    else if ([optionDraw isEqualToString:@"viewStyle2"]) {
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* colorStroke = [UIColor colorWithRed: 0.727 green: 0.727 blue: 0.727 alpha: 1];
        UIColor* upColor = [UIColor colorWithRed: 0.994 green: 0.994 blue: 0.994 alpha: 1];
        UIColor* downColor = [UIColor colorWithRed: 0.931 green: 0.931 blue: 0.931 alpha: 1];
        UIColor* shadowColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.2];
        
        //// Gradient Declarations
        NSArray* mainGradientColors = [NSArray arrayWithObjects: 
                                       (id)upColor.CGColor, 
                                       (id)downColor.CGColor, nil];
        CGFloat mainGradientLocations[] = {0, 1};
        CGGradientRef mainGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)mainGradientColors, mainGradientLocations);
        
        //// Shadow Declarations
        UIColor* shadow = shadowColor2;
        CGSize shadowOffset = CGSizeMake(1, 2);
        CGFloat shadowBlurRadius = 2;
        
        //// Frames
        CGRect frame = rect;
        
        
        //// Rectangle Drawing
        CGRect rectangleRect = CGRectMake(CGRectGetMinX(frame) + 3.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 7, CGRectGetHeight(frame) - 5);
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRoundedRect: rectangleRect cornerRadius: 5];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
        CGContextBeginTransparencyLayer(context, NULL);
        [rectanglePath addClip];
        CGContextDrawLinearGradient(context, mainGradient,
                                    CGPointMake(CGRectGetMidX(rectangleRect), CGRectGetMinY(rectangleRect)),
                                    CGPointMake(CGRectGetMidX(rectangleRect), CGRectGetMaxY(rectangleRect)),
                                    0);
        CGContextEndTransparencyLayer(context);
        CGContextRestoreGState(context);
        
        [colorStroke setStroke];
        rectanglePath.lineWidth = 1;
        [rectanglePath stroke];
        
        
        //// Cleanup
        CGGradientRelease(mainGradient);
        CGColorSpaceRelease(colorSpace);

    }
    else if ([optionDraw isEqualToString:@"cell"]) {
        
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* topColor = [UIColor colorWithRed: 0.991 green: 0.991 blue: 0.991 alpha: 1];
        UIColor* bottomColor = [UIColor colorWithRed: 0.931 green: 0.931 blue: 0.931 alpha: 1];
        UIColor* borderColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.2];
        UIColor* topBPartColor = [UIColor colorWithRed: 0.204 green: 0.663 blue: 0.986 alpha: 1];
        UIColor* bottomBPartColor = [UIColor colorWithRed: 0.034 green: 0.335 blue: 0.707 alpha: 1];
        //UIColor* bluePartShadowColor = [UIColor colorWithRed: 0.792 green: 0.975 blue: 0.969 alpha: 0.7];
        UIColor* bluePartShadowColor = [UIColor colorWithRed: 0.792 green: 0.975 blue: 0.969 alpha: 0.7];
        UIColor* mainShapeShadowColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.1];
        UIColor* arrowShadowColor = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.5];
        UIColor* bottomHColor = [UIColor colorWithRed: 0.891 green: 0.953 blue: 0.972 alpha: 1];
        UIColor* topColorCheckout = [UIColor colorWithRed: 0.979 green: 0.944 blue: 0.827 alpha: 1];
        UIColor* bottomColorCheckout = [UIColor colorWithRed: 0.967 green: 0.911 blue: 0.723 alpha: 1];
        
        //// Gradient Declarations
        NSArray* mainGradientColors = [NSArray arrayWithObjects:
                                       (id)topColor.CGColor,
                                       (id)bottomColor.CGColor, nil];
        CGFloat mainGradientLocations[] = {0, 1};
        CGGradientRef mainGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)mainGradientColors, mainGradientLocations);
        
        NSArray* bluePartGradientColors = [NSArray arrayWithObjects:
                                           (id)topBPartColor.CGColor,
                                           (id)[UIColor colorWithRed: 0.126 green: 0.506 blue: 0.85 alpha: 1].CGColor,
                                           //(id)[UIColor darkGrayColor].CGColor,
                                           (id)bottomBPartColor.CGColor, nil];
        CGFloat bluePartGradientLocations[] = {0, 0.34, 1};
        CGGradientRef bluePartGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)bluePartGradientColors, bluePartGradientLocations);
        
        NSArray* grayPartGradientColors = [NSArray arrayWithObjects:
                                           (id)[UIColor whiteColor].CGColor,
                                           (id)[UIColor darkGrayColor].CGColor,
                                            nil];
        CGFloat grayPartGradientLocations[] = {0,1};
        CGGradientRef grayPartGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)grayPartGradientColors, grayPartGradientLocations);
        
        NSArray* mainHGradientColors = [NSArray arrayWithObjects:
                                        (id)topColor.CGColor,
                                        (id)bottomHColor.CGColor, nil];
        CGFloat mainHGradientLocations[] = {0, 1};
        CGGradientRef mainHGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)mainHGradientColors, mainHGradientLocations);
        NSArray* checkoutGradientColors = [NSArray arrayWithObjects:
                                           (id)topColorCheckout.CGColor,
                                           (id)bottomColorCheckout.CGColor, nil];
        CGFloat checkoutGradientLocations[] = {0, 1};
        CGGradientRef checkoutGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)checkoutGradientColors, checkoutGradientLocations);
        

        //// Shadow Declarations
        UIColor* bluePartShadow = bluePartShadowColor;
        CGSize bluePartShadowOffset = CGSizeMake(-1.1, 1.1);
        CGFloat bluePartShadowBlurRadius = 1;
        UIColor* outerShadowForLine = borderColor;
        CGSize outerShadowForLineOffset = CGSizeMake(-1.1, -0.1);
        CGFloat outerShadowForLineBlurRadius = 0;
        UIColor* innerShadowForLine = [UIColor whiteColor];
        CGSize innerShadowForLineOffset = CGSizeMake(1.1, -0.1);
        CGFloat innerShadowForLineBlurRadius = 0;
        UIColor* mainShapeShadow = mainShapeShadowColor;
        CGSize mainShapeShadowOffset = CGSizeMake(0.1, 3.1);
        CGFloat mainShapeShadowBlurRadius = 3;
        UIColor* arrowShadow = arrowShadowColor;
        CGSize arrowShadowOffset = CGSizeMake(-1.1, -0.1);
        CGFloat arrowShadowBlurRadius = 0;
        
        //// Frames
        CGRect frame = rect;
        
        if (!optionCellDraw || [optionCellDraw isEqualToString:@"hasCheckout"]) {
            if (optionHover){
                //// mainHShape Drawing
                CGRect mainHShapeRect = CGRectMake(CGRectGetMinX(frame) + 4.5, CGRectGetMinY(frame) + 0.5, CGRectGetWidth(frame) - 9, CGRectGetHeight(frame) - 10);
                UIBezierPath* mainHShapePath = [UIBezierPath bezierPathWithRoundedRect: mainHShapeRect cornerRadius: 5];
                CGContextSaveGState(context);
                [mainHShapePath addClip];
                CGContextDrawLinearGradient(context, mainHGradient,
                                            CGPointMake(CGRectGetMidX(mainHShapeRect), CGRectGetMinY(mainHShapeRect)),
                                            CGPointMake(CGRectGetMidX(mainHShapeRect), CGRectGetMaxY(mainHShapeRect)),
                                            0);
                CGContextRestoreGState(context);
                [borderColor setStroke];
                mainHShapePath.lineWidth = 1;
                [mainHShapePath stroke];
            } else {
            //// mainShape Drawing
            CGRect mainShapeRect = CGRectMake(CGRectGetMinX(frame) + 4.5, CGRectGetMinY(frame) + 0.5, CGRectGetWidth(frame) - 9, CGRectGetHeight(frame) - 10);
            UIBezierPath* mainShapePath = [UIBezierPath bezierPathWithRoundedRect: mainShapeRect cornerRadius: 5];
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, mainShapeShadowOffset, mainShapeShadowBlurRadius, mainShapeShadow.CGColor);
            CGContextBeginTransparencyLayer(context, NULL);
            [mainShapePath addClip];
            CGContextDrawLinearGradient(context, mainGradient,
                                        CGPointMake(CGRectGetMidX(mainShapeRect), CGRectGetMinY(mainShapeRect)),
                                        CGPointMake(CGRectGetMidX(mainShapeRect), CGRectGetMaxY(mainShapeRect)),
                                        0);
            CGContextEndTransparencyLayer(context);
            CGContextRestoreGState(context);
            
            [borderColor setStroke];
            mainShapePath.lineWidth = 1;
            [mainShapePath stroke];
            }
            
            if ([optionCellDraw isEqualToString:@"hasCheckout"]) {
                //// checkoutShape Drawing
                CGRect checkoutShapeRect = CGRectMake(CGRectGetMinX(frame) + 5, CGRectGetMinY(frame) + 1, 95, CGRectGetHeight(frame) - 11);
                UIBezierPath* checkoutShapePath = [UIBezierPath bezierPathWithRoundedRect: checkoutShapeRect byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii: CGSizeMake(4, 4)];
                CGContextSaveGState(context);
                CGContextSetShadowWithColor(context, innerShadowForLineOffset, innerShadowForLineBlurRadius, innerShadowForLine.CGColor);
                CGContextBeginTransparencyLayer(context, NULL);
                [checkoutShapePath addClip];
                CGContextDrawLinearGradient(context, checkoutGradient,
                                            CGPointMake(CGRectGetMidX(checkoutShapeRect), CGRectGetMinY(checkoutShapeRect)),
                                            CGPointMake(CGRectGetMidX(checkoutShapeRect), CGRectGetMaxY(checkoutShapeRect)),
                                            0);
                CGContextEndTransparencyLayer(context);
                
                ////// checkoutShape Inner Shadow
                CGRect checkoutShapeBorderRect = CGRectInset([checkoutShapePath bounds], -outerShadowForLineBlurRadius, -outerShadowForLineBlurRadius);
                checkoutShapeBorderRect = CGRectOffset(checkoutShapeBorderRect, -outerShadowForLineOffset.width, -outerShadowForLineOffset.height);
                checkoutShapeBorderRect = CGRectInset(CGRectUnion(checkoutShapeBorderRect, [checkoutShapePath bounds]), -1, -1);
                
                UIBezierPath* checkoutShapeNegativePath = [UIBezierPath bezierPathWithRect: checkoutShapeBorderRect];
                [checkoutShapeNegativePath appendPath: checkoutShapePath];
                checkoutShapeNegativePath.usesEvenOddFillRule = YES;
                
                CGContextSaveGState(context);
                {
                    CGFloat xOffset = outerShadowForLineOffset.width + round(checkoutShapeBorderRect.size.width);
                    CGFloat yOffset = outerShadowForLineOffset.height;
                    CGContextSetShadowWithColor(context,
                                                CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                                outerShadowForLineBlurRadius,
                                                outerShadowForLine.CGColor);
                    
                    [checkoutShapePath addClip];
                    CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(checkoutShapeBorderRect.size.width), 0);
                    [checkoutShapeNegativePath applyTransform: transform];
                    [[UIColor grayColor] setFill];
                    [checkoutShapeNegativePath fill];
                }
            }
            
        }
    
        
        if ([optionCellDraw isEqualToString:@"hasOptionAndBlueLine"] || [optionCellDraw isEqualToString:@"hasBlueLine"]) {
            //// bluePartShape Drawing
            CGRect bluePartShapeRect = CGRectMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) - 17, CGRectGetMinY(frame) + 1, 12, CGRectGetHeight(frame) - 11);
            UIBezierPath* bluePartShapePath = [UIBezierPath bezierPathWithRoundedRect: bluePartShapeRect byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: CGSizeMake(4, 4)];
            CGContextSaveGState(context);
            [bluePartShapePath addClip];
            CGContextDrawLinearGradient(context, bluePartGradient,
                                        CGPointMake(CGRectGetMidX(bluePartShapeRect), CGRectGetMinY(bluePartShapeRect)),
                                        CGPointMake(CGRectGetMidX(bluePartShapeRect), CGRectGetMaxY(bluePartShapeRect)),
                                        0);
            CGContextRestoreGState(context);
            
            ////// bluePartShape Inner Shadow
            CGRect bluePartShapeBorderRect = CGRectInset([bluePartShapePath bounds], -bluePartShadowBlurRadius, -bluePartShadowBlurRadius);
            bluePartShapeBorderRect = CGRectOffset(bluePartShapeBorderRect, -bluePartShadowOffset.width, -bluePartShadowOffset.height);
            bluePartShapeBorderRect = CGRectInset(CGRectUnion(bluePartShapeBorderRect, [bluePartShapePath bounds]), -1, -1);
            
            UIBezierPath* bluePartShapeNegativePath = [UIBezierPath bezierPathWithRect: bluePartShapeBorderRect];
            [bluePartShapeNegativePath appendPath: bluePartShapePath];
            bluePartShapeNegativePath.usesEvenOddFillRule = YES;
            
            CGContextSaveGState(context);
            {
                CGFloat xOffset = bluePartShadowOffset.width + round(bluePartShapeBorderRect.size.width);
                CGFloat yOffset = bluePartShadowOffset.height;
                CGContextSetShadowWithColor(context,
                                            CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                            bluePartShadowBlurRadius,
                                            bluePartShadow.CGColor);
                
                [bluePartShapePath addClip];
                CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(bluePartShapeBorderRect.size.width), 0);
                [bluePartShapeNegativePath applyTransform: transform];
                [[UIColor grayColor] setFill];
                [bluePartShapeNegativePath fill];
            }
            CGContextRestoreGState(context);
        
            //// Arrow Drawing
            UIBezierPath* arrowPath = [UIBezierPath bezierPath];
            [arrowPath moveToPoint: CGPointMake(CGRectGetMaxX(frame) - 12.5, CGRectGetMinY(frame) + 0.38514 * CGRectGetHeight(frame))];
            [arrowPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 10.29, CGRectGetMinY(frame) + 0.38514 * CGRectGetHeight(frame))];
            [arrowPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 8, CGRectGetMinY(frame) + 0.45946 * CGRectGetHeight(frame))];
            [arrowPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 10.29, CGRectGetMinY(frame) + 0.53378 * CGRectGetHeight(frame))];
            [arrowPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 12.5, CGRectGetMinY(frame) + 0.53378 * CGRectGetHeight(frame))];
            [arrowPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 10.29, CGRectGetMinY(frame) + 0.45946 * CGRectGetHeight(frame))];
            [arrowPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 12.5, CGRectGetMinY(frame) + 0.38514 * CGRectGetHeight(frame))];
            [arrowPath closePath];
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, arrowShadowOffset, arrowShadowBlurRadius, arrowShadow.CGColor);
            [[UIColor whiteColor] setFill];
            [arrowPath fill];
            CGContextRestoreGState(context);
            
            if ([optionCellDraw isEqualToString:@"hasOptionAndBlueLine"]){
                //// optionShape Drawing
                CGRect optionShapeRect = CGRectMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) - 100, CGRectGetMinY(frame) + 1, 2, CGRectGetHeight(frame) - 11);
                UIBezierPath* optionShapePath = [UIBezierPath bezierPathWithRect: optionShapeRect];
                CGContextSaveGState(context);
                CGContextSetShadowWithColor(context, outerShadowForLineOffset, outerShadowForLineBlurRadius, outerShadowForLine.CGColor);
                CGContextBeginTransparencyLayer(context, NULL);
                [optionShapePath addClip];
                CGContextDrawLinearGradient(context, mainGradient,
                                            CGPointMake(CGRectGetMidX(optionShapeRect), CGRectGetMinY(optionShapeRect)),
                                            CGPointMake(CGRectGetMidX(optionShapeRect), CGRectGetMaxY(optionShapeRect)),
                                            0);
                CGContextEndTransparencyLayer(context);
                
                ////// optionShape Inner Shadow
                CGRect optionShapeBorderRect = CGRectInset([optionShapePath bounds], -innerShadowForLineBlurRadius, -innerShadowForLineBlurRadius);
                optionShapeBorderRect = CGRectOffset(optionShapeBorderRect, -innerShadowForLineOffset.width, -innerShadowForLineOffset.height);
                optionShapeBorderRect = CGRectInset(CGRectUnion(optionShapeBorderRect, [optionShapePath bounds]), -1, -1);
                
                UIBezierPath* optionShapeNegativePath = [UIBezierPath bezierPathWithRect: optionShapeBorderRect];
                [optionShapeNegativePath appendPath: optionShapePath];
                optionShapeNegativePath.usesEvenOddFillRule = YES;
                
                CGContextSaveGState(context);
                {
                    CGFloat xOffset = innerShadowForLineOffset.width + round(optionShapeBorderRect.size.width);
                    CGFloat yOffset = innerShadowForLineOffset.height;
                    CGContextSetShadowWithColor(context,
                                                CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                                innerShadowForLineBlurRadius,
                                                innerShadowForLine.CGColor);
                    
                    [optionShapePath addClip];
                    CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(optionShapeBorderRect.size.width), 0);
                    [optionShapeNegativePath applyTransform: transform];
                    [[UIColor grayColor] setFill];
                    [optionShapeNegativePath fill];
                }
                CGContextRestoreGState(context);
                
                CGContextRestoreGState(context);
            }
        }
        
        if ([optionCellDraw isEqualToString:@"hasOptionAndGrayLine"] || [optionCellDraw isEqualToString:@"hasGrayLine"]) {
            //// bluePartShape Drawing
            CGRect bluePartShapeRect = CGRectMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) - 17, CGRectGetMinY(frame) + 1, 12, CGRectGetHeight(frame) - 11);
            UIBezierPath* bluePartShapePath = [UIBezierPath bezierPathWithRoundedRect: bluePartShapeRect byRoundingCorners: UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii: CGSizeMake(4, 4)];
            CGContextSaveGState(context);
            [bluePartShapePath addClip];
            CGContextDrawLinearGradient(context, grayPartGradient,
                                        CGPointMake(CGRectGetMidX(bluePartShapeRect), CGRectGetMinY(bluePartShapeRect)),
                                        CGPointMake(CGRectGetMidX(bluePartShapeRect), CGRectGetMaxY(bluePartShapeRect)),
                                        0);
            CGContextRestoreGState(context);
            
            ////// bluePartShape Inner Shadow
            CGRect bluePartShapeBorderRect = CGRectInset([bluePartShapePath bounds], -bluePartShadowBlurRadius, -bluePartShadowBlurRadius);
            bluePartShapeBorderRect = CGRectOffset(bluePartShapeBorderRect, -bluePartShadowOffset.width, -bluePartShadowOffset.height);
            bluePartShapeBorderRect = CGRectInset(CGRectUnion(bluePartShapeBorderRect, [bluePartShapePath bounds]), -1, -1);
            
            UIBezierPath* bluePartShapeNegativePath = [UIBezierPath bezierPathWithRect: bluePartShapeBorderRect];
            [bluePartShapeNegativePath appendPath: bluePartShapePath];
            bluePartShapeNegativePath.usesEvenOddFillRule = YES;
            
            CGContextSaveGState(context);
            {
                CGFloat xOffset = bluePartShadowOffset.width + round(bluePartShapeBorderRect.size.width);
                CGFloat yOffset = bluePartShadowOffset.height;
                CGContextSetShadowWithColor(context,
                                            CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                            bluePartShadowBlurRadius,
                                            bluePartShadow.CGColor);
                
                [bluePartShapePath addClip];
                CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(bluePartShapeBorderRect.size.width), 0);
                [bluePartShapeNegativePath applyTransform: transform];
                [[UIColor grayColor] setFill];
                [bluePartShapeNegativePath fill];
            }
            CGContextRestoreGState(context);
            
            //// Arrow Drawing
            UIBezierPath* arrowPath = [UIBezierPath bezierPath];
            [arrowPath moveToPoint: CGPointMake(CGRectGetMaxX(frame) - 12.5, CGRectGetMinY(frame) + 0.38514 * CGRectGetHeight(frame))];
            [arrowPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 10.29, CGRectGetMinY(frame) + 0.38514 * CGRectGetHeight(frame))];
            [arrowPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 8, CGRectGetMinY(frame) + 0.45946 * CGRectGetHeight(frame))];
            [arrowPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 10.29, CGRectGetMinY(frame) + 0.53378 * CGRectGetHeight(frame))];
            [arrowPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 12.5, CGRectGetMinY(frame) + 0.53378 * CGRectGetHeight(frame))];
            [arrowPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 10.29, CGRectGetMinY(frame) + 0.45946 * CGRectGetHeight(frame))];
            [arrowPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 12.5, CGRectGetMinY(frame) + 0.38514 * CGRectGetHeight(frame))];
            [arrowPath closePath];
            CGContextSaveGState(context);
            CGContextSetShadowWithColor(context, arrowShadowOffset, arrowShadowBlurRadius, arrowShadow.CGColor);
            [[UIColor whiteColor] setFill];
            [arrowPath fill];
            CGContextRestoreGState(context);
            
            if ([optionCellDraw isEqualToString:@"hasOptionAndGrayLine"]){
                //// optionShape Drawing
                CGRect optionShapeRect = CGRectMake(CGRectGetMinX(frame) + CGRectGetWidth(frame) - 100, CGRectGetMinY(frame) + 1, 2, CGRectGetHeight(frame) - 11);
                UIBezierPath* optionShapePath = [UIBezierPath bezierPathWithRect: optionShapeRect];
                CGContextSaveGState(context);
                CGContextSetShadowWithColor(context, outerShadowForLineOffset, outerShadowForLineBlurRadius, outerShadowForLine.CGColor);
                CGContextBeginTransparencyLayer(context, NULL);
                [optionShapePath addClip];
                CGContextDrawLinearGradient(context, mainGradient,
                                            CGPointMake(CGRectGetMidX(optionShapeRect), CGRectGetMinY(optionShapeRect)),
                                            CGPointMake(CGRectGetMidX(optionShapeRect), CGRectGetMaxY(optionShapeRect)),
                                            0);
                CGContextEndTransparencyLayer(context);
                
                ////// optionShape Inner Shadow
                CGRect optionShapeBorderRect = CGRectInset([optionShapePath bounds], -innerShadowForLineBlurRadius, -innerShadowForLineBlurRadius);
                optionShapeBorderRect = CGRectOffset(optionShapeBorderRect, -innerShadowForLineOffset.width, -innerShadowForLineOffset.height);
                optionShapeBorderRect = CGRectInset(CGRectUnion(optionShapeBorderRect, [optionShapePath bounds]), -1, -1);
                
                UIBezierPath* optionShapeNegativePath = [UIBezierPath bezierPathWithRect: optionShapeBorderRect];
                [optionShapeNegativePath appendPath: optionShapePath];
                optionShapeNegativePath.usesEvenOddFillRule = YES;
                
                CGContextSaveGState(context);
                {
                    CGFloat xOffset = innerShadowForLineOffset.width + round(optionShapeBorderRect.size.width);
                    CGFloat yOffset = innerShadowForLineOffset.height;
                    CGContextSetShadowWithColor(context,
                                                CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
                                                innerShadowForLineBlurRadius,
                                                innerShadowForLine.CGColor);
                    
                    [optionShapePath addClip];
                    CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(optionShapeBorderRect.size.width), 0);
                    [optionShapeNegativePath applyTransform: transform];
                    [[UIColor grayColor] setFill];
                    [optionShapeNegativePath fill];
                }
                CGContextRestoreGState(context);
                
                CGContextRestoreGState(context);
            }
        }
        
        //// Cleanup
        CGGradientRelease(mainGradient);
        CGGradientRelease(bluePartGradient);
        CGGradientRelease(mainHGradient);
        CGGradientRelease(checkoutGradient);
        CGColorSpaceRelease(colorSpace);


    }
    


}


@end
