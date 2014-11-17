//
//  LTTViewAuditor.m
//  Leech
//
//  Created by Sam Odom on 3/20/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTViewAuditor.h"

#import "LTTMethodSwizzler.h"
#import "NSObject+Association.h"

const char *UIViewShouldForwardAwakeFromNibCall = "UIViewShouldForwardAwakeFromNibCall";
const char *UIViewAwakeFromNibCalled = "UIViewAwakeFromNibCalled";

const char *UIViewShouldForwardLayoutSubviewsCall = "UIViewShouldForwardLayoutSubviewsCall";
const char *UIViewLayoutSubviewsCalled = "UIViewLayoutSubviewsCalled";

const char *UIViewShouldForwardSetNeedsDisplayCall = "UIViewShouldForwardSetNeedsDisplayCall";
const char *UIViewSetNeedsDisplayCalled = "UIViewSetNeedsDisplayCalled";


////////////////////////////////////////////////////////////////////////////////
//  Category on UIView
////////////////////////////////////////////////////////////////////////////////

@implementation UIView (Leech)

- (void)Leech_AwakeFromNib {
    [[LTTViewAuditor class] associateKey:UIViewAwakeFromNibCalled withValue:@YES];
    NSNumber *forward = [[LTTViewAuditor class] associationForKey:UIViewShouldForwardAwakeFromNibCall];
    if (forward.boolValue) {
        [self Leech_AwakeFromNib];
    }
}

- (void)Leech_LayoutSubviews {
    [[LTTViewAuditor class] associateKey:UIViewLayoutSubviewsCalled withValue:@YES];
    NSNumber *forward = [[LTTViewAuditor class] associationForKey:UIViewShouldForwardLayoutSubviewsCall];
    if (forward.boolValue) {
        [self Leech_LayoutSubviews];
    }
}

- (void)Leech_SetNeedsDisplay {
    [[LTTViewAuditor class] associateKey:UIViewSetNeedsDisplayCalled withValue:@YES];
    NSNumber *forward = [[LTTViewAuditor class] associationForKey:UIViewShouldForwardSetNeedsDisplayCall];
    if (forward.boolValue) {
        [self Leech_SetNeedsDisplay];
    }
}

@end

////////////////////////////////////////////////////////////////////////////////
//  View Auditor implementation
////////////////////////////////////////////////////////////////////////////////

@implementation LTTViewAuditor

+ (void)auditAwakeFromNibMethod:(BOOL)forward {
    [self associateKey:UIViewShouldForwardAwakeFromNibCall withValue:@(forward)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIView class] selectorOne:@selector(awakeFromNib) selectorTwo:@selector(Leech_AwakeFromNib)];
}

+ (void)stopAuditingAwakeFromNibMethod {
    [self dissociateKey:UIViewShouldForwardAwakeFromNibCall];
    [self dissociateKey:UIViewAwakeFromNibCalled];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIView class] selectorOne:@selector(awakeFromNib) selectorTwo:@selector(Leech_AwakeFromNib)];
}

+ (BOOL)didCallSuperAwakeFromNib {
    NSNumber *awakeCalled = [self associationForKey:UIViewAwakeFromNibCalled];
    return awakeCalled.boolValue;
}

+ (void)auditLayoutSubviewsMethod:(BOOL)forward {
    [self associateKey:UIViewShouldForwardLayoutSubviewsCall withValue:@(forward)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIView class] selectorOne:@selector(layoutSubviews) selectorTwo:@selector(Leech_LayoutSubviews)];
}

+ (void)stopAuditingLayoutSubviewsMethod {
    [self dissociateKey:UIViewShouldForwardLayoutSubviewsCall];
    [self dissociateKey:UIViewLayoutSubviewsCalled];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIView class] selectorOne:@selector(layoutSubviews) selectorTwo:@selector(Leech_LayoutSubviews)];
}

+ (BOOL)didCallSuperLayoutSubviews {
    NSNumber *layoutCalled = [self associationForKey:UIViewLayoutSubviewsCalled];
    return layoutCalled.boolValue;
}

+ (void)auditSetNeedsDisplayMethod:(BOOL)forward {
    [self associateKey:UIViewShouldForwardSetNeedsDisplayCall withValue:@(forward)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIView class] selectorOne:@selector(setNeedsDisplay) selectorTwo:@selector(Leech_SetNeedsDisplay)];
}

+ (void)stopAuditingSetNeedsDisplayMethod {
    [self dissociateKey:UIViewShouldForwardSetNeedsDisplayCall];
    [self dissociateKey:UIViewSetNeedsDisplayCalled];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIView class] selectorOne:@selector(setNeedsDisplay) selectorTwo:@selector(Leech_SetNeedsDisplay)];
}

+ (BOOL)didCallSetNeedsDisplay {
    NSNumber *needsCalled = [self associationForKey:UIViewSetNeedsDisplayCalled];
    return needsCalled.boolValue;
}

@end
