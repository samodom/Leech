//
//  TableViewAuditorTests.m
//  Leech
//
//  Created by Sam Odom on 3/14/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <XCTest/XCTest.h>

//  Mocks+


//  Production
#import "LTTTableViewAuditor.h"

@interface TableViewAuditorTests : XCTestCase

@end

@implementation TableViewAuditorTests {
    UITableView *tableView;
}

- (void)setUp {
    [super setUp];

    tableView = [UITableView new];
}

- (void)tearDown {
    tableView = nil;

    [super tearDown];
}

- (void)testAuditingOfReloadDataMethod {
    IMP realImplementation = class_getMethodImplementation([tableView class], @selector(reloadData));
    [LTTTableViewAuditor auditReloadDataMethod:tableView forward:YES];
    IMP currentImplementation = class_getMethodImplementation([tableView class], @selector(reloadData));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [tableView reloadData];
    XCTAssertTrue([LTTTableViewAuditor didCallReloadData:tableView], @"The call to reload data should be captured");
    [LTTTableViewAuditor stopAuditingReloadDataMethod:tableView];
    currentImplementation = class_getMethodImplementation([tableView class], @selector(reloadData));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfBeginUpdatesMethod {
    IMP realImplementation = class_getMethodImplementation([tableView class], @selector(beginUpdates));
    [LTTTableViewAuditor auditBeginUpdatesMethod:tableView forward:YES];
    IMP currentImplementation = class_getMethodImplementation([tableView class], @selector(beginUpdates));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [tableView beginUpdates];
    XCTAssertTrue([LTTTableViewAuditor didCallBeginUpdates:tableView], @"The call to begin updates should be captured");
    [LTTTableViewAuditor stopAuditingBeginUpdatesMethod:tableView];
    currentImplementation = class_getMethodImplementation([tableView class], @selector(beginUpdates));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfEndUpdatesMethod {
    IMP realImplementation = class_getMethodImplementation([tableView class], @selector(endUpdates));
    [LTTTableViewAuditor auditEndUpdatesMethod:tableView forward:YES];
    IMP currentImplementation = class_getMethodImplementation([tableView class], @selector(endUpdates));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    [tableView endUpdates];
    XCTAssertTrue([LTTTableViewAuditor didCallEndUpdates:tableView], @"The call to end updates should be captured");
    [LTTTableViewAuditor stopAuditingEndUpdatesMethod:tableView];
    currentImplementation = class_getMethodImplementation([tableView class], @selector(endUpdates));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfInsertSectionsMethod {
    IMP realImplementation = class_getMethodImplementation([tableView class], @selector(insertSections:withRowAnimation:));
    [LTTTableViewAuditor auditInsertSectionsMethod:tableView forward:YES];
    IMP currentImplementation = class_getMethodImplementation([tableView class], @selector(insertSections:withRowAnimation:));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:0];
    [indexSet addIndex:3];
    [tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    NSIndexSet *auditedIndexSet = [LTTTableViewAuditor insertSectionsIndexSet:tableView];
    XCTAssertEqualObjects(auditedIndexSet, indexSet, @"The index set should be captured");
    XCTAssertEqual([LTTTableViewAuditor insertSectionsRowAnimation:tableView], UITableViewRowAnimationFade, @"The row animation should be captured");
    [LTTTableViewAuditor stopAuditingInsertSectionsMethod:tableView];
    currentImplementation = class_getMethodImplementation([tableView class], @selector(insertSections:withRowAnimation:));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfDeleteSectionsMethod {
    IMP realImplementation = class_getMethodImplementation([tableView class], @selector(deleteSections:withRowAnimation:));
    [LTTTableViewAuditor auditDeleteSectionsMethod:tableView forward:YES];
    IMP currentImplementation = class_getMethodImplementation([tableView class], @selector(deleteSections:withRowAnimation:));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:0];
    [indexSet addIndex:3];
    [tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    NSIndexSet *auditedIndexSet = [LTTTableViewAuditor deleteSectionsIndexSet:tableView];
    XCTAssertEqualObjects(auditedIndexSet, indexSet, @"The index set should be captured");
    XCTAssertEqual([LTTTableViewAuditor deleteSectionsRowAnimation:tableView], UITableViewRowAnimationFade, @"The row animation should be captured");
    [LTTTableViewAuditor stopAuditingDeleteSectionsMethod:tableView];
    currentImplementation = class_getMethodImplementation([tableView class], @selector(deleteSections:withRowAnimation:));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfReloadSectionsMethod {
    IMP realImplementation = class_getMethodImplementation([tableView class], @selector(reloadSections:withRowAnimation:));
    [LTTTableViewAuditor auditReloadSectionsMethod:tableView forward:YES];
    IMP currentImplementation = class_getMethodImplementation([tableView class], @selector(reloadSections:withRowAnimation:));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:0];
    [indexSet addIndex:3];
    [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
    NSIndexSet *auditedIndexSet = [LTTTableViewAuditor reloadSectionsIndexSet:tableView];
    XCTAssertEqualObjects(auditedIndexSet, indexSet, @"The index set should be captured");
    XCTAssertEqual([LTTTableViewAuditor reloadSectionsRowAnimation:tableView], UITableViewRowAnimationFade, @"The row animation should be captured");
    [LTTTableViewAuditor stopAuditingReloadSectionsMethod:tableView];
    currentImplementation = class_getMethodImplementation([tableView class], @selector(reloadSections:withRowAnimation:));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfInsertRowsMethod {
    IMP realImplementation = class_getMethodImplementation([tableView class], @selector(insertRowsAtIndexPaths:withRowAnimation:));
    [LTTTableViewAuditor auditInsertRowsMethod:tableView forward:YES];
    IMP currentImplementation = class_getMethodImplementation([tableView class], @selector(insertRowsAtIndexPaths:withRowAnimation:));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:0 inSection:0], [NSIndexPath indexPathForRow:1 inSection:1]];
    [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    NSArray *auditedIndexPaths = [LTTTableViewAuditor insertRowsIndexPaths:tableView];
    XCTAssertEqualObjects(auditedIndexPaths, indexPaths, @"The index paths should be captured");
    XCTAssertEqual([LTTTableViewAuditor insertRowsRowAnimation:tableView], UITableViewRowAnimationFade, @"The row animation should be captured");
    [LTTTableViewAuditor stopAuditingInsertRowsMethod:tableView];
    currentImplementation = class_getMethodImplementation([tableView class], @selector(insertRowsAtIndexPaths:withRowAnimation:));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfDeleteRowsMethod {
    IMP realImplementation = class_getMethodImplementation([tableView class], @selector(deleteRowsAtIndexPaths:withRowAnimation:));
    [LTTTableViewAuditor auditDeleteRowsMethod:tableView forward:YES];
    IMP currentImplementation = class_getMethodImplementation([tableView class], @selector(deleteRowsAtIndexPaths:withRowAnimation:));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:0 inSection:0], [NSIndexPath indexPathForRow:1 inSection:1]];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    NSArray *auditedIndexPaths = [LTTTableViewAuditor deleteRowsIndexPaths:tableView];
    XCTAssertEqualObjects(auditedIndexPaths, indexPaths, @"The index paths should be captured");
    XCTAssertEqual([LTTTableViewAuditor deleteRowsRowAnimation:tableView], UITableViewRowAnimationFade, @"The row animation should be captured");
    [LTTTableViewAuditor stopAuditingDeleteRowsMethod:tableView];
    currentImplementation = class_getMethodImplementation([tableView class], @selector(deleteRowsAtIndexPaths:withRowAnimation:));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfMoveRowMethod {
    IMP realImplementation = class_getMethodImplementation([tableView class], @selector(moveRowAtIndexPath:toIndexPath:));
    [LTTTableViewAuditor auditMoveRowMethod:tableView forward:YES];
    IMP currentImplementation = class_getMethodImplementation([tableView class], @selector(moveRowAtIndexPath:toIndexPath:));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    NSIndexPath *fromPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *toPath = [NSIndexPath indexPathForRow:1 inSection:1];
    [tableView moveRowAtIndexPath:fromPath toIndexPath:toPath];
    NSIndexPath *sourcePath = [LTTTableViewAuditor moveRowSourceIndexPath:tableView];
    XCTAssertEqualObjects(sourcePath, fromPath, @"The source index path should be captured");
    NSIndexPath *destinationPath = [LTTTableViewAuditor moveRowDestinationIndexPath:tableView];
    XCTAssertEqualObjects(destinationPath, toPath, @"The destination index path should be captured");
    [LTTTableViewAuditor stopAuditingMoveRowMethod:tableView];
    currentImplementation = class_getMethodImplementation([tableView class], @selector(moveRowAtIndexPath:toIndexPath:));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

- (void)testAuditingOfReloadRowsMethod {
    IMP realImplementation = class_getMethodImplementation([tableView class], @selector(reloadRowsAtIndexPaths:withRowAnimation:));
    [LTTTableViewAuditor auditReloadRowsMethod:tableView forward:YES];
    IMP currentImplementation = class_getMethodImplementation([tableView class], @selector(reloadRowsAtIndexPaths:withRowAnimation:));
    XCTAssertNotEqual(currentImplementation, realImplementation, @"The method should be swizzled");
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:0 inSection:0], [NSIndexPath indexPathForRow:1 inSection:1]];
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    NSArray *auditedIndexPaths = [LTTTableViewAuditor reloadRowsIndexPaths:tableView];
    XCTAssertEqualObjects(auditedIndexPaths, indexPaths, @"The index paths should be captured");
    XCTAssertEqual([LTTTableViewAuditor reloadRowsRowAnimation:tableView], UITableViewRowAnimationFade, @"The row animation should be captured");
    [LTTTableViewAuditor stopAuditingReloadRowsMethod:tableView];
    currentImplementation = class_getMethodImplementation([tableView class], @selector(reloadRowsAtIndexPaths:withRowAnimation:));
    XCTAssertEqual(currentImplementation, realImplementation, @"The method should no longer be swizzled");
}

@end
