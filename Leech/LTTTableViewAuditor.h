//
//  LTTTableViewAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/14/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTTTableViewAuditor : NSObject

#pragma mark - Update and reload methods

#pragma mark -reloadData

+ (void)auditReloadDataMethod:(UITableView*)tableView forward:(BOOL)forward;
+ (void)stopAuditingReloadDataMethod:(UITableView*)tableView;
+ (BOOL)didCallReloadData:(UITableView*)tableView;

#pragma mark -beginUpdates

+ (void)auditBeginUpdatesMethod:(UITableView*)tableView forward:(BOOL)forward;
+ (void)stopAuditingBeginUpdatesMethod:(UITableView*)tableView;
+ (BOOL)didCallBeginUpdates:(UITableView*)tableView;

#pragma mark -endUpdates

+ (void)auditEndUpdatesMethod:(UITableView*)tableView forward:(BOOL)forward;
+ (void)stopAuditingEndUpdatesMethod:(UITableView*)tableView;
+ (BOOL)didCallEndUpdates:(UITableView*)tableView;

#pragma mark -insertSections:withRowAnimation:

+ (void)auditInsertSectionsMethod:(UITableView*)tableView forward:(BOOL)forward;
+ (void)stopAuditingInsertSectionsMethod:(UITableView*)tableView;
+ (NSIndexSet*)insertSectionsIndexSet:(UITableView*)tableView;
+ (UITableViewRowAnimation)insertSectionsRowAnimation:(UITableView*)tableView;

#pragma mark -deleteSections:withRowAnimation:

+ (void)auditDeleteSectionsMethod:(UITableView*)tableView forward:(BOOL)forward;
+ (void)stopAuditingDeleteSectionsMethod:(UITableView*)tableView;
+ (NSIndexSet*)deleteSectionsIndexSet:(UITableView*)tableView;
+ (UITableViewRowAnimation)deleteSectionsRowAnimation:(UITableView*)tableView;

#pragma mark -reloadSections:withRowAnimation:

+ (void)auditReloadSectionsMethod:(UITableView*)tableView forward:(BOOL)forward;
+ (void)stopAuditingReloadSectionsMethod:(UITableView*)tableView;
+ (NSIndexSet*)reloadSectionsIndexSet:(UITableView*)tableView;
+ (UITableViewRowAnimation)reloadSectionsRowAnimation:(UITableView*)tableView;

#pragma mark -insertRowsAtIndexPaths:withRowAnimation:

+ (void)auditInsertRowsMethod:(UITableView*)tableView forward:(BOOL)forward;
+ (void)stopAuditingInsertRowsMethod:(UITableView*)tableView;
+ (NSArray*)insertRowsIndexPaths:(UITableView*)tableView;
+ (UITableViewRowAnimation)insertRowsRowAnimation:(UITableView*)tableView;

#pragma mark -deleteRowsAtIndexPaths:withRowAnimation:

+ (void)auditDeleteRowsMethod:(UITableView*)tableView forward:(BOOL)forward;
+ (void)stopAuditingDeleteRowsMethod:(UITableView*)tableView;
+ (NSArray*)deleteRowsIndexPaths:(UITableView*)tableView;
+ (UITableViewRowAnimation)deleteRowsRowAnimation:(UITableView*)tableView;

#pragma mark -moveRowAtIndexPaths:toIndexPath:

+ (void)auditMoveRowMethod:(UITableView*)tableView forward:(BOOL)forward;
+ (void)stopAuditingMoveRowMethod:(UITableView*)tableView;
+ (NSIndexPath*)moveRowSourceIndexPath:(UITableView*)tableView;
+ (NSIndexPath*)moveRowDestinationIndexPath:(UITableView*)tableView;

#pragma mark -reloadRowsAtIndexPaths:withRowAnimation:

+ (void)auditReloadRowsMethod:(UITableView*)tableView forward:(BOOL)forward;
+ (void)stopAuditingReloadRowsMethod:(UITableView*)tableView;
+ (NSArray*)reloadRowsIndexPaths:(UITableView*)tableView;
+ (UITableViewRowAnimation)reloadRowsRowAnimation:(UITableView*)tableView;


@end
