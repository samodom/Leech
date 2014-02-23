//
//  MockNotificationCenterTests.m
//  CanWeNetwork
//
//  Created by Sam Odom on 9/20/13.
//  Copyright (c) 2013 CanWe Studios, LLC. All rights reserved.
//
//  Yes, this is a set of tests for a mock object.  It's very valuable, though, and is
//  more involved than other test helpers.  That's why we're testing it!!!!!  Tests for
//  -hasObserver... methods are not included since they have to work for all of the other
//  tests to work!

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

//  Mocks +
#import "LTTMockNotificationCenter.h"

//  Production


static NSString *FakeNotificationName = @"FakeNotificationName";
const char *MockNotificationCenterTestingHandlerCalled = "MockNotificationCenterTestingHandlerCalled";

@interface FakeObserver : NSObject

- (void)handler;

@end

@implementation FakeObserver

- (void)handler {}

@end

@interface FakePublisher : NSObject

@end

@implementation FakePublisher

@end

@interface MockNotificationCenterTests : XCTestCase

@end

@implementation MockNotificationCenterTests {
    LTTMockNotificationCenter *center;
    FakePublisher *publisher;
    FakeObserver *observer;
}

- (void)setUp {
    [super setUp];

    center = [LTTMockNotificationCenter new];
    publisher = [FakePublisher new];
    observer = [FakeObserver new];
}

- (void)tearDown {
    center = nil;
    publisher = nil;
    observer = nil;

    [super tearDown];
}

- (void) testCanCreateMockNotificationCenter {
    XCTAssertTrue([center isKindOfClass:[LTTMockNotificationCenter class]], @"Should be able to create a mock notification center");
}

- (void) testCannotAddNilObserver {
    XCTAssertThrows([center addObserver:nil selector:@selector(handler) name:FakeNotificationName object:publisher], @"Should not be able to add a nil observer");
}

- (void) testCannotAddObserverForNilNotificationName {
    XCTAssertThrows([center addObserver:observer selector:@selector(handler) name:nil object:publisher], @"Should not be able to add an observer without a notification name");
}

- (void) testCannotAddObserverForEmptyNotificationName {
    XCTAssertThrows([center addObserver:observer selector:@selector(handler) name:@"" object:publisher], @"Should not be able to add an observer with an empty notification name");
}

- (void) testCenterCanAddObserverForNotificationName {
    [center addObserver:observer selector:@selector(handler) name:FakeNotificationName object:nil];
    XCTAssertTrue([center hasObserver:observer forNotificationName:FakeNotificationName], @"Should be able to add an observer with a notification name");
}

- (void) testCenterCanAddObserverForNotificationNameAndObject {
    [center addObserver:observer selector:@selector(handler) name:FakeNotificationName object:publisher];
    XCTAssertTrue([center hasObserver:observer forNotificationName:FakeNotificationName object:publisher], @"Should be able to add an observer with a notification name and publisher");
}

- (void) testCenterCanAddObserverForNotificationNameAndNilObject {
    [center addObserver:observer selector:@selector(handler) name:FakeNotificationName object:nil];
    XCTAssertTrue([center hasObserver:observer forNotificationName:FakeNotificationName], @"Should be able to add an observer with a notification name and nil publisher");
}

- (void) testCenterCanAddObserverForNotificationNameAndQueueAndBlock {
    NSObject *object = [NSObject new];
    LTTFakeNotificationDispatchEntry *entry = (LTTFakeNotificationDispatchEntry*) [center addObserverForName:FakeNotificationName object:publisher queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        objc_setAssociatedObject(object, MockNotificationCenterTestingHandlerCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    }];
    XCTAssertTrue([center hasObserver:entry forNotificationName:FakeNotificationName object:publisher], @"Should be able to add a notification handler block for a notification and publisher");
    entry.handlerBlock(nil);
    NSNumber *handlerCalled = objc_getAssociatedObject(object, MockNotificationCenterTestingHandlerCalled);
    XCTAssertTrue(handlerCalled.boolValue, @"Handler needs to be saved as part of the entry");
}

- (void) testCenterCanRemoveObserver {
    [center removeObserver:observer];
    XCTAssertFalse([center hasObserver:observer], @"Center should remove all entries for observer");
}

- (void) testCenterIgnoresRemovingNilObserver {
    [center addObserver:observer selector:@selector(handler) name:FakeNotificationName object:nil];
    XCTAssertNoThrow([center removeObserver:nil], @"Center should ignore a request to remove a nil observer");
    [center addObserver:observer selector:@selector(handler) name:FakeNotificationName object:nil];
    XCTAssertNoThrow([center removeObserver:nil name:FakeNotificationName object:nil], @"Center should ignore a request to remove a nil oberserver");
    [center addObserver:observer selector:@selector(handler) name:FakeNotificationName object:publisher];
    XCTAssertNoThrow([center removeObserver:nil name:FakeNotificationName object:publisher], @"Center should ignore a request to remove a nil oberserver");
}

- (void) testCenterCanRemoveObserverForNotificationNameAndObject {
    [center addObserver:observer selector:@selector(handler) name:@"another name" object:nil];
    [center addObserver:observer selector:@selector(handler) name:FakeNotificationName object:nil];
    [center addObserver:observer selector:@selector(handler) name:FakeNotificationName object:publisher];
    [center removeObserver:observer name:FakeNotificationName object:publisher];
    XCTAssertFalse([center hasObserver:observer forNotificationName:FakeNotificationName object:publisher], @"Center should remove observer for notification name and object");
    XCTAssertTrue([center hasObserver:observer forNotificationName:FakeNotificationName], @"Center should still have an entry for notification without object");
    XCTAssertTrue([center hasObserver:observer forNotificationName:@"another name"], @"Center should still have an entry for notification and no object");
}

- (void) testCenterCannotRemoveObserverForNilNotificationNameAndObject {
    [center addObserver:observer selector:@selector(handler) name:FakeNotificationName object:publisher];
    XCTAssertThrows([center removeObserver:observer name:nil object:publisher], @"Center should not allow removing observer with nil notification name and object");
}

- (void) testCenterCannotRemoveObserverForEmptyNotificationNameAndObject {
    [center addObserver:observer selector:@selector(handler) name:FakeNotificationName object:publisher];
    XCTAssertThrows([center removeObserver:observer name:@"" object:publisher], @"Center should not allow removing observer with empty notification name and object");
}

- (void) testCenterCanRemoveObserverForNotificationNameAndNilObject {
    [center addObserver:observer selector:@selector(handler) name:FakeNotificationName object:nil];
    [center removeObserver:observer name:FakeNotificationName object:nil];
    XCTAssertFalse([center hasObserver:observer forNotificationName:FakeNotificationName], @"Center should allow removing observer with notification name and nil object");
}

- (void) testCenterProvidesDispatchEntryForObserverAndName {
    [center addObserver:observer selector:@selector(handler) name:FakeNotificationName object:nil];
    LTTFakeNotificationDispatchEntry *entry = [center dispatchEntryForObserver:observer name:FakeNotificationName object:nil];
    XCTAssertEqualObjects(entry.observer, observer, @"Entry should contain correct observer");
    XCTAssertNil(entry.publisher, @"Entry should not contain a publisher");
    XCTAssertEqualObjects(NSStringFromSelector(entry.selector), NSStringFromSelector(@selector(handler)), @"Entry should have correct selector");
}

- (void) testCenterProvidesDispatchEntryForObserverAndNameAndObject {
    [center addObserver:observer selector:@selector(handler) name:FakeNotificationName object:publisher];
    LTTFakeNotificationDispatchEntry *entry = [center dispatchEntryForObserver:observer name:FakeNotificationName object:publisher];
    XCTAssertEqualObjects(entry.observer, observer, @"Entry should contain correct observer");
    XCTAssertEqualObjects(entry.publisher, publisher, @"Entry should contain correct publisher");
    XCTAssertEqualObjects(NSStringFromSelector(entry.selector), NSStringFromSelector(@selector(handler)), @"Entry should have correct selector");
}

@end
