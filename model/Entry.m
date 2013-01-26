//
//  Entry.m
//  WhoPaidfor
//
//  Created by user on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Entry.h"
#import "SBJsonParser.h"
@implementation Entry
#define SERVER_URL @"http://dj-daituongvn.com/whopaid/public/"
static Entry *_instance = nil;  // <-- important 
@synthesize _id, _user_id, _event_id, _enpenses_type_id, _amount, _description; 
+(Entry *)instance
{ 
	// skip everything
	if(_instance) return _instance; 
    
	// Singleton
	@synchronized([Entry class]) 
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
-(NSMutableArray *)getDatasWS:(int)event_id
{
    NSMutableArray *listData = [[NSMutableArray alloc] init ];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    Helper *helper = [Helper instance];
    NSString *url = [NSString stringWithFormat:@"%@/expenses/getlistbyevent?event_id=%d", SERVER_URL, event_id]; 
    NSLog(@" get list entries %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSArray *results = [parser objectWithString:json_string error:nil];
    for (NSDictionary *obj in results)
    {
        NSString *money = [helper stringToMoney:[[obj objectForKey:@"totalamount"] doubleValue]];
        NSString *name = [NSString stringWithFormat:@"%d#%@#%@#%@#€%@#%@", [[obj objectForKey:@"id"] intValue], [obj objectForKey:@"created"], money, [obj objectForKey:@"description"], [obj objectForKey:@"user_name"], [obj objectForKey:@"totalpeople"] ];
        //NSString *objRow = [[NSString stringWithFormat:@"%d#%@#%@#%@#%@#%d", key, date, amount, description, user_name,total ] retain];
        NSLog(@"money %@",money);
        [listData addObject:name]; 
    }
    return listData;
}

-(NSMutableArray *)getDatas:(int)event_id
{
    NSMutableArray *listData = [[NSMutableArray alloc] init ];
    sqlite3 *database;
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            const char *sql = "select e.id, e.date_expenses, e.amount, e.description, u.name as user_name, sum(p.quantity) as total from expenses e INNER JOIN users u ON u.id = e.user_id INNER JOIN participants p ON p.expenses_id = e.id WHERE e.event_id = ? and e.publish = 0 group by e.id";
            sqlite3_stmt *compliledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compliledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compliledStatement, 1, event_id);
                while (sqlite3_step(compliledStatement) == SQLITE_ROW) {
                    @try {
                        int key = sqlite3_column_int(compliledStatement, 0);
                        NSString *date = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 1)] retain];
                        NSString *amount = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 2)] retain];
                        NSString *description = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 3)] retain];
                        NSString *user_name = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 4)] retain];
                        int *total = sqlite3_column_int(compliledStatement, 5);
                        NSString *objRow = [[NSString stringWithFormat:@"%d#%@#%@#%@#%@#%d", key, date, amount, description, user_name,total ] retain];
                        [listData addObject:objRow];
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
    return listData;
}

-(NSString *) getDetailWS:(int)entry_id
{
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/expenses/getexpenseinfo?expenses_id=%d",SERVER_URL, entry_id];
    NSLog(@"get event list: %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSArray *results = [parser objectWithString:json_string error:nil];
    NSArray *obj = [parser objectWithString:json_string error:nil];
    NSString *name = [NSString stringWithFormat:@"%d#%@#%@#%@#%@#%d#%d#%d", [[obj objectForKey:@"id"] intValue], [obj objectForKey:@"date_expenses"], [obj objectForKey:@"amount"],[obj objectForKey:@"description"],[obj objectForKey:@"user_name"],[[obj objectForKey:@"total"] intValue],[[obj objectForKey:@"user_id"] intValue], [[obj objectForKey:@"owner_id"] intValue] ];
    
    //[NSString stringWithFormat:@"%@#%@#%@", [obj objectForKey:@"id"], [obj objectForKey:@"name"], [obj 
    return name;
}

-(NSString *) getDetail:(int)entry_id
{
    NSString *objRow = @"";
    sqlite3 *database;
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            const char *sql = "select e.id, e.date_expenses, e.amount, e.description, u.name as user_name, sum(p.quantity) as total, e.user_id from expenses e INNER JOIN users u ON u.id = e.user_id INNER JOIN participants p ON p.expenses_id = e.id WHERE e.id = ? and e.publish = 0 group by e.id";
            sqlite3_stmt *compliledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compliledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compliledStatement, 1, entry_id);
                while (sqlite3_step(compliledStatement) == SQLITE_ROW) {
                    @try {
                        int key = sqlite3_column_int(compliledStatement, 0);
                        NSString *date = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 1)] retain];
                        NSString *amount = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 2)] retain];
                        NSString *description = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 3)] retain];
                        NSString *user_name = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 4)] retain];
                        int total = sqlite3_column_int(compliledStatement, 5);
                        int user_id = sqlite3_column_int(compliledStatement, 6);
                        //objRow = [NSString stringWithFormat:@"%d#%@#%d#%@#%@#%d", key, date, amount, description, user_name, total];
                        objRow = [NSString stringWithFormat:@"%d#%@#%@#%@#%@#%d#%d", key, date, amount,description,user_name,total,user_id];
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

-(int) addEntryWS:(int)user_id Amount:(NSString *)amount Description:(NSString *)description DateExpenses:(NSString *)date_expense eventId:(int)event_id paidFor:(int)paidFor ParticipantStr:(NSString *)parStr
{
    Helper *helper = [Helper instance];
    description = [description stringByReplacingOccurrencesOfString:@" "
                                           withString:@"%20"];
    amount = [helper moneyToString:amount];
    NSString *url = [NSString stringWithFormat:@"id=%d&event_id=%d&user_id=%d&description=%@&member=%@&date=%@&amount=%@&paid_id=%d", 0, event_id, user_id, description, parStr, date_expense, amount, paidFor];
    url = [NSString stringWithFormat:@"%@/expenses/add?%@",SERVER_URL,url];
    NSLog(@"save entry: %@", url);
    NSString *contents = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]];
}
-(int) addEntry:(int)user_id Amount:(NSString *)amount Description:(NSString *)description DateExpenses:(NSString *)date_expense eventId:(int)event_id paidFor:(int)paidFor
{
    Helper *helper = [Helper instance];
    NSString *uuid = [helper generateUuidString];
    NSString *currentTime = [helper getCurrentTime];
    int entry_id = 0;
    sqlite3 *database;
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        const char *sqlStatement;
        sqlite3_stmt *compiledStatement = nil;
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            const char *sqlStatement = "insert into expenses(amount,description,date_expenses,event_id, user_id,uuid,settled) values(?, ?, ?, ?,?,?,0 )";
            if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_text(compiledStatement, 1, [amount  UTF8String ], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 2, [description  UTF8String ], -1, SQLITE_TRANSIENT);
                sqlite3_bind_text(compiledStatement, 3, [date_expense  UTF8String ], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(compiledStatement, 4, event_id);
                sqlite3_bind_int(compiledStatement, 5, paidFor);
                sqlite3_bind_text(compiledStatement, 6, [uuid  UTF8String ], -1, SQLITE_TRANSIENT);
            }
            if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                NSLog(@"ERROR: %s", sqlite3_errmsg(database));
            }else {
                entry_id = sqlite3_last_insert_rowid(database);
                sqlite3_finalize(compiledStatement);
                sqlStatement = "insert into sync(data_time, sync_time, sync_table,sync_id,sync_type) values(?,'','expenses',?,1 )";
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
       
    
    return entry_id;
}
-(void)updateEntryWS:(NSInteger)entry_id UserId:(int)user_id Amount:(NSNumber*)amount Description:(NSString*)description DateExpenses:(NSString *)date_expense eventId:(int)event_id paidFor:(NSInteger)paidFor ParticipantStr:(NSString *)parStr
{
    Helper *helper = [Helper instance];
    description = [description stringByReplacingOccurrencesOfString:@" "
                                                         withString:@"%20"];
    amount = [helper moneyToString:amount];
    NSString *url = [NSString stringWithFormat:@"id=%d&event_id=%d&user_id=%d&description=%@&member=%@&date=%@&amount=%@&paid_id=%d", entry_id, event_id, user_id, description, parStr, date_expense, amount, paidFor];
    url = [NSString stringWithFormat:@"%@/expenses/add?%@",SERVER_URL,url];
    NSLog(@"save entry: %@", url);
    NSString *contents = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]];
}

-(void)updateEntry:(NSInteger)entry_id Amount:(NSNumber*)amount Description:(NSString*)description DateExpenses:(NSString *)date_expense paidFor:(NSInteger)paidFor
{
    sqlite3 *database;
    NSInteger _id =0;
    Helper *helper = [[Helper alloc] init];
    NSString *currentTime = [helper getCurrentTime];
    NSString *uuid = @"";
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        //NSLog(@"db path =%@",databasePath);
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            const char *sql = "select uuid from expenses where id=?";
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compiledStatement, 1, entry_id);
                if(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    uuid = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)] retain];
                }
                sqlite3_finalize(compiledStatement);
                //update event
                sql = "update expenses set amount= ?, description=?, date_expenses=?, user_id=? where id = ?";
                if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                    sqlite3_bind_text(compiledStatement, 1, [amount  UTF8String ], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(compiledStatement, 2, [description UTF8String ], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(compiledStatement, 3, [date_expense UTF8String ], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(compiledStatement, 4, paidFor);
                    sqlite3_bind_int(compiledStatement, 5, entry_id);
                    if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                        NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                    }else {
                        sqlite3_finalize(compiledStatement);
                        sql = "insert into sync(data_time, sync_time, sync_table,sync_id,sync_type) values(?,'','expenses',?,2 )";
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

-(void) deleteEntryWS:(NSInteger)entry_id userId:(NSInteger)user_id
{
    NSString *url = [NSString stringWithFormat:@"%@expenses/remove?id=%d&user_id=%d",SERVER_URL,entry_id,user_id];
    NSLog(@"link delete entry %@",url);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}

-(void)deleteEntry:(NSInteger)entry_id userId:(NSInteger)user_id
{
    sqlite3 *database;
    NSInteger _id =0;
    Helper *helper = [[Helper alloc] init];
    NSString *currentTime = [helper getCurrentTime];
    NSString *uuid = @"";
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        NSLog(@"db path =%@",databasePath);
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            const char *sql = "select uuid from expenses where id=?";
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compiledStatement, 1, entry_id);
                if(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    uuid = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)] retain];
                }
                sqlite3_finalize(compiledStatement);
                //update event
                sql = "update expenses set publish=1 where id = ?";
                if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                    sqlite3_bind_int(compiledStatement, 1, entry_id);
                    if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                        NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                    }else {
                        sqlite3_finalize(compiledStatement);
                        sql = "insert into sync(data_time, sync_time, sync_table,sync_id,sync_type) values(?,'','expenses',?,3 )";
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
