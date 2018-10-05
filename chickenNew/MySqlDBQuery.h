//
//  MySqlDBQuery.h
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 1/19/16
//
//  Copyright (c) 2016 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MySqlDB;
// -----------------------------------------------------------------

@interface MySqlDBQuery : NSObject
{
    MySqlDB* db;
    NSMutableArray* rowsArray;
    NSInteger num_fields;
}
// -----------------------------------------------------------------
// properties
@property (copy)NSString* sql;

// -----------------------------------------------------------------
// methods

+ (instancetype)node;
- (instancetype)init;

- (id)initWithDatabase:(MySqlDB*)dbase; // инициализатор на базе класса mbMysqlDB
- (void)execQuery; // Выполнение запроса указанного в свойстве sql
- (NSInteger)recordCount; // кол-во строк, возвращенных после запроса
- (NSString*)stringValFromRow:(int)row Column:(int)col; // возвращает строковое значение из строки row и столбца col
- (NSInteger)integerValFromRow:(int)row Column:(int)col;//возвращает цело-численное
//значение из строки row и столбца col
- (double)doubleValFromRow:(int)row Column:(int)col; //возвращает значение с плав. точкой из строки row и столбца col

// -----------------------------------------------------------------

@end




