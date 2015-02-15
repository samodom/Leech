//
//  LTTObjectAuditor.m
//  Leech
//
//  Created by Sam Odom on 4/1/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTObjectAuditor.h"

#import "LTTMethodSwizzler.h"

const char *ObjectSelectorToPerform = "ObjectSelectorToPerform";
const char *ObjectArgumentToSelector = "ObjectArgumentToSelector";
const char *ObjectWaitUntilDoneFlag = "ObjectWaitUntilDoneFlag";

////////////////////////////////////////////////////////////////////////////////
//  Category on NSObject
////////////////////////////////////////////////////////////////////////////////

@implementation NSObject (Leech)

- (void)Leech_PerformSelectorOnMainThread:(SEL)aSelector withObject:(id)arg waitUntilDone:(BOOL)wait {
    objc_setAssociatedObject(self, ObjectSelectorToPerform, NSStringFromSelector(aSelector), OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, ObjectArgumentToSelector, arg, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, ObjectWaitUntilDoneFlag, @(wait), OBJC_ASSOCIATION_RETAIN);
}

@end

////////////////////////////////////////////////////////////////////////////////
//  LTTObjectAuditor implementation
////////////////////////////////////////////////////////////////////////////////

@implementation LTTObjectAuditor

+ (void)auditPerformSelectorOnMainThread:(NSObject *)object {
    [LTTMethodSwizzler swapInstanceMethodsForClass:[object class] selectorOne:@selector(performSelectorOnMainThread:withObject:waitUntilDone:) selectorTwo:@selector(Leech_PerformSelectorOnMainThread:withObject:waitUntilDone:)];
}

+ (void)stopAuditingPerformSelectorOnMainThread:(NSObject *)object {
    objc_setAssociatedObject(object, ObjectSelectorToPerform, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(object, ObjectArgumentToSelector, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(object, ObjectWaitUntilDoneFlag, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[object class] selectorOne:@selector(performSelectorOnMainThread:withObject:waitUntilDone:) selectorTwo:@selector(Leech_PerformSelectorOnMainThread:withObject:waitUntilDone:)];
}

+ (SEL)selectorToPerform:(NSObject *)auditedObject {
    NSString *selectorString = objc_getAssociatedObject(auditedObject, ObjectSelectorToPerform);
    return NSSelectorFromString(selectorString);
}

+ (id)argumentToSelector:(NSObject *)auditedObject {
    return objc_getAssociatedObject(auditedObject, ObjectArgumentToSelector);
}

+ (BOOL)waitUntilDoneFlag:(NSObject *)auditedObject {
    NSNumber *wait = objc_getAssociatedObject(auditedObject, ObjectWaitUntilDoneFlag);
    return wait.boolValue;
}

@end
