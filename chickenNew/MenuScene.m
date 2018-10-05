//
//  MenuScene.m
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 1/6/16
//
//  Copyright (c) 2016 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "MenuScene.h"

// -----------------------------------------------------------------
//CGSize size;
CGSize size2;
@implementation MenuScene

// -----------------------------------------------------------------
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    // 'layer' is an autorelease object.
    MenuScene *layer = [MenuScene node];
    // add layer as a child to scene
    [scene addChild: layer];
    // return the scene
    return scene;
}
+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    size2 = [[CCDirector sharedDirector] viewSize];
    
   CCSprite* foregroungImage = [CCSprite spriteWithImageNamed:@"fon_960х640.png"];
    foregroungImage.position = ccp(size2.width/2 , size2.height/2);
    foregroungImage.scale = 0.5;
    [self addChild:foregroungImage z:0];
    
    [self addButtonRecords];
    [self addButtonGame];
    return self;
}

-(void)addButtonRecords{
    [self stopAllActions];
    CCButton* goToRecords = [CCButton buttonWithTitle:@"Records" fontName:@"Verdana-Bold" fontSize:18];
    goToRecords.positionInPoints = ccp(size2.width/2, size2.height*5/10);
    [goToRecords setTarget:self selector:@selector(getToRecordsScene:)];
    [self addChild:goToRecords z:3];
}

-(void)getToRecordsScene:(id)sender{
//    Class SceneClass = NSClassFromString(@"RecordsOfGameScene");
    Class SceneClass = NSClassFromString(@"SceneOfRecords2");

    [[CCDirector sharedDirector] replaceScene:[SceneClass scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:1.0f]];
    
}

-(void)addButtonGame{
    [self stopAllActions];
    CCButton* goToGame = [CCButton buttonWithTitle:@"Play game" fontName:@"Verdana-Bold" fontSize:18];
    goToGame.positionInPoints = ccp(size2.width/2, size2.height*7/10);
    [goToGame setTarget:self selector:@selector(getToGameScene:)];
    [self addChild:goToGame z:3];
}

-(void)getToGameScene:(id)sender{
    Class SceneClass = NSClassFromString(@"HelloWorldScene");
    [[CCDirector sharedDirector] replaceScene:[SceneClass scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:1.0f]];
}
// -----------------------------------------------------------------

@end





