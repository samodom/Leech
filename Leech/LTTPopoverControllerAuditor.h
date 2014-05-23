//
//  LTTPopoverControllerAuditor.h
//  Leech
//
//  Created by Sam Odom on 5/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTPopoverControllerAuditor : NSObject

+ (void)auditInitWithContentViewControllerMethod;
+ (void)stopAuditingInitWithContentViewControllerMethod;
+ (UIPopoverController*)initiliazedPopoverController;
+ (UIViewController*)initializationContentViewController;

@end
