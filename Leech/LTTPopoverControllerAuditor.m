//
//  LTTPopoverControllerAuditor.m
//  Leech
//
//  Created by Sam Odom on 5/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTPopoverControllerAuditor.h"

#import "LTTMethodSwizzler.h"

const char *LTTPopoverControllerInitializedPopoverController = "LTTPopoverControllerInitializedPopoverController";
const char *LTTPopoverControllerContentViewController = "LTTPopoverControllerContentViewController";

////////////////////////////////////////////////////////////////////////////////
//  Category on UIPopoverController
////////////////////////////////////////////////////////////////////////////////

@implementation UIPopoverController (Leech)

- (id)initLeechWithContentViewController:(UIViewController *)viewController {
    self = [self initLeechWithContentViewController:viewController];
    objc_setAssociatedObject([LTTPopoverControllerAuditor class], LTTPopoverControllerInitializedPopoverController, self, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTPopoverControllerAuditor class], LTTPopoverControllerContentViewController, viewController, OBJC_ASSOCIATION_RETAIN);
    
    return self;
}

@end

////////////////////////////////////////////////////////////////////////////////
//  Implementation of Popover Controller Auditor
////////////////////////////////////////////////////////////////////////////////

@implementation LTTPopoverControllerAuditor

+ (void)auditInitWithContentViewControllerMethod {
    [self swizzleInstanceMethods];
}

+ (void)stopAuditingInitWithContentViewControllerMethod {
    objc_setAssociatedObject([self class], LTTPopoverControllerInitializedPopoverController, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject([self class], LTTPopoverControllerContentViewController, nil, OBJC_ASSOCIATION_ASSIGN);
    [self swizzleInstanceMethods];
}

+ (void)swizzleInstanceMethods {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIPopoverController class] selectorOne:@selector(initWithContentViewController:) selectorTwo:@selector(initLeechWithContentViewController:)];
}

+ (UIPopoverController *)initiliazedPopoverController {
    return objc_getAssociatedObject([self class], LTTPopoverControllerInitializedPopoverController);
}

+ (UIViewController *)initializationContentViewController {
    return objc_getAssociatedObject([self class], LTTPopoverControllerContentViewController);
}

@end
