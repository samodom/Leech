//
//  LTTMockURLSession.m
//  Leech
//
//  Created by Sam Odom on 2/26/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTMockURLSession.h"

#import "LTTMockURLDataTask.h"

@implementation LTTMockURLSession {
    NSMutableArray *dataTasks;
}

- (NSURLSessionDataTask*)dataTaskWithURL:(NSURL*)url completionHandler:(data_task_completion_t)completionHandler {
    LTTMockURLDataTask *task = [LTTMockURLDataTask new];
    task.URL = url;
    task.completionHandler = completionHandler;
    [dataTasks addObject:task];
    return (NSURLSessionDataTask*) task;
}

- (void)getTasksWithCompletionHandler:(task_list_completion_t)completionHandler {
    NSPredicate *activePredicate = [NSPredicate predicateWithFormat:@"state == %i || state == %i", NSURLSessionTaskStateRunning, NSURLSessionTaskStateSuspended];
    NSArray *activeDataTasks = [dataTasks filteredArrayUsingPredicate:activePredicate];
    completionHandler(activeDataTasks, nil, nil);
}

- (id)init {
    if (self = [super init]) {
        dataTasks = [NSMutableArray array];
    }

    return self;
}

@end
