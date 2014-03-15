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

@implementation UINavigationController (Leech)

- (void)Leech_PushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    objc_setAssociatedObject(self, ViewControllerToPush, viewController, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, PushViewControllerAnimatedFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ForwardPushViewControllerCall);
    if (forward.boolValue)
        [self Leech_PushViewController:viewController animated:animated];
}

@end

@implementation LTTNavigationControllerAuditor

+ (void)auditPushViewControllerMethod:(BOOL)forward {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UINavigationController class] selectorOne:@selector(pushViewController:animated:) selectorTwo:@selector(Leech_PushViewController:animated:)];
}

+ (void)stopAuditingPushViewControllerMethod:(UINavigationController *)auditedController {
    objc_setAssociatedObject(auditedController, ForwardPushViewControllerCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(auditedController, ViewControllerToPush, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(auditedController, PushViewControllerAnimatedFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UINavigationController class] selectorOne:@selector(pushViewController:animated:) selectorTwo:@selector(Leech_PushViewController:animated:)];
}

+ (UIViewController *)viewControllerToPush:(UINavigationController *)auditedController {
    return objc_getAssociatedObject(auditedController, ViewControllerToPush);
}

+ (BOOL)pushViewControllerAnimatedFlag:(UINavigationController *)auditedController {
    NSNumber *animated = objc_getAssociatedObject(auditedController, PushViewControllerAnimatedFlag);
    return animated.boolValue;
}

@end
