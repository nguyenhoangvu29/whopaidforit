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

@end
