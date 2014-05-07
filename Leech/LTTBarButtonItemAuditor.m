//
//  LTTBarButtonItemAuditor.m
//  Leech
//
//  Created by Sam Odom on 3/16/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTBarButtonItemAuditor.h"

#import "LTTMethodSwizzler.h"

const char *BarButtonItemAppearanceProxy = "BarButtonItemAppearanceProxy";
const char *NormalTitleTextAttributes = "NormalTitleTextAttributes";
const char *DisabledTitleTextAttributes = "DisabledTitleTextAttributes";

////////////////////////////////////////////////////////////////////////////////
//  Category on UIBarButtonItem
////////////////////////////////////////////////////////////////////////////////

@implementation UIBarButtonItem (Leech)

+ (instancetype)Leech_Appearance {
    UIBarButtonItem *testProxy = objc_getAssociatedObject([LTTBarButtonItemAuditor class], BarButtonItemAppearanceProxy);
    if (!testProxy) {
        testProxy = [UIBarButtonItem new];
        objc_setAssociatedObject([LTTBarButtonItemAuditor class], BarButtonItemAppearanceProxy, testProxy, OBJC_ASSOCIATION_RETAIN);
    }
    return testProxy;
}

- (void)Leech_SetTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state {
    const char *stateKey = nil;
    if (state == UIControlStateNormal)
        stateKey = NormalTitleTextAttributes;

    else if (state == UIControlStateDisabled)
        stateKey = DisabledTitleTextAttributes;

    if (stateKey)
        objc_setAssociatedObject(self, stateKey, attributes, OBJC_ASSOCIATION_RETAIN);
}

- (NSDictionary *)Leech_TitleTextAttributesForState:(UIControlState)state {
    const char *stateKey = nil;
    if (state == UIControlStateNormal)
        stateKey = NormalTitleTextAttributes;

    else if (state == UIControlStateDisabled)
        stateKey = DisabledTitleTextAttributes;

    if (stateKey)
        return objc_getAssociatedObject(self, stateKey);

    return nil;
}


@end

////////////////////////////////////////////////////////////////////////////////
//  Bar Button Item Auditor implementation
////////////////////////////////////////////////////////////////////////////////

@implementation LTTBarButtonItemAuditor

+ (void)auditAppearanceProxyTitleTextAttributesMethods {
    [LTTMethodSwizzler swapClassMethodsForClass:[UIBarButtonItem class] selectorOne:@selector(appearance) selectorTwo:@selector(Leech_Appearance)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIBarButtonItem class] selectorOne:@selector(setTitleTextAttributes:forState:) selectorTwo:@selector(Leech_SetTitleTextAttributes:forState:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIBarButtonItem class] selectorOne:@selector(titleTextAttributesForState:) selectorTwo:@selector(Leech_TitleTextAttributesForState:)];
}

+ (void)stopAuditingAppearanceProxyTitleTextAttributesMethods {
    objc_setAssociatedObject([LTTBarButtonItemAuditor class], BarButtonItemAppearanceProxy, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapClassMethodsForClass:[UIBarButtonItem class] selectorOne:@selector(appearance) selectorTwo:@selector(Leech_Appearance)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIBarButtonItem class] selectorOne:@selector(setTitleTextAttributes:forState:) selectorTwo:@selector(Leech_SetTitleTextAttributes:forState:)];
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIBarButtonItem class] selectorOne:@selector(titleTextAttributesForState:) selectorTwo:@selector(Leech_TitleTextAttributesForState:)];
}

@end
