//
//  LTTAlertViewAuditor.m
//  Leech
//
//  Created by Sam Odom on 3/31/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTAlertViewAuditor.h"

#import "LTTMethodSwizzler.h"
#import "NSObject+Association.h"

const char *AlertViewAuditorInitializedAlertView = "AlertViewAuditorInitializedAlertView";
const char *AlertViewAuditorInitializationAlertViewTitle = "AlertViewAuditorInitializationAlertViewTitle";
const char *AlertViewAuditorInitializationAlertViewMessage = "AlertViewAuditorInitializationAlertViewMessage";
const char *AlertViewAuditorInitializationAlertViewDelegate = "AlertViewAuditorInitializationAlertViewDelegate";
const char *AlertViewAuditorInitializationAlertViewCancelTitle = "AlertViewAuditorInitializationAlertViewCancelTitle";
const char *AlertViewAuditorInitializationAlertViewOtherTitles = "AlertViewAuditorInitializationAlertViewOtherTitles";

const char *AlertViewAuditorDidShowAlertView = "AlertViewAuditorDidShowAlertView";
const char *AlertViewAuditorAlertToShow = "AlertViewAuditorAlertToShow";

////////////////////////////////////////////////////////////////////////////////
//  Category on UIAlertView
////////////////////////////////////////////////////////////////////////////////

@implementation UIAlertView (Leech)

- (id)initLeechWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    Class cls = [LTTAlertViewAuditor class];
    [cls associateKey:AlertViewAuditorInitializationAlertViewTitle withValue:title];
    [cls associateKey:AlertViewAuditorInitializationAlertViewMessage withValue:message];
    [cls associateKey:AlertViewAuditorInitializationAlertViewDelegate withValue:delegate];
    [cls associateKey:AlertViewAuditorInitializationAlertViewCancelTitle withValue:cancelButtonTitle];

    if (otherButtonTitles) {
        va_list arguments;
        id tempTitle;
        va_start(arguments, otherButtonTitles);
        NSMutableArray *titles = [@[otherButtonTitles] mutableCopy];
        while ((tempTitle = va_arg(arguments, id)) != nil)
            [titles addObject:tempTitle];
        va_end(arguments);
        [cls associateKey:AlertViewAuditorInitializationAlertViewOtherTitles withValue:[NSArray arrayWithArray:titles]];
    }

    [cls associateKey:AlertViewAuditorInitializedAlertView withValue:self];
    return self;
}

- (void)Leech_Show {
    [[LTTAlertViewAuditor class] associateKey:AlertViewAuditorDidShowAlertView withValue:@YES];
}

- (void)Leech_ShowAndCapture {
    [[LTTAlertViewAuditor class] associateKey:AlertViewAuditorAlertToShow withValue:self];
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
    Class cls = [LTTAlertViewAuditor class];
    [cls dissociateKey:AlertViewAuditorInitializedAlertView];
    [cls dissociateKey:AlertViewAuditorInitializationAlertViewTitle];
    [cls dissociateKey:AlertViewAuditorInitializationAlertViewMessage];
    [cls dissociateKey:AlertViewAuditorInitializationAlertViewDelegate];
    [cls dissociateKey:AlertViewAuditorInitializationAlertViewCancelTitle];
    [cls dissociateKey:AlertViewAuditorInitializationAlertViewOtherTitles];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIAlertView class] selectorOne:@selector(initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:) selectorTwo:@selector(initLeechWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:)];
}

+ (UIAlertView *)initializedAlertView {
    return [self associationForKey:AlertViewAuditorInitializedAlertView];
}

+ (NSString *)initializationTitle {
    return [self associationForKey:AlertViewAuditorInitializationAlertViewTitle];
}

+ (NSString *)initializationMessage {
    return [self associationForKey:AlertViewAuditorInitializationAlertViewMessage];
}

+ (id<UIAlertViewDelegate>)initializationDelegate {
    return [self associationForKey:AlertViewAuditorInitializationAlertViewDelegate];
}

+ (NSString *)initializationCancelTitle {
    return [self associationForKey:AlertViewAuditorInitializationAlertViewCancelTitle];
}

+ (NSArray *)initializationOtherTitles {
    return [self associationForKey:AlertViewAuditorInitializationAlertViewOtherTitles];
}

#pragma mark -show

+ (void)auditShowMethod {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIAlertView class] selectorOne:@selector(show) selectorTwo:@selector(Leech_Show)];
}

+ (void)stopAuditingShowMethod {
    [self dissociateKey:AlertViewAuditorDidShowAlertView];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIAlertView class] selectorOne:@selector(show) selectorTwo:@selector(Leech_Show)];
}

+ (BOOL)didShowAlertView {
    NSNumber *didShow = [self associationForKey:AlertViewAuditorDidShowAlertView];
    return didShow.boolValue;
}

+ (void)captureAlertToShow {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIAlertView class] selectorOne:@selector(show) selectorTwo:@selector(Leech_ShowAndCapture)];
}

+ (void)stopCapturingAlertToShow {
    [self dissociateKey:AlertViewAuditorAlertToShow];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIAlertView class] selectorOne:@selector(show) selectorTwo:@selector(Leech_ShowAndCapture)];
}

+ (UIAlertView *)alertToShow {
    return [self associationForKey:AlertViewAuditorAlertToShow];
}

@end
