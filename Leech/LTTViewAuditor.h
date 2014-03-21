//
//  LTTViewAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/20/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTViewAuditor : NSObject

#pragma mark - Superclass calls

+ (void)auditAwakeFromNibMethod:(BOOL)forward;
+ (void)stopAuditingAwakeFromNibMethod;
+ (BOOL)didCallSuperAwakeFromNib;

@end
