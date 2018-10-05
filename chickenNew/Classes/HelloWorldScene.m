//
//  HelloWorldScene.m
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 11/14/15
//
//  Copyright (c) 2015 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import "HelloWorldScene.h"
CCSprite* selectedSprite;

//суть переменной в том, чтобы перемещать в нее selectedSprite для выполнения с ней действия после удаления selectedSprite
CCSprite* selectedSprite2;
//CCSprite* selectedSprite3;

ChickenClass* selectedChicken;

ChickenClass* chicken0;
ChickenClass* chicken1;
ChickenClass* chicken2;
ChickenClass* chicken3;
ChickenClass* chicken4;

ChickenClass* speedChichen0;
ChickenClass* bezierChichen0;
ChickenClass* bezierChichen1;

CCSprite* backgroungImage;
CCSprite* foregroungImage;
BOOL chickenIsInTheHouse;
BOOL stopAction;
BOOL stopTheGame;
BOOL touchIsON;
float bestSeconds;
CGPoint touchLocation;
CGPoint oldTouchLocation;
CGPoint changedPosition;
id action;
CCActionInterval* speedAction;
CCActionInterval* bezierAction;

TimerClass* timer;
CCLabelTTF* timerLabel;
NSString* timerText;
CCLabelTTF *bestTimeLabel;
NSString* bestTimeText;
CCTouch* touch;
CCTouchEvent* event;

NSString* bestTimeText2;

CCActionRepeatForever *repeatingAnimation0;
CCAnimation *walkAnim;
CCAnimation *walkAnim2;


CCSprite* cat;
CCSprite* car;
CCSprite* car2;

BOOL objectWasMoved;
//BOOL turningLeft;
NSTimer* catStopTimer;

// -----------------------------------------------------------------------

@implementation HelloWorldScene
+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];
    
    // 'layer' is an autorelease object.
    HelloWorldScene *layer = [HelloWorldScene node];
    
    // add layer as a child to scene
    [scene addChild: layer];
    
    // return the scene
    return scene;
}
// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];

    // The thing is, that if this fails, your app will 99.99% crash anyways, so why bother
    // Just make an assert, so that you can catch it in debug
    
    //создание фона
    size = [[CCDirector sharedDirector] viewSize];
    
    backgroungImage = [CCSprite spriteWithImageNamed:@"fon.png"];
    backgroungImage.position = ccp(size.width/2 , size.height*0.45);
    backgroungImage.scaleX = 0.48;
    backgroungImage.scaleY = 0.41;
    [self addChild:backgroungImage z:1];
    
   // foregroungImage = [CCSprite spriteWithImageNamed:@"fon_960х640.png"];
    foregroungImage = [CCSprite spriteWithImageNamed:@"fon.png"];

    foregroungImage.position = ccp(size.width/2 , size.height/2);
    foregroungImage.scale = 0.57;
    [self addChild:foregroungImage z:5];
    
    CCSprite* les = [CCSprite spriteWithImageNamed:@"les.png"];
    les.position = ccp(size.width*0.55 , size.height*0.5);
    les.scale = 0.5;	
    [self addChild:les z:17];
    
    CCSprite* kust1 = [CCSprite spriteWithImageNamed:@"k1.png"];
    kust1.position = ccp(size.width*0.44 , size.height*0.5);
    kust1.scale = 0.5;
    [self addChild:kust1 z:16];
    
    CCSprite* kust2 = [CCSprite spriteWithImageNamed:@"k2.png"];
    kust2.position = ccp(size.width*0.44 , size.height*0.5);
    kust2.scale = 0.5;
    [self addChild:kust2 z:14];
    
    CCSprite* kust3 = [CCSprite spriteWithImageNamed:@"k3.png"];
    kust3.position = ccp(size.width*0.44 , size.height*0.5);
    kust3.scale = 0.5;
    [self addChild:kust3 z:14];
    
    cat = [CCSprite spriteWithImageNamed:@"kot1.png"];
    cat.position = ccp(size.width*0.44, size.height/2 - 20);
    cat.scale = 0.5;
    [self addChild:cat z:15];
    
    CCParticleMeteor* part = [[CCParticleMeteor alloc] init];
    [part setTotalParticles:20];
    [part setAutoRemoveOnFinish:YES];
    [part setLife:4];
    part.positionInPoints = ccp(size.width*0.5, size.height*0.45);
  //  CGRect rect = CGRectMake(size.width*0.5, size.height*0.45, 30, 40);
    [self addChild:part z:30];

    
    
    
    
    // переменная определяет, нужно ли остановить всех курочек
    stopAction = NO;
    // переменная отпределяет, началось ли движение
    isTheMoveStart = NO;

    bestSeconds = 0;
    
//включение касания
    self.userInteractionEnabled = NO;
    
    //запуск уровня через н секунд
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startLevel1) userInfo:nil repeats:NO];

//массив с реактивными курочками
    arrayOfSpeedChickens = [[NSMutableArray alloc] init];
    
//массив с курочками Безье
    arrayOfBezierChickens = [[NSMutableArray alloc] init];
    
    
    timer = [[TimerClass alloc] init];
    [timer startTime];
    timerText = [[NSString stringWithFormat:@"Timer is: %lf seconds", [timer timeElapsedInSeconds]] substringToIndex:14];
    timerLabel = [CCLabelTTF labelWithString:timerText fontName:@"AppleGothic" fontSize:20];
    timerLabel.rotation = 0;
    timerLabel.color = [CCColor cyanColor];
    timerLabel.position = ccp(size.width*0.5, size.height*0.9);
    
    [self addChild:timerLabel z:20];
    
    bestTimeText = [[NSString stringWithFormat:@"Best time is: %lf seconds", [timer timeElapsedInSeconds]] substringToIndex:14];
    bestTimeLabel = [CCLabelTTF labelWithString:bestTimeText fontName:@"AppleGothic" fontSize:20];
    bestTimeLabel = [CCLabelTTF labelWithString:[SafeScoreClass saveScoreOfTheGame:bestSeconds]
 fontName:@"AppleGothic" fontSize:20];

    bestTimeLabel.rotation = 0;
    bestTimeLabel.color = [CCColor cyanColor];
    bestTimeLabel.position = ccp(size.width*0.5, size.height*0.1);
    [self addChild:bestTimeLabel z:20];
    
    //вызов метода обновления
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self schedule:@selector(updateTenTimesPerSecond:) interval:0.1f];
    /* Код, который должен выполниться в фоне */
    });
		
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(carAnimation) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:3.4 target:self selector:@selector(carAnimation2) userInfo:nil repeats:YES];

    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(babo4ka1animation) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(babo4ka2animation) userInfo:nil repeats:NO];

    catStopTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(catAnimation) userInfo:nil repeats:YES];

    [self volnaAnimation];
    //запуск условия столкновения курочки с домиком через 5 сек
  //  [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateAfterStart) userInfo:nil repeats:NO];
    
    
    
    
    
    
    
    
    // done
    return self;
}
//-----------------------------------------------------------------------

///////////////////  Эффекты  //////////////////
-(void)carAnimation{
        car = [CCSprite spriteWithImageNamed:@"mah.png"];
        car.scale = 0.5;
        car.position = ccp(size.width + 300, size.height*0.5 + 50);
        [self addChild:car z:7];
        CCActionMoveTo* move = [CCActionMoveTo actionWithDuration:3.5 position:ccp(size.width*0.1 - 600, size.height*0.5)];
        [car runAction:move];
    car = nil;
}
-(void)carAnimation2{
    car2 = [CCSprite spriteWithImageNamed:@"mah.png"];
    car2.scale = 0.45;
    car2.flipX = YES;
    car2.position = ccp(size.width*0.1 - 300, size.height*0.6 + 70);
    [self addChild:car2 z:6];
    CCActionMoveTo* move = [CCActionMoveTo actionWithDuration:3.5 position:ccp(size.width + 600, size.height*0.6)];
    [car2 runAction:move];
    car2 = nil;
}

-(void)catCatchAnimation:(CGFloat)a and:(CGFloat)b and2:(CCSprite*)sprite{
    //остановить анимацию котика
    [catStopTimer invalidate];
    catStopTimer = nil;
    [cat stopAllActions];
    
    CCActionMoveTo* catLost1 = [CCActionMoveTo actionWithDuration:0.2 position:ccp(size.width/2 , size.height/2 - 40)];
    CCActionSequence* catLost = [CCActionSequence actions:catLost1, nil];
    [cat runAction:catLost];
    [cat setVisible:NO];
    CCSprite* cat = [CCSprite spriteWithImageNamed:@"kot2n.png"];
    cat.position = ccp(size.width*0.1 - 100, b);
    cat.scale = 0.5;
    [self addChild:cat z:20];
    
    CCActionMoveTo* moveToChicken = [[CCActionMoveTo alloc] initWithDuration:0.4 position:ccp(50, b)];
    CCActionMoveTo* moveWithChicken = [[CCActionMoveTo alloc] initWithDuration:0.4 position:ccp(size.width*0.1 - 100, b)];
    CCActionSequence* seq = [CCActionSequence actionOne:moveToChicken two:moveWithChicken];
    CCActionMoveTo* chickenOutOfScreen = [[CCActionMoveTo alloc] initWithDuration:0.4 position:ccp(a, b)];
    CCActionMoveTo* chickenOutOfScreen2 = [[CCActionMoveTo alloc] initWithDuration:0.4 position:ccp(size.width*0.1 - 100, sprite.positionInPoints.y)];
    CCActionSequence* seq2 = [CCActionSequence actionOne:chickenOutOfScreen two:chickenOutOfScreen2];
    [cat runAction:seq];

    [sprite runAction:seq2];

}




-(void)volnaAnimation{
    CCSprite* volna = [CCSprite spriteWithImageNamed:@"Voln.png"];
    volna.position = ccp(size.width*0.5 , size.height*0.45);
    volna.scaleY = 0.5;
    volna.scaleX = 0.7;
    [self addChild:volna z:14];

    ccBezierConfig bezierConf;
    bezierConf.controlPoint_1 = CGPointMake(volna.position.x +15, volna.position.y - 8);
    bezierConf.controlPoint_2 = CGPointMake(volna.position.x +10, volna.position.y + 12);
    bezierConf.endPosition = CGPointMake(volna.position.x + 5, volna.position.y - 4);
    id actionMove1 = [CCActionBezierTo actionWithDuration:3.0f bezier:bezierConf];
    CCActionInterval* volnaAction;
    volnaAction = actionMove1;

    CCActionRepeatForever* repeat = [CCActionRepeatForever actionWithAction:volnaAction];
    [volna runAction:repeat];
}

-(void)babo4ka1animation{
    CCSprite* babo4ka1 = [CCSprite spriteWithImageNamed:@"b1.png"];
    babo4ka1.position = ccp(size.width*0.5, size.height*0.45);
    babo4ka1.scale = 0.5;
    [self addChild:babo4ka1 z:14];
    int j = arc4random_uniform(251);
    int i = arc4random_uniform(101);
    ccBezierConfig bezierConf;
    bezierConf.controlPoint_1 = CGPointMake(i, j);
    j = arc4random_uniform(251);
    i = arc4random_uniform(101);
    bezierConf.controlPoint_2 = CGPointMake(i, j);
    j = arc4random_uniform(251);
    i = arc4random_uniform(101);
    bezierConf.endPosition = CGPointMake(j, j);
    id actionMove1 = [CCActionBezierTo actionWithDuration:36.0f bezier:bezierConf];
    bezierAction = actionMove1;
    
    CCActionRepeat* repeat2 = [CCActionRepeat actionWithAction:bezierAction times:2];
    [babo4ka1 runAction:repeat2];

    
}

-(void)babo4ka2animation{
    CCSprite* babo4ka2 = [CCSprite spriteWithImageNamed:@"b2.png"];
    babo4ka2.position = ccp(size.width*0.5, size.height*0.45);
    babo4ka2.scale = 0.5;
    [self addChild:babo4ka2 z:14];
    
    int j = arc4random_uniform(251);
    int i = arc4random_uniform(101);
    ccBezierConfig bezierConf;
    bezierConf.controlPoint_1 = CGPointMake(i, j);
    j = arc4random_uniform(251);
    i = arc4random_uniform(101);
    bezierConf.controlPoint_2 = CGPointMake(i, j);
    j = arc4random_uniform(251);
    i = arc4random_uniform(101);
    bezierConf.endPosition = CGPointMake(j, j);
    id actionMove1 = [CCActionBezierTo actionWithDuration:50.0f bezier:bezierConf];
    bezierAction = actionMove1;
    
    CCActionRepeat* repeat = [CCActionRepeat actionWithAction:bezierAction times:1];
    [babo4ka2 runAction:repeat];
}

-(void)addBullk:(CGFloat)x and:(CGFloat)y{
    CCSprite* plyh = [CCSprite spriteWithImageNamed:@"plyh1.png"];
 //   plyh.positionInPoints = ccp(size.width/2, size.height/2);

    plyh.anchorPoint = ccp(0.5, 0.5);
    plyh.position = ccp(x, y);
    plyh.scale = 0.1;
    [self addChild:plyh z:14];
    CCActionScaleTo* plyhApeear = [CCActionScaleTo actionWithDuration:0.2 scale:0.5];
    [plyh runAction:plyhApeear];
    
}

-(void)addBah:(CGFloat)x and:(CGFloat)y{
    CCSprite* bah = [CCSprite spriteWithImageNamed:@"bah1.png"];
    //   plyh.positionInPoints = ccp(size.width/2, size.height/2);
    bah.anchorPoint = ccp(0.5, 0.5);
    bah.position = ccp(x, y + 20);
    bah.scale = 0.05;
    [self addChild:bah z:14];
    CCActionScaleTo* bahApeear = [CCActionScaleTo actionWithDuration:0.2 scale:0.5];
    [bah runAction:bahApeear];
}

-(void)catAnimation{
    CCActionMoveTo* catAppear = [CCActionMoveTo actionWithDuration:1 position:ccp(size.width*0.44 , size.height/2 - 10)];
    CCActionMoveTo* catAppear3 = [CCActionMoveTo actionWithDuration:1 position:ccp(size.width*0.44 , size.height/2 - 20)];
    CCActionSequence* catSeq = [CCActionSequence actions:catAppear, catAppear3, nil];
    [cat runAction:catSeq];
}

///////////////////  Блок эффектов закончен //////////////////



//запуск условия столкновения курочки с домиком через 5 сек
-(void)updateAfterStart{
    [self schedule:@selector(updateAndCheckTheCollision) interval:0.1f];
}
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!метод определяет что курочки столкнулись друг с другом
-(void)updateAndCheckTheCollision{
    for (CCSprite* first in arrayOfChickens) {
        for (CCSprite* second in arrayOfChickens) {
            if (first != second) {
                if (CGRectIntersectsRect([first boundingBox], [second boundingBox])) {
                    if (touchIsON) {
                        NSLog(@"collisions detected");
                       [self stopAllActions];
                        [self touchEnded:touch withEvent:event];
                    }
                }
            }
        }
    }
   //курочка столкнулась с реактивной курочкой
    for (CCSprite* first in arrayOfSpeedChickens) {
        for (CCSprite* second in arrayOfChickens) {
            if (first != second) {
                if (CGRectIntersectsRect([first boundingBox], [second boundingBox])) {
                    if (touchIsON) {
                        NSLog(@"collisions detected");
                        [self touchEnded:touch withEvent:event];
                        [self stopAllActions];

                    }
                }
            }
        }
    }
}

//Добавить скольжение
-(void)glidingOfTheTouchedChicken:(CGPoint)oldTouchLocation and:(CGPoint)touchLocation{
    float deltaX = touchLocation.x - oldTouchLocation.x;
    float deltaY = touchLocation.y - oldTouchLocation.y;
    float glidingPointX;
    float glidingPointY;
        glidingPointX = touchLocation.x + deltaX * 2;
        glidingPointY = touchLocation.y + deltaY * 2;
    
        CGPoint glidingPoint = CGPointMake(glidingPointX, glidingPointY);
        CCActionMoveTo* glidingMove = [CCActionMoveTo actionWithDuration:0.6 position:glidingPoint];
        [selectedSprite runAction:glidingMove];
        touchLocation = glidingPoint;
}

//обновлять метод 10 раз за секунду
-(void)updateTenTimesPerSecond:(CCTime)delta{
    if (stopTheGame == NO) {
        [timer stopTime];
    NSString* timerText2 = [[NSString stringWithFormat:@"Timer is: %lf seconds", [timer timeElapsedInSeconds]] substringToIndex:14];
        [timerLabel setString:[NSString stringWithFormat:@"%@",timerText2]];

        for (int i = 0; i < arrayOfChickens.count; i++){
            if (!CGRectContainsPoint(backgroungImage.boundingBox, [[arrayOfChickens objectAtIndex:i]positionInPoints])){
                NSString* stringRange0 = timerText2;
                NSRange range;
                range.length = 4;	
                range.location = 9;
                NSString* stringRange = [stringRange0 substringWithRange:range];
                float currentSeconds = stringRange.floatValue;
                [timer stopTime];
                stopAction = YES;
                for (int i = 0; i < arrayOfChickens.count; i++) {
                    [[arrayOfChickens objectAtIndex:i] stopAllActions];
                }
                for (int i = 0; i < arrayOfSpeedChickens.count; i++) {
                    [[arrayOfSpeedChickens objectAtIndex:i] stopAllActions];
                    arrayOfSpeedChickens = nil;
                }
                for (int i = 0; i < arrayOfBezierChickens.count; i++) {
                    [[arrayOfBezierChickens objectAtIndex:i] stopAllActions];
                    arrayOfBezierChickens = nil;
                }

         // добавить анимацию проиграша
                float a = [[arrayOfChickens objectAtIndex:i]positionInPoints].x;
                float b = [[arrayOfChickens objectAtIndex:i]positionInPoints].y;
                
                if (a >= 40 && b < 100)
                {
                    [[arrayOfChickens objectAtIndex:i] stopAllActions];
                    [self addBullk:a and:b];
                }
                NSLog(@"a = %f  b = %f", a, b);
                if (a > 40 && b > 250)
                {
                    [[arrayOfChickens objectAtIndex:i] stopAllActions];
                    [self addBah:a and:b];
                }
                
                if (a < 140 && b >0)
                {
                    [[arrayOfChickens objectAtIndex:i] stopAllActions];
                    [self catCatchAnimation:a and:b and2:[arrayOfChickens objectAtIndex:i]];
                }
                
                //закончить вызов текущего метода
                stopTheGame = YES;
                
                if (currentSeconds > bestSeconds) {
                    bestSeconds = currentSeconds;
                    bestTimeText2 = [[NSString stringWithFormat:@"Best time is: %f", currentSeconds] substringToIndex:18];
        	
                    [bestTimeLabel setString:[SafeScoreClass saveScoreOfTheGame:bestSeconds]];
                    bestTimeText2 = nil;
                                    }
                [self addButtonRestart];
                [self addButtonExit];
                [self unschedule:_cmd];
            }
           
        }
        [timer releaseStopTime];
    }
}

-(void)updateTenTimesPerSecond2:(CCTime)delta{
    if (stopTheGame == NO) {
        [timer stopTime];
        NSString* timerText2 = [[NSString stringWithFormat:@"Timer is: %lf seconds", [timer timeElapsedInSeconds]] substringToIndex:14];
        for (int i = 0; i < arrayOfSpeedChickens.count; i++){
            if (!CGRectContainsPoint(foregroungImage.boundingBox, [[arrayOfSpeedChickens objectAtIndex:i]positionInPoints])){
                
                NSString* stringRange0 = timerText2;
                NSRange range;
                range.length = 4;
                range.location = 9;
                NSString* stringRange = [stringRange0 substringWithRange:range];
                float currentSeconds = stringRange.floatValue;
                stopAction = YES;
                for (int i = 0; i < arrayOfSpeedChickens.count; i++) {
                    [[arrayOfSpeedChickens objectAtIndex:i] stopAllActions];
                }
                for (int i = 0; i < arrayOfChickens.count; i++) {
                    [[arrayOfChickens objectAtIndex:i] stopAllActions];
                }
                for (int i = 0; i < arrayOfBezierChickens.count; i++) {
                    [[arrayOfBezierChickens objectAtIndex:i] stopAllActions];
                }
                
                CCSprite* image = [arrayOfSpeedChickens objectAtIndex:i];
                
                if (image.positionInPoints.x < 100 && image.positionInPoints.y < 100)
                {
                   // [self addBullk:image];
                }
                    
                //закончить вызов текущего метода
                stopTheGame = YES;
                if (currentSeconds > bestSeconds) {
                    bestSeconds = currentSeconds;
                    bestTimeText2 = [[NSString stringWithFormat:@"Best time is: %f", currentSeconds] substringToIndex:18];
                    [bestTimeLabel setString:[SafeScoreClass saveScoreOfTheGame:bestSeconds]];
                    bestTimeText2 = nil;
                    [timer stopTime];

                }
                [self addButtonRestart];
                [self addButtonExit];
                [self unschedule:_cmd];
            }
        }
        [timer releaseStopTime];
    }
}

-(void)updateTenTimesPerSecond3:(CCTime)delta{
    if (stopTheGame == NO) {
        [timer stopTime];
        NSString* timerText2 = [[NSString stringWithFormat:@"Timer is: %lf seconds", [timer timeElapsedInSeconds]] substringToIndex:14];
        for (int i = 0; i < arrayOfBezierChickens.count; i++){
            if (!CGRectContainsPoint(foregroungImage.boundingBox, [[arrayOfBezierChickens objectAtIndex:i]positionInPoints])){
                NSString* stringRange0 = timerText2;
                NSRange range;
                range.length = 4;
                range.location = 9;
                NSString* stringRange = [stringRange0 substringWithRange:range];
                float currentSeconds = stringRange.floatValue;
                stopAction = YES;
                for (int i = 0; i < arrayOfChickens.count; i++) {
                    [[arrayOfChickens objectAtIndex:i] stopAllActions];
                }
                for (int i = 0; i < arrayOfBezierChickens.count; i++) {
                    [[arrayOfBezierChickens objectAtIndex:i] stopAllActions];
                }
                for (int i = 0; i < arrayOfSpeedChickens.count; i++) {
                    [[arrayOfSpeedChickens objectAtIndex:i] stopAllActions];
                }
                //закончить вызов текущего метода
                stopTheGame = YES;
                if (currentSeconds > bestSeconds) {
                    bestSeconds = currentSeconds;
                    bestTimeText2 = [[NSString stringWithFormat:@"Best time is: %f", currentSeconds] substringToIndex:18];
                    [bestTimeLabel setString:[SafeScoreClass saveScoreOfTheGame:bestSeconds]];
                    bestTimeText2 = nil;
                    [timer stopTime];
                    
                }
                [self addButtonRestart];
                [self addButtonExit];
                [self unschedule:_cmd];
            }

        }
    [timer releaseStopTime];
    }

}

-(void)addButtonRestart{

    [self stopAllActions];
    CCButton* restartButton = [CCButton buttonWithTitle:@"RESTART" fontName:@"Verdana-Bold" fontSize:18];
    restartButton.positionInPoints = ccp(size.width/2, size.height*7/10);
    [restartButton setTarget:self selector:@selector(redrawThisScene:)];
    [self addChild:restartButton z:30];
    
}
-(void)redrawThisScene:(id)sender{
    //остановить анимацию котика
    [catStopTimer invalidate];
    catStopTimer = nil;
    
    foregroungImage = nil;
    timerLabel = nil;
    timerText = nil;
    [car stopAllActions];
    car = nil;
    [timer releaseStartTime];
    timer = nil;
    Class SceneClass = NSClassFromString(@"HelloWorldScene");
    [[CCDirector sharedDirector] replaceScene:[SceneClass scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:1.0f]];
    stopTheGame = NO;
}

-(void)addButtonExit{
    //остановить анимацию котика
    [catStopTimer invalidate];
    catStopTimer = nil;
    
    [self stopAllActions];
    CCButton* exitButton = [CCButton buttonWithTitle:@"EXIT" fontName:@"Verdana-Bold" fontSize:18];
    exitButton.positionInPoints = ccp(size.width/2, size.height*3/10);
    [exitButton setTarget:self selector:@selector(getToMenuScene:)];
    [self addChild:exitButton z:30];
}

-(void)getToMenuScene:(id)sender{
    foregroungImage = nil;
    timerLabel = nil;
    timerText = nil;
    [car stopAllActions];
    car = nil;
    [timer releaseStartTime];
    timer = nil;
    Class SceneClass = NSClassFromString(@"MenuScene");
    [[CCDirector sharedDirector] replaceScene:[SceneClass scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:1.0f]];
    
}
// -----------------------------------------------------------------------
// Б Л О К   О Б Ы Ч Н Ы Х   К У Р О Ч Е К


//Добавить объект
-(void)addChicken:(ChickenClass*)chicken{
  //  self.userInteractionEnabled = NO;

    chicken.imageOfChickens = [CCSprite spriteWithImageNamed:@"chicken01.png"];
    chicken.anchorPoint = ccp(0.5,0.5);
    int i = arc4random_uniform(51);
    chicken.imageOfChickens.position = ccp(((size.width/2-20) + i), ((size.height/2-20) + i));
    chicken.imageOfChickens.scale = 0.2;
    [self addChild:chicken.imageOfChickens z:10];
    
    CCActionScaleTo* bornOfChicken = [CCActionScaleTo actionWithDuration:0.5 scale:0.4];
    [chicken.imageOfChickens runAction:bornOfChicken];
    NSLog(@"add chicken finish");
    
   // chickenIsInTheHouse = YES;
   // [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(timeToGetChickenFromHouse) userInfo:nil repeats:NO];
  //  [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(animationOfChicken:chick:) userInfo:nil repeats:NO];
 //   self.userInteractionEnabled = YES;

}

-(void)animationOfChicken:(CCSprite*)animatedSprite{
    NSLog(@"begin");
    //анимация курочек
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"chick.plist"];


    //The sprite animation
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int i = 1; i < 3; i++)
    {
        [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"chicken0%d.png", i]]];
    }
    walkAnim = [CCAnimation
                animationWithSpriteFrames:walkAnimFrames delay:0.2f]; 
    CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:walkAnim];
    CCActionRepeatForever *repeatingAnimation0 = [CCActionRepeatForever actionWithAction:animationAction];
   [animatedSprite runAction:repeatingAnimation0];
}

//-(void)timeToGetChickenFromHouse{
//    chickenIsInTheHouse = NO;
//}

//метод бесконечного движения курочек
-(void)foreverRepeat{
    for (int i = 0; i < arrayOfChickens.count; i++) {
        [self isRunning:[arrayOfChickens objectAtIndex:i]];

    }
}


//метод случайного перемещения каждой курицы
-(void)isRunning:(CCSprite*)image{
    float duration = 3.0f;
    if (stopAction == YES) {
        // если начался 2 уровень, то нужно остановить все движения
        //[image stopAllActions];
        [image stopActionByTag:1];
    }
    else{
        NSLog(@"!!!!!!!!!!!!!!!!!");
        int j = arc4random() %12;
        action = nil;
        switch (j) {
            case 0:{
                NSLog(@"0");
                id actionMove1 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x - 435, image.positionInPoints.y - 465)];
                action = actionMove1;
                break;}
            case 1:{
                NSLog(@"1");
                id actionMove2 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x + 235, image.positionInPoints.y + 265)];
                action = actionMove2;
                break;}
            case 2:{
                NSLog(@"2");
                id actionMove3 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x - 435, image.positionInPoints.y + 265)];
                action = actionMove3;
                break;}
            case 3:{
                NSLog(@"3");
                id actionMove4 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x + 235, image.positionInPoints.y - 465)];
                action = actionMove4;
                break;}
            case 4:{
                NSLog(@"4");
                id actionMove5 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x - 235, image.positionInPoints.y - 400)];
                action = actionMove5;
                break;}
            case 5:{
                NSLog(@"5");
                id actionMove6 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x + 235, image.positionInPoints.y + 400)];
                action = actionMove6;
                break;}
            case 6:{
                NSLog(@"6");
                id actionMove7 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x - 235, image.positionInPoints.y + 400)];
                action = actionMove7;
                break;}
            case 7:{
                NSLog(@"7");
                id actionMove8 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x + 235, image.positionInPoints.y - 400)];
                action = actionMove8;
                break;}
            case 8:{
                NSLog(@"8");
                id actionMove9 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x - 435, image.positionInPoints.y)];
                action = actionMove9;
                break;}
            case 9:{
                NSLog(@"9");
                id actionMove10 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x + 435, image.positionInPoints.y)];
                action = actionMove10;
                break;}
            case 10:{
                NSLog(@"10");
                id actionMove11 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x, image.positionInPoints.y + 400)];
                action = actionMove11;
                break;}
            case 11:{
                NSLog(@"11");
                id actionMove12 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x, image.positionInPoints.y - 400)];
                action = actionMove12;
                break;}
                
        }
            CCActionRepeat* repeat = [CCActionRepeat actionWithAction:action times:1];
            CCActionSpeed*  speedOfTheChicken = [CCActionSpeed actionWithAction:repeat speed:0.1f];
            speedOfTheChicken.tag = 1;
            [image runAction:speedOfTheChicken];

        duration = 0;
        action = nil;

        if (j == 1 || j == 3 || j == 5 || j == 7 || j == 9 || j == 11){
            image.flipX = YES;
            [self animationOfChicken:image];
        }
        else{
           image.flipX = NO;
           [self animationOfChicken:image];
        }
}
}

//выбрать объект по нажатию
-(void)selectObjectChicken:(CGPoint)touchLocation{
    CCSprite* touchedSprite = nil;
        for (int i = 0; i < arrayOfChickens.count; i++) {
            if (CGRectContainsPoint([[arrayOfChickens objectAtIndex:i] boundingBox], touchLocation)){
                touchedSprite = [arrayOfChickens objectAtIndex:i];
                break;
            }
        }

    if (touchedSprite != nil){
        selectedSprite = touchedSprite;
        NSLog(@"detect0");
        [selectedSprite stopAllActions];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"chickS.plist"];
        NSMutableArray *walkAnimFrames2 = [NSMutableArray array];
        for(int i = 1; i < 3; i++)
        {
            [walkAnimFrames2 addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"chickenS0%d.png", i]]];
        }
        CCAnimation *walkAnim2 = [[CCAnimation alloc] init];
        walkAnim2 = [CCAnimation animationWithSpriteFrames:walkAnimFrames2 delay:0.2f];
        CCActionAnimate *animationAction2 = [CCActionAnimate actionWithAnimation:walkAnim2];
        CCActionRepeat * rep2 = [CCActionRepeat actionWithAction:animationAction2 times:1];
        [selectedSprite runAction:rep2];
        NSLog(@"detect1");
    }
}

//Двигать выбраный объект
-(void)moveChicken:(CGPoint)changedPosition {
    for (int i = 0; i < arrayOfChickens.count; i++) {
        
        if (selectedSprite == [arrayOfChickens objectAtIndex:i])
        {
            [selectedSprite stopActionByTag:1];
            CGPoint newPos = ccpAdd(selectedSprite.position, changedPosition);
            selectedSprite.position = newPos;
            CCActionMoveTo* move1chicken = [CCActionMoveTo actionWithDuration:0.1 position:newPos];
            [[arrayOfChickens objectAtIndex:i] runAction:move1chicken];
            isTheMoveStart = YES;
            touchIsON = YES;
            //условие если вести курочку к домику, то упрешся в стенку
//            if ((selectedSprite.position.x > size.width/2 - 50) && (selectedSprite.position.y > size.height/2 - 50) && (selectedSprite.position.x < size.width/2 + 50) && (selectedSprite.position.y < size.height/2 + 50)) {
//                [move1chicken stop];
//            }
        }
    }
}

-(void)continueRunning{
    
    for (int i = 0; i < arrayOfChickens.count; i++) {
        if (selectedSprite2 == [arrayOfChickens objectAtIndex:i]) {
            
            if (isTheMoveStart) {
                [self isRunning:selectedSprite2];
                NSLog(@"TouchesEnded");
                [selectedSprite stopAllActions];
                selectedSprite2 = nil;
            }
        }
    }
}




//---------------------------------------------------------
// Б Л О К   Р Е А К Т И В Н Ы Х   К У Р О Ч Е К

//Добавить объект реактивная курица
-(void)addSpeedChicken:(ChickenClass*)speedChicken{
    speedChicken.imageOfChickens = [CCSprite spriteWithImageNamed:@"speed_chicken01.png"];
    speedChicken.anchorPoint = ccp(0.5,0.5);
    int i = arc4random_uniform(51);
    speedChicken.imageOfChickens.position = ccp(((size.width/2-20) + i), ((size.height/2-20) + i));
    speedChicken.imageOfChickens.scale = 0.1;
    [self addChild:speedChicken.imageOfChickens z:11];
    CCActionScaleTo* bornOfChicken = [CCActionScaleTo actionWithDuration:0.5 scale:0.3];
    [speedChicken.imageOfChickens runAction:bornOfChicken];
    NSLog(@"add chicken finish");
  // chickenIsInTheHouse = YES;
 //   [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(timeToGetChickenFromHouse) userInfo:nil repeats:NO];
}

-(void)animationOfSpeedChicken:(CCSprite*)animatedSpeedChick{
    //анимация курочек
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"react_chick.plist"];
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int i = 1; i < 4; i++)
    {
        [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"react_chick0%d.png", i]]];
    }
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:walkAnimFrames delay:0.1f];
    CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:walkAnim];
    CCActionRepeatForever *repeatingAnimation = [CCActionRepeatForever actionWithAction:animationAction];
        [animatedSpeedChick runAction:repeatingAnimation];
}

//метод бесконечного движения реактивных курочек
-(void)speedChickenForeverRepeat{
    for (int i = 0; i < arrayOfSpeedChickens.count; i++) {
        [self isRunningSpeedChicken:[arrayOfSpeedChickens objectAtIndex:i]];
    }
}

//метод случайного перемещения каждой реактивной курицы
-(void)isRunningSpeedChicken:(CCSprite*)image{
    float duration = 0.8f;
    if (stopAction == YES) {
        [image stopActionByTag:2];
    }
    else{
        int j = arc4random() %12;
        speedAction = nil;
        switch (j) {
            case 0:{
                NSLog(@"0");
                id actionMove1 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x - 135, image.positionInPoints.y - 365)];
                id ease1 = [CCActionEaseBounceIn actionWithAction:actionMove1];
                speedAction = ease1;
                break;}
            case 1:{
                NSLog(@"1");
                id actionMove2 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x + 135, image.positionInPoints.y + 165)];
                id ease2 = [CCActionEaseBounceIn actionWithAction:actionMove2];
                speedAction = ease2;
                break;}
            case 2:{
                NSLog(@"2");
                id actionMove3 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x- 235, image.positionInPoints.y + 165)];
                id ease3 = [CCActionEaseBounceIn actionWithAction:actionMove3];
                speedAction = ease3;
                break;}
            case 3:{
                NSLog(@"3");
                id actionMove4 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x+135, image.positionInPoints.y - 265)];
                id ease4 = [CCActionEaseBounceIn actionWithAction:actionMove4];
                speedAction = ease4;
                break;}
            case 4:{
                NSLog(@"4");
                id actionMove5 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x - 135, image.positionInPoints.y - 200)];
                id ease5 = [CCActionEaseBounceIn actionWithAction:actionMove5];
                speedAction = ease5;
                break;}
            case 5:{
                NSLog(@"5");
                id actionMove6 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x + 135, image.positionInPoints.y + 300)];
                id ease6 = [CCActionEaseBounceIn actionWithAction:actionMove6];
                speedAction = ease6;
                break;}
            case 6:{
                NSLog(@"6");
                id actionMove7 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x - 135, image.positionInPoints.y + 300)];
                id ease7 = [CCActionEaseBounceIn actionWithAction:actionMove7];
                speedAction = ease7;
                break;}
            case 7:{
                NSLog(@"7");
                id actionMove8 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x + 135, image.positionInPoints.y - 200)];
                id ease8 = [CCActionEaseBounceIn actionWithAction:actionMove8];
                speedAction = ease8;}
                break;
            case 8:{
                NSLog(@"8");
                id actionMove9 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x - 135, image.positionInPoints.y)];
                id ease9 = [CCActionEaseBounceIn actionWithAction:actionMove9];
                speedAction = ease9;
                break;}
            case 9:{
                NSLog(@"9");
                id actionMove10 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x + 435, image.positionInPoints.y)];
                id ease10 = [CCActionEaseBounceIn actionWithAction:actionMove10];
                speedAction = ease10;
                break;}
            case 10:{
                NSLog(@"10");
                id actionMove11 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x, image.positionInPoints.y + 400)];
                id ease11 = [CCActionEaseBounceIn actionWithAction:actionMove11];
                speedAction = ease11;
                break;}
            case 11:{
                NSLog(@"11");
                id actionMove12 = [CCActionMoveTo actionWithDuration:duration position:ccp(image.positionInPoints.x, image.positionInPoints.y - 400)];
                id ease12 = [CCActionEaseBounceIn actionWithAction:actionMove12];
                speedAction = ease12;
                break;}
                
        }
        CCActionRepeat* repeat = [CCActionRepeat actionWithAction:speedAction times:1];
        CCActionSpeed*  speedOfTheSpeedChicken = [CCActionSpeed actionWithAction:repeat speed:0.1f];
        speedOfTheSpeedChicken.tag = 2;
        [image runAction:speedOfTheSpeedChicken];
        duration = 0;
        
        if (j == 1 || j == 3 || j == 5 || j == 7 || j == 9 || j == 11){
            image.flipX = YES;
            [self animationOfSpeedChicken:image];
        }
        else{
            image.flipX = NO;
            [self animationOfSpeedChicken:image];
        }
        
    }
}

//выбрать объект реактивная курица по нажатию
-(void)selectObjectSpeedChicken:(CGPoint)touchLocation{
    CCSprite* touchedSprite = nil;
    for (CCSprite* sprite in arrayOfSpeedChickens){
         NSLog(@"%@",sprite.description);
        for (int i = 0; i < arrayOfSpeedChickens.count; i++) {
            if (CGRectContainsPoint([[arrayOfSpeedChickens objectAtIndex:i] boundingBox], touchLocation)){
                touchedSprite = [arrayOfSpeedChickens objectAtIndex:i];
                break;
            }
        }
    }
    if (touchedSprite != nil){
        selectedSprite = touchedSprite;
    }
}

//Двигать выбраный объект реактивная курица
-(void)moveSpeedChicken:(CGPoint)changedPosition {
    for (int i = 0; i < arrayOfSpeedChickens.count; i++) {
        
        if (selectedSprite == [arrayOfSpeedChickens objectAtIndex:i])
        {
            [selectedSprite stopActionByTag:2];

            CGPoint newPos = ccpAdd(selectedSprite.position, changedPosition);
            selectedSprite.position = newPos;
            CCActionMoveTo* move1chicken = [CCActionMoveTo actionWithDuration:0.1 position:newPos];
            [[arrayOfSpeedChickens objectAtIndex:i] runAction:move1chicken];
            isTheMoveStart = YES;
            touchIsON = YES;
            //условие если вести курочку к домику, то упрешся в стенку
//            if ((selectedSprite.position.x > size.width/2 - 50) && (selectedSprite.position.y > size.height/2 - 50) && (selectedSprite.position.x < size.width/2 + 50) && (selectedSprite.position.y < size.height/2 + 50)) {
//                [move1chicken stop];
//            }
        }
    }
}
-(void)continueRunningSpeedChicken{
    for (int i = 0; i < arrayOfSpeedChickens.count; i++) {
        if (selectedSprite2 == [arrayOfSpeedChickens objectAtIndex:i]) {
            if (isTheMoveStart) {
                [self isRunningSpeedChicken:selectedSprite2];
                [self animationOfSpeedChicken:selectedSprite2];
                NSLog(@"TouchesEnded");
            }
            selectedSprite2 = nil;
        }
    }
}


//---------------------------------------------------------
// Б Л О К    К У Р О Ч Е К   Б Е З Ь Е


//Добавить объект курица безье
-(void)addBezierChicken:(ChickenClass*)bezierChicken{
 //   self.userInteractionEnabled = NO;

    bezierChicken.imageOfChickens = [CCSprite spriteWithImageNamed:@"bezier_chicken01.png"];
    bezierChicken.anchorPoint = ccp(0.5,0.5);
    int i = arc4random_uniform(51);
    bezierChicken.imageOfChickens.position = ccp(((size.width/2-20) + i), ((size.height/2-20) + i));
    bezierChicken.imageOfChickens.scale = 0.1;
    [self addChild:bezierChicken.imageOfChickens z:12];
    CCActionScaleTo* bornOfChicken = [CCActionScaleTo actionWithDuration:0.1 scale:0.3];
    [bezierChicken.imageOfChickens runAction:bornOfChicken];
    NSLog(@"add chicken finish");

  //  chickenIsInTheHouse = YES;
    
   // [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(timeToGetChickenFromHouse) userInfo:nil repeats:NO];
//    self.userInteractionEnabled = YES;

}

-(void)animationOfBezierChicken:(CCSprite*)animatedSprite{
    
    //    //анимация курочек
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bez_chick.plist"];
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int i = 1; i < 3; i++)
    {
        [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"bez_chick0%d.png", i]]];
    }
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:walkAnimFrames delay:0.1f];
    CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:walkAnim];
    CCActionRepeatForever *repeatingAnimation = [CCActionRepeatForever actionWithAction:animationAction];
    [animatedSprite runAction:repeatingAnimation];
}


//метод бесконечного движения куриц безье
-(void)bezierChickenForeverRepeat{
    for (int i = 0; i < arrayOfBezierChickens.count; i++) {
        [self isRunningBezierChicken:[arrayOfBezierChickens objectAtIndex:i]];
    }
}


//метод случайного перемещения каждой курицы безье
-(void)isRunningBezierChicken:(CCSprite*)image{
 //   float duration = 0.8f;
    if (stopAction == YES) {
        // если начался 2 уровень, то нужно остановить все движения
        [image stopActionByTag:3];
    }
    else{
        int j = arc4random() %4;
        ccBezierConfig bezierConf;

        bezierAction = nil;
        switch (j) {
            case 0:{
                NSLog(@"0");
                bezierConf.controlPoint_1 = CGPointMake(arc4random() %400, arc4random() %300);
                bezierConf.controlPoint_2 = CGPointMake(arc4random() %400, arc4random() %300);
                bezierConf.endPosition = CGPointMake(arc4random() %600, arc4random() %10);
                id actionMove1 = [CCActionBezierTo actionWithDuration:1.0f bezier:bezierConf];
                bezierAction = actionMove1;
                break;}
            case 1:{
                NSLog(@"1");
                ccBezierConfig bezierConf;
                bezierConf.controlPoint_1 = CGPointMake(arc4random() %400, arc4random() %300);
                bezierConf.controlPoint_2 = CGPointMake(arc4random() %400, arc4random() %300);
                bezierConf.endPosition = CGPointMake(arc4random() %10, arc4random() %440);
                id actionMove2 = [CCActionBezierTo actionWithDuration:1.0f bezier:bezierConf];

                bezierAction = actionMove2;
                break;}
            case 2:{
                NSLog(@"2");
                ccBezierConfig bezierConf;
                bezierConf.controlPoint_1 = CGPointMake(arc4random() %400, arc4random() %300);
                bezierConf.controlPoint_2 = CGPointMake(arc4random() %400, arc4random() %300);
                bezierConf.endPosition = CGPointMake(arc4random() %600, arc4random() %440 + 10);
                id actionMove3 = [CCActionBezierTo actionWithDuration:1.0f bezier:bezierConf];
                
                bezierAction = actionMove3;
                break;}
            case 3:{
                NSLog(@"3");
                ccBezierConfig bezierConf;
                bezierConf.controlPoint_1 = CGPointMake(arc4random() %400, arc4random() %300);
                bezierConf.controlPoint_2 = CGPointMake(arc4random() %400, arc4random() %300);
                bezierConf.endPosition = CGPointMake(arc4random() %750 + 10, arc4random() %440);
                id actionMove4 = [CCActionBezierTo actionWithDuration:1.0f bezier:bezierConf];
                
                bezierAction = actionMove4;
                break;}
        }
        
        CCActionRepeat* repeat = [CCActionRepeat actionWithAction:bezierAction times:1];
        CCActionSpeed*  speedOfTheBezierChicken = [CCActionSpeed actionWithAction:repeat speed:0.2f];
        speedOfTheBezierChicken.tag = 3;

       [image runAction:speedOfTheBezierChicken];
        
        if (bezierConf.endPosition.x > bezierConf.controlPoint_1.x){
            image.flipX = YES;
            [self animationOfBezierChicken:image];

        }
        else{
            image.flipX = NO;
            [self animationOfBezierChicken:image];
        }
     //   duration = 0;
    }
}

//выбрать объект курица безье по нажатию
-(void)selectObjectBezierChicken:(CGPoint)touchLocation{
    CCSprite* touchedSprite = nil;
    for (CCSprite* sprite in arrayOfBezierChickens){
        NSLog(@"%@",sprite.description);
        for (int i = 0; i < arrayOfBezierChickens.count; i++) {
            if (CGRectContainsPoint([[arrayOfBezierChickens objectAtIndex:i] boundingBox], touchLocation)){
                touchedSprite = [arrayOfBezierChickens objectAtIndex:i];
                break;
            }
        }
    }
    if (touchedSprite != nil){
        selectedSprite = touchedSprite;
    }
}

//Двигать выбраный объект курица безье
-(void)moveBezierChicken:(CGPoint)changedPosition {
    for (int i = 0; i < arrayOfBezierChickens.count; i++) {
        if (selectedSprite == [arrayOfBezierChickens objectAtIndex:i])
        {
            [selectedSprite stopActionByTag:3];
            
            CGPoint newPos = ccpAdd(selectedSprite.position, changedPosition);
            selectedSprite.position = newPos;
            CCActionMoveTo* move1chicken = [CCActionMoveTo actionWithDuration:0.1 position:newPos];
            [[arrayOfBezierChickens objectAtIndex:i] runAction:move1chicken];
            isTheMoveStart = YES;
            touchIsON = YES;
            //условие если вести курочку к домику, то упрешся в стенку
//            if ((selectedSprite.position.x > size.width/2 - 50) && (selectedSprite.position.y > size.height/2 - 50) && (selectedSprite.position.x < size.width/2 + 50) && (selectedSprite.position.y < size.height/2 + 50)) {
//                [move1chicken stop];
//            }
        }
    }
}

-(void)continueRunningBezierChicken{
    for (int i = 0; i < arrayOfBezierChickens.count; i++) {
        if (selectedSprite2 == [arrayOfBezierChickens objectAtIndex:i]) {
            if (isTheMoveStart) {
                [self isRunningBezierChicken:selectedSprite2];
                [self animationOfBezierChicken:selectedSprite2];
                NSLog(@"TouchesEnded");
            }
            selectedSprite2 = nil;
        }
    }
}


//------------------------------------------------------------------------
//Обработка касаний


-(void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event{
    NSLog(@"began");
    //перевод точки касания в координаты понятные машине

    CGPoint touchLocation = [touch locationInNode:self];
   [self moveMotionStreakToTouch:touch];
   [self selectObjectChicken:touchLocation];
   [self selectObjectSpeedChicken:touchLocation];
    
    [self selectObjectBezierChicken:touchLocation];

}

-(void) touchMoved:(CCTouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"TouchesMoved");
    touchLocation = [touch locationInNode:self];
    oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    changedPosition = ccpSub(touchLocation, oldTouchLocation);
    
    [self moveMotionStreakToTouch:touch];
    //метод перемещения курицы при ведении курсора
    [self selectObjectChicken:touchLocation];
    //метод перемещения курицы после нажатия на нее
    [self moveChicken:changedPosition];
    
    //метод перемещения реактивной курицы при ведении курсора
    [self selectObjectSpeedChicken:touchLocation];
    //метод перемещения реактиной курицы после нажатия на нее
    [self moveSpeedChicken:changedPosition];
    
    [self selectObjectBezierChicken:touchLocation];
    [self moveBezierChicken:changedPosition];
    objectWasMoved = YES;
}
-(void) touchEnded:(CCTouch *)touch withEvent:(UIEvent *)event{
    NSLog(@"TouchesEnd");
    
    touchIsON = NO;
    
    [self isRunning:selectedSprite];
    
    if (objectWasMoved)
   [self glidingOfTheTouchedChicken:oldTouchLocation and:touchLocation];
    
    selectedSprite2 = selectedSprite;
    
   [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(continueRunning) userInfo:nil repeats:YES];
   [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(continueRunningBezierChicken) userInfo:nil repeats:YES];
   [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(continueRunningSpeedChicken) userInfo:nil repeats:YES];
 
    selectedSprite = nil;
    [self removeChildByName:@"streakName"];
    objectWasMoved = NO;
  //  oldTouchLocation = touchLocation;
    touch = nil;
    event = nil;
}

///////////////////////Методы обработки касаний закончились

//Метод определения точки касания
-(CGPoint)locationFromTouch:(CCTouch*)touch{
    CGPoint touchLocation = [touch locationInView:[touch view]];
    return [[CCDirector sharedDirector] convertToGL:touchLocation];
}


//добавить эффект парящей летны
-(void)moveMotionStreakToTouch:(CCTouch*)touch{
    CCMotionStreak* streak = [self getMotionStreak];
    streak.position = [self locationFromTouch:touch];
}
-(CCMotionStreak*)getMotionStreak{
//    CCMotionStreak* streak = [CCMotionStreak streakWithFade:0.59f
//                                                     minSeg:8
//                                                      width:12
//                                                      color:[CCColor whiteColor]
//                                            textureFilename:@"image1-1.png"];
       CCMotionStreak* streak = [CCMotionStreak streakWithFade:0.59f
                                                      minSeg:8
                                                       width:12
                                                       color:[CCColor whiteColor]
                                           textureFilename:@"white_square.png"];
    streak.scale = 1;
    
   [self addChild:streak z:15 name:@"streakName"];
    CCNode* node = [self getChildByName:@"streakName" recursively:NO];
    NSAssert([node isKindOfClass:[CCMotionStreak class]], @"not a CCMotionStreak");
    streak = nil;
    return (CCMotionStreak*)node;
}

//1 уровень
-(void)startLevel1{
    arrayOfChickens = [[NSMutableArray alloc] init];

    stopTheGame = NO;

    // создание курочек
    chicken0 = [[ChickenClass alloc]init];
    [self addChicken:chicken0];
    [arrayOfChickens addObject:chicken0.imageOfChickens];
  //  [self animationOfChicken:chicken0.imageOfChickens];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startLevel1_0) userInfo:nil repeats:NO];
}


-(void)startLevel1_0{
    chicken1 = [[ChickenClass alloc]init];
    [self addChicken:chicken1];
    [arrayOfChickens addObject:chicken1.imageOfChickens];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startLevel1_1) userInfo:nil repeats:NO];
    
}
-(void)startLevel1_1{
    chicken2 = [[ChickenClass alloc]init];
    [self addChicken:chicken2];
    [arrayOfChickens addObject:chicken2.imageOfChickens];
    [self foreverRepeat];
    [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(beganToTouch) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(finishLevel1) userInfo:nil repeats:NO];

}

-(void)beganToTouch{
    //включение касания
    self.userInteractionEnabled = YES;
}

//метод перед началом 2 уровня
-(void)finishLevel1{
    stopAction = YES;
    for (int i = 0; i < arrayOfChickens.count; i++) {
        [[arrayOfChickens objectAtIndex:i] stopActionByTag:1];
    }
    //создание 4-ой курочки
    if (stopTheGame == NO) {
        chicken3 = [[ChickenClass alloc]init];
        [self addChicken:chicken3];
        [arrayOfChickens addObject:chicken3.imageOfChickens];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startLevel2) userInfo:nil repeats:NO];
    }
}
//!Второй уровень
-(void)startLevel2{
    //запуск движения
    stopAction = NO;
    for (int i = 0; i < arrayOfChickens.count; i++) {
      [self isRunning:[arrayOfChickens objectAtIndex:i]];
      CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfChickens objectAtIndex:i] getActionByTag:1];
      speedOfTheChicken.speed = 0.2f;
    }
    
 [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(finishLevel2) userInfo:nil repeats:NO];

}

//метод перед началом 3 уровня
-(void)finishLevel2{
    stopAction = YES;
    for (int i = 0; i < arrayOfChickens.count; i++) {
        [[arrayOfChickens objectAtIndex:i] stopActionByTag:1];
    }
    //создание 5-ой курочки
    if (stopTheGame == NO) {
        chicken4 = [[ChickenClass alloc]init];
        [self addChicken:chicken4];
        [arrayOfChickens addObject:chicken4.imageOfChickens];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startLevel3) userInfo:nil repeats:NO];
    }
}
//3 уровень
-(void)startLevel3{
    //запуск движения
    stopAction = NO;
    for (int i = 0; i < arrayOfChickens.count; i++) {
        [self isRunning:[arrayOfChickens objectAtIndex:i]];
        CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfChickens objectAtIndex:i] getActionByTag:1];
        speedOfTheChicken.speed = 0.3f;
    }
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(finishLevel3) userInfo:nil repeats:NO];
}
//метод перед началом 4 уровня
-(void)finishLevel3{
    stopAction = YES;
    for (int i = 0; i < arrayOfChickens.count; i++) {
        [[arrayOfChickens objectAtIndex:i] stopActionByTag:1];
    }
    //создание курочки безье
    if (stopTheGame == NO) {
        //создание курочки Безье
        bezierChichen0 = [[ChickenClass alloc] init];
        [self addBezierChicken:bezierChichen0];
        [arrayOfBezierChickens addObject:bezierChichen0.imageOfChickens];
        [self animationOfBezierChicken:bezierChichen0.imageOfChickens];
        [self bezierChickenForeverRepeat];
        
        //вызов метода обновления
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self schedule:@selector(updateTenTimesPerSecond3:) interval:0.2f];
            /* Код, который должен выполниться в фоне */
        });
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startLevel4) userInfo:nil repeats:NO];
    }
}

//4 уровень
-(void)startLevel4{
    //запуск движения
    stopAction = NO;
    for (int i = 0; i < arrayOfChickens.count; i++) {
        [self isRunning:[arrayOfChickens objectAtIndex:i]];
        CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfChickens objectAtIndex:i] getActionByTag:1];
        speedOfTheChicken.speed = 0.2f;
    }
    for (int i = 0; i < arrayOfBezierChickens.count; i++) {
        [self isRunningBezierChicken:[arrayOfBezierChickens objectAtIndex:i]];
        CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfBezierChickens objectAtIndex:i] getActionByTag:1];
        speedOfTheChicken.speed = 0.1f;
    }
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(finishLevel4) userInfo:nil repeats:NO];
}


//метод перед началом 5 уровня
-(void)finishLevel4{
    stopAction = YES;
    for (int i = 0; i < arrayOfChickens.count; i++) {
        [[arrayOfChickens objectAtIndex:i] stopActionByTag:1];
    }
    for (int i = 0; i < arrayOfBezierChickens.count; i++) {
        [[arrayOfBezierChickens objectAtIndex:i] stopActionByTag:3];
    }
    if (stopTheGame == NO) {
    //создание 2 курочки Безье
        bezierChichen1 = [[ChickenClass alloc] init];
        [self addBezierChicken:bezierChichen1];
        [arrayOfBezierChickens addObject:bezierChichen1.imageOfChickens];
        [self animationOfBezierChicken:bezierChichen1.imageOfChickens];
        [self bezierChickenForeverRepeat];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startLevel5) userInfo:nil repeats:NO];
    }
}

//5 уровень
-(void)startLevel5{
    //запуск движения
    stopAction = NO;
    for (int i = 0; i < arrayOfBezierChickens.count; i++) {
        [self isRunningBezierChicken:[arrayOfBezierChickens objectAtIndex:i]];
        CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfBezierChickens objectAtIndex:i] getActionByTag:3];
        speedOfTheChicken.speed = 0.1f;
    }
    for (int i = 0; i < arrayOfChickens.count; i++) {
        [self isRunning:[arrayOfChickens objectAtIndex:i]];
        CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfChickens objectAtIndex:i] getActionByTag:1];
        speedOfTheChicken.speed = 0.2f;
    }

    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(finishLevel5) userInfo:nil repeats:NO];
}
//метод перед началом 6 уровня
-(void)finishLevel5{
    stopAction = YES;
    for (int i = 0; i < arrayOfChickens.count; i++) {
        [[arrayOfChickens objectAtIndex:i] stopActionByTag:1];
    }
    for (int i = 0; i < arrayOfBezierChickens.count; i++) {
        [[arrayOfBezierChickens objectAtIndex:i] stopActionByTag:3];
    }
    //создание реактивной курочки
    if (stopTheGame == NO) {
        speedChichen0 = [[ChickenClass alloc] init];
        [self addSpeedChicken:speedChichen0];
        [arrayOfSpeedChickens addObject:speedChichen0.imageOfChickens];
        [self animationOfSpeedChicken:speedChichen0.imageOfChickens];
        //запуск движения реактивных курочек
    [self isRunningSpeedChicken:speedChichen0.imageOfChickens];
        
    [self schedule:@selector(updateTenTimesPerSecond2:) interval:0.2f];
        
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startLevel6) userInfo:nil repeats:NO];
    }
}

//6 уровень
-(void)startLevel6{
    //запуск движения
    stopAction = NO;
    for (int i = 0; i < arrayOfChickens.count; i++) {
        [self isRunning:[arrayOfChickens objectAtIndex:i]];
        CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfChickens objectAtIndex:i] getActionByTag:1];
        speedOfTheChicken.speed = 0.3f;
    }
    for (int i = 0; i < arrayOfBezierChickens.count; i++) {
        [self isRunningBezierChicken:[arrayOfBezierChickens objectAtIndex:i]];
        CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfBezierChickens objectAtIndex:i] getActionByTag:3];
        speedOfTheChicken.speed = 0.1f;
    }
    for (int i = 0; i < arrayOfSpeedChickens.count; i++) {
        [self isRunningSpeedChicken:[arrayOfSpeedChickens objectAtIndex:i]];
        CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfSpeedChickens objectAtIndex:i] getActionByTag:2];
        speedOfTheChicken.speed = 0.2f;
    }
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(finishLevel6) userInfo:nil repeats:NO];
}

//метод перед началом 7 уровня
-(void)finishLevel6{
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startLevel7) userInfo:nil repeats:NO];
}

//7 уровень
-(void)startLevel7{
    if (stopTheGame == NO) {

    //запуск движения
    stopAction = NO;
    for (int i = 0; i < arrayOfChickens.count; i++) {
        [self isRunning:[arrayOfChickens objectAtIndex:i]];
        CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfChickens objectAtIndex:i] getActionByTag:1];
        speedOfTheChicken.speed = 0.4f;
    }
    for (int i = 0; i < arrayOfBezierChickens.count; i++) {
        [self isRunningBezierChicken:[arrayOfBezierChickens objectAtIndex:i]];
        CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfBezierChickens objectAtIndex:i] getActionByTag:3];
        speedOfTheChicken.speed = 0.1f;
    }
    for (int i = 0; i < arrayOfSpeedChickens.count; i++) {
        [self isRunningSpeedChicken:[arrayOfSpeedChickens objectAtIndex:i]];
        CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfSpeedChickens objectAtIndex:i] getActionByTag:2];
        speedOfTheChicken.speed = 0.2f;
    }
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(startLevel8) userInfo:nil repeats:NO];
    }
}

-(void)startLevel8{
    if (stopTheGame == NO) {
        
        //запуск движения
        stopAction = NO;
        for (int i = 0; i < arrayOfChickens.count; i++) {
            [self isRunning:[arrayOfChickens objectAtIndex:i]];
            CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfChickens objectAtIndex:i] getActionByTag:1];
            speedOfTheChicken.speed = 0.4f;
        }
        for (int i = 0; i < arrayOfBezierChickens.count; i++) {
            [self isRunningBezierChicken:[arrayOfBezierChickens objectAtIndex:i]];
            CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfBezierChickens objectAtIndex:i] getActionByTag:3];
            speedOfTheChicken.speed = 0.15f;
        }
        for (int i = 0; i < arrayOfSpeedChickens.count; i++) {
            [self isRunningSpeedChicken:[arrayOfSpeedChickens objectAtIndex:i]];
            CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfSpeedChickens objectAtIndex:i] getActionByTag:2];
            speedOfTheChicken.speed = 0.2f;
        }
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(startLevel9) userInfo:nil repeats:NO];
    }
}

-(void)startLevel9{
    if (stopTheGame == NO) {
        
        //запуск движения
        stopAction = NO;
        for (int i = 0; i < arrayOfChickens.count; i++) {
            [self isRunning:[arrayOfChickens objectAtIndex:i]];
            CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfChickens objectAtIndex:i] getActionByTag:1];
            speedOfTheChicken.speed = 0.4f;
        }
        for (int i = 0; i < arrayOfBezierChickens.count; i++) {
            [self isRunningBezierChicken:[arrayOfBezierChickens objectAtIndex:i]];
            CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfBezierChickens objectAtIndex:i] getActionByTag:3];
            speedOfTheChicken.speed = 0.15f;
        }
        for (int i = 0; i < arrayOfSpeedChickens.count; i++) {
            [self isRunningSpeedChicken:[arrayOfSpeedChickens objectAtIndex:i]];
            CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfSpeedChickens objectAtIndex:i] getActionByTag:2];
            speedOfTheChicken.speed = 0.25f;
        }
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(startLevel10) userInfo:nil repeats:NO];
    }
}
-(void)startLevel10{
    if (stopTheGame == NO) {
        
        //запуск движения
        stopAction = NO;
        for (int i = 0; i < arrayOfChickens.count; i++) {
            [self isRunning:[arrayOfChickens objectAtIndex:i]];
            CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfChickens objectAtIndex:i] getActionByTag:1];
            speedOfTheChicken.speed = 0.45f;
        }
        for (int i = 0; i < arrayOfBezierChickens.count; i++) {
            [self isRunningBezierChicken:[arrayOfBezierChickens objectAtIndex:i]];
            CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfBezierChickens objectAtIndex:i] getActionByTag:3];
            speedOfTheChicken.speed = 0.2f;
        }
        for (int i = 0; i < arrayOfSpeedChickens.count; i++) {
            [self isRunningSpeedChicken:[arrayOfSpeedChickens objectAtIndex:i]];
            CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfSpeedChickens objectAtIndex:i] getActionByTag:2];
            speedOfTheChicken.speed = 0.3f;
        }
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(startLevel11) userInfo:nil repeats:NO];
    }
}

-(void)startLevel11{
    if (stopTheGame == NO) {
        
        //запуск движения
        stopAction = NO;
        for (int i = 0; i < arrayOfChickens.count; i++) {
            [self isRunning:[arrayOfChickens objectAtIndex:i]];
            CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfChickens objectAtIndex:i] getActionByTag:1];
            speedOfTheChicken.speed = 0.45f;
        }
        for (int i = 0; i < arrayOfBezierChickens.count; i++) {
            [self isRunningBezierChicken:[arrayOfBezierChickens objectAtIndex:i]];
            CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfBezierChickens objectAtIndex:i] getActionByTag:3];
            speedOfTheChicken.speed = 0.25f;
        }
        for (int i = 0; i < arrayOfSpeedChickens.count; i++) {
            [self isRunningSpeedChicken:[arrayOfSpeedChickens objectAtIndex:i]];
            CCActionSpeed* speedOfTheChicken = (CCActionSpeed*)[[arrayOfSpeedChickens objectAtIndex:i] getActionByTag:2];
            speedOfTheChicken.speed = 0.35f;
        }
     //   [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(startLevel11) userInfo:nil repeats:NO];
    }
}
@end
	




// why not add a few extra lines, so we dont have to sit and edit at the bottom of the screen ...
