
#import <UIKit/UIKit.h>


@interface RCSwitch : UIControl {
	UIImage *knobImage;
	UIImage *knobImagePressed;
	
	UIImage *sliderOff;
	UIImage *sliderOn;
	
	float percent, oldPercent;
	float knobWidth;
	float endcapWidth;
	CGPoint startPoint;
	float scale;
    float drawHeight;
	float animationDuration;
	
	CGSize lastBoundsSize;
	
	NSDate *endDate;
	BOOL mustFlip;
    
}

/* Common initialization method for initWithFrame: and initWithCoder: */
- (void)initCommon;

/* Override to regenerate anything you need when the view changes sizes */
- (void)regenerateImages;

/* Override to draw your own custom text or graphics in the track */
- (void)drawUnderlayersInRect:(CGRect)aRect withOffset:(float)offset inTrackWidth:(float)trackWidth;
@property(readwrite,assign) float knobWidth;

- (void)setOn:(BOOL)aBool animated:(BOOL)animated;
@property(readwrite,assign,getter=isOn) BOOL on;

@end
