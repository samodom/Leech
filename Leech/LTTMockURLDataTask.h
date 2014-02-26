//
//  LTTMockURLDataTask.h
//  Leech
//
//  Created by Sam Odom on 2/26/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTMockURLDataTask : NSObject

@property NSURLSessionTaskState state;

- (BOOL)wasAskedToCancel;

@end
