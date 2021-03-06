//
//  ViewControllerAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 2/23/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+
#import "TestViewController.h"

//  Production
#import "LTTViewControllerAuditor.h"

@interface ViewControllerAuditorTests : XCTestCase

@end

@implementation ViewControllerAuditorTests {
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
    methodCalled = nil;
    animatedFlag = nil;
    currentImplementation = NULL;
    realImplementation = NULL;

    [super tearDown];
}

#pragma mark - Superclass calls

- (void)testAuditingOfViewDidLoadMethod {
    realImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidLoad)));
    [LTTViewControllerAuditor auditViewDidLoadMethod:YES];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidLoad)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [controller viewDidLoad];
    XCTAssertTrue([LTTViewControllerAuditor didCallSuperViewDidLoad], @"Controller should have called its superclass' -viewDidLoad method");
    [LTTViewControllerAuditor stopAuditingViewDidLoadMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidLoad)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfViewWillAppearMethod {
    realImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewWillAppear:)));
    [LTTViewControllerAuditor auditViewWillAppearMethod:YES];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewWillAppear:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [controller viewWillAppear:YES];
    XCTAssertTrue([LTTViewControllerAuditor didCallSuperViewWillAppear], @"Controller should have called its superclass' -viewWillAppear method");
    XCTAssertTrue([LTTViewControllerAuditor viewWillAppearAnimatedFlag], @"Controller should have passed the animated flag to the superclass method");
    [LTTViewControllerAuditor stopAuditingViewWillAppearMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewWillAppear:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfViewDidAppearMethod {
    realImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidAppear:)));
    [LTTViewControllerAuditor auditViewDidAppearMethod:YES];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidAppear:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [controller viewDidAppear:YES];
    XCTAssertTrue([LTTViewControllerAuditor didCallSuperViewDidAppear], @"Controller should have called its superclass' -viewDidAppear method");
    XCTAssertTrue([LTTViewControllerAuditor viewDidAppearAnimatedFlag], @"Controller should have passed the animated flag to the superclass method");
    [LTTViewControllerAuditor stopAuditingViewDidAppearMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidAppear:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfViewWillDisappearMethod {
    realImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewWillDisappear:)));
    [LTTViewControllerAuditor auditViewWillDisappearMethod:YES];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewWillDisappear:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [controller viewWillDisappear:YES];
    XCTAssertTrue([LTTViewControllerAuditor didCallSuperViewWillDisappear], @"Controller should have called its superclass' -viewWillDisappear method");
    XCTAssertTrue([LTTViewControllerAuditor viewWillDisappearAnimatedFlag], @"Controller should have passed the animated flag to the superclass method");
    [LTTViewControllerAuditor stopAuditingViewWillDisappearMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewWillDisappear:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfViewDidDisappearMethod {
    realImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidDisappear:)));
    [LTTViewControllerAuditor auditViewDidDisappearMethod:YES];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidDisappear:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [controller viewDidDisappear:YES];
    XCTAssertTrue([LTTViewControllerAuditor didCallSuperViewDidDisappear], @"Controller should have called its superclass' -viewDidDisappear method");
    XCTAssertTrue([LTTViewControllerAuditor viewDidDisappearAnimatedFlag], @"Controller should have passed the animated flag to the superclass method");
    [LTTViewControllerAuditor stopAuditingViewDidDisappearMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIViewController class], @selector(viewDidDisappear:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

#pragma mark - View controller presentation

- (void)testAuditingOfPresentViewControllerMethod {
    realImplementation = method_getImplementation(class_getInstanceMethod([TestViewController class], @selector(presentViewController:animated:completion:)));
    [LTTViewControllerAuditor auditPresentViewControllerMethod:controller forward:YES];
    currentImplementation = method_getImplementation(class_getInstanceMethod([TestViewController class], @selector(presentViewController:animated:completion:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    UIViewController *sampleController = [UIViewController new];
    __block BOOL completionCalled = NO;
    leech_completion_block_t completion = ^{
        completionCalled = YES;
    };
    [controller presentViewController:sampleController animated:YES completion:completion];
    XCTAssertEqualObjects([LTTViewControllerAuditor viewControllerToPresent:controller], sampleController, @"The view controller to present should be captured");
    XCTAssertTrue([LTTViewControllerAuditor presentViewControllerAnimatedFlag:controller], @"The animated flag should have been audited");
    leech_completion_block_t capturedBlock = [LTTViewControllerAuditor presentViewControllerCompletionBlock:controller];
    XCTAssertEqualObjects(capturedBlock, completion, @"The completion block should be captured");
    capturedBlock();
    XCTAssertTrue(completionCalled, @"The completion handler should be the same");
    [LTTViewControllerAuditor stopAuditingPresentViewControllerMethod:controller];
    currentImplementation = method_getImplementation(class_getInstanceMethod([TestViewController class], @selector(presentViewController:animated:completion:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

#pragma mark - View controller dismissal

- (void)testAuditingOfDismissViewControllerMethod {
    realImplementation = method_getImplementation(class_getInstanceMethod([TestViewController class], @selector(dismissViewControllerAnimated:completion:)));
    [LTTViewControllerAuditor auditDismissViewControllerMethod:controller forward:YES];
    currentImplementation = method_getImplementation(class_getInstanceMethod([TestViewController class], @selector(dismissViewControllerAnimated:completion:)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    __block BOOL completionCalled = NO;
    leech_completion_block_t completion = ^{
        completionCalled = YES;
    };
    [controller dismissViewControllerAnimated:YES completion:completion];
    XCTAssertTrue([LTTViewControllerAuditor dismissViewControllerAnimatedFlag:controller], @"The animated flag should have been audited");
    leech_completion_block_t capturedBlock = [LTTViewControllerAuditor dismissViewControllerCompletionBlock:controller];
    XCTAssertEqualObjects(capturedBlock, completion, @"The completion block should be captured");
    capturedBlock();
    XCTAssertTrue(completionCalled, @"The completion handler should be the same");
    [LTTViewControllerAuditor stopAuditingDismissViewControllerMethod:controller];
    currentImplementation = method_getImplementation(class_getInstanceMethod([TestViewController class], @selector(dismissViewControllerAnimated:completion:)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

@end
