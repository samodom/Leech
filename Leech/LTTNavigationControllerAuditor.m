//
//  LTTNavigationControllerAuditor.m
//  Leech
//
//  Created by Sam Odom on 3/14/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTNavigationControllerAuditor.h"

#import "LTTMethodSwizzler.h"

const char *ForwardPushViewControllerCall = "ForwardPushViewControllerCall";
const char *ViewControllerToPush = "ViewControllerToPush";
const char *PushViewControllerAnimatedFlag = "PushViewControllerAnimatedFlag";

const char *ForwardPopViewControllerCall = "ForwardPopViewControllerCall";
const char *PopViewControllerAnimatedFlag = "PopViewControllerAnimatedFlag";

@implementation UINavigationController (Leech)

- (void)Leech_PushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    objc_setAssociatedObject(self, ViewControllerToPush, viewController, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, PushViewControllerAnimatedFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ForwardPushViewControllerCall);
    if (forward.boolValue)
        [self Leech_PushViewController:viewController animated:animated];
}

- (void)Leech_PopViewControllerAnimated:(BOOL)animated {
    objc_setAssociatedObject(self, PopViewControllerAnimatedFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ForwardPopViewControllerCall);
    if (forward.boolValue)
        [self Leech_PopViewControllerAnimated:animated];
}

@end

@implementation LTTNavigationControllerAuditor

#pragma mark -pushViewController:animated:

+ (void)auditPushViewControllerMethod:(UINavigationController *)navController forward:(BOOL)forward {
    objc_setAssociatedObject(navController, ForwardPushViewControllerCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[navController class] selectorOne:@selector(pushViewController:animated:) selectorTwo:@selector(Leech_PushViewController:animated:)];
}

+ (void)stopAuditingPushViewControllerMethod:(UINavigationController *)auditedController {
    objc_setAssociatedObject(auditedController, ForwardPushViewControllerCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(auditedController, ViewControllerToPush, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(auditedController, PushViewControllerAnimatedFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[auditedController class] selectorOne:@selector(pushViewController:animated:) selectorTwo:@selector(Leech_PushViewController:animated:)];
}

+ (UIViewController *)viewControllerToPush:(UINavigationController *)auditedController {
    return objc_getAssociatedObject(auditedController, ViewControllerToPush);
}

+ (BOOL)pushViewControllerAnimatedFlag:(UINavigationController *)auditedController {
    NSNumber *animated = objc_getAssociatedObject(auditedController, PushViewControllerAnimatedFlag);
    return animated.boolValue;
}

#pragma mark -popViewControllerAnimated:

+ (void)auditPopViewControllerMethod:(UINavigationController *)navController forward:(BOOL)forward {
    objc_setAssociatedObject(navController, ForwardPopViewControllerCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[navController class] selectorOne:@selector(popViewControllerAnimated:) selectorTwo:@selector(Leech_PopViewControllerAnimated:)];
}

+ (void)stopAuditingPopViewControllerMethod:(UINavigationController *)auditedController {
    objc_setAssociatedObject(auditedController, ForwardPopViewControllerCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(auditedController, PopViewControllerAnimatedFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[auditedController class] selectorOne:@selector(popViewControllerAnimated:) selectorTwo:@selector(Leech_PopViewControllerAnimated:)];
}

+ (BOOL)popViewControllerAnimatedFlag:(UINavigationController *)auditedController {
    NSNumber *animated = objc_getAssociatedObject(auditedController, PopViewControllerAnimatedFlag);
    return animated.boolValue;
}

@end
