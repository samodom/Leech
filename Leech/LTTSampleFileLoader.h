//
//  LTTSampleFileLoader.h
//  Leech
//
//  Created by Sam Odom on 2/28/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTSampleFileLoader : NSObject

#pragma mark - Raw Data

+ (NSData*)loadDataFromFile:(NSString*)fileName ofType:(NSString*)fileType;
+ (NSString*)loadStringFromFile:(NSString*)fileName ofType:(NSString*)fileType;

#pragma mark - JSON

+ (NSDictionary*)loadDictionaryFromJSONFile:(NSString*)jsonFileName;
+ (NSArray*)loadArrayFromJSONFile:(NSString*)jsonFileName;

@end
