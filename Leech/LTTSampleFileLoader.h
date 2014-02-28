//
//  LTTSampleFileLoader.h
//  Leech
//
//  Created by Sam Odom on 2/28/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTSampleFileLoader : NSObject

+ (NSDictionary*)loadDictionaryFromJSONFile:(NSString*)jsonFileName;
+ (NSArray*)loadArrayFromJSONFile:(NSString*)jsonFileName;

@end
