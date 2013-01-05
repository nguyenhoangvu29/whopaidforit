//
//  SQLiteDataProvider.m
//  PAM
//
//  Created by Tan Nguyen on 9/30/10.
//  Copyright 2010 EverS Software Solution. All rights reserved.
//

#import "SQLiteDataProvider.h"

@interface SQLiteDataProvider: NSObject{

	NSString *databasePath;
}

@property (nonatomic, retain) NSString *databasePath;


-(void) checkAndCreateDatabase;
+ (SQLiteDataProvider *)instance;
- (void) createDatabase;
- (BOOL) isDataBaseExist;

@end
