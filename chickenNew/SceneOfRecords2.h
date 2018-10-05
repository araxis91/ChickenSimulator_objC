//
//  SceneOfRecords2.h
//
//  Created by : dchernega
//  Project    : safeMyChicken
//  Date       : 7/21/16
//
//  Copyright (c) 2016 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------

//#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Reachability.h"
#import "ParseDB.h"
//#import "MySqlDB.h"
//cocos2d-ui.h - даёт доступ к классу ССButton
#import "cocos2d-ui.h"
#import "SafeScoreClass.h"

// -----------------------------------------------------------------

@interface SceneOfRecords2 : CCNode <UITableViewDataSource, UITableViewDelegate, ParseDBProtocol>
// -----------------------------------------------------------------
// properties
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

// -----------------------------------------------------------------
// methods

+(CCScene *) scene;


+ (instancetype)node;
- (instancetype)init;

// -----------------------------------------------------------------

@end




