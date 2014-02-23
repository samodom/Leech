//
//  UIViewController+Leech.m
//  Leech
//
//  Created by Sam Odom on 2/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <objc/runtime.h>

#import "UIViewController+Leech.h"

#import "LTTMethodSwizzler.h"

const char *ShouldForwardViewDidLoadCall = "ShouldForwardViewDidLoadCall";
const char *ViewDidLoadCalled = "ViewDidLoadCalled";
const char *ShouldForwardViewWillAppearCall = "ShouldForwardViewWillAppearCall";
const char *ViewWillAppearCalled = "ViewWillAppearCalled";
const char *ViewWillAppearAnimatedFlag = "ViewWillAppearAnimatedFlag";
const char *ShouldForwardViewDidAppearCall = "ShouldForwardViewDidAppearCall";
const char *ViewDidAppearCalled = "ViewDidAppearCalled";
const char *ViewDidAppearAnimatedFlag = "ViewDidAppearAnimatedFlag";
const char *ShouldForwardViewWillDisappearCall = "ShouldForwardViewWillDisappearCall";
const char *ViewWillDisappearCalled = "ViewWillDisappearCalled";
const char *ViewWillDisappearAnimatedFlag = "ViewWillDisappearAnimatedFlag";
const char *ShouldForwardViewDidDisappearCall = "ShouldForwardViewDidDisappearCall";
const char *ViewDidDisappearCalled = "ViewDidDisappearCalled";
const char *ViewDidDisappearAnimatedFlag = "ViewDidDisappearAnimatedFlag";

@implementation UIViewController (Leech)

#pragma mark - View

#pragma mark -viewDidLoad

+ (void)auditViewDidLoadMethod:(BOOL)forward {
    objc_setAssociatedObject(self, ShouldForwardViewDidLoadCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewDidLoad) selectorTwo:@selector(Leech_ViewDidLoad)];
}

+ (void)stopAuditingViewDidLoadMethod {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewDidLoad) selectorTwo:@selector(Leech_ViewDidLoad)];
}

- (BOOL)didCallSuperViewDidLoad {
    NSNumber *value = objc_getAssociatedObject(self, ViewDidLoadCalled);
    return value.boolValue;
}

- (void)Leech_ViewDidLoad {
    objc_setAssociatedObject(self, ViewDidLoadCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardViewDidLoadCall);
    if (forward.boolValue)
        [self Leech_ViewDidLoad];
}

#pragma mark -viewWillAppear:

+ (void)auditViewWillAppearMethod:(BOOL)forward {
    objc_setAssociatedObject(self, ShouldForwardViewWillAppearCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewWillAppear:) selectorTwo:@selector(Leech_ViewWillAppear:)];
}

+ (void)stopAuditingViewWillAppearMethod {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewWillAppear:) selectorTwo:@selector(Leech_ViewWillAppear:)];
}

- (BOOL)didCallSuperViewWillAppear {
    NSNumber *value = objc_getAssociatedObject(self, ViewWillAppearCalled);
    return value.boolValue;
}

- (BOOL)viewWillAppearAnimatedFlag {
    NSNumber *value = objc_getAssociatedObject(self, ViewWillAppearAnimatedFlag);
    return value.boolValue;
}

- (void)Leech_ViewWillAppear:(BOOL)animated {
    objc_setAssociatedObject(self, ViewWillAppearCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, ViewWillAppearAnimatedFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardViewWillAppearCall);
    if (forward.boolValue)
        [self Leech_ViewWillAppear:animated];
}

#pragma mark -viewDidAppear:

+ (void)auditViewDidAppearMethod:(BOOL)forward {
    objc_setAssociatedObject(self, ShouldForwardViewDidAppearCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewDidAppear:) selectorTwo:@selector(Leech_ViewDidAppear:)];
}

+ (void)stopAuditingViewDidAppearMethod {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewDidAppear:) selectorTwo:@selector(Leech_ViewDidAppear:)];
}

- (BOOL)didCallSuperViewDidAppear {
    NSNumber *value = objc_getAssociatedObject(self, ViewDidAppearCalled);
    return value.boolValue;
}

- (BOOL)viewDidAppearAnimatedFlag {
    NSNumber *value = objc_getAssociatedObject(self, ViewDidAppearAnimatedFlag);
    return value.boolValue;
}

- (void)Leech_ViewDidAppear:(BOOL)animated {
    objc_setAssociatedObject(self, ViewDidAppearCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, ViewDidAppearAnimatedFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardViewDidAppearCall);
    if (forward.boolValue)
        [self Leech_ViewDidAppear:animated];
}

#pragma mark -viewWillDisappear:

+ (void)auditViewWillDisappearMethod:(BOOL)forward {
    objc_setAssociatedObject(self, ShouldForwardViewWillDisappearCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewWillDisappear:) selectorTwo:@selector(Leech_ViewWillDisappear:)];
}

+ (void)stopAuditingViewWillDisappearMethod {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewWillDisappear:) selectorTwo:@selector(Leech_ViewWillDisappear:)];
}

- (BOOL)didCallSuperViewWillDisappear {
    NSNumber *value = objc_getAssociatedObject(self, ViewWillDisappearCalled);
    return value.boolValue;
}

- (BOOL)viewWillDisappearAnimatedFlag {
    NSNumber *value = objc_getAssociatedObject(self, ViewWillDisappearAnimatedFlag);
    return value.boolValue;
}

- (void)Leech_ViewWillDisappear:(BOOL)animated {
    objc_setAssociatedObject(self, ViewWillDisappearCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, ViewWillDisappearAnimatedFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardViewWillDisappearCall);
    if (forward.boolValue)
        [self Leech_ViewWillDisappear:animated];
}

#pragma mark -viewDidDisappear:

+ (void)auditViewDidDisappearMethod:(BOOL)forward {
    objc_setAssociatedObject(self, ShouldForwardViewDidDisappearCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewDidDisappear:) selectorTwo:@selector(Leech_ViewDidDisappear:)];
}

+ (void)stopAuditingViewDidDisappearMethod {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewDidDisappear:) selectorTwo:@selector(Leech_ViewDidDisappear:)];
}

- (BOOL)didCallSuperViewDidDisappear {
    NSNumber *value = objc_getAssociatedObject(self, ViewDidDisappearCalled);
    return value.boolValue;
}

- (BOOL)viewDidDisappearAnimatedFlag {
    NSNumber *value = objc_getAssociatedObject(self, ViewDidDisappearAnimatedFlag);
    return value.boolValue;
}

- (void)Leech_ViewDidDisappear:(BOOL)animated {
    objc_setAssociatedObject(self, ViewDidDisappearCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, ViewDidDisappearAnimatedFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardViewDidDisappearCall);
    if (forward.boolValue)
        [self Leech_ViewDidDisappear:animated];
}

#pragma mark - Auditing cleanup

- (void)clearAuditData {
    objc_removeAssociatedObjects(self);
}

@end
