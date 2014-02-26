//
//  LTTMockURLDataTask.m
//  Leech
//
//  Created by Sam Odom on 2/26/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTMockURLDataTask.h"

@implementation LTTMockURLDataTask {
    BOOL cancelled;
}

- (void)cancel {
    cancelled = YES;
}

- (BOOL)wasAskedToCancel {
    return cancelled;
}

@end
