//
//  NavigationControllerAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 3/14/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+
#import "TestViewController.h"

//  Production
#import "LTTNavigationControllerAuditor.h"

@interface NavigationControllerAuditorTests : XCTestCase

@end

@implementation NavigationControllerAuditorTests {
    UINavigationController *navController;
}

- (void)setUp {
    [super setUp];

    navController = [UINavigationController new];
}

- (void)tearDown {
    navController = nil;

    [super tearDown];
}

#pragma mark - Pushing view controller

- (void)testAuditingOfPushViewControllerMethod {
    IMP realImplementation = class_getMethodImplementation([navController class], @selector(pushViewController:animated:));
    [LTTNavigationControllerAuditor auditPushViewControllerMethod:navController forward:YES];
    IMP currentImplementation = class_getMethodImplementation([navController class], @selector(pushViewController:animated:));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    UIViewController *sampleController = [UIViewController new];
    [navController pushViewController:sampleController animated:YES];
    XCTAssertEqualObjects([LTTNavigationControllerAuditor viewControllerToPush:navController], sampleController, @"The view controller to push should be captured");
    XCTAssertTrue([LTTNavigationControllerAuditor pushViewControllerAnimatedFlag:navController], @"The animated flag should have been audited");
    [LTTNavigationControllerAuditor stopAuditingPushViewControllerMethod:navController];
    currentImplementation = class_getMethodImplementation([navController class], @selector(pushViewController:animated:));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

@end
