//
//  UIViewControllerTests.m
//  Leech
//
//  Created by Sam Odom on 2/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

//  Mocks+
#import "TestViewController.h"

//  Production
#import "UIViewController+Leech.h"

@interface UIViewControllerTests : XCTestCase

@end

@implementation UIViewControllerTests {
    NSNumber *methodCalled;
    NSNumber *animatedFlag;
    TestViewController *controller;
    IMP realImplementation, currentImplementation;
}

- (void)setUp {
    [super setUp];

    controller = [TestViewController new];
}

- (void)tearDown {
    [controller clearAuditData];

    methodCalled = nil;
    animatedFlag = nil;
    currentImplementation = NULL;
    realImplementation = NULL;

    [super tearDown];
}

- (void)testClearingOfAuditData {
    NSObject *object = [NSObject new];
    objc_setAssociatedObject(controller, @"sample audit key", object, OBJC_ASSOCIATION_RETAIN);
    [controller clearAuditData];
    NSObject *auditData = objc_getAssociatedObject(controller, "sample audit key");
    XCTAssertNil(auditData, @"The associated objects should be cleared");
}

#pragma mark - Superclass calls

- (void)testAuditingOfViewDidLoadMethod {
    realImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidLoad)));
    [UIViewController auditViewDidLoadMethod:YES];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidLoad)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [controller viewDidLoad];
    XCTAssertTrue([controller didCallSuperViewDidLoad], @"Controller should have called its superclass' -viewDidLoad method");
    [UIViewController stopAuditingViewDidLoadMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidLoad)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfViewWillAppearMethod {
    realImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewWillAppear:)));
    [UIViewController auditViewWillAppearMethod:YES];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewWillAppear:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [controller viewWillAppear:YES];
    XCTAssertTrue([controller didCallSuperViewWillAppear], @"Controller should have called its superclass' -viewWillAppear method");
    XCTAssertTrue([controller viewWillAppearAnimatedFlag], @"Controller should have passed the animated flag to the superclass method");
    [UIViewController stopAuditingViewWillAppearMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewWillAppear:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfViewDidAppearMethod {
    realImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidAppear:)));
    [UIViewController auditViewDidAppearMethod:YES];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidAppear:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [controller viewDidAppear:YES];
    XCTAssertTrue([controller didCallSuperViewDidAppear], @"Controller should have called its superclass' -viewDidAppear method");
    XCTAssertTrue([controller viewDidAppearAnimatedFlag], @"Controller should have passed the animated flag to the superclass method");
    [UIViewController stopAuditingViewDidAppearMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidAppear:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfViewWillDisappearMethod {
    realImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewWillDisappear:)));
    [UIViewController auditViewWillDisappearMethod:YES];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewWillDisappear:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [controller viewWillDisappear:YES];
    XCTAssertTrue([controller didCallSuperViewWillDisappear], @"Controller should have called its superclass' -viewWillDisappear method");
    XCTAssertTrue([controller viewWillDisappearAnimatedFlag], @"Controller should have passed the animated flag to the superclass method");
    [UIViewController stopAuditingViewWillDisappearMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewWillDisappear:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfViewDidDisappearMethod {
    realImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidDisappear:)));
    [UIViewController auditViewDidDisappearMethod:YES];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidDisappear:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [controller viewDidDisappear:YES];
    XCTAssertTrue([controller didCallSuperViewDidDisappear], @"Controller should have called its superclass' -viewDidDisappear method");
    XCTAssertTrue([controller viewDidDisappearAnimatedFlag], @"Controller should have passed the animated flag to the superclass method");
    [UIViewController stopAuditingViewDidDisappearMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidDisappear:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

@end
