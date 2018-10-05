//
//  ParseDB.m
//
//  Created by : Dima Chernega
//  Project    : safeMyChicken
//  Date       : 1/20/16
//
//  Copyright (c) 2016 Dima Chernega.
//  All rights reserved.
//
// -----------------------------------------------------------------
#import "ParseDB.h"
#import "MySqlDB.h"

// -----------------------------------------------------------------

@interface ParseDB()
{
    NSMutableData *_downloadedData;

}
@end
@implementation ParseDB

// -----------------------------------------------------------------

+ (instancetype)node
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    NSAssert(self, @"Unable to create class %@", [self class]);
    // class initalization goes here
    
    return self;
}

- (void)downloadItems
{
    // Download the json file
    NSURL *jsonFileUrl = [NSURL URLWithString:@"http://chickens.goldlans.com/readDB.php"];

    // Create the request
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    // Create the NSURLConnection
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

#pragma mark NSURLConnectionDataProtocol Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Initialize the data object
    _downloadedData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the newly downloaded data
    [_downloadedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Create an array to store the locations
    NSMutableArray *_chickenResult = [[NSMutableArray alloc] init];
    
    // Parse the JSON that came in
    NSError *error;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"json array is - %@", jsonArray);

    // Loop through Json objects, create question objects and add them to our questions array
    for (int i = 0; i < jsonArray.count; i++)
    {
 //        Create a new location object and set its props to JsonElement properties

        NSDictionary *jsonElement = jsonArray[i];
        MySqlDB *newDB = [[MySqlDB alloc] init];
        newDB.score = jsonElement[@"cop"];
      //  newDB.idi = jsonElement[@"id"];
        newDB.idi = [NSString stringWithFormat:@"%i", i];

        newDB.nick = jsonElement[@"nic"];

        // Add this question to the locations array
        [_chickenResult addObject:newDB];
    }

    // Ready to notify delegate that data is ready and pass back items
    if (self.delegate)
    {
        NSLog(@"_chickenResult %@", _chickenResult);
         [self.delegate itemsDownloaded2:_chickenResult];
        NSLog(@"AAAALERT2");

    }
    NSLog(@"AAAALERT2.5");

}

// -----------------------------------------------------------------

@end
