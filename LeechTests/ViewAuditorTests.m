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

@end
