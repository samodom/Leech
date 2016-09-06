//
//  LTTMethodSwizzlingRecordKeeper.m
//  Leech
//
//  Created by Sam Odom on 2/16/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import "LTTMethodSwizzlingRecordKeeper.h"

#import "LTTClassMethodSwizzlingRecord.h"
#import "LTTInstanceMethodSwizzlingRecord.h"

@interface LTTMethodSwizzlingRecordKeeper ()

@property NSDictionary *classMethodRecords;
@property NSDictionary *instanceMethodRecords;

@end

@implementation LTTMethodSwizzlingRecordKeeper


- (BOOL)isClassMethodSwizzledForSelector:(SEL)realSelector {
    NSString *key = NSStringFromSelector(realSelector);
    return self.classMethodRecords[key] != nil;
}

- (BOOL)isInstanceMethodSwizzledForSelector:(SEL)realSelector {
    NSString *key = NSStringFromSelector(realSelector);
    return self.instanceMethodRecords[key] != nil;
}
//
//- (BOOL)hasMethodSwizzlingRecord:(LTTMethodSwizzlingRecord *)record {
//    NSDictionary *methodRecords;
//    if ([record isKindOfClass:[LTTClassMethodSwizzlingRecord class]]) {
//        methodRecords = self.classMethodRecords;
//    }
//    else {
//        methodRecords = self.instanceMethodRecords;
//    }
//
//    NSString *key = NSStringFromSelector(record.realSelector);
//    LTTMethodSwizzlingRecord *acceptedRecord = methodRecords[key];
//
//    if (acceptedRecord.fakeSelector == record.fakeSelector) {
//        return YES;
//    }
//
//    return NO;
//}


- (BOOL)acceptMethodSwizzlingRecord:(LTTMethodSwizzlingRecord *)record {
//    if ([self hasMethodSwizzlingRecord:record]) {
//        return NO;
//    }
//
//    [self saveMethodSwizzlingRecord:record];
//    return YES;
    return NO;
}

- (void)releaseMethodSwizzlingRecord:(LTTMethodSwizzlingRecord *)record {
//    if (![self hasMethodSwizzlingRecord:record]) {
//        return;
//    }
//
//    NSMutableArray *classRecordArray = [[self classRecordArrayForClassName:record.className] mutableCopy];
//    if (!classRecordArray) {
//        return;
//    }
//
//    [classRecordArray enumerateObjectsUsingBlock:^(LTTMethodSwizzlingRecord *candidate, NSUInteger idx, BOOL *stop) {
//        if ([candidate isKindOfClass:[record class]] && candidate.realSelector == record.realSelector) {
//            [classRecordArray removeObject:candidate];
//            [self setRecordArray:[NSArray arrayWithArray:classRecordArray] forClassName:record.className];
//            *stop = YES;
//        }
//    }];
}


#pragma mark - Internal

- (instancetype)init {
    if (self = [super init]) {
        _classMethodRecords = @{};
        _instanceMethodRecords = @{};
    }

    return self;
}

- (NSArray*)classRecordArrayForClassName:(NSString*)className {
//    return classRecordArrays[className] ?: [NSArray array];
    return nil;
}

- (void)saveMethodSwizzlingRecord:(LTTMethodSwizzlingRecord*)record {
//    NSArray *classRecordArray = [self classRecordArrayForClassName:record.className];
//    classRecordArray = [classRecordArray arrayByAddingObject:record];
//    [self setRecordArray:classRecordArray forClassName:record.className];
}

- (void)setRecordArray:(NSArray*)records forClassName:(NSString*)className {
//    NSMutableDictionary *mutableRecords = [classRecordArrays mutableCopy];
//    mutableRecords[className] = records;
//    classRecordArrays = [NSDictionary dictionaryWithDictionary:mutableRecords];
}


@end
