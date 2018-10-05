//
//  ParseDB.h
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 1/20/16
//
//  Copyright (c) 2016 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// -----------------------------------------------------------------
@protocol ParseDBProtocol <NSObject>
- (void)itemsDownloaded2:(NSArray *)items;
@end

@interface ParseDB : NSObject <NSURLConnectionDataDelegate>
{
    NSMutableArray *_items;
}
// -----------------------------------------------------------------
// properties
@property (nonatomic, weak) id <ParseDBProtocol> delegate;

// -----------------------------------------------------------------
// methods
- (void)downloadItems;

+ (instancetype)node;
- (instancetype)init;

// -----------------------------------------------------------------

@end




