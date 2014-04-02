//
//  LTTActionSheetAuditor.m
//  Leech
//
//  Created by Sam Odom on 3/21/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTActionSheetAuditor.h"

#import "LTTMethodSwizzler.h"

const char *InitializedActionSheet = "InitializedActionSheet";
const char *InitializationActionSheetTitle = "InitializationActionSheetTitle";
const char *InitializationActionSheetDelegate = "InitializationActionSheetDelegate";
const char *InitializationActionSheetCancelTitle = "InitializationActionSheetCancelTitle";
const char *InitializationActionSheetDestructTitle = "InitializationActionSheetDestructTitle";
const char *InitializationActionSheetOtherTitles = "InitializationActionSheetOtherTitles";

const char *ActionSheetToShow = "ActionSheetToShow";
const char *TabBarToShowFrom = "TabBarToShowFrom";

////////////////////////////////////////////////////////////////////////////////
//  Category on UIActionSheet
////////////////////////////////////////////////////////////////////////////////

@implementation UIActionSheet (Leech)

- (id)initLeechWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION {
    objc_setAssociatedObject([LTTActionSheetAuditor class], InitializationActionSheetTitle, title, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTActionSheetAuditor class], InitializationActionSheetDelegate, delegate, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTActionSheetAuditor class], InitializationActionSheetCancelTitle, cancelButtonTitle, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTActionSheetAuditor class], InitializationActionSheetDestructTitle, destructiveButtonTitle, OBJC_ASSOCIATION_RETAIN);

    if (otherButtonTitles) {
        va_list arguments;
        id tempTitle;
        va_start(arguments, otherButtonTitles);
        NSMutableArray *titles = [@[otherButtonTitles] mutableCopy];
        while ((tempTitle = va_arg(arguments, id)) != nil)
            [titles addObject:tempTitle];
        va_end(arguments);
        objc_setAssociatedObject([LTTActionSheetAuditor class], InitializationActionSheetOtherTitles, [NSArray arrayWithArray:titles], OBJC_ASSOCIATION_RETAIN);
    }

    objc_setAssociatedObject([LTTActionSheetAuditor class], InitializedActionSheet, self, OBJC_ASSOCIATION_RETAIN);

    return self;
}

- (void)Leech_ShowFromTabBar:(UITabBar*)tabBar {
    objc_setAssociatedObject([LTTActionSheetAuditor class], ActionSheetToShow, self, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject([LTTActionSheetAuditor class], TabBarToShowFrom, tabBar, OBJC_ASSOCIATION_RETAIN);
}

@end

////////////////////////////////////////////////////////////////////////////////
//  Action Sheet Auditor implementation
////////////////////////////////////////////////////////////////////////////////

@implementation LTTActionSheetAuditor

#pragma mark -initWithTitle:delegate:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:

+ (void)auditInitWithTitleDelegateButtonTitlesMethod {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIActionSheet class] selectorOne:@selector(initWithTitle:delegate:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:) selectorTwo:@selector(initLeechWithTitle:delegate:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:)];
}

+ (void)stopAuditingInitWithTitleDelegateButtonTitlesMethod {
    objc_setAssociatedObject(self, InitializedActionSheet, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, InitializationActionSheetTitle, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, InitializationActionSheetDelegate, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, InitializationActionSheetCancelTitle, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, InitializationActionSheetDestructTitle, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, InitializationActionSheetOtherTitles, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIActionSheet class] selectorOne:@selector(initWithTitle:delegate:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:) selectorTwo:@selector(initLeechWithTitle:delegate:cancelButtonTitle:destructiveButtonTitle:otherButtonTitles:)];
}

+ (UIActionSheet *)initializedActionSheet {
    return objc_getAssociatedObject(self, InitializedActionSheet);
}

+ (NSString *)initializationTitle {
    return objc_getAssociatedObject(self, InitializationActionSheetTitle);
}

+ (id<UIActionSheetDelegate>)initializationDelegate {
    return objc_getAssociatedObject(self, InitializationActionSheetDelegate);
}

+ (NSString *)initializationCancelTitle {
    return objc_getAssociatedObject(self, InitializationActionSheetCancelTitle);
}

+ (NSString *)initializationDestructTitle {
    return objc_getAssociatedObject(self, InitializationActionSheetDestructTitle);
}

+ (NSArray *)initializationOtherTitles {
    return objc_getAssociatedObject(self, InitializationActionSheetOtherTitles);
}

#pragma mark -show

+ (void)auditShowFromTabBarMethod {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIActionSheet class] selectorOne:@selector(showFromTabBar:) selectorTwo:@selector(Leech_ShowFromTabBar:)];
}

+ (void)stopAuditingShowFromTabBarMethod {
    objc_setAssociatedObject(self, ActionSheetToShow, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, TabBarToShowFrom, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIActionSheet class] selectorOne:@selector(showFromTabBar:) selectorTwo:@selector(Leech_ShowFromTabBar:)];
}

+ (UIActionSheet*)actionSheetToShowFromTabBar {
    return objc_getAssociatedObject(self, ActionSheetToShow);
}

+ (UITabBar *)tabBarToShowFrom {
    return objc_getAssociatedObject(self, TabBarToShowFrom);
}

@end
