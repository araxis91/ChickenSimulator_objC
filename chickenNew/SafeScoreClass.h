//
//  SafeScoreClass.h
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 11/28/15
//
//  Copyright (c) 2015 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
//#import "cocos2d.h"

//#import "HelloWorldScene.h"

// -----------------------------------------------------------------

@interface SafeScoreClass : CALayer
{
  // float bestResult;
}
// -----------------------------------------------------------------
// properties
//@property (assign) float bestResult;
//@property (nonatomic) float bestResult;
// -----------------------------------------------------------------
// methods

//+ (instancetype)node;
- (instancetype)init;
+(NSString*)saveScoreOfTheGame:(float)bestScoreOfScene;
+(float)showTheBestScore;
//+(SafeScoreClass *)sharedMySingleton;
// -----------------------------------------------------------------

@end




