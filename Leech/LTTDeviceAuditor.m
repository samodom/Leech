//
//  LTTDeviceAuditor.m
//  Leech
//
//  Created by Sam Odom on 7/2/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTDeviceAuditor.h"

#import "LTTMethodSwizzler.h"

const char * UIDeviceForcedUserInterfaceIdiom = "UIDeviceForcedUserInterfaceIdiom";

@implementation UIDevice (Leech)

- (UIUserInterfaceIdiom)Leech_UserInterfaceIdiom {
    
    UIDevice *device = [UIDevice currentDevice];
    NSNumber *idiom = objc_getAssociatedObject(device, UIDeviceForcedUserInterfaceIdiom);
    return idiom.integerValue;
}

@end

@implementation LTTDeviceAuditor

+ (void)forceUserInterfaceIdiom:(UIUserInterfaceIdiom)idiom {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIDevice class] selectorOne:@selector(userInterfaceIdiom) selectorTwo:@selector(Leech_UserInterfaceIdiom)];
    UIDevice *device = [UIDevice currentDevice];
    objc_setAssociatedObject(device, UIDeviceForcedUserInterfaceIdiom, @(idiom), OBJC_ASSOCIATION_RETAIN);
}

+ (void)stopForcingUserInterfaceIdiom {
    UIDevice *device = [UIDevice currentDevice];
    objc_setAssociatedObject(device, UIDeviceForcedUserInterfaceIdiom, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[UIDevice class] selectorOne:@selector(userInterfaceIdiom) selectorTwo:@selector(Leech_UserInterfaceIdiom)];
}

@end
