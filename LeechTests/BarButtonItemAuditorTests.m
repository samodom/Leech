//
//  BarButtonItemAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 3/16/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+


//  Production
#import "LTTBarButtonItemAuditor.h"

@interface BarButtonItemAuditorTests : XCTestCase

@end

@implementation BarButtonItemAuditorTests {
    UIBarButtonItem *button;
    NSDictionary *normalAttributes, *disabledAttributes;
    IMP realProxyImplementation, currentProxyImplementation;
    IMP realGetterImplementation, currentGetterImplementation;
    IMP realSetterImplementation, currentSetterImplementation;
}

- (void)setUp {
    [super setUp];

    button = [UIBarButtonItem new];
    normalAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:[UIFont systemFontSize]] };
    disabledAttributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:8.0] };
}

- (void)tearDown {
    realProxyImplementation = NULL;
    currentProxyImplementation = NULL;
    realGetterImplementation = NULL;
    currentGetterImplementation = NULL;
    realSetterImplementation = NULL;
    currentSetterImplementation = NULL;
    normalAttributes = nil;
    disabledAttributes = nil;
    button = nil;

    [super tearDown];
}

- (void)testAuditingOfAppearanceProxyTitleTextAttributesMethods {
    realProxyImplementation = method_getImplementation(class_getClassMethod([UIBarButtonItem class], @selector(appearance)));
    realGetterImplementation = class_getMethodImplementation([UIBarButtonItem class], @selector(setTitleTextAttributes:forState:));
    realSetterImplementation = class_getMethodImplementation([UIBarButtonItem class], @selector(titleTextAttributesForState:));
    [LTTBarButtonItemAuditor auditAppearanceProxyTitleTextAttributesMethods];
    currentProxyImplementation = method_getImplementation(class_getClassMethod([UIBarButtonItem class], @selector(appearance)));
    XCTAssertNotEqual(currentProxyImplementation, realProxyImplementation, @"The proxy method implementation should be swizzled");
    currentGetterImplementation = class_getMethodImplementation([UIBarButtonItem class], @selector(setTitleTextAttributes:forState:));
    XCTAssertNotEqual(currentGetterImplementation, realGetterImplementation, @"The getter method implementation should be swizzled");
    currentSetterImplementation = class_getMethodImplementation([UIBarButtonItem class], @selector(titleTextAttributesForState:));
    XCTAssertNotEqual(currentSetterImplementation, realSetterImplementation, @"The setter method implementation should be swizzled");
    [[UIBarButtonItem appearance] setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    XCTAssertEqualObjects([[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateNormal], normalAttributes, @"The normal proxy title text attributes should be captured");
    [[UIBarButtonItem appearance] setTitleTextAttributes:disabledAttributes forState:UIControlStateDisabled];
    XCTAssertEqualObjects([[UIBarButtonItem appearance] titleTextAttributesForState:UIControlStateDisabled], disabledAttributes, @"The disabled proxy title text attributes should be captured");
    [LTTBarButtonItemAuditor stopAuditingAppearanceProxyTitleTextAttributesMethods];
    currentProxyImplementation = method_getImplementation(class_getClassMethod([UIBarButtonItem class], @selector(appearance)));
    XCTAssertEqual(currentProxyImplementation, realProxyImplementation, @"The proxy method implementation should not longer be swizzled");
    currentGetterImplementation = class_getMethodImplementation([UIBarButtonItem class], @selector(setTitleTextAttributes:forState:));
    XCTAssertEqual(currentGetterImplementation, realGetterImplementation, @"The getter method implementation should not longer be swizzled");
    currentSetterImplementation = class_getMethodImplementation([UIBarButtonItem class], @selector(titleTextAttributesForState:));
    XCTAssertEqual(currentSetterImplementation, realSetterImplementation, @"The setter method implementation should not longer be swizzled");
}

@end
