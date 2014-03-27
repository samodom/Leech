//
//  LTTViewControllerAuditor.m
//  Leech
//
//  Created by Sam Odom on 2/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTViewControllerAuditor.h"

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

const char *ShouldForwardPresentViewControllerCall = "ShouldForwardPresentViewControllerCall";
const char *ViewControllerToPresent = "ViewControllerToPresent";
const char *PresentViewControllerAnimatedFlag = "PresentViewControllerAnimatedFlag";
const char *PresentViewControllerCompletionBlock = "PresentViewControllerCompletionBlock";
const char *ShouldForwardDismissViewControllerCall = "ShouldForwardDismissViewControllerCall";
const char *DismissViewControllerAnimatedFlag = "DismissViewControllerAnimatedFlag";
const char *DismissViewControllerCompletionBlock = "DismissViewControllerCompletionBlock";

////////////////////////////////////////////////////////////////////////////////
//  Category on UIViewController
////////////////////////////////////////////////////////////////////////////////

@implementation UIViewController (Leech)

#pragma mark - View methods

- (void)Leech_ViewDidLoad {
    objc_setAssociatedObject([LTTViewControllerAuditor class], ViewDidLoadCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject([LTTViewControllerAuditor class], ShouldForwardViewDidLoadCall);
    if (forward.boolValue)
        [self Leech_ViewDidLoad];
}

- (void)Leech_ViewWillAppear:(BOOL)animated {
    objc_setAssociatedObject([LTTViewControllerAuditor class], ViewWillAppearCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTViewControllerAuditor class], ViewWillAppearAnimatedFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject([LTTViewControllerAuditor class], ShouldForwardViewWillAppearCall);
    if (forward.boolValue)
        [self Leech_ViewWillAppear:animated];
}

- (void)Leech_ViewDidAppear:(BOOL)animated {
    objc_setAssociatedObject([LTTViewControllerAuditor class], ViewDidAppearCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTViewControllerAuditor class], ViewDidAppearAnimatedFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject([LTTViewControllerAuditor class], ShouldForwardViewDidAppearCall);
    if (forward.boolValue)
        [self Leech_ViewDidAppear:animated];
}

- (void)Leech_ViewWillDisappear:(BOOL)animated {
    objc_setAssociatedObject([LTTViewControllerAuditor class], ViewWillDisappearCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTViewControllerAuditor class], ViewWillDisappearAnimatedFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject([LTTViewControllerAuditor class], ShouldForwardViewWillDisappearCall);
    if (forward.boolValue)
        [self Leech_ViewWillDisappear:animated];
}

- (void)Leech_ViewDidDisappear:(BOOL)animated {
    objc_setAssociatedObject([LTTViewControllerAuditor class], ViewDidDisappearCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTViewControllerAuditor class], ViewDidDisappearAnimatedFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject([LTTViewControllerAuditor class], ShouldForwardViewDidDisappearCall);
    if (forward.boolValue)
        [self Leech_ViewDidDisappear:animated];
}

#pragma mark - Present/dismiss view controller methods

- (void)Leech_PresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(leech_completion_block_t)completion {
    objc_setAssociatedObject(self, ViewControllerToPresent, viewControllerToPresent, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, PresentViewControllerAnimatedFlag, @(flag), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, PresentViewControllerCompletionBlock, completion, OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardPresentViewControllerCall);
    if (forward.boolValue)
        [self Leech_PresentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)Leech_DismissViewControllerAnimated:(BOOL)flag completion:(leech_completion_block_t)completion {
    objc_setAssociatedObject(self, DismissViewControllerAnimatedFlag, @(flag), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, DismissViewControllerCompletionBlock, completion, OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardDismissViewControllerCall);
    if (forward.boolValue)
        [self Leech_DismissViewControllerAnimated:flag completion:completion];
}

@end

////////////////////////////////////////////////////////////////////////////////
//  Auditor implementation
////////////////////////////////////////////////////////////////////////////////

@implementation LTTViewControllerAuditor

#pragma mark - View

#pragma mark -viewDidLoad

+ (void)auditViewDidLoadMethod:(BOOL)forward {
    objc_setAssociatedObject(self, ShouldForwardViewDidLoadCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewDidLoad) selectorTwo:@selector(Leech_ViewDidLoad)];
}

+ (void)stopAuditingViewDidLoadMethod {
    objc_setAssociatedObject(self, ShouldForwardViewDidLoadCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, ViewDidLoadCalled, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewDidLoad) selectorTwo:@selector(Leech_ViewDidLoad)];
}

+ (BOOL)didCallSuperViewDidLoad {
    NSNumber *value = objc_getAssociatedObject(self, ViewDidLoadCalled);
    return value.boolValue;
}

#pragma mark -viewWillAppear:

+ (void)auditViewWillAppearMethod:(BOOL)forward {
    objc_setAssociatedObject(self, ShouldForwardViewWillAppearCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewWillAppear:) selectorTwo:@selector(Leech_ViewWillAppear:)];
}

+ (void)stopAuditingViewWillAppearMethod {
    objc_setAssociatedObject(self, ShouldForwardViewWillAppearCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, ViewWillAppearCalled, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, ViewWillAppearAnimatedFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewWillAppear:) selectorTwo:@selector(Leech_ViewWillAppear:)];
}

+ (BOOL)didCallSuperViewWillAppear {
    NSNumber *value = objc_getAssociatedObject(self, ViewWillAppearCalled);
    return value.boolValue;
}

+ (BOOL)viewWillAppearAnimatedFlag {
    NSNumber *value = objc_getAssociatedObject(self, ViewWillAppearAnimatedFlag);
    return value.boolValue;
}

#pragma mark -viewDidAppear:

+ (void)auditViewDidAppearMethod:(BOOL)forward {
    objc_setAssociatedObject(self, ShouldForwardViewDidAppearCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewDidAppear:) selectorTwo:@selector(Leech_ViewDidAppear:)];
}

+ (void)stopAuditingViewDidAppearMethod {
    objc_setAssociatedObject(self, ShouldForwardViewDidAppearCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, ViewDidAppearCalled, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, ViewDidAppearAnimatedFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewDidAppear:) selectorTwo:@selector(Leech_ViewDidAppear:)];
}

+ (BOOL)didCallSuperViewDidAppear {
    NSNumber *value = objc_getAssociatedObject(self, ViewDidAppearCalled);
    return value.boolValue;
}

+ (BOOL)viewDidAppearAnimatedFlag {
    NSNumber *value = objc_getAssociatedObject(self, ViewDidAppearAnimatedFlag);
    return value.boolValue;
}

#pragma mark -viewWillDisappear:

+ (void)auditViewWillDisappearMethod:(BOOL)forward {
    objc_setAssociatedObject(self, ShouldForwardViewWillDisappearCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewWillDisappear:) selectorTwo:@selector(Leech_ViewWillDisappear:)];
}

+ (void)stopAuditingViewWillDisappearMethod {
    objc_setAssociatedObject(self, ShouldForwardViewWillDisappearCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, ViewWillDisappearCalled, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, ViewWillDisappearAnimatedFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewWillDisappear:) selectorTwo:@selector(Leech_ViewWillDisappear:)];
}

+ (BOOL)didCallSuperViewWillDisappear {
    NSNumber *value = objc_getAssociatedObject(self, ViewWillDisappearCalled);
    return value.boolValue;
}

+ (BOOL)viewWillDisappearAnimatedFlag {
    NSNumber *value = objc_getAssociatedObject(self, ViewWillDisappearAnimatedFlag);
    return value.boolValue;
}

#pragma mark -viewDidDisappear:

+ (void)auditViewDidDisappearMethod:(BOOL)forward {
    objc_setAssociatedObject(self, ShouldForwardViewDidDisappearCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewDidDisappear:) selectorTwo:@selector(Leech_ViewDidDisappear:)];
}

+ (void)stopAuditingViewDidDisappearMethod {
    objc_setAssociatedObject(self, ShouldForwardViewDidDisappearCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, ViewDidAppearCalled, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, ViewDidAppearAnimatedFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIViewController class] selectorOne:@selector(viewDidDisappear:) selectorTwo:@selector(Leech_ViewDidDisappear:)];
}

+ (BOOL)didCallSuperViewDidDisappear {
    NSNumber *value = objc_getAssociatedObject(self, ViewDidDisappearCalled);
    return value.boolValue;
}

+ (BOOL)viewDidDisappearAnimatedFlag {
    NSNumber *value = objc_getAssociatedObject(self, ViewDidDisappearAnimatedFlag);
    return value.boolValue;
}

#pragma mark - Present/dismiss view controller methods

#pragma mark -presentViewController:animated:completion:

+ (void)auditPresentViewControllerMethod:(UIViewController *)viewController forward:(BOOL)forward {
    objc_setAssociatedObject(viewController, ShouldForwardPresentViewControllerCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[viewController class] selectorOne:@selector(presentViewController:animated:completion:) selectorTwo:@selector(Leech_PresentViewController:animated:completion:)];
}

+ (void)stopAuditingPresentViewControllerMethod:(UIViewController *)auditedController {
    objc_setAssociatedObject(auditedController, ShouldForwardPresentViewControllerCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(auditedController, ViewControllerToPresent, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(auditedController, PresentViewControllerAnimatedFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(auditedController, PresentViewControllerCompletionBlock, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[auditedController class] selectorOne:@selector(presentViewController:animated:completion:) selectorTwo:@selector(Leech_PresentViewController:animated:completion:)];
}

+ (UIViewController *)viewControllerToPresent:(UIViewController *)auditedController {
    return objc_getAssociatedObject(auditedController, ViewControllerToPresent);
}

+ (BOOL)presentViewControllerAnimatedFlag:(UIViewController *)auditedController {
    NSNumber *boxedFlag = objc_getAssociatedObject(auditedController, PresentViewControllerAnimatedFlag);
    return boxedFlag.boolValue;
}

+ (leech_completion_block_t)presentViewControllerCompletionBlock:(UIViewController *)auditedController {
    return objc_getAssociatedObject(auditedController, PresentViewControllerCompletionBlock);
}

#pragma mark -dismissViewControllerAnimated:completion:

+ (void)auditDismissViewControllerMethod:(UIViewController*)viewController forward:(BOOL)forward {
    objc_setAssociatedObject(viewController, ShouldForwardDismissViewControllerCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[viewController class] selectorOne:@selector(dismissViewControllerAnimated:completion:) selectorTwo:@selector(Leech_DismissViewControllerAnimated:completion:)];
}

+ (void)stopAuditingDismissViewControllerMethod:(UIViewController *)auditedController {
    objc_setAssociatedObject(auditedController, ShouldForwardDismissViewControllerCall, nil, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(auditedController, DismissViewControllerAnimatedFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(auditedController, DismissViewControllerCompletionBlock, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[auditedController class] selectorOne:@selector(dismissViewControllerAnimated:completion:) selectorTwo:@selector(Leech_DismissViewControllerAnimated:completion:)];
}

+ (BOOL)dismissViewControllerAnimatedFlag:(UIViewController *)auditedController {
    NSNumber *boxedFlag = objc_getAssociatedObject(auditedController, DismissViewControllerAnimatedFlag);
    return boxedFlag.boolValue;
}

+ (leech_completion_block_t)dismissViewControllerCompletionBlock:(UIViewController *)auditedController {
    return objc_getAssociatedObject(auditedController, DismissViewControllerCompletionBlock);
}

@end
