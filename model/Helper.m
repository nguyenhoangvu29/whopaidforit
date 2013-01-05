//
//  Helper.m
//  WhoPaidfor
//
//  Created by user on 10/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Helper.h"

@implementation Helper

static Helper *_instance = nil;  // <-- important 

+(Helper *)instance
{ 
	// skip everything
	if(_instance) return _instance; 
    
	// Singleton
	@synchronized([Helper class]) 
	{
		if(!_instance)
		{
			_instance = [[self alloc] init];
            
            //	NSLog(@"Creating global instance!"); <-- You should see this once only in your program
		}
        
		return _instance;
	}
    
	return nil;
}

// return a new autoreleased UUID string
- (NSString *)generateUuidString
{
    // create a new UUID which you own
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    
    // create a new CFStringRef (toll-free bridged to NSString)
    // that you own
    NSString *uuidString = (NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    
    // transfer ownership of the string
    // to the autorelease pool
    [uuidString autorelease];
    
    // release the UUID
    CFRelease(uuid);
    
    return uuidString;
}
-(NSString *)getCurrentTime
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];

    dateString = [formatter stringFromDate:[NSDate date]];
    
    return  dateString;
}
-(NSString *)convertDatetoString:(NSString *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myDate =[dateFormat dateFromString:date];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    date = [dateFormat stringFromDate:myDate];
    return date;
}
-(NSString *)convertStringtoDate:(NSString *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    NSDate *myDate =[dateFormat dateFromString:date];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    date = [dateFormat stringFromDate:myDate];
    return date;
}
-(NSString *)stringToMoney:(double) money
{
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    //[currencyFormatter setCurrencyCode:@"NL"];
    [currencyFormatter setNegativePrefix:@"-"];
    [currencyFormatter setNegativeSuffix:@""];
    [currencyFormatter setCurrencyDecimalSeparator:@","];
    [currencyFormatter setCurrencyGroupingSeparator:@"."];
    [currencyFormatter setCurrencySymbol:@""];
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString *response = [currencyFormatter stringFromNumber:[NSNumber numberWithDouble:money]];
    [currencyFormatter release];
    NSLog(response);
    return response;
}
-(NSString *)moneyToString:(NSString *) money
{
    money = [money stringByReplacingOccurrencesOfString:@"." withString:@""];
    money = [money stringByReplacingOccurrencesOfString:@"," withString:@"."];
    return money;
}
@end
