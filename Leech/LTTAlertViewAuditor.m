//
//  LTTAlertViewAuditor.m
//  Leech
//
//  Created by Sam Odom on 3/31/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTAlertViewAuditor.h"

#import "LTTMethodSwizzler.h"

const char *InitializedAlertView = "InitializedAlertView";
const char *InitializationAlertViewTitle = "InitializationAlertViewTitle";
const char *InitializationAlertViewMessage = "InitializationAlertViewMessage";
const char *InitializationAlertViewDelegate = "InitializationAlertViewDelegate";
const char *InitializationAlertViewCancelTitle = "InitializationAlertViewCancelTitle";
const char *InitializationAlertViewOtherTitles = "InitializationAlertViewOtherTitles";

const char *DidShowAlertView = "DidShowAlertView";

////////////////////////////////////////////////////////////////////////////////
//  Category on UIAlertView
////////////////////////////////////////////////////////////////////////////////

@implementation UIAlertView (Leech)

- (id)initLeechWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    objc_setAssociatedObject([LTTAlertViewAuditor class], InitializationAlertViewTitle, title, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTAlertViewAuditor class], InitializationAlertViewMessage, message, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTAlertViewAuditor class], InitializationAlertViewDelegate, delegate, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTAlertViewAuditor class], InitializationAlertViewCancelTitle, cancelButtonTitle, OBJC_ASSOCIATION_RETAIN);

    if (otherButtonTitles) {
        va_list arguments;
        id tempTitle;
        va_start(arguments, otherButtonTitles);
        NSMutableArray *titles = [@[otherButtonTitles] mutableCopy];
        while ((tempTitle = va_arg(arguments, id)) != nil)
            [titles addObject:tempTitle];
        va_end(arguments);
        objc_setAssociatedObject([LTTAlertViewAuditor class], InitializationAlertViewOtherTitles, [NSArray arrayWithArray:titles], OBJC_ASSOCIATION_RETAIN);
    }

    objc_setAssociatedObject([LTTAlertViewAuditor class], InitializedAlertView, self, OBJC_ASSOCIATION_RETAIN);

    return self;
}

- (void)Leech_Show {
    objc_setAssociatedObject([LTTAlertViewAuditor class], DidShowAlertView, @(YES), OBJC_ASSOCIATION_RETAIN);
}

@end

////////////////////////////////////////////////////////////////////////////////
//  UIAlertView Auditor implmentation
////////////////////////////////////////////////////////////////////////////////

@implementation LTTAlertViewAuditor

#pragma mark -initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:

+ (void)auditInitWithTitleMessageDelegateButtonTitlesMethod {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIAlertView class] selectorOne:@selector(initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:) selectorTwo:@selector(initLeechWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:)];
}

+ (void)stopAuditingInitWithTitleMessageDelegateButtonTitlesMethod {
    objc_setAssociatedObject(self, InitializedAlertView, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, InitializationAlertViewTitle, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, InitializationAlertViewMessage, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, InitializationAlertViewDelegate, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, InitializationAlertViewCancelTitle, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, InitializationAlertViewOtherTitles, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIAlertView class] selectorOne:@selector(initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:) selectorTwo:@selector(initLeechWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:)];
}

+ (UIAlertView *)initializedAlertView {
    return objc_getAssociatedObject(self, InitializedAlertView);
}

+ (NSString *)initializationTitle {
    return objc_getAssociatedObject(self, InitializationAlertViewTitle);
}

+ (NSString *)initializationMessage {
    return objc_getAssociatedObject(self, InitializationAlertViewMessage);
}

+ (id<UIAlertViewDelegate>)initializationDelegate {
    return objc_getAssociatedObject(self, InitializationAlertViewDelegate);
}

+ (NSString *)initializationCancelTitle {
    return objc_getAssociatedObject(self, InitializationAlertViewCancelTitle);
}

+ (NSArray *)initializationOtherTitles {
    return objc_getAssociatedObject(self, InitializationAlertViewOtherTitles);
}

#pragma mark -show

+ (void)auditShowMethod {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIAlertView class] selectorOne:@selector(show) selectorTwo:@selector(Leech_Show)];
}

+ (void)stopAuditingShowMethod {
    objc_setAssociatedObject(self, DidShowAlertView, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIAlertView class] selectorOne:@selector(show) selectorTwo:@selector(Leech_Show)];
}

+ (BOOL)didShowAlertView {
    NSNumber *didShow = objc_getAssociatedObject(self, DidShowAlertView);
    return didShow.boolValue;

}

@end
