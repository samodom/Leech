//
//  ViewAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 3/20/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+
#import "TestView.h"

//  Production
#import "LTTViewAuditor.h"

@interface ViewAuditorTests : XCTestCase

@end

@implementation ViewAuditorTests {
    TestView *view;;
}

- (void)setUp {
    [super setUp];

    view = [TestView new];
}

- (void)tearDown {
    view = nil;

    [super tearDown];
}

- (void)testAuditingOfAwakeFromNibMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UIView class], @selector(awakeFromNib)));
    [LTTViewAuditor auditAwakeFromNibMethod:YES];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UIView class], @selector(awakeFromNib)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [view awakeFromNib];
    XCTAssertTrue([LTTViewAuditor didCallSuperAwakeFromNib], @"The view should call its superclass' -awakeFromNib method");
    [LTTViewAuditor stopAuditingAwakeFromNibMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIView class], @selector(awakeFromNib)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfLayoutSubviewsMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UIView class], @selector(layoutSubviews)));
    [LTTViewAuditor auditLayoutSubviewsMethod:YES];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UIView class], @selector(layoutSubviews)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [view layoutSubviews];
    XCTAssertTrue([LTTViewAuditor didCallSuperLayoutSubviews], @"The view should call its superclass' -layoutSubviews method");
    [LTTViewAuditor stopAuditingLayoutSubviewsMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIView class], @selector(layoutSubviews)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfSetNeedsDisplayMethod {
    IMP realImplementation = method_getImplementation(class_getInstanceMethod([UIView class], @selector(setNeedsDisplay)));
    [LTTViewAuditor auditSetNeedsDisplayMethod:YES];
    IMP currentImplementation = method_getImplementation(class_getInstanceMethod([UIView class], @selector(setNeedsDisplay)));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [view setNeedsDisplay];
    XCTAssertTrue([LTTViewAuditor didCallSetNeedsDisplay], @"The view should capture calls to its -setNeedsDisplay method");
    [LTTViewAuditor stopAuditingSetNeedsDisplayMethod];
    currentImplementation = method_getImplementation(class_getInstanceMethod([UIView class], @selector(setNeedsDisplay)));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

@end
