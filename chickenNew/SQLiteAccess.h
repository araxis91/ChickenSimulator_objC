

#define dbName @"Players_scores"

@interface SQLiteAccess : NSObject {
}

+ (NSString *)selectOneValueSQL:(NSString *)sql;
+ (NSArray *)selectManyValuesWithSQL:(NSString *)sql;
+ (NSDictionary *)selectOneRowWithSQL:(NSString *)sql;
+ (NSArray *)selectManyRowsWithSQL:(NSString *)sql;
+ (NSNumber *)insertWithSQL:(NSString *)sql;
+ (void)updateWithSQL:(NSString *)sql;
+ (void)deleteWithSQL:(NSString *)sql;

@end