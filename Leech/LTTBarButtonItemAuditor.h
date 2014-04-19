//
//  LTTBarButtonItemAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/16/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 LTTBarButtonItemAuditor assists in testing code that modifies the UIBarButtonItem appearance proxy. _For some reason, checking the appearance proxy for this particular class does not work using the XCTest framework._
 
 ##Usage
 
 __Step 1__ Begin auditing the appearance proxy methods
 
     [LTTBarButtonItemAuditor auditAppearanceProxyTitleTextAttributesMethods];

 __Step 2__ Invoke your method that sets the title text attributes on the UIBarButtonItem appearance proxy
 
 __Step 3__ Check that the attributes you expected have been set

     NSDictionary *normalAttributes = @{ NSFontAttributeName: <#enabledFont#>,
                                         NSForegroundColorAttributeName: <#enabledColor#> };
     NSDictionary *disabledAttributes = @{ NSFontAttributeName: <#disabledFont#>,
                                           NSForegroundColorAttributeName: <#disabledColor#> };
     XCTAssertEqualObjects([[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal],
                           normalAttributes,
                           @"The title text attributes should be set for the normal state");
     XCTAssertEqualObjects([[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateDisabled],
                           disabledAttributes,
                           @"The title text attributes should be set for the disabled state");
 
 __Step 4__ End auditing of the appearance proxy methods
 
     [LTTBarButtonItemAuditor stopAuditingAppearanceProxyTitleTextAttributesMethods];
 
 */

@interface LTTBarButtonItemAuditor : NSObject

/**
 Audits modification of the UIBarButtonItem appearance proxy in order to ensure the appropriate title text attributes are set
 
 @discussion This method replaces the real method implementation of `+[UIBarButtonItem appearance]` with another method that returns a test proxy.  It also replaces the real method implementation of `-[UIBarButtonItem setTitleTextAttributes:forState:]` with another method that 
 
 @warning The replacement method DOES NOT call the real method despite returning the object to initialize.
 */
+ (void)auditAppearanceProxyTitleTextAttributesMethods;

/**
 Ends auditing of UIBarButtonItem appearance proxy modification and clears audited data
 */
+ (void)stopAuditingAppearanceProxyTitleTextAttributesMethods;

//+ (void)auditContainedAppearanceProxyMethods;
//+ (void)stopAuditingContainedAppearanceProxyMethods;


@end
