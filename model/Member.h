//
//  Member.h
//  ICTP
//
//  Created by user on 9/28/12.
//  Copyright (c) 2012 ICTP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SQLiteDataProvider.h"
#import "Event.h"
#import "Helper.h"
@interface Member : NSObject
{
    NSString *name;
    NSString *email;
    int _id;
    NSString *price;
}
@property(nonatomic) int _id;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *email;
@property(nonatomic, retain) NSString *price;

// methods
+ (Member *)instance;
@end
