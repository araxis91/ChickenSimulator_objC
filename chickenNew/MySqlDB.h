//
//  MySqlDB.h
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 1/19/16
//
//  Copyright (c) 2016 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
// -----------------------------------------------------------------

@interface MySqlDB : NSObject
// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) NSString *idi;
@property (nonatomic, strong) NSString *nick;
@property (nonatomic, strong) NSString *score;

// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)init;

// -----------------------------------------------------------------

@end




