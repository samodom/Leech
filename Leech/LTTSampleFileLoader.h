//
//  LTTSampleFileLoader.h
//  Leech
//
//  Created by Sam Odom on 2/28/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Helper class for loading sample data when testing
 */
@interface LTTSampleFileLoader : NSObject

#pragma mark - Raw Data

/** @name Loading raw file contents */

/**
 Loads a given file and returns the raw data contents
 
 @param fileName The name of the sample file without its extension
 @param fileType The file extension of the sample file
 
 @return NSData representing the raw contents of the file
 */
+ (NSData*)loadDataFromFile:(NSString*)fileName ofType:(NSString*)fileType;

/**
 Loads a given file and returns the text contents
 
 @param fileName The name of the sample file without its extension
 @param fileType The file extension of the sample file
 
 @return NSString representing the text contents of the file
 */
+ (NSString*)loadStringFromFile:(NSString*)fileName ofType:(NSString*)fileType;

#pragma mark - JSON

/** @name Loading JSON file contents */

/**
 Loads a given JSON file and returns the parsed contents as a dictionary
 
 @param jsonFileName The name of the sample file without its extension
 
 @return NSDictionary representing the parsed contents of the file
 */
+ (NSDictionary*)loadDictionaryFromJSONFile:(NSString*)jsonFileName;

/**
 Loads a given JSON file and returns the parsed contents as an array
 
 @param jsonFileName The name of the sample file without its extension
 
 @return NSArray representing the parsed contents of the file
 */
+ (NSArray*)loadArrayFromJSONFile:(NSString*)jsonFileName;

@end
