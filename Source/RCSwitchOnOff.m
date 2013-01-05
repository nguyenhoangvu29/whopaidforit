

#import "RCSwitchOnOff.h"


@implementation RCSwitchOnOff

- (void)initCommon
{
	[super initCommon];
	onText = [UILabel new];
	onText.text = NSLocalizedString(@"YES", @"Switch localized string");
	onText.textColor = [UIColor colorWithRed:198/255.0f green:100/255.0f blue:29/255.0f alpha:1];
	onText.font = [UIFont boldSystemFontOfSize:11];
	onText.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
    onText.shadowOffset = CGSizeMake(0, 1);
	
	offText = [UILabel new];
	offText.text = NSLocalizedString(@"NO", @"Switch localized string");
	offText.textColor = [UIColor colorWithRed:75/255.0f green:75/255.0f blue:75/255.0f alpha:1.0];
	offText.font = [UIFont boldSystemFontOfSize:11];
	offText.shadowColor = [UIColor colorWithWhite:1 alpha:0.5];
    offText.shadowOffset = CGSizeMake(0, 1);
	
}


- (void)drawUnderlayersInRect:(CGRect)aRect withOffset:(float)offset inTrackWidth:(float)trackWidth
{
	{
		CGRect textRect = [self bounds];
        textRect.size = CGSizeMake(74, 40);
		textRect.origin.x += 9.0 + (offset - trackWidth);
        textRect.origin.y = textRect.origin.y - 4;
		[onText drawTextInRect:textRect];	
	}
	
	{
		CGRect textRect = [self bounds];
        textRect.size = CGSizeMake(74, 40);
        textRect.origin.y = textRect.origin.y - 4;
		textRect.origin.x += (offset + trackWidth) + 3;
		[offText drawTextInRect:textRect];
	}	
}

@end
