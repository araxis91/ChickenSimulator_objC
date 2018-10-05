//
//  RecordsOfGameSnece.h
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 1/6/16
//
//  Copyright (c) 2016 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"

#import "MenuScene.h"
#import "Reachability.h"
#import "ParseDB.h"
#import "SafeScoreClass.h"
#import "MySqlDB.h"
NSUserDefaults* savedBestScore2;

// -----------------------------------------------------------------

@interface RecordsOfGameScene : CCScene <UITableViewDataSource, UITableViewDelegate, ParseDBProtocol>

// -----------------------------------------------------------------
// properties
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (nonatomic, retain) NSMutableData *infoData;

// -----------------------------------------------------------------
// methods
+(CCScene *) scene;

+ (instancetype)node;
- (instancetype)init;

// -----------------------------------------------------------------

@end



