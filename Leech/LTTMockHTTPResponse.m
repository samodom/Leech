//
//  LTTMockHTTPResponse.m
//  Leech
//
//  Created by Sam Odom on 2/25/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTMockHTTPResponse.h"

@implementation LTTMockHTTPResponse

+ (LTTMockHTTPResponse *)responseWithStatus:(NSUInteger)status payloadFile:(NSString *)payloadFile {
    LTTMockHTTPResponse *response = [LTTMockHTTPResponse new];
    response.statusCode = status;
    response.responseData = [NSData dataWithContentsOfFile:payloadFile];
    return response;
}

@end
