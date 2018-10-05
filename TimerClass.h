//
//  TimerClass.h
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

@interface TimerClass : CALayer{
    NSDate* start;
    NSDate* end;
}

// -----------------------------------------------------------------
// properties

// -----------------------------------------------------------------
// methods
-(void)startTime;
-(void)stopTime;

-(void)releaseStopTime;
-(void)releaseStartTime;
-(double)timeElapsedInSeconds;
-(double)timeElapsedInMiliseconds;
-(double)timeElapsedInMinutes;

+ (instancetype)node;
- (instancetype)init;

// -----------------------------------------------------------------

@end




