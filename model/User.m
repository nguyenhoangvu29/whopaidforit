//
//  User.m
//  WhoPaid
//
//  Created by user on 9/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"
#import "SBJsonParser.h"
@implementation User
static User *_instance = nil;  // <-- important 
@synthesize _id, _name, _username, _tab, page;
#define SERVER_URL @"http://nghexaydung.com/whopaid/public/"
+(User *)instance
{ 
	// skip everything
	if(_instance) return _instance; 
    
	// Singleton
	@synchronized([User class]) 
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
-(NSString *) loginWS:(NSString *)username  passwd:(NSString *)passwd
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    User *user = [User instance];
    Event *event = [Event instance];
    NSString *url = [NSString stringWithFormat:@"%@user/login?username=%@&password=%@",SERVER_URL,username, passwd];
    NSLog(@"login %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSArray *obj = [parser objectWithString:json_string error:nil];
    NSString *page = [obj objectForKey:@"page"];
    if([page isEqualToString:@"addentry"]){
        user._id = [[obj objectForKey:@"id"] intValue];
        //event._id = [[obj objectForKey:@"event_id"] intValue];
        //event._name = [obj objectForKey:@"event_name"];
    }else if ([page isEqualToString:@"addevent"]) {
        user._id = [[obj objectForKey:@"id"] intValue];
    }else if ([page isEqualToString:@"listentries"]) {
        user._id = [[obj objectForKey:@"id"] intValue];
        //event._id = [[obj objectForKey:@"event_id"] intValue];
        //event._name = [obj objectForKey:@"event_name"];
    }else if ([page isEqualToString:@"events"]) {
        user._id = [[obj objectForKey:@"id"] intValue];
        //event._id = [[obj objectForKey:@"event_id"] intValue];
        //event._name = [obj objectForKey:@"event_name"];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" 
                                                        message:@"Your account is wrong, please try again"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    return page;
}
-(NSString *) login:(NSString *)username  passwd:(NSString *)passwd
{
    sqlite3 *database ;
    NSString *response = @"";
    User *user = [User instance];
    Event *event = [Event instance];
    Helper *helper = [[Helper alloc] init];
    NSString *currentTime = [helper getCurrentTime];
    NSString *uuid = [helper generateUuidString];
    @try {		
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        NSLog(@"database path %@",databasePath);
        const char *sqlStatement;
        sqlite3_stmt *compiledStatement = nil;
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            sqlStatement = "select id,name, mail_address from users where  mail_address = ? and password = ? and publish = 0";
            if(sqlite3_prepare_v2(database, sqlStatement, -1,
                                  &compiledStatement, NULL) == SQLITE_OK) {                
                sqlite3_bind_text( compiledStatement, 1, 
                                  [username UTF8String], -1, SQLITE_TRANSIENT);			
                sqlite3_bind_text(compiledStatement, 2, [passwd UTF8String], -1, SQLITE_TRANSIENT);
            }
            //right username and password
            if(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                @try {
                    int key = sqlite3_column_int(compiledStatement, 0);
                    NSString *name = [[NSString stringWithUTF8String:
                                       (char *)sqlite3_column_text(compiledStatement, 1)] retain];
                    NSString *email = [[NSString stringWithUTF8String:
                                        (char *)sqlite3_column_text(compiledStatement, 2)] retain];
                    user._id = key;
                    user._name = name;
                    //get lastest event
                    sqlStatement = "select events.id, events.name from events INNER JOIN user_event ue ON ue.event_id = events.id where ue.user_id = ? and events.publish = 0 order by events.id desc";
                    if(sqlite3_prepare_v2(database, sqlStatement, -1,
                                          &compiledStatement, NULL) == SQLITE_OK) {
                        sqlite3_bind_int(compiledStatement, 1, key);
                    }
                    if(sqlite3_step(compiledStatement) == SQLITE_ROW) {                        
                        event._id = sqlite3_column_int(compiledStatement, 0);
                        event._name = [[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStatement, 1)] retain];
                        NSLog(@"event id %d",event._id);
                        response = @"addentry";
                    }else {
                        response = @"addevent";
                    }    
                }
                @catch (NSException * e) {
                    NSLog(@"Error in read record -> %@", e);
                }
            }else {
                //check for email
                sqlStatement = "select mail_address,password, id from users where  mail_address = ? ";
                compiledStatement = nil;
                if(sqlite3_prepare_v2(database, sqlStatement, -1,
                                      &compiledStatement, NULL) == SQLITE_OK) {                
                    sqlite3_bind_text( compiledStatement, 1, 
                                      [username UTF8String], -1, SQLITE_TRANSIENT);			
                }
                if(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    @try {
                        //check if password empty
                        if ( (char *)sqlite3_column_text(compiledStatement, 1) == nil ) {
                            //update passwd
                            sqlStatement = "update users set password = ? where  mail_address = ? ";
                            compiledStatement = nil;
                            if(sqlite3_prepare_v2(database, sqlStatement, -1,
                                                  &compiledStatement, NULL) == SQLITE_OK) {                
                                sqlite3_bind_text( compiledStatement, 1, 
                                                  [passwd UTF8String], -1, SQLITE_TRANSIENT);	
                                sqlite3_bind_text( compiledStatement, 2, 
                                                  [username UTF8String], -1, SQLITE_TRANSIENT);
                            }
                            if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                                NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                            }else {
                                NSLog(@"update password %d", passwd);
                            }
                            user._id = sqlite3_column_int(compiledStatement, 2);
                            //get lastest event
                            sqlStatement = "select events.id, events.name from events INNER JOIN user_event ue ON ue.event_id = events.id where events.publish = 1 and ue.user_id = ? order by events.id desc";
                            if(sqlite3_prepare_v2(database, sqlStatement, -1,
                                                  &compiledStatement, NULL) == SQLITE_OK) {
                                sqlite3_bind_int(compiledStatement, user._id, 1);
                            }
                            if(sqlite3_step(compiledStatement) == SQLITE_ROW) {                        
                                event._id = sqlite3_column_int(compiledStatement, 0);
                                event._name = [[NSString stringWithUTF8String: (char *)sqlite3_column_text(compiledStatement, 1)] retain];
                                NSLog(@"event id %d",event._id);
                                response = @"listentries";
                            }else {
                                response = @"events";
                            }
                        }else{
                            //wrong pasword
                            response = @"wrong";
                            
                        }
                    }
                    @catch (NSException *exception) {
                        //password empty
                        NSLog(@"%@",exception);
                    }
                    
                }else {
                    //create new user
                    sqlStatement = "insert into users(name,mail_address,password,created,uuid,publish) values(?,?,?,?,?,0)";
                    if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                        NSArray *name = [username componentsSeparatedByString:@"@"];
                        sqlite3_bind_text(compiledStatement, 1, [[name objectAtIndex:0] UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(compiledStatement, 2, [username UTF8String ], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(compiledStatement, 3, [passwd UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(compiledStatement, 4, [currentTime UTF8String], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(compiledStatement, 5, [uuid UTF8String], -1, SQLITE_TRANSIENT);
                    }
                    if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                        NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                    }else{
                        user._id = sqlite3_last_insert_rowid(database);
                        sqlite3_finalize(compiledStatement);
                        sqlStatement = "insert into sync(data_time, sync_time, sync_table,sync_id,sync_type) values(?,'','user',?,1 )";
                        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                            sqlite3_bind_text(compiledStatement, 1, [currentTime  UTF8String ], -1, SQLITE_TRANSIENT);
                            sqlite3_bind_text(compiledStatement, 2, [uuid UTF8String ], -1, SQLITE_TRANSIENT);
                        }  
                        if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                            NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                        }
                    }
                    
                    response = @"addevent";
                }    
            }	
            sqlite3_finalize(compiledStatement);
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: error in save data to table product -> %@", e);
    }
    @finally {
        sqlite3_close(database);
    }
    return response;
}

-(NSMutableArray *) getMemberByEventWS:(int)event_id
{
    NSMutableArray *listData = [[NSMutableArray alloc] init ];
    Event *event = [Event instance];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/user/getmemberbyevent?event_id=%d",SERVER_URL, event._id];
    NSLog(@" get member by event: %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSDictionary *object = [parser objectWithString:json_string error:nil];
    NSArray *results = [parser objectWithString:json_string error:nil];
    NSMutableArray *listUser = [[NSMutableArray alloc] init ];
    int i=0;
    for (NSDictionary *obj in results)
    {
        
        NSString *objRow = [[NSString stringWithFormat:@"%d#%@#%@#%d", [[obj objectForKey:@"user_id"] intValue], [obj objectForKey:@"name"], [obj objectForKey:@"mail_address"], [[obj objectForKey:@"active"] intValue] ] retain];
        [listData addObject:objRow];
    }
    return listData;
}

-(NSMutableArray *) getMemberByEvent:(int)event_id
{
    NSMutableArray *listData = [[NSMutableArray alloc] init ];
    sqlite3 *database;
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            const char *sql = "select u.id, u.name, u.mail_address from users u INNER JOIN user_event ue ON ue.user_id = u.id where ue.event_id = ?";
            //NSLog(@"sql get member %@",sql);
            sqlite3_stmt *compliledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compliledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compliledStatement, 1, event_id);
                while (sqlite3_step(compliledStatement) == SQLITE_ROW) {
                    @try {
                        int key = sqlite3_column_int(compliledStatement, 0);
                        NSString *name = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 1)] retain];
                        NSString *email = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 2)] retain];
                        NSString *objRow = [[NSString stringWithFormat:@"%d#%@#%@", key, name, email] retain];
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

-(NSInteger) addMemberWS:(NSInteger)event_id Name:(NSString *)name Email:(NSString *)email
{
    User *user = [User instance];
    name = [name stringByReplacingOccurrencesOfString:@" "
                                           withString:@"%20"];
    NSString *url = [NSString stringWithFormat:@"%@user/addmember?name=%@&email=%@&event_id=%d&user_id=%d",SERVER_URL,name, email, event_id, user._id];
    NSLog(@"\nAdd Member %@",url);
    //NSString *contents = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}    
-(NSInteger) addMember:(NSInteger)event_id Name:(NSString *)name Email:(NSString *)email
{
    sqlite3 *database;
    int _id =0;
    Helper *helper = [[Helper alloc] init];
    NSString *currentTime = [helper getCurrentTime];
    NSString *uuid = [helper generateUuidString];
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            const char *sql = "insert into users(name,mail_address,created,uuid) values(?,?,?,?)";
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_text(compiledStatement, 1, [name UTF8String ], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 2, [email UTF8String ], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 3, [currentTime UTF8String ], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 4, [uuid UTF8String ], -1, SQLITE_TRANSIENT);
                if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                    NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                }else {
                    _id = sqlite3_last_insert_rowid(database);
                    sqlite3_finalize(compiledStatement);
                    sql = "insert into user_event(user_id, event_id) values(?,?)";
                    if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                        sqlite3_bind_int(compiledStatement, 1, _id);
                        sqlite3_bind_int(compiledStatement, 2, event_id);
                    }
                    if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                        NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                    }
                    sqlite3_finalize(compiledStatement);
                    sql = "insert into sync(data_time, sync_time, sync_table,sync_id,sync_type) values(?,'','user',?,1 )";
                    if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
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
    }
    @catch (NSException *exception) {
        NSLog(@"Exception error when loading data from table repeat %@",exception);
    }
    @finally {
        sqlite3_close(database);		
    } 
    return _id;
}
-(void)updateMemberWS:(int)member_id Name:(NSString *)name Email:(NSString *)email
{
    User *user = [User instance];
    Event *event = [Event instance];
    name = [name stringByReplacingOccurrencesOfString:@" "
                                           withString:@"%20"];
    NSString *url = [NSString stringWithFormat:@"%@user/addmember?id=%d&name=%@&email=%@&event_id=%d&user_id=%d",SERVER_URL,member_id,name, email, event._id, user._id];
    NSLog(@"\nUpdate Member %@",url);
    //NSString *contents = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}
-(void)updateMember:(NSInteger)member_id Name:(NSString *)name Email:(NSString *)email
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
            const char *sql = "select uuid from users where id=?";
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compiledStatement, 1, member_id);
                if(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    uuid = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)] retain];
                }
                sqlite3_finalize(compiledStatement);
                //update member
                sql = "update users set name= ?, email=? where id = ?";
                if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                    sqlite3_bind_text(compiledStatement, 1, [name UTF8String ], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(compiledStatement, 2, [email UTF8String ], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(compiledStatement, 3, member_id);
                    if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                        NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                    }else {
                        sqlite3_finalize(compiledStatement);
                        sql = "insert into sync(data_time, sync_time, sync_table,sync_id,sync_type) values(?,'','user',?,2 )";
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
-(NSString *) getAccountWS:(int) user_id
{
    NSString *objRow = @"";
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@user/getuserinfo?id=%d",SERVER_URL,user_id];
    NSLog(@"get account info: %@", url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSDictionary *obj = [parser objectWithString:json_string error:nil];
    NSArray *user_info = [obj objectForKey:@"properties"];
    for (NSDictionary *info in user_info) {
        objRow = [NSString stringWithFormat:@"%@#%@#%@", [info valueForKey:@"name"], [info valueForKey:@"mail_address"], @""];
    }
    return objRow;
}
-(NSString *) getAccount:(int) user_id
{
    NSString *objRow = @"";
    sqlite3 *database;
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            const char *sql = "select name, mail_address,password from users where id= ?";
            sqlite3_stmt *compliledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compliledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compliledStatement, 1, user_id);
                while (sqlite3_step(compliledStatement) == SQLITE_ROW) {
                    @try {
                        NSString *name = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 0)] retain];
                        NSString *emal = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 1)] retain];
                        NSString *password = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 2)] retain];
                        objRow = [NSString stringWithFormat:@"%@#%@#%@", name, emal, password];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"Error in read events %@",exception);
                        continue;
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
    return objRow;
}
-(void)updateAccountWS:(NSInteger)member_id Name:(NSString *)name Email:(NSString *)email Password:(NSString *)password
{
    
}
-(void)updateAccount:(NSInteger)member_id Name:(NSString *)name Email:(NSString *)email Password:(NSString *)password
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
            const char *sql = "select uuid from users where id=?";
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compiledStatement, 1, member_id);
                if(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    uuid = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)] retain];
                }
                sqlite3_finalize(compiledStatement);
                //update member
                if(password)
                    sql = "update users set name= ?, mail_address=?,password=? where id = ?";
                else
                    sql = "update users set name= ?, mail_address=? where id = ?";
                if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                    sqlite3_bind_text(compiledStatement, 1, [name UTF8String ], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(compiledStatement, 2, [email UTF8String ], -1, SQLITE_TRANSIENT);
                    if(password){
                        sqlite3_bind_text(compiledStatement, 3, [password UTF8String ], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_int(compiledStatement, 4, member_id);
                    }else {
                        sqlite3_bind_int(compiledStatement, 3, member_id);
                    }
                    
                    if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                        NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                    }else {
                        sqlite3_finalize(compiledStatement);
                        sql = "insert into sync(data_time, sync_time, sync_table,sync_id,sync_type) values(?,'','user',?,2 )";
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
