//
//  SQLiteDataProvider.m
//  PAM
//
//  Created by Tan Nguyen on 9/30/10.
//  Copyright 2010 EverS Software Solution. All rights reserved.
//

#import "SQLiteDataProvider.h"


@implementation SQLiteDataProvider

static SQLiteDataProvider *_instance;


@synthesize databasePath;
#define DBNAME  @"whopaidfor.sqlite"

- (SQLiteDataProvider *) init{
	self = [super init];
	
	NSArray *documentPaths =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:DBNAME];
	
	return self;
}

- (BOOL) isDataBaseExist{
	BOOL success;
	// scan all path
	NSArray *documentPaths = 
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                        NSUserDomainMask, YES);
    // retrieve current path
	NSString *documentsDir = [documentPaths objectAtIndex:0];
    // conecticate the path with the database name
	databasePath = [documentsDir stringByAppendingPathComponent:DBNAME];
    // create instance of file manager to manages all files in 
    //    current path
	NSFileManager *fileManager = [NSFileManager defaultManager];
    // check file existed or not
	success = [fileManager fileExistsAtPath:databasePath];
	[fileManager release];
	return success;
}

- (void) createDatabase{
	@try {
		
		NSArray *documentPaths = 
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                            NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		databasePath = [documentsDir stringByAppendingPathComponent:DBNAME];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *databasePathFromApp = 
        [[[NSBundle mainBundle] resourcePath] 
         stringByAppendingPathComponent:DBNAME];
        // copy file from your project's bundle to the
        // path of simulator 
		[fileManager copyItemAtPath:databasePathFromApp 
                             toPath:databasePath error:nil];	
		[fileManager release];
	}
	@catch (NSException * e) {
		NSLog(@"Exception: Could not create TRAININGDB databse %@", e );
	}
}

+ (SQLiteDataProvider *)instance{
	@synchronized(self){
		if (_instance == NULL)
			_instance = [[SQLiteDataProvider alloc] init];
    }
	return(_instance);
}


-(void) checkAndCreateDatabase{
	
	if(![self isDataBaseExist])
		[self createDatabase];
	
}


@end
