//
//  MethodSwizzlingTests.m
//  Leech
//
//  Created by Sam Odom on 2/15/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

#import "NSObject+MethodSwizzling.h"
#import "LTTMethodSwizzlingRecord.h"
#import "LTTMethodSwizzlingRecordKeeper.h"

#import "SampleSwizzlableClass.h"

@interface MethodSwizzlingTests : XCTestCase

@end

@implementation MethodSwizzlingTests {
    Class class;
    SampleSwizzlableClass *object;
    LTTMethodSwizzlingRecord *classMethodRecord, *instanceMethodRecord;
    SEL realClassMethodSelector, fakeClassMethodSelector;
    SEL realInstanceMethodSelector, fakeInstanceMethodSelector;
    IMP realClassImplementation, fakeClassImplementation;
    IMP realInstanceImplementation, fakeInstanceImplementation;
    IMP currentImplementation;
}

- (void)setUp {
    [super setUp];

    class = [SampleSwizzlableClass class];
    object = [SampleSwizzlableClass new];
    NSString *className = NSStringFromClass([SampleSwizzlableClass class]);
    realClassMethodSelector = @selector(realClassMethod);
    fakeClassMethodSelector = @selector(fakeClassMethod);
    realInstanceMethodSelector = @selector(realInstanceMethod);
    fakeInstanceMethodSelector = @selector(fakeInstanceMethod);

    classMethodRecord = [LTTMethodSwizzlingRecord classRecordWithClassName:className
                                                              realSelector:realClassMethodSelector
                                                              fakeSelector:fakeClassMethodSelector];
    instanceMethodRecord = [LTTMethodSwizzlingRecord instanceRecordWithClassName:className
                                                                    realSelector:realInstanceMethodSelector
                                                                    fakeSelector:fakeInstanceMethodSelector];

    realClassImplementation = class_getMethodImplementation(class, realClassMethodSelector);
    fakeClassImplementation = class_getMethodImplementation(class, fakeClassMethodSelector);
    realInstanceImplementation = class_getMethodImplementation(class, realInstanceMethodSelector);
    fakeInstanceImplementation = class_getMethodImplementation(class, fakeInstanceMethodSelector);
}

- (void)tearDown {
//    [object unswizzleMethodWithRecord:classMethodRecord];
//    [object unswizzleMethodWithRecord:instanceMethodRecord];

    [SampleSwizzlableClass clearClassMethodCallFlags];
    object.realInstanceMethodCalled = NO;
    object.fakeInstanceMethodCalled = NO;

    class = nil;
    object = nil;
    classMethodRecord = nil;
    instanceMethodRecord = nil;
    realClassImplementation = nil;
    fakeClassImplementation = nil;
    realInstanceImplementation = nil;
    fakeInstanceImplementation = nil;
    currentImplementation = nil;

    [super tearDown];
}

- (void)testObjectHasRecordKeeper {
//    lt
}

- (void)testSwizzlingClassMethod {
    //  SWIZZLE
    [object swizzleMethodWithRecord:classMethodRecord];

    //  Fake is real
    currentImplementation = class_getMethodImplementation(class, realClassMethodSelector);
    XCTAssertEqual(currentImplementation, fakeClassImplementation, @"The real class method selector should be swizzled to point to the fake method");
    [SampleSwizzlableClass realClassMethod];
    XCTAssertFalse([SampleSwizzlableClass realClassMethodCalled], @"The real method should not have been called");
    XCTAssertTrue([SampleSwizzlableClass fakeClassMethodCalled], @"The fake method should have been called");
    [SampleSwizzlableClass clearClassMethodCallFlags];

    //  Real is fake
    currentImplementation = class_getMethodImplementation(class, fakeClassMethodSelector);
    XCTAssertEqual(currentImplementation, realClassImplementation, @"The fake class method selector should be swizzled to point to the real method");
    [SampleSwizzlableClass fakeClassMethod];
    XCTAssertTrue([SampleSwizzlableClass realClassMethodCalled], @"The real method should have been called");
    XCTAssertFalse([SampleSwizzlableClass fakeClassMethodCalled], @"The fake method should not have been called");
    [SampleSwizzlableClass clearClassMethodCallFlags];

    //  UNSWIZZLE
    [object unswizzleMethodWithRecord:classMethodRecord];

    //  Real is real
    currentImplementation = class_getMethodImplementation(class, realClassMethodSelector);
    XCTAssertEqual(currentImplementation, realClassImplementation, @"The real class method selector should be swizzled back to point to the real method");
    [SampleSwizzlableClass realClassMethod];
    XCTAssertTrue([SampleSwizzlableClass realClassMethodCalled], @"The real method should have been called");
    XCTAssertFalse([SampleSwizzlableClass fakeClassMethodCalled], @"The fake method should not have been called");
    [SampleSwizzlableClass clearClassMethodCallFlags];

    //  Fake is fake
    currentImplementation = class_getMethodImplementation(class, fakeClassMethodSelector);
    XCTAssertEqual(currentImplementation, fakeClassImplementation, @"The fake class method selector should be swizzled back to point to the fake method");
    [SampleSwizzlableClass fakeClassMethod];
    XCTAssertFalse([SampleSwizzlableClass realClassMethodCalled], @"The real method should not have been called");
    XCTAssertTrue([SampleSwizzlableClass fakeClassMethodCalled], @"The fake method should have been called");
    [SampleSwizzlableClass clearClassMethodCallFlags];
}

- (void)testSwizzlingInstanceMethod {
    //  SWIZZLE
    [object swizzleMethodWithRecord:instanceMethodRecord];

    //  Real is fake
    currentImplementation = class_getMethodImplementation(class, realInstanceMethodSelector);
    XCTAssertEqual(currentImplementation, fakeInstanceImplementation, @"The real instance method selector should be swizzled to point to the fake method");
    [object realInstanceMethod];
    XCTAssertFalse(object.realInstanceMethodCalled, @"The real method should not have been called");
    XCTAssertTrue(object.fakeInstanceMethodCalled, @"The fake method should have been called");
    object.realInstanceMethodCalled = NO;
    object.fakeInstanceMethodCalled = NO;

    //  Fake is real
    currentImplementation = class_getMethodImplementation(class, fakeInstanceMethodSelector);
    XCTAssertEqual(currentImplementation, realInstanceImplementation, @"The fake instance method selector should be swizzled to point to the real method");
    [object fakeInstanceMethod];
    XCTAssertTrue(object.realInstanceMethodCalled, @"The real method should have been called");
    XCTAssertFalse(object.fakeInstanceMethodCalled, @"The fake method should not have been called");
    object.realInstanceMethodCalled = NO;
    object.fakeInstanceMethodCalled = NO;

    //  UNSWIZZLE
    [object unswizzleMethodWithRecord:instanceMethodRecord];

    //  Real is real
    currentImplementation = class_getMethodImplementation(class, realInstanceMethodSelector);
    XCTAssertEqual(currentImplementation, realInstanceImplementation, @"The real instance method selector should be swizzled back to point to the real method");
    [object realInstanceMethod];
    XCTAssertTrue(object.realInstanceMethodCalled, @"The real method should have been called");
    XCTAssertFalse(object.fakeInstanceMethodCalled, @"The fake method should not have been called");
    object.realInstanceMethodCalled = NO;
    object.fakeInstanceMethodCalled = NO;

    //  Fake is fake
    currentImplementation = class_getMethodImplementation(class, fakeInstanceMethodSelector);
    XCTAssertEqual(currentImplementation, fakeInstanceImplementation, @"The fake instance method selector should be swizzled back to point to the fake method");
    [object fakeInstanceMethod];
    XCTAssertFalse(object.realInstanceMethodCalled, @"The real method should not have been called");
    XCTAssertTrue(object.fakeInstanceMethodCalled, @"The fake method should have been called");
    object.realInstanceMethodCalled = NO;
    object.fakeInstanceMethodCalled = NO;
}

- (void)testSwizzledMethodCannotBeSwizzled {
    [object swizzleMethodWithRecord:classMethodRecord];
    [object swizzleMethodWithRecord:instanceMethodRecord];

    XCTAssertThrows([object swizzleMethodWithRecord:classMethodRecord], @"A method that is already swizzled cannot be swizzled again");
    XCTAssertThrows([object swizzleMethodWithRecord:instanceMethodRecord], @"A method that is already swizzled cannot be swizzled again");

    currentImplementation = class_getMethodImplementation(class, realClassMethodSelector);
    XCTAssertEqual(currentImplementation, fakeClassImplementation, @"The real class method selector should be swizzled to point to the fake method");
    currentImplementation = class_getMethodImplementation(class, realInstanceMethodSelector);
    XCTAssertEqual(currentImplementation, fakeInstanceImplementation, @"The real instance method selector should be swizzled to point to the fake method");

    [object unswizzleMethodWithRecord:classMethodRecord];
    [object unswizzleMethodWithRecord:instanceMethodRecord];
}

- (void)testSwizzledMethodCannotBeSwizzledWithDifferentFakeSelector {
    [object swizzleMethodWithRecord:classMethodRecord];
    [object swizzleMethodWithRecord:instanceMethodRecord];
    LTTMethodSwizzlingRecord *badClassMethodRecord =
    [LTTMethodSwizzlingRecord classRecordWithClassName:classMethodRecord.className
                                          realSelector:@selector(realClassMethod)
                                          fakeSelector:@selector(fileExistsAtPath:)];
    LTTMethodSwizzlingRecord *badInstanceMethodRecord =
    [LTTMethodSwizzlingRecord instanceRecordWithClassName:instanceMethodRecord.className
                                             realSelector:@selector(realInstanceMethod)
                                             fakeSelector:@selector(stringWithFormat:)];

    XCTAssertThrows([object swizzleMethodWithRecord:badClassMethodRecord], @"A method that is already swizzled cannot be swizzled again");
    XCTAssertThrows([object swizzleMethodWithRecord:badInstanceMethodRecord], @"A method that is already swizzled cannot be swizzled again");

    currentImplementation = class_getMethodImplementation(class, realClassMethodSelector);
    XCTAssertEqual(currentImplementation, fakeClassImplementation, @"The real class method selector should be swizzled to point to the fake method");
    currentImplementation = class_getMethodImplementation(class, realInstanceMethodSelector);
    XCTAssertEqual(currentImplementation, fakeInstanceImplementation, @"The real instance method selector should be swizzled to point to the fake method");

    [object unswizzleMethodWithRecord:classMethodRecord];
    [object unswizzleMethodWithRecord:instanceMethodRecord];
}

- (void)testUnswizzlingUnswizzledMethodIsIgnored {
    XCTAssertNoThrow([object unswizzleMethodWithRecord:classMethodRecord], @"Trying to unswizzle an unswizzled class method should be ignored");
    XCTAssertNoThrow([object unswizzleMethodWithRecord:instanceMethodRecord], @"Trying to unswizzle an unswizzled class method should be ignored");

    currentImplementation = class_getMethodImplementation(class, realClassMethodSelector);
    XCTAssertEqual(currentImplementation, realClassImplementation, @"The real class method selector should still point to the real method");

    currentImplementation = class_getMethodImplementation(class, realInstanceMethodSelector);
    XCTAssertEqual(currentImplementation, realInstanceImplementation, @"The real instance method selector should still point to the real method");
}

@end
