//
//  LTTDeviceAuditor.h
//  Leech
//
//  Created by Sam Odom on 7/2/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTDeviceAuditor : NSObject

+ (void)forceUserInterfaceIdiom:(UIUserInterfaceIdiom)idiom;
+ (void)stopForcingUserInterfaceIdiom;

@end
