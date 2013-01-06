//
//  Event.m
//  WhoPaidfor
//
//  Created by user on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"
#import "SBJsonParser.h"
@implementation Event
#define SERVER_URL @"http://nghexaydung.com/whopaid/public/"
static Event *_instance = nil;  // <-- important 
@synthesize _id, _name, _user_id, idEvent; 
+(Event *)instance
{ 
	// skip everything
	if(_instance) return _instance; 
    
	// Singleton
	@synchronized([Event class]) 
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

-(NSMutableArray *)getDatasWS:(NSInteger)user_id
{
    NSMutableArray *listData = [[NSMutableArray alloc] init ];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/event/getlistbyuser?user_id=%d",SERVER_URL, user_id];
    NSLog(@"get event list: %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSArray *results = [parser objectWithString:json_string error:nil];
    for (NSDictionary *obj in results)
    {
        NSString *name = [NSString stringWithFormat:@"%@#%@#%@#%@#%@#%d#%d", [obj objectForKey:@"id"], [obj objectForKey:@"name"], [obj objectForKey:@"description"],[obj objectForKey:@"created"], [obj objectForKey:@"totalamount"],[[obj objectForKey:@"active"] intValue], [[obj objectForKey:@"owner_id"] intValue] ];
        [listData addObject:name]; 
    }
    return listData;
}
-(NSMutableArray *)getDatas:(NSInteger)user_id
{
    NSMutableArray *listData = [[NSMutableArray alloc] init ];
    sqlite3 *database;
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            const char *sql = "select e.id, e.name, e.description from events e INNER JOIN user_event ue ON ue.event_id = e.id WHERE ue.user_id = ? and e.publish = 0";
            sqlite3_stmt *compliledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compliledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compliledStatement, 1, user_id);
                while (sqlite3_step(compliledStatement) == SQLITE_ROW) {
                    @try {
                        int key = sqlite3_column_int(compliledStatement, 0);
                        NSString *name = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 1)] retain];
                         NSString *description = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 2)] retain];
                        NSString *objRow = [[NSString stringWithFormat:@"%d#%@#%@", key, name, description ] retain];
                        [listData addObject:objRow];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"Error in read events %@",exception);
                        continue;
                    }
                    @finally {
                        sqlite3_close(database);
                    }
                }
            }
            sqlite3_finalize(compliledStatement);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception error when loading data from table repeat %@",exception);
    }
    @finally {
        sqlite3_close(database);		
    }
    return listData;
}
-(int) addEventWS:(NSInteger)user_id eventName:(NSString *)name eventDescription:(NSString *)description
{
    Event *event = [Event instance];
    name = [name stringByReplacingOccurrencesOfString:@" "
                                           withString:@"%20"];
    description = [description stringByReplacingOccurrencesOfString:@" "
                                                         withString:@"%20"];
    NSString *url = [NSString stringWithFormat:@"%@event/add?name=%@&description=%@&user_id=%d",SERVER_URL,name, description,user_id];
    //NSString *contents = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]];
    NSLog(@"link add event %@",url);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSArray *obj = [parser objectWithString:json_string error:nil];
    event._id = [[obj objectForKey:@"event_id"] intValue];
    event._name = [obj objectForKey:@"event_name"];
    return  event._id;
}
-(int) addEvent:(NSInteger)user_id eventName:(NSString *)name eventDescription:(NSString *)description
{
    Helper *helper = [[Helper alloc] init];
    NSString *uuid = [helper generateUuidString];
    NSString *currentTime = [helper getCurrentTime];
    int event_id = 0;
    sqlite3 *database;
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        const char *sqlStatement;
        sqlite3_stmt *compiledStatement = nil;
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            const char *sqlStatement = "insert into events(name, description,created,uuid,publish) values(?,?, ?, ?, 0 )";
            if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_text( compiledStatement, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text( compiledStatement, 2, [description UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 3, [currentTime  UTF8String ], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 4, [uuid UTF8String ], -1, SQLITE_TRANSIENT);
            }
            if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                NSLog(@"ERROR: %s", sqlite3_errmsg(database));
            }else {
                event_id = sqlite3_last_insert_rowid(database);
                sqlite3_finalize(compiledStatement);
                sqlStatement = "insert into user_event(user_id,event_id) values(?, ? )";
                if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                    sqlite3_bind_int(compiledStatement, 1, user_id);
                    sqlite3_bind_int(compiledStatement, 2, event_id);
                    sqlite3_step(compiledStatement);
                }
                sqlite3_finalize(compiledStatement);
                sqlStatement = "insert into sync(data_time, sync_time, sync_table,sync_id,sync_type) values(?,'','event',?,1 )";
                if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                    sqlite3_bind_text(compiledStatement, 1, [currentTime  UTF8String ], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(compiledStatement, 2, [uuid UTF8String ], -1, SQLITE_TRANSIENT);
                }  
                if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                    NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                }
            }
        } 
        sqlite3_finalize(compiledStatement);
    }    
    @catch (NSException *exception) {
        NSLog(@"Exception error when loading data from table repeat %@",exception);
    }
    @finally {
        sqlite3_close(database);		
    }   
    
    return event_id;
}
-(void)updateEventWS:(int)event_id userId:(int)user_id Name:(NSString *)name Description:(NSString *)description
{
    Event *event = [Event instance];
    name = [name stringByReplacingOccurrencesOfString:@" "
                                           withString:@"%20"];
    description = [description stringByReplacingOccurrencesOfString:@" "
                                                         withString:@"%20"];
    NSString *url = [NSString stringWithFormat:@"%@event/add?id=%d&name=%@&description=%@&user_id=%d",SERVER_URL,event_id,name, description,user_id];
    //NSString *contents = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]];
    NSLog(@"link update event %@",url);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSArray *obj = [parser objectWithString:json_string error:nil];
    event._id = [[obj objectForKey:@"event_id"] intValue];
    event._name = [obj objectForKey:@"event_name"];
    //return  event._id;
}
-(void)updateEvent:(int)event_id Name:(NSString *)name Description:(NSString *)description
{
    sqlite3 *database;
    NSInteger _id =0;
    Helper *helper = [[Helper alloc] init];
    NSString *currentTime = [helper getCurrentTime];
    NSString *uuid = @"";
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            const char *sql = "select uuid from events where id=?";
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compiledStatement, 1, event_id);
                if(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    uuid = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)] retain];
                }
                sqlite3_finalize(compiledStatement);
                //update event
                name = [name stringByReplacingOccurrencesOfString:@" "
                                                       withString:@"%20"];
                description = [description stringByReplacingOccurrencesOfString:@" "
                                                                     withString:@"%20"];
                sql = "update events set name= ?, description=? where id = ?";
                if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                    sqlite3_bind_text(compiledStatement, 1, [name UTF8String ], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(compiledStatement, 2, [description UTF8String ], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(compiledStatement, 3, event_id);
                    if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                        NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                    }else {
                        sqlite3_finalize(compiledStatement);
                        sql = "insert into sync(data_time, sync_time, sync_table,sync_id,sync_type) values(?,'','event',?,2 )";
                        if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                            sqlite3_bind_text(compiledStatement, 1, [currentTime UTF8String ], -1, SQLITE_TRANSIENT);
                            sqlite3_bind_text(compiledStatement, 2, [uuid UTF8String ], -1, SQLITE_TRANSIENT);
                        }  
                        if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                            NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                        }    
                    }
                }
            }
            sqlite3_finalize(compiledStatement);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception error when loading data from table repeat %@",exception);
    }
    @finally {
        sqlite3_close(database);		
    } 
}

-(void)deleteEventWS:(NSInteger)event_id userId:(NSInteger)user_id
{
    NSString *url = [NSString stringWithFormat:@"%@event/remove?id=%d&user_id=%d",SERVER_URL,event_id,user_id];
    NSLog(@"link delete event %@",url);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    //NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    //NSArray *obj = [parser objectWithString:json_string error:nil];
}

-(void)deleteEvent:(NSInteger)event_id userId:(NSInteger)user_id
{
    sqlite3 *database;
    NSInteger _id =0;
    Helper *helper = [[Helper alloc] init];
    NSString *currentTime = [helper getCurrentTime];
    NSString *uuid = @"";
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            const char *sql = "select uuid from events where id=?";
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compiledStatement, 1, event_id);
                if(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    uuid = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)] retain];
                }
                sqlite3_finalize(compiledStatement);
                //update event
                sql = "update events set publish=1 where id = ?";
                if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                    sqlite3_bind_int(compiledStatement, 1, event_id);
                    if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                        NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                    }else {
                        sqlite3_finalize(compiledStatement);
                        sql = "insert into sync(data_time, sync_time, sync_table,sync_id,sync_type) values(?,'','event',?,3 )";
                        if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                            sqlite3_bind_text(compiledStatement, 1, [currentTime UTF8String ], -1, SQLITE_TRANSIENT);
                            sqlite3_bind_text(compiledStatement, 2, [uuid UTF8String ], -1, SQLITE_TRANSIENT);
                        }  
                        if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                            NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                        }    
                    }
                }
            }
            sqlite3_finalize(compiledStatement);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception error when loading data from table repeat %@",exception);
    }
    @finally {
        sqlite3_close(database);		
    } 
}
@end
