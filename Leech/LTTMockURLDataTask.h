//
//  LTTMockURLDataTask.h
//  Leech
//
//  Created by Sam Odom on 2/26/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^data_task_completion_t)(NSData *data, NSURLResponse *response, NSError *error);

@interface LTTMockURLDataTask : NSObject

@property NSURLSessionTaskState state;
@property (strong) NSURL *URL;
@property (strong) data_task_completion_t completionHandler;

- (BOOL)wasAskedToCancel;

@end
