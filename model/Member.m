//
//  Member.m
//  ICTP
//
//  Created by user on 9/28/12.
//  Copyright (c) 2012 ICTP. All rights reserved.
//

#import "Member.h"

@implementation Member
static Member *_instance = nil;  // <-- important 
@synthesize name;
@synthesize email;
@synthesize price;
@synthesize _id;

-(void)dealloc
{
    self._id = nil;
    self.name = nil;
    self.email = nil;
    self.price = nil;
    [super dealloc];
}

+(Member *)instance
{ 
	// skip everything
	if(_instance) return _instance; 
    
	// Singleton
	@synchronized([Member class]) 
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
@end
