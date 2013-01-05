//
//  Participate.h
//  WhoPaidfor
//
//  Created by user on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SQLiteDataProvider.h"
#import "Helper.h"
@interface Participate : NSObject
{
    NSString *name;
    NSString *money;
    int num;
    int id_;
}
@property(nonatomic, retain) NSString *money;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, readwrite) int num;
@property(nonatomic, readwrite) int id_;
-(id)initWithID:(int)id_;

// methods
+ (Participate *)instance;
@end
