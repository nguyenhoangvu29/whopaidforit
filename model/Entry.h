//
//  Entry.h
//  WhoPaidfor
//
//  Created by user on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SQLiteDataProvider.h"
#import "Event.h"
#import "Helper.h"
@interface Entry : NSObject
{
    int _id;
    int _user_id;
    int _event_id;
    float _amount;
    int _enpenses_type_id;
    NSString *_description;
}
@property(nonatomic) int _id;
@property(nonatomic) int _user_id;
@property(nonatomic) int _event_id;
@property(nonatomic) float _amount;
@property(nonatomic) int _enpenses_type_id;
@property(nonatomic) NSString *_description;

// methods
+ (Entry *)instance;
-(NSMutableArray *)getDatasWS:(int)event_id;
-(NSMutableArray *)getDatas:(int)event_id;
-(NSString *) getDetailWS:(int)entry_id;
-(NSString *) getDetail:(int)entry_id;
-(int) addEntryWS:(int)user_id Amount:(NSString *)amount Description:(NSString *)description DateExpenses:(NSString *)date_expense eventId:(int)event_id paidFor:(int)paidFor ParticipantStr:(NSString *)parStr;
-(int) addEntry:(int)user_id Amount:(NSString *)amount Description:(NSString *)description DateExpenses:(NSString *)date_expense eventId:(int)event_id paidFor:(int)paidFor;
-(void)updateEntryWS:(NSInteger)entry_id UserId:(int)user_id Amount:(NSNumber*)amount Description:(NSString*)description DateExpenses:(NSString *)date_expense eventId:(int)event_id paidFor:(NSInteger)paidFor ParticipantStr:(NSString *)parStr;
-(void)updateEntry:(NSInteger)entry_id Amount:(NSNumber*)amount Description:(NSString*)description DateExpenses:(NSString *)date_expense paidFor:(NSInteger)paidFor;
-(void) deleteEntryWS:(NSInteger)entry_id userId:(NSInteger)user_id;
-(void)deleteEntry:(NSInteger)entry_id userId:(NSInteger)user_id;

@end
