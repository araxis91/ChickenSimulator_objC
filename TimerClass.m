//
//  TimerClass.m
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 11/14/15
//
//  Copyright (c) 2015 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "TimerClass.h"

// -----------------------------------------------------------------

@implementation TimerClass
//-(id)init{
//    self = [super init];
//    if (self!= nil) {
//        start = nil;
//        end = nil;
//    }
//    return self;
//}

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
    if (self!= nil) {
        start = nil;
        end = nil;
    }
    return self;
}

-(void)startTime{
    start = [NSDate date];
    [start retain];
}

-(void)stopTime{
    end = [NSDate date];
    [end retain];
}

-(void)releaseStopTime{
    if (end != nil) {
        [end release];
    }
}
-(void)releaseStartTime{
    if (start != nil) {
        [start release];
    }
}

-(double)timeElapsedInSeconds{
    return [end timeIntervalSinceDate:start];
}

-(double)timeElapsedInMiliseconds{
    return [self timeElapsedInSeconds]*1000.0f;
}

-(double)timeElapsedInMinutes{
    return [self timeElapsedInSeconds]/60.0f;
}
// -----------------------------------------------------------------

@end





