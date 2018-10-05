//
//  SafeScoreClass.m
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 11/28/15
//
//  Copyright (c) 2015 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------
float bestResult;

#import "SafeScoreClass.h"
// -----------------------------------------------------------------

@implementation SafeScoreClass
//@synthesize bestResult;
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

+(NSString*)saveScoreOfTheGame:(float)bestScoreOfScene{
    if (bestScoreOfScene > bestResult) {
        bestResult = bestScoreOfScene;
    }
    NSString* string = [[NSString stringWithFormat:@"Best time is: %f seconds", bestResult] substringToIndex:18] ;
    return string;
}

+(float)showTheBestScore{
    return bestResult;
}
//static SafeScoreClass * sharedMySingleton = NULL;
//+(SafeScoreClass *)sharedMySingleton {
//    if (!sharedMySingleton || sharedMySingleton == NULL) {
//        sharedMySingleton = [SafeScoreClass new];
//    }
//    return sharedMySingleton;
//}


// -----------------------------------------------------------------

@end





