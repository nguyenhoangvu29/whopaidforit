//
//  Checkout.m
//  Test
//
//  Created by admin on 10/31/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "Checkout.h"
#import "SBJsonParser.h"
@implementation Checkout
#define SERVER_URL @"http://nghexaydung.com/whopaid/public/"
static Checkout *_instance = nil;  // <-- important
@synthesize _id, _user_id, _event_id, _enpenses_type_id, _amount, _description;
+(Checkout *)instance
{
	// skip everything
	if(_instance) return _instance;
    
	// Singleton
	@synchronized([Checkout class])
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
-(NSMutableArray *)getCheckoutWS:(int)event_id
{
    NSMutableArray *listData = [[NSMutableArray alloc] init ];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/checkout/getinfocheckout?event_id=%d",SERVER_URL, event_id];
    NSLog(@"get checkout: %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSArray *results = [parser objectWithString:json_string error:nil];
    for (NSDictionary *obj in results)
    {
        NSString *objRow = [[NSString stringWithFormat:@"%d#%d#%@#%@#%@#%d#%d", [[obj objectForKey:@"id"] intValue], [[obj objectForKey:@"user_id"] intValue] , [obj objectForKey:@"user_name"], [obj objectForKey:@"member_name"],[obj objectForKey:@"amount"], [[obj objectForKey:@"quantity"] intValue], [[obj objectForKey:@"member_id"] intValue] ] retain];
        [listData addObject:objRow];
       
    }
    NSLog(@"number row in checkout %d", [listData count]);
    return listData;
}
-(NSMutableArray *)getCheckout:(int)event_id
{
    NSMutableArray *listData = [[NSMutableArray alloc] init ];
    sqlite3 *database;
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            const char *sql = "SELECT `expenses`.id as id,`expenses`.user_id as user_id, us.name as user_create_name , (select name from users where pa.user_id=users.id ) as member_name,sum (round( (expenses.amount / (select sum(par.quantity) from participants par where expenses.id = par.expenses_id ) ),2) * pa.quantity ) AS `amount_member`, `pa`.`quantity`, `pa`.`user_id` AS `member_id` FROM `expenses` INNER JOIN `users` AS `us` ON us.id = expenses.user_id INNER JOIN `participants` AS `pa` ON pa.expenses_id = expenses.id WHERE (expenses.publish = 0 and expenses.event_id = ? and member_id<>`expenses`.user_id) group by `expenses`.user_id, `member_id`";
            //expenses.settled = 0 and
            sqlite3_stmt *compliledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compliledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compliledStatement, 1, event_id);
                while (sqlite3_step(compliledStatement) == SQLITE_ROW) {
                    @try {
                        int key = sqlite3_column_int(compliledStatement, 0);
                        int user_id = sqlite3_column_int(compliledStatement, 1);
                        NSString *user_name = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 2)] retain];
                        NSString *member_name = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 3)] retain];
                        NSString *amount = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 4)] retain];
                        int quantity = sqlite3_column_int(compliledStatement, 5);
                        int member_id = sqlite3_column_int(compliledStatement, 6);
                        NSString *objRow = [[NSString stringWithFormat:@"%d#%d#%@#%@#%@#%d#%d", key, user_id, user_name, member_name, amount, quantity, member_id] retain];
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
-(NSMutableArray *)getDatasWS:(int)event_id
{
    NSMutableArray *listData = [[NSMutableArray alloc] init ];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/checkout/getlistchekout?event_id=%d",SERVER_URL, event_id];
    NSLog(@"get checkout list: %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSArray *results = [parser objectWithString:json_string error:nil];
    for (NSDictionary *obj in results)
    {
        NSString *ch = [NSString stringWithFormat:@"%d#%@#%@",[[obj objectForKey:@"id"] intValue], [obj objectForKey:@"date"], [obj objectForKey:@"username"]];
        NSLog(@"link %@",ch);
        [listData addObject: ch];
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
            const char *sql = "SELECT c.id, c.date, u.`name` FROM `checkout` c INNER JOIN `users` u ON u.id = c.user_id WHERE (c.event_id = ? ) ";
            sqlite3_stmt *compliledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compliledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compliledStatement, 1, event_id);
                while (sqlite3_step(compliledStatement) == SQLITE_ROW) {
                    @try {
                        int key = sqlite3_column_int(compliledStatement, 0);
                        NSString *date = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 1)] retain];
                        NSString *user_name = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 2)] retain];
                        NSString *objRow = [[NSString stringWithFormat:@"%d#%@#%@", key, date, user_name] retain];
                        [listData addObject:objRow];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"Error in read checkout %@",exception);
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
-(NSMutableArray *) getDetailWS:(int)checkout_id
{
    Helper *helper = [Helper instance];
    NSMutableArray *listData = [[NSMutableArray alloc] init ];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@checkout/getchekoutinfo?checkout_id=%d",SERVER_URL,checkout_id];
    NSLog(@"get checkout detail %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    NSArray *results = [parser objectWithString:json_string error:nil];
    NSString *amount = @"";
    NSString *member_amount = @"";
    for (NSDictionary *obj in results)
    {   
        amount = [helper stringToMoney:[[obj objectForKey:@"amount"] doubleValue]];
        member_amount = [helper stringToMoney:[[obj objectForKey:@"member_amount"] doubleValue]];
        NSString *objRow = [NSString stringWithFormat:@"%d#%@#%@#%d#%@#%d#%@#%d", [[obj objectForKey:@"user_id"] intValue], [obj objectForKey:@"user_name"], amount , 1, member_amount, [[obj objectForKey:@"status"] intValue],[obj objectForKey:@"member_name"], [[obj objectForKey:@"member_id"] intValue] ];
        [listData addObject:objRow];
        
    }
    return listData;
}    
-(NSMutableArray *) getDetail:(int)checkout_id
{
    NSMutableArray *listData = [[NSMutableArray alloc] init ];
    NSMutableArray *listItem = [[NSMutableArray alloc] init ];
    sqlite3 *database;
    @try {
        [[SQLiteDataProvider instance] checkAndCreateDatabase];
        NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
            const char *sql = "select e.user_id, u.name, e.amount, p.quantity, p.status, m.name, p.user_id from checkout c INNER JOIN checkout_expenses ce ON ce.checkout_id = c.id INNER JOIN expenses e ON e.id = ce.expenses_id INNER JOIN users u ON u.id = e.user_id INNER JOIN participants p On p.expenses_id = e.id INNER JOIN users m ON m.id = p.user_id WHERE c.id = ?";
            sqlite3_stmt *compliledStatement;
            if(sqlite3_prepare_v2(database, sql, -1, &compliledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_int(compliledStatement, 1, checkout_id);
                int member = 0;
                while (sqlite3_step(compliledStatement) == SQLITE_ROW) {
                    @try {
                        int key = sqlite3_column_int(compliledStatement,0);
                        NSString *user_name = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 1)] retain];
                        double amount = sqlite3_column_double(compliledStatement, 2);
                        double quantity = sqlite3_column_double(compliledStatement, 3);
                        int status = sqlite3_column_int(compliledStatement, 4);
                        NSString *member_name = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compliledStatement, 5)] retain];
                        int member_id = sqlite3_column_int(compliledStatement,6);
                        int number = 0;
                        if(amount > 0) 
                            number = 1;
                        
                        NSString *objRow = [NSString stringWithFormat:@"%d#%@#%.02f#%d#%.02f#%d#%@#%d", key, user_name, amount, number, quantity, status, member_name, member_id ];
                        [listData addObject:objRow];
                    }
                    @catch (NSException *exception) {
                        NSLog(@"Error in read events %@",exception);
                        continue;
                    }
                    member++;
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
-(int) addCheckoutWS:(int)user_id EventId:(int)event_id ArrayExpenses:(NSMutableArray *)listExpenses ArrayParticipate:(NSMutableArray *)listParticipate
{
    NSString *url = [NSString stringWithFormat:@"%@checkout/addinfocheckout?event_id=%d&user_id=%d",SERVER_URL,event_id, user_id];
    NSString *contents = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]];
}
-(int) addCheckout:(int)user_id EventId:(int)event_id ArrayExpenses:(NSMutableArray *)listExpenses ArrayParticipate:(NSMutableArray *)listParticipate
{
    Helper *helper = [[Helper alloc] init];
    NSString *uuid = [helper generateUuidString];
    NSString *currentTime = [helper getCurrentTime];
    int checkout_id = 0;
    int expense_id = 0; 
    sqlite3 *database;
    [[SQLiteDataProvider instance] checkAndCreateDatabase];
    NSString *databasePath = [[SQLiteDataProvider instance] databasePath];
    //NSLog(@"database path %@",databasePath);
    const char *sqlStatement;
    sqlite3_stmt *compiledStatement = nil;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        
        // add into checkout
        sqlStatement = "insert into checkout(date, user_id, event_id, uuid) values(?, ?, ?, ? )";
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
            sqlite3_bind_text(compiledStatement, 1, [currentTime  UTF8String ], -1, SQLITE_TRANSIENT);
            sqlite3_bind_int(compiledStatement, 2, user_id);
            sqlite3_bind_int(compiledStatement, 3, event_id);
            sqlite3_bind_text(compiledStatement, 4, [uuid  UTF8String ], -1, SQLITE_TRANSIENT);
        }
        if(sqlite3_step(compiledStatement) != SQLITE_DONE){
            NSLog(@"ERROR: %s", sqlite3_errmsg(database));
        }else {
            checkout_id = sqlite3_last_insert_rowid(database);
            sqlite3_finalize(compiledStatement);
            
            //update current expenses
            sqlStatement = "update expenses set settled=1, date_settled=?,check_out_id=?, publish=1 where event_id=? and settled=0";
            if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                sqlite3_bind_text(compiledStatement, 1, [currentTime  UTF8String ], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(compiledStatement, 2, checkout_id);
                sqlite3_bind_int(compiledStatement, 3, event_id);
            }
            if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                NSLog(@"ERROR: %s", sqlite3_errmsg(database));
            }
            sqlite3_finalize(compiledStatement);
            
            for(int i=0;i < [listExpenses count];i++)
            {
                NSString *value = [listExpenses objectAtIndex:i];
                NSArray *column = [value componentsSeparatedByString:@"#"];
                NSString *amount = [column objectAtIndex:2];
                sqlStatement = "insert into expenses(event_id,user_id,expenses_type_id,check_out_id,date_expenses,amount,settled,publish,uuid) values(?,?,1,0,?,?,0,1,?)";
                if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                    sqlite3_bind_int(compiledStatement, 1, event_id);
                    sqlite3_bind_int(compiledStatement, 2, [[column objectAtIndex:0] intValue]);
                    sqlite3_bind_text(compiledStatement, 3, [currentTime  UTF8String ], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(compiledStatement, 4, [amount UTF8String ], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(compiledStatement, 5, [uuid UTF8String ], -1, SQLITE_TRANSIENT);
                }
                if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                    NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                }
                expense_id = sqlite3_last_insert_rowid(database);
                sqlite3_finalize(compiledStatement);
                sqlStatement = "insert into checkout_expenses(checkout_id,expenses_id) values(?,?)";
                if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                    sqlite3_bind_int(compiledStatement, 1, checkout_id);
                    sqlite3_bind_int(compiledStatement, 2, expense_id);
                }
                if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                    NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                }
                sqlite3_finalize(compiledStatement);
                NSLog(@"sub item %d",[[listParticipate objectAtIndex:i] count]);
                for (int j=0; j<[[listParticipate objectAtIndex:i] count]; j++) 
                {
                    NSString *valueItem = [[listParticipate objectAtIndex:i] objectAtIndex:j];
                    NSLog(@"item %@",valueItem);
                    NSArray *columnItem = [valueItem componentsSeparatedByString:@"#"];
                    sqlStatement = "insert into participants(expenses_id,user_id,quantity,date_created,created_by,`status`,`ispaid`) values(?,?,?,?,?,?,0)";
                    if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK){
                        sqlite3_bind_int(compiledStatement, 1, expense_id);
                        sqlite3_bind_int(compiledStatement, 2, [[columnItem objectAtIndex:0] intValue] );
                        sqlite3_bind_text(compiledStatement, 3, [[columnItem objectAtIndex:2] UTF8String ], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_text(compiledStatement, 4, [currentTime  UTF8String ], -1, SQLITE_TRANSIENT);
                        sqlite3_bind_int(compiledStatement, 5, user_id);
                        sqlite3_bind_int(compiledStatement, 6, [[columnItem objectAtIndex:3] intValue]);
                    }
                    if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                        NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                    }
                    sqlite3_finalize(compiledStatement);
                }
            }
            
        }
    }
    
    return checkout_id;
}
-(void)updateCheckout:(NSInteger)checkout_id Amount:(NSString*)amount Description:(NSString*)description paidFor:(NSInteger)paidFor
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
                sqlite3_bind_int(compiledStatement, 1, checkout_id);
                if(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    uuid = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)] retain];
                }
                //update event
                sql = "update expenses set amount= ?, description=?,user_id=? where id = ?";
                if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                    sqlite3_bind_text(compiledStatement, 1, [amount UTF8String ], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_text(compiledStatement, 2, [description UTF8String ], -1, SQLITE_TRANSIENT);
                    sqlite3_bind_int(compiledStatement, 3, paidFor);
                    sqlite3_bind_int(compiledStatement, 4, checkout_id);
                    if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                        NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                    }else {
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
}
-(void)deleteCheckout:(NSInteger)checkout_id userId:(NSInteger)user_id
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
                sqlite3_bind_int(compiledStatement, 1, checkout_id);
                if(sqlite3_step(compiledStatement) == SQLITE_ROW){
                    uuid = [[NSString stringWithUTF8String:(char *) sqlite3_column_text(compiledStatement, 0)] retain];
                }
                //update event
                sql = "update expenses set publish=1 where id = ?";
                if(sqlite3_prepare_v2(database, sql, -1, &compiledStatement, NULL) == SQLITE_OK){
                    sqlite3_bind_int(compiledStatement, 1, checkout_id);
                    if(sqlite3_step(compiledStatement) != SQLITE_DONE){
                        NSLog(@"ERROR: %s", sqlite3_errmsg(database));
                    }else {
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
}
@end
