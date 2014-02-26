//
//  LTTMockURLDataTask.m
//  Leech
//
//  Created by Sam Odom on 2/26/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTMockURLDataTask.h"

@implementation LTTMockURLDataTask {
    BOOL resumed;
    BOOL suspended;
    BOOL cancelled;
}

- (void)resume {
    resumed = YES;
    self.state = NSURLSessionTaskStateRunning;
}

- (BOOL)wasAskedToResume {
    return resumed;
}

- (void)suspend {
    suspended = YES;
    self.state = NSURLSessionTaskStateSuspended;
}

- (BOOL)wasAskedToSuspend {
    return suspended;
}

- (void)cancel {
    cancelled = YES;
    self.state = NSURLSessionTaskStateCanceling;
}

- (BOOL)wasAskedToCancel {
    return cancelled;
}

@end
