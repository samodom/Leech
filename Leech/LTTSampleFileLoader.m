//
//  LTTSampleFileLoader.m
//  Leech
//
//  Created by Sam Odom on 2/28/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTSampleFileLoader.h"

@implementation LTTSampleFileLoader

#pragma mark - Raw Data

+ (NSData *)loadDataFromFile:(NSString *)fileName ofType:(NSString *)fileType {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:fileName ofType:fileType];
    return [NSData dataWithContentsOfFile:path];
}

+ (NSString *)loadStringFromFile:(NSString *)fileName ofType:(NSString *)fileType {
    NSData *data = [self loadDataFromFile:fileName ofType:fileType];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - JSON

+ (NSDictionary *)loadDictionaryFromJSONFile:(NSString *)jsonFileName {
    NSData *data = [self loadDataFromFile:jsonFileName ofType:@"json"];

    __autoreleasing NSError *error = nil;
    NSDictionary *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error)
        NSLog(@"Error parsing JSON file: %@", error.debugDescription);

    return values;
}

+ (NSArray *)loadArrayFromJSONFile:(NSString *)jsonFileName {
    NSData *data = [self loadDataFromFile:jsonFileName ofType:@"json"];

    __autoreleasing NSError *error = nil;
    NSArray *values = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error)
        NSLog(@"Error parsing JSON file: %@", error.debugDescription);

    return values;
}

+ (NSData*)dataFromJSONFile:(NSString*)jsonFileName {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:jsonFileName ofType:@"json"];
    return [NSData dataWithContentsOfFile:path];
}

@end
