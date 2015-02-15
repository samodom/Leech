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

const char *LTTPopoverControllerPresentationRect = "LTTPopoverControllerPreentationRect";
const char *LTTPopoverControllerPresentationView = "LTTPopoverControllerPresentationView";
const char *LTTPopoverControllerPresentationArrowDirections = "LTTPopoverControllerPresentationArrowDirections";
const char *LTTPopoverControllerPresentationAnimationFlag = "LTTPopoverControllerPresentationAnimationFlag";
const char *LTTPopoverControllerPresentationBarButtonItem = "LTTPopoverControllerPresentationBarButtonItem";

const char *LTTPopoverControllerDismissalAnimationFlag = "LTTPopoverControllerDismissalAnimationFlag";

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

- (void)Leech_PresentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated {
    objc_setAssociatedObject([LTTPopoverControllerAuditor class], LTTPopoverControllerPresentationRect, [NSValue valueWithCGRect:rect], OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTPopoverControllerAuditor class], LTTPopoverControllerPresentationView, view, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTPopoverControllerAuditor class], LTTPopoverControllerPresentationArrowDirections, @(arrowDirections), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTPopoverControllerAuditor class], LTTPopoverControllerPresentationAnimationFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
}

- (void)Leech_PresentPopoverFromBarButtonItem:(UIBarButtonItem *)item permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated {
    objc_setAssociatedObject([LTTPopoverControllerAuditor class], LTTPopoverControllerPresentationBarButtonItem, item, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTPopoverControllerAuditor class], LTTPopoverControllerPresentationArrowDirections, @(arrowDirections), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTPopoverControllerAuditor class], LTTPopoverControllerPresentationAnimationFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
}

- (void)Leech_DismissPopoverAnimated:(BOOL)animated {
    objc_setAssociatedObject([LTTPopoverControllerAuditor class], LTTPopoverControllerDismissalAnimationFlag, @(animated), OBJC_ASSOCIATION_RETAIN);
}

@end

////////////////////////////////////////////////////////////////////////////////
//  Implementation of Popover Controller Auditor
////////////////////////////////////////////////////////////////////////////////

@implementation LTTPopoverControllerAuditor

#pragma mark -initWithContentViewController:

+ (void)auditInitWithContentViewControllerMethod {
    [self swizzleInitializationMethods];
}

+ (void)stopAuditingInitWithContentViewControllerMethod {
    objc_setAssociatedObject([self class], LTTPopoverControllerInitializedPopoverController, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject([self class], LTTPopoverControllerContentViewController, nil, OBJC_ASSOCIATION_ASSIGN);
    [self swizzleInitializationMethods];
}

+ (void)swizzleInitializationMethods {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIPopoverController class] selectorOne:@selector(initWithContentViewController:) selectorTwo:@selector(initLeechWithContentViewController:)];
}

+ (UIPopoverController *)initializedPopoverController {
    return objc_getAssociatedObject([self class], LTTPopoverControllerInitializedPopoverController);
}

+ (UIViewController *)initializationContentViewController {
    return objc_getAssociatedObject([self class], LTTPopoverControllerContentViewController);
}

#pragma mark -presentPopoverFromRect:inView:permittedArrowDirections:animated:

+ (void)auditPresentFromRectMethod {
    [self swizzlePresentFromRectMethods];
}

+ (void)stopAuditingPresentFromRectMethod {
    objc_setAssociatedObject([self class], LTTPopoverControllerPresentationRect, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject([self class], LTTPopoverControllerPresentationView, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject([self class], LTTPopoverControllerPresentationArrowDirections, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject([self class], LTTPopoverControllerPresentationAnimationFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [self swizzlePresentFromRectMethods];
}

+ (void)swizzlePresentFromRectMethods {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIPopoverController class] selectorOne:@selector(presentPopoverFromRect:inView:permittedArrowDirections:animated:) selectorTwo:@selector(Leech_PresentPopoverFromRect:inView:permittedArrowDirections:animated:)];
}

+ (CGRect)rectFromWhichToPresentPopover {
    NSValue *value = objc_getAssociatedObject([self class], LTTPopoverControllerPresentationRect);
    return [value CGRectValue];
}

+ (UIView *)viewInWhichToPresentPopover {
    return objc_getAssociatedObject([self class], LTTPopoverControllerPresentationView);
}

+ (UIPopoverArrowDirection)arrowDirectionsForPopover {
    NSNumber *directions = objc_getAssociatedObject([self class], LTTPopoverControllerPresentationArrowDirections);
    return directions.integerValue;
}

+ (BOOL)presentPopoverAnimationFlag {
    NSNumber *animated = objc_getAssociatedObject([self class], LTTPopoverControllerPresentationAnimationFlag);
    return animated.boolValue;
}

#pragma mark -presentPopoverFromBarButtonItem:permittedArrowDirections:animated:

+ (void)auditPresentFromBarButtonMethod {
    [self swizzlePresentFromBarButtonItemMethods];
}

+ (void)stopAuditingPresentFromBarButtonMethod {
    objc_setAssociatedObject([self class], LTTPopoverControllerPresentationBarButtonItem, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject([self class], LTTPopoverControllerPresentationArrowDirections, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject([self class], LTTPopoverControllerPresentationAnimationFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [self swizzlePresentFromBarButtonItemMethods];
}

+ (void)swizzlePresentFromBarButtonItemMethods {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIPopoverController class] selectorOne:@selector(presentPopoverFromBarButtonItem:permittedArrowDirections:animated:) selectorTwo:@selector(Leech_PresentPopoverFromBarButtonItem:permittedArrowDirections:animated:)];
}

+ (UIBarButtonItem *)barButtonItemFromWhichToPresentPopover {
    return objc_getAssociatedObject([self class], LTTPopoverControllerPresentationBarButtonItem);
}

#pragma mark -dismissPopoverAnimated:

+ (void)auditDismissPopoverAnimatedMethod {
    [self swizzleDismissPopoverMethods];
}

+ (void)stopAuditingDismissPopoverAnimatedMethod {
    objc_setAssociatedObject([self class], LTTPopoverControllerDismissalAnimationFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [self swizzleDismissPopoverMethods];
}

+ (void)swizzleDismissPopoverMethods {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIPopoverController class] selectorOne:@selector(dismissPopoverAnimated:) selectorTwo:@selector(Leech_DismissPopoverAnimated:)];
}

+ (BOOL)dismissPopoverAnimationFlag {
    NSNumber *animated = objc_getAssociatedObject([self class], LTTPopoverControllerDismissalAnimationFlag);
    return animated.boolValue;
}

@end
