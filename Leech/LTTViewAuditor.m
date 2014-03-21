//
//  LTTViewAuditor.m
//  Leech
//
//  Created by Sam Odom on 3/20/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTViewAuditor.h"

#import "LTTMethodSwizzler.h"

const char *ShouldForwardAwakeFromNibCall = "ShouldForwardAwakeFromNibCall";
const char *AwakeFromNibCalled = "AwakeFromNibCalled";

////////////////////////////////////////////////////////////////////////////////
//  Category on UIView
////////////////////////////////////////////////////////////////////////////////

@implementation UIView (Leech)

- (void)Leech_AwakeFromNib {
    objc_setAssociatedObject([LTTViewAuditor class], AwakeFromNibCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject([LTTViewAuditor class], ShouldForwardAwakeFromNibCall);
    if (forward.boolValue)
        [self Leech_AwakeFromNib];
}

@end

////////////////////////////////////////////////////////////////////////////////
//  View Auditor implementation
////////////////////////////////////////////////////////////////////////////////

@implementation LTTViewAuditor

+ (void)auditAwakeFromNibMethod:(BOOL)forward {
    objc_setAssociatedObject(self, ShouldForwardAwakeFromNibCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIView class] selectorOne:@selector(awakeFromNib) selectorTwo:@selector(Leech_AwakeFromNib)];
}

+ (void)stopAuditingAwakeFromNibMethod {
    objc_setAssociatedObject(self, ShouldForwardAwakeFromNibCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, AwakeFromNibCalled, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIView class] selectorOne:@selector(awakeFromNib) selectorTwo:@selector(Leech_AwakeFromNib)];
}

+ (BOOL)didCallSuperAwakeFromNib {
    NSNumber *awakeCalled = objc_getAssociatedObject(self, AwakeFromNibCalled);
    return awakeCalled.boolValue;
}

@end
