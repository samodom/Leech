//
//  LTTActionSheetAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/21/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTActionSheetAuditor : NSObject

#pragma mark -initWithTitle:delegate:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:

+ (void)auditInitWithTitleDelegateButtonTitlesMethod;
+ (void)stopAuditingInitWithTitleDelegateButtonTitlesMethod;
+ (UIActionSheet*)initializedActionSheet;
+ (NSString*)initializationTitle;
+ (id<UIActionSheetDelegate>)initializationDelegate;
+ (NSString*)initializationCancelTitle;
+ (NSString*)initializationDestructTitle;
+ (NSArray*)initializationOtherTitles;

#pragma mark -show

+ (void)auditShowFromTabBarMethod;
+ (void)stopAuditingShowFromTabBarMethod;
+ (UIActionSheet*)actionSheetToShowFromTabBar;
+ (UITabBar*)tabBarToShowFrom;

@end
