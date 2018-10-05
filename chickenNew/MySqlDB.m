//
//  MySqlDB.m
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 1/19/16
//
//  Copyright (c) 2016 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "MySqlDB.h"

// -----------------------------------------------------------------

@implementation MySqlDB

// -----------------------------------------------------------------

+ (instancetype)node
{
    
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    
    
    
    return self;
}

// -----------------------------------------------------------------

@end





