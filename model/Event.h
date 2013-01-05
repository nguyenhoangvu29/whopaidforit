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
@property(nonatomic) NSString *_name;

// methods
+ (Event *)instance;
@end
