//
//  LTTMockHTTPResponse.m
//  Leech
//
//  Created by Sam Odom on 2/25/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTMockHTTPResponse.h"

@implementation LTTMockHTTPResponse

+ (LTTMockHTTPResponse *)responseWithStatus:(NSUInteger)status payloadFile:(NSString *)payloadFile ofType:(NSString *)fileType {
    LTTMockHTTPResponse *response = [LTTMockHTTPResponse new];
    response.statusCode = status;

    if (payloadFile.length) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:payloadFile ofType:fileType];
        response.responseData = [NSData dataWithContentsOfFile:path];
    }

    return response;
}

@end
