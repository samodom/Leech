//
//  LTTMockHTTPResponse.h
//  Leech
//
//  Created by Sam Odom on 2/25/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTMockHTTPResponse : NSObject

@property NSUInteger statusCode;
@property (strong) NSData *responseData;

+ (LTTMockHTTPResponse*)responseWithStatus:(NSUInteger)status payloadFile:(NSString*)payloadFile;

@end
