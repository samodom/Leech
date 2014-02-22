//
//  MethodSwizzlerTests.m
//  Leech
//
//  Created by Sam Odom on 2/22/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

//  Mocks+


//  Production
#import "LTTMethodSwizzler.h"

const char *markerKey = "TestingMarker";

@interface MethodSwizzlerTests : XCTestCase

@end

@implementation MethodSwizzlerTests {
    SEL realSelector, fakeSelector;
    Method realMethod, fakeMethod;
    IMP realImplementation, fakeImplementation, newImplementation;
}

+ (void) realClassMethod {
    objc_setAssociatedObject(self, markerKey, @(NO), OBJC_ASSOCIATION_RETAIN);
}

+ (void) fakeClassMethod {
    objc_setAssociatedObject(self, markerKey, @(YES), OBJC_ASSOCIATION_RETAIN);
}

- (void) realInstanceMethod {
    objc_setAssociatedObject(self, markerKey, @(NO), OBJC_ASSOCIATION_RETAIN);
}

- (void) fakeInstanceMethod {
    objc_setAssociatedObject(self, markerKey, @(YES), OBJC_ASSOCIATION_RETAIN);
}

- (void)setUp {
    [super setUp];

}

- (void)tearDown {
    realSelector = NULL;
    fakeSelector = NULL;
    realMethod = NULL;
    fakeMethod = NULL;
    realImplementation = NULL;
    fakeImplementation = NULL;
    objc_removeAssociatedObjects(self);
    objc_removeAssociatedObjects([self class]);

    [super tearDown];
}

- (void)testMethodSwizzlerExchangesClassMethodImplementations {
    realSelector = @selector(realClassMethod);
    realMethod = class_getClassMethod([self class], realSelector);
    realImplementation = method_getImplementation(realMethod);
    fakeSelector = @selector(fakeClassMethod);
    fakeMethod = class_getClassMethod([self class], fakeSelector);
    fakeImplementation = method_getImplementation(fakeMethod);
    [LTTMethodSwizzler swapClassMethodsForClass:[self class] selectorOne:realSelector selectorTwo:fakeSelector];
    newImplementation = method_getImplementation(realMethod);
    XCTAssertEqual(newImplementation, fakeImplementation, @"The fake implementation should now be attached to the real selector");
    newImplementation = method_getImplementation(fakeMethod);
    XCTAssertEqual(newImplementation, realImplementation, @"The real implementation should now be attached to the fake selector");
    [[self class] realClassMethod];
    NSNumber *marker = objc_getAssociatedObject([self class], markerKey);
    XCTAssertTrue(marker.boolValue, @"The marker should be set with the fake method being called");
    [LTTMethodSwizzler swapClassMethodsForClass:[self class] selectorOne:realSelector selectorTwo:fakeSelector];
    newImplementation = method_getImplementation(realMethod);
    XCTAssertEqual(newImplementation, realImplementation, @"The real implementation should now be attached to the real selector");
    newImplementation = method_getImplementation(fakeMethod);
    XCTAssertEqual(newImplementation, fakeImplementation, @"The fake implementation should now be attached to the fake selector");
    [[self class] realClassMethod];
    marker = objc_getAssociatedObject([self class], markerKey);
    XCTAssertFalse(marker.boolValue, @"The marker should be cleared with the real method being called");
}

- (void)testMethodSwizzlerExchangesInstanceMethodImplementations {
    realSelector = @selector(realInstanceMethod);
    realMethod = class_getInstanceMethod([self class], realSelector);
    realImplementation = method_getImplementation(realMethod);
    fakeSelector = @selector(fakeInstanceMethod);
    fakeMethod = class_getInstanceMethod([self class], fakeSelector);
    fakeImplementation = method_getImplementation(fakeMethod);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[self class] selectorOne:realSelector selectorTwo:fakeSelector];
    newImplementation = method_getImplementation(realMethod);
    XCTAssertEqual(newImplementation, fakeImplementation, @"The fake implementation should now be attached to the real selector");
    newImplementation = method_getImplementation(fakeMethod);
    XCTAssertEqual(newImplementation, realImplementation, @"The real implementation should now be attached to the fake selector");
    [self realInstanceMethod];
    NSNumber *marker = objc_getAssociatedObject(self, markerKey);
    XCTAssertTrue(marker.boolValue, @"The marker should be set with the fake method being called");
    [LTTMethodSwizzler swapInstanceMethodsForClass:[self class] selectorOne:realSelector selectorTwo:fakeSelector];
    newImplementation = method_getImplementation(realMethod);
    XCTAssertEqual(newImplementation, realImplementation, @"The real implementation should now be attached to the real selector");
    newImplementation = method_getImplementation(fakeMethod);
    XCTAssertEqual(newImplementation, fakeImplementation, @"The fake implementation should now be attached to the fake selector");
    [self realInstanceMethod];
    marker = objc_getAssociatedObject(self, markerKey);
    XCTAssertFalse(marker.boolValue, @"The marker should be cleared with the real method being called");
}

@end
