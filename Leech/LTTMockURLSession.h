//
//  LTTMockURLSession.h
//  Leech
//
//  Created by Sam Odom on 2/26/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

typedef void (^task_list_completion_t)(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks);

#import <Foundation/Foundation.h>

@interface LTTMockURLSession : NSObject

@end
