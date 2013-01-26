//
//  Participate.m
//  WhoPaidfor
//
//  Created by user on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Participate.h"
#import "SBJsonParser.h"
@implementation Participate
#define SERVER_URL @"http://dj-daituongvn.com/whopaid/public/"
static Participate *_instance = nil;  // <-- important 
@synthesize name;
@synthesize num;
@synthesize money;
@synthesize id_;

-(id)initWithID:(int)id_
{
    if (self = [super init])
    {
        self.name = @"Username";
        self.num = 0;
        self.money = @"0";
        self.id_ = 0;
    }
    return self;
}

-(NSString*)description
{
    return [NSString stringWithFormat:@"name: %@, num: %d", self.name, self.num];
}

-(void)dealloc
{
    self.name = nil;
    self.money = nil;
    self.id_ = nil;
    [super dealloc];
}

+(Participate *)instance
{ 
	// skip everything
	if(_instance) return _instance; 
    
	// Singleton
	@synchronized([Participate class]) 
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
-(NSMutableArray *)getDatasWS:(int)entry_id
{
    NSMutableArray *listData = [[NSMutableArray alloc] init ];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/expenses/getparticipants?expenses_id=%d", SERVER_URL, entry_id]; 
    NSLog(@" get list participant %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSArray *results = [parser objectWithString:json_string error:nil];
    for (NSDictionary *obj in results)
    {
        NSString *name = [NSString stringWithFormat:@"%d#%@#%d", [[obj objectForKey:@"user_id"] intValue], [obj objectForKey:@"user_name"], [[obj objectForKey:@"quantity"] intValue] ];
        [listData addObject:name];
    }
    return listData;
}
-(NSMutableArray *)getDatas:(int)entry_id
{
    NSMutableArray *listData = [[NSMutableArray alloc] init ];
    sqlite3 *database;
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            const char *sql = "select p.user_id, p.quantity, u.name from participants p INNER JOIN users u ON p.user_id = u.id WHERE p.expenses_id = ?";
            sqlite3_stmt *compliledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compliledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compliledStatement, 1, entry_id);
                while (sqlite3_step(compliledStatement) == SQLITE_ROW) {
                    @try {
                        int key = sqlite3_column_int(compliledStatement, 0);
                        int quantity = sqlite3_column_int(compliledStatement, 1);
                        NSString *name = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 2)] retain];
                        NSString *objRow = [[NSString stringWithFormat:@"%d#%@#%d", key, name, quantity ] retain];
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
    return listData;
}
-(NSInteger) addParticipant:(NSInteger)expenses_id userId:(NSInteger)user_id Quantity:(NSInteger)quantity
{
    Helper *helper = [[Helper alloc] init];
    NSString *uuid = [helper generateUuidString];
    NSString *currentTime = [helper getCurrentTime];
    NSInteger event_id = 0;
    sqlite3 *database;
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        const char *sqlStatement;
        sqlite3_stmt *compiledStatement = nil;
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            const char *sqlStatement = "insert into participants(expenses_id,user_id,quantity) values(?,?,?)";
            if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compiledStatement, 1, expenses_id);
                sqlite3_bind_int(compiledStatement, 2, user_id);
                sqlite3_bind_int(compiledStatement, 3, quantity);
            }
            if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                NSLog(@"ERROR: %s", sqlite3_errmsg(database));
            }else {
                event_id = sqlite3_last_insert_rowid(database);
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
-(void)deleteParticipant:(NSInteger)expenses_id
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
            const char *sql = "delete from participants where expenses_id=?";
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compiledStatement, 1, expenses_id);
                if(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    NSLog(@"remove old participant");
                }
            }else {
                NSLog(@"can not remove participate");
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
