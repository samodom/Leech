//
//  LTTAlertViewAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/31/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTAlertViewAuditor : NSObject

#pragma mark -initWithTitle:message:delegate:cancelButtonTitle:otherButtonTitles:

+ (void)auditInitWithTitleMessageDelegateButtonTitlesMethod;
+ (void)stopAuditingInitWithTitleMessageDelegateButtonTitlesMethod;
+ (UIAlertView*)initializedAlertView;
+ (NSString*)initializationTitle;
+ (NSString*)initializationMessage;
+ (id<UIAlertViewDelegate>)initializationDelegate;
+ (NSString*)initializationCancelTitle;
+ (NSArray*)initializationOtherTitles;

#pragma mark -show

+ (void)auditShowMethod;
+ (void)stopAuditingShowMethod;
+ (BOOL)didShowAlertView;

@end
