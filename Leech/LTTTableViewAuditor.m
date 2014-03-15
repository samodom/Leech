//
//  LTTTableViewAuditor.m
//  Leech
//
//  Created by Sam Odom on 3/14/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import "LTTTableViewAuditor.h"

#import "LTTMethodSwizzler.h"

const char *ShouldForwardReloadDataCall = "ShouldForwardReloadDataCall";
const char *ReloadDataCalled = "ReloadDataCalled";

const char *ShouldForwardBeginUpdatesCall = "ShouldForwardBeginUpdatesCall";
const char *BeginUpdatesCalled = "BeginUpdatesCalled";
const char *ShouldForwardEndUpdatesCall = "ShouldForwardEndUpdatesCall";
const char *EndUpdatesCalled = "EndUpdatesCalled";

const char *ShouldForwardInsertSectionsCall = "ShouldForwardInsertSectionsCall";
const char *InsertSectionsIndexSet = "InsertSectionsIndexSet";
const char *InsertSectionsRowAnimation = "InsertSectionsRowAnimation";
const char *ShouldForwardDeleteSectionsCall = "ShouldForwardDeleteSectionsCall";
const char *DeleteSectionsIndexSet = "DeleteSectionsIndexSet";
const char *DeleteSectionsRowAnimation = "DeleteSectionsRowAnimation";
const char *ShouldForwardReloadSectionsCall = "ShouldForwardReloadSectionsCall";
const char *ReloadSectionsIndexSet = "ReloadSectionsIndexSet";
const char *ReloadSectionsRowAnimation = "ReloadSectionsRowAnimation";

const char *ShouldForwardInsertRowsCall = "ShouldForwardInsertRowsCall";
const char *InsertRowsIndexPaths = "InsertRowsIndexPaths";
const char *InsertRowsRowAnimation = "InsertRowsRowAnimation";
const char *ShouldForwardDeleteRowsCall = "ShouldForwardDeleteRowsCall";
const char *DeleteRowsIndexPaths = "DeleteRowsIndexPaths";
const char *DeleteRowsRowAnimation = "DeleteRowsRowAnimation";
const char *ShouldForwardMoveRowCall = "ShouldForwardMoveRowCall";
const char *MoveRowSourceIndexPath = "MoveRowSourceIndexPath";
const char *MoveRowDestinationIndexPath = "MoveRowDestinationIndexPath";
const char *ShouldForwardReloadRowsCall = "ShouldForwardReloadRowsCall";
const char *ReloadRowsIndexPaths = "ReloadRowsIndexPaths";
const char *ReloadRowsRowAnimation = "ReloadRowsRowAnimation";

////////////////////////////////////////////////////////////////////////////////
//  Category on UITableView
////////////////////////////////////////////////////////////////////////////////

@implementation UITableView (Leech)

- (void)Leech_ReloadData {
    objc_setAssociatedObject(self, ReloadDataCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardReloadDataCall);
    if (forward.boolValue)
        [self Leech_ReloadData];
}

- (void)Leech_BeginUpdates {
    objc_setAssociatedObject(self, BeginUpdatesCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardReloadDataCall);
    if (forward.boolValue)
        [self Leech_BeginUpdates];
}

- (void)Leech_EndUpdates {
    objc_setAssociatedObject(self, EndUpdatesCalled, @(YES), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardReloadDataCall);
    if (forward.boolValue)
        [self Leech_EndUpdates];
}

- (void)Leech_InsertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    objc_setAssociatedObject(self, InsertSectionsIndexSet, sections, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, InsertSectionsRowAnimation, @(animation), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardInsertSectionsCall);
    if (forward.boolValue)
        [self Leech_InsertSections:sections withRowAnimation:animation];
}

- (void)Leech_DeleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    objc_setAssociatedObject(self, DeleteSectionsIndexSet, sections, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, DeleteSectionsRowAnimation, @(animation), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardDeleteSectionsCall);
    if (forward.boolValue)
        [self Leech_DeleteSections:sections withRowAnimation:animation];
}

- (void)Leech_ReloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation {
    objc_setAssociatedObject(self, ReloadSectionsIndexSet, sections, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, ReloadSectionsRowAnimation, @(animation), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardReloadSectionsCall);
    if (forward.boolValue)
        [self Leech_ReloadSections:sections withRowAnimation:animation];
}

- (void)Leech_InsertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    objc_setAssociatedObject(self, InsertRowsIndexPaths, indexPaths, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, InsertRowsRowAnimation, @(animation), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardInsertRowsCall);
    if (forward.boolValue)
        [self Leech_InsertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)Leech_DeleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    objc_setAssociatedObject(self, DeleteRowsIndexPaths, indexPaths, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, DeleteRowsRowAnimation, @(animation), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardDeleteRowsCall);
    if (forward.boolValue)
        [self Leech_DeleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)Leech_MoveRowAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    objc_setAssociatedObject(self, MoveRowSourceIndexPath, indexPath, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, MoveRowDestinationIndexPath, newIndexPath, OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardMoveRowCall);
    if (forward.boolValue)
        [self Leech_MoveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

- (void)Leech_ReloadRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation {
    objc_setAssociatedObject(self, ReloadRowsIndexPaths, indexPaths, OBJC_ASSOCIATION_RETAIN);
    objc_setAssociatedObject(self, ReloadRowsRowAnimation, @(animation), OBJC_ASSOCIATION_RETAIN);
    NSNumber *forward = objc_getAssociatedObject(self, ShouldForwardReloadRowsCall);
    if (forward.boolValue)
        [self Leech_ReloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

@end

////////////////////////////////////////////////////////////////////////////////
//  Table view auditor implementation
////////////////////////////////////////////////////////////////////////////////

@implementation LTTTableViewAuditor

#pragma mark - Update and reload

#pragma mark -reloadData

+ (void)auditReloadDataMethod:(UITableView *)tableView forward:(BOOL)forward {
    objc_setAssociatedObject(tableView, ShouldForwardReloadDataCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(reloadData) selectorTwo:@selector(Leech_ReloadData)];
}

+ (void)stopAuditingReloadDataMethod:(UITableView *)tableView {
    objc_setAssociatedObject(tableView, ShouldForwardReloadDataCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, ReloadDataCalled, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(reloadData) selectorTwo:@selector(Leech_ReloadData)];
}

+ (BOOL)didCallReloadData:(UITableView *)tableView {
    NSNumber *reloadCalled = objc_getAssociatedObject(tableView, ReloadDataCalled);
    return reloadCalled.boolValue;
}

#pragma mark -beginUpdates

+ (void)auditBeginUpdatesMethod:(UITableView *)tableView forward:(BOOL)forward {
    objc_setAssociatedObject(tableView, ShouldForwardBeginUpdatesCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(beginUpdates) selectorTwo:@selector(Leech_BeginUpdates)];
}

+ (void)stopAuditingBeginUpdatesMethod:(UITableView *)tableView {
    objc_setAssociatedObject(tableView, ShouldForwardBeginUpdatesCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, BeginUpdatesCalled, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(beginUpdates) selectorTwo:@selector(Leech_BeginUpdates)];
}

+ (BOOL)didCallBeginUpdates:(UITableView *)tableView {
    NSNumber *beginCalled = objc_getAssociatedObject(tableView, BeginUpdatesCalled);
    return beginCalled.boolValue;
}

#pragma mark -endUpdates

+ (void)auditEndUpdatesMethod:(UITableView *)tableView forward:(BOOL)forward {
    objc_setAssociatedObject(tableView, ShouldForwardEndUpdatesCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(endUpdates) selectorTwo:@selector(Leech_EndUpdates)];
}

+ (void)stopAuditingEndUpdatesMethod:(UITableView *)tableView {
    objc_setAssociatedObject(tableView, ShouldForwardEndUpdatesCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, EndUpdatesCalled, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(endUpdates) selectorTwo:@selector(Leech_EndUpdates)];
}

+ (BOOL)didCallEndUpdates:(UITableView *)tableView {
    NSNumber *endCalled = objc_getAssociatedObject(tableView, EndUpdatesCalled);
    return endCalled.boolValue;
}

#pragma mark -insertSections:withRowAnimation:

+ (void)auditInsertSectionsMethod:(UITableView *)tableView forward:(BOOL)forward {
    objc_setAssociatedObject(tableView, ShouldForwardInsertSectionsCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(insertSections:withRowAnimation:) selectorTwo:@selector(Leech_InsertSections:withRowAnimation:)];
}

+ (void)stopAuditingInsertSectionsMethod:(UITableView *)tableView {
    objc_setAssociatedObject(tableView, ShouldForwardInsertSectionsCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, InsertSectionsIndexSet, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, InsertSectionsRowAnimation, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(insertSections:withRowAnimation:) selectorTwo:@selector(Leech_InsertSections:withRowAnimation:)];
}

+ (NSIndexSet *)insertSectionsIndexSet:(UITableView*)tableView {
    return objc_getAssociatedObject(tableView, InsertSectionsIndexSet);
}

+ (UITableViewRowAnimation)insertSectionsRowAnimation:(UITableView*)tableView {
    NSNumber *animation = objc_getAssociatedObject(tableView, InsertSectionsRowAnimation);
    return animation.integerValue;
}

#pragma mark -deleteSections:withRowAnimation:

+ (void)auditDeleteSectionsMethod:(UITableView *)tableView forward:(BOOL)forward {
    objc_setAssociatedObject(tableView, ShouldForwardDeleteSectionsCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(deleteSections:withRowAnimation:) selectorTwo:@selector(Leech_DeleteSections:withRowAnimation:)];
}

+ (void)stopAuditingDeleteSectionsMethod:(UITableView *)tableView {
    objc_setAssociatedObject(tableView, ShouldForwardDeleteSectionsCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, DeleteSectionsIndexSet, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, DeleteSectionsRowAnimation, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(deleteSections:withRowAnimation:) selectorTwo:@selector(Leech_DeleteSections:withRowAnimation:)];
}

+ (NSIndexSet *)deleteSectionsIndexSet:(UITableView*)tableView {
    return objc_getAssociatedObject(tableView, DeleteSectionsIndexSet);
}

+ (UITableViewRowAnimation)deleteSectionsRowAnimation:(UITableView*)tableView {
    NSNumber *animation = objc_getAssociatedObject(tableView, DeleteSectionsRowAnimation);
    return animation.integerValue;
}

#pragma mark -reloadSections:withRowAnimation:

+ (void)auditReloadSectionsMethod:(UITableView *)tableView forward:(BOOL)forward {
    objc_setAssociatedObject(tableView, ShouldForwardReloadSectionsCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(reloadSections:withRowAnimation:) selectorTwo:@selector(Leech_ReloadSections:withRowAnimation:)];
}

+ (void)stopAuditingReloadSectionsMethod:(UITableView *)tableView {
    objc_setAssociatedObject(tableView, ShouldForwardReloadSectionsCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, ReloadSectionsIndexSet, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, ReloadSectionsRowAnimation, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(reloadSections:withRowAnimation:) selectorTwo:@selector(Leech_ReloadSections:withRowAnimation:)];
}

+ (NSIndexSet *)reloadSectionsIndexSet:(UITableView*)tableView {
    return objc_getAssociatedObject(tableView, ReloadSectionsIndexSet);
}

+ (UITableViewRowAnimation)reloadSectionsRowAnimation:(UITableView*)tableView {
    NSNumber *animation = objc_getAssociatedObject(tableView, ReloadSectionsRowAnimation);
    return animation.integerValue;
}

#pragma mark -insertRowsAtIndexPaths:withRowAnimation:

+ (void)auditInsertRowsMethod:(UITableView *)tableView forward:(BOOL)forward {
    objc_setAssociatedObject(tableView, ShouldForwardInsertRowsCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(insertRowsAtIndexPaths:withRowAnimation:) selectorTwo:@selector(Leech_InsertRowsAtIndexPaths:withRowAnimation:)];
}

+ (void)stopAuditingInsertRowsMethod:(UITableView *)tableView {
    objc_setAssociatedObject(tableView, ShouldForwardInsertRowsCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, InsertRowsIndexPaths, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, InsertRowsRowAnimation, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(insertRowsAtIndexPaths:withRowAnimation:) selectorTwo:@selector(Leech_InsertRowsAtIndexPaths:withRowAnimation:)];
}

+ (NSArray *)insertRowsIndexPaths:(UITableView *)tableView {
    return objc_getAssociatedObject(tableView, InsertRowsIndexPaths);
}

+ (UITableViewRowAnimation)insertRowsRowAnimation:(UITableView *)tableView {
    NSNumber *number = objc_getAssociatedObject(tableView, InsertRowsRowAnimation);
    return number.integerValue;
}

#pragma mark -deleteRowsAtIndexPaths:withRowAnimation:

+ (void)auditDeleteRowsMethod:(UITableView *)tableView forward:(BOOL)forward {
    objc_setAssociatedObject(tableView, ShouldForwardDeleteRowsCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(deleteRowsAtIndexPaths:withRowAnimation:) selectorTwo:@selector(Leech_DeleteRowsAtIndexPaths:withRowAnimation:)];
}

+ (void)stopAuditingDeleteRowsMethod:(UITableView *)tableView {
    objc_setAssociatedObject(tableView, ShouldForwardDeleteRowsCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, DeleteRowsIndexPaths, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, DeleteRowsRowAnimation, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(deleteRowsAtIndexPaths:withRowAnimation:) selectorTwo:@selector(Leech_DeleteRowsAtIndexPaths:withRowAnimation:)];
}

+ (NSArray *)deleteRowsIndexPaths:(UITableView *)tableView {
    return objc_getAssociatedObject(tableView, DeleteRowsIndexPaths);
}

+ (UITableViewRowAnimation)deleteRowsRowAnimation:(UITableView *)tableView {
    NSNumber *number = objc_getAssociatedObject(tableView, DeleteRowsRowAnimation);
    return number.integerValue;
}

#pragma mark -moveRowAtIndexPaths:toIndexPath:

+ (void)auditMoveRowMethod:(UITableView *)tableView forward:(BOOL)forward {
    objc_setAssociatedObject(tableView, ShouldForwardMoveRowCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(moveRowAtIndexPath:toIndexPath:) selectorTwo:@selector(Leech_MoveRowAtIndexPath:toIndexPath:)];
}

+ (void)stopAuditingMoveRowMethod:(UITableView *)tableView {
    objc_setAssociatedObject(tableView, ShouldForwardMoveRowCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, MoveRowSourceIndexPath, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, MoveRowDestinationIndexPath, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(moveRowAtIndexPath:toIndexPath:) selectorTwo:@selector(Leech_MoveRowAtIndexPath:toIndexPath:)];
}

+ (NSIndexPath *)moveRowSourceIndexPath:(UITableView *)tableView {
    return objc_getAssociatedObject(tableView, MoveRowSourceIndexPath);
}

+ (NSIndexPath *)moveRowDestinationIndexPath:(UITableView *)tableView {
    return objc_getAssociatedObject(tableView, MoveRowDestinationIndexPath);
}

#pragma mark -reloadRowsAtIndexPaths:withRowAnimation:

+ (void)auditReloadRowsMethod:(UITableView *)tableView forward:(BOOL)forward {
    objc_setAssociatedObject(tableView, ShouldForwardReloadRowsCall, @(forward), OBJC_ASSOCIATION_RETAIN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(reloadRowsAtIndexPaths:withRowAnimation:) selectorTwo:@selector(Leech_ReloadRowsAtIndexPaths:withRowAnimation:)];
}

+ (void)stopAuditingReloadRowsMethod:(UITableView *)tableView {
    objc_setAssociatedObject(tableView, ShouldForwardReloadRowsCall, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, ReloadRowsIndexPaths, nil, OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(tableView, ReloadRowsRowAnimation, nil, OBJC_ASSOCIATION_ASSIGN);
    [LTTMethodSwizzler swapInstanceMethodsForClass:[tableView class] selectorOne:@selector(reloadRowsAtIndexPaths:withRowAnimation:) selectorTwo:@selector(Leech_ReloadRowsAtIndexPaths:withRowAnimation:)];
}

+ (NSArray *)reloadRowsIndexPaths:(UITableView *)tableView {
    return objc_getAssociatedObject(tableView, ReloadRowsIndexPaths);
}

+ (UITableViewRowAnimation)reloadRowsRowAnimation:(UITableView *)tableView {
    NSNumber *number = objc_getAssociatedObject(tableView, ReloadRowsRowAnimation);
    return number.integerValue;
}

@end
