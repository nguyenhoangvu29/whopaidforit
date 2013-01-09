//
//  Event.h
//  WhoPaidfor
//
//  Created by user on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SQLiteDataProvider.h"
#import "Helper.h"
@interface Event : NSObject
{
    int _id;
    int idEvent;
    int _user_id;
    NSString *_name;
}
@property(nonatomic) int _id;
@property(nonatomic) int idEvent;
@property(nonatomic) int _user_id;
@property(nonatomic, retain) NSString *_name;

// methods
+ (Event *)instance;
-(NSMutableArray *)getDatasWS:(NSInteger)user_id;
-(NSMutableArray *)getDatas:(NSInteger)user_id;
-(int) addEventWS:(NSInteger)user_id eventName:(NSString *)name eventDescription:(NSString *)description;
-(int) addEvent:(NSInteger)user_id eventName:(NSString *)name eventDescription:(NSString *)description;
-(void)updateEventWS:(int)event_id userId:(int)user_id Name:(NSString *)name Description:(NSString *)description;
-(void)updateEvent:(int)event_id Name:(NSString *)name Description:(NSString *)description;
-(void)deleteEventWS:(NSInteger)event_id userId:(NSInteger)user_id;
-(void)deleteEvent:(NSInteger)event_id userId:(NSInteger)user_id;
-(void)activeEvent:(NSInteger)user_id eventId:(NSInteger)event_id;
@end
