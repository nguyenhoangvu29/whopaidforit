//
//  User.h
//  WhoPaid
//
//  Created by user on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SQLiteDataProvider.h"
#import "Event.h"
#import "Helper.h"

@interface User : NSObject
{
    int _id;
    NSString *_name;
    NSString *_username;
    int _tab;
}
@property(nonatomic) int _id;
@property(nonatomic) int _tab;
@property(nonatomic, retain) NSString *_name;
@property(nonatomic, retain) NSString *_email;
@property(nonatomic, retain) NSString *_username;
@property(nonatomic, retain) NSString *page;

// methods
+ (User *)instance;
-(NSString *) loginWS:(NSString *)username  passwd:(NSString *)passwd;
-(NSString *) login:(NSString *)username  passwd:(NSString *)passwd;
-(NSMutableArray *) getMemberByEventWS:(int)event_id;
-(NSMutableArray *) getMemberByEvent:(int)event_id;
-(NSInteger) addMemberWS:(NSInteger)event_id Name:(NSString *)name Email:(NSString *)email;
-(NSInteger) addMember:(NSInteger)event_id Name:(NSString *)name Email:(NSString *)email;
-(NSString *) getAccountWS:(int) user_id;
-(NSString *) getAccount:(int) user_id;
-(void)updateAccountWS:(NSInteger)member_id Name:(NSString *)name Email:(NSString *)email Password:(NSString *)password;
-(void)updateAccount:(NSInteger)member_id Name:(NSString *)name Email:(NSString *)email Password:(NSString *)password;
-(void) deleteMemberWS:(NSInteger)member_id eventId:(NSInteger)event_id userId:(NSInteger)user_id;

@end
