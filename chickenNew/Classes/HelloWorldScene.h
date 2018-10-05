//
//  HelloWorldScene.h
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
#import "cocos2d-ui.h"
#import "CCTouch.h"

#import "ChickenClass.h"
#import "TimerClass.h"
#import "SafeScoreClass.h"
#import "CCAnimationCache.h"
//#import "MenuScene.h"

// -----------------------------------------------------------------------

@interface HelloWorldScene : CCScene{
    CGSize size;
    NSMutableArray* arrayOfChickens;
    NSMutableArray* arrayOfSpeedChickens;
    NSMutableArray* arrayOfBezierChickens;
  //  float bestScoreResult;

  //  CCSprite* selectedSprite;
    BOOL isTheMoveStart;

}
// -----------------------------------------------------------------------

- (instancetype)init;
+(CCScene *) scene;
-(void)addChicken:(ChickenClass*)chicken;
-(void)addSpeedChicken:(ChickenClass*)speedChicken;
-(void)moveChicken:(CGPoint)changedPosition;
-(void)isRunning:(CCSprite*)image;
-(void)isRunningSpeedChicken:(CCSprite*)image;
-(void)foreverRepeat;
-(void)speedChickenForeverRepeat;
-(void)moveMotionStreakToTouch:(CCTouch*)touch;
-(void)glidingOfTheTouchedChicken:(CGPoint)oldTouchLocation and:(CGPoint)touchLocation;
// -----------------------------------------------------------------------

@end


































