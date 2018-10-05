//
//  ChickenClass.h
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 11/14/15
//
//  Copyright (c) 2015 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------

@interface ChickenClass : CALayer{
    CCSprite* imageOfChickens;
}

// -----------------------------------------------------------------
// properties
@property (nonatomic, strong) CCSprite* imageOfChickens;
// -----------------------------------------------------------------
// methods
-(BOOL)dieOfChickens;
+ (instancetype)node;
- (instancetype)init;

// -----------------------------------------------------------------

@end




