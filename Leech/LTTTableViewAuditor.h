//
//  LTTTableViewAuditor.h
//  Leech
//
//  Created by Sam Odom on 3/14/14.
//  Copyright (c) 2014 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 LTTTableViewAuditor assists in testing code that performs operations on UITableView objects
 
 ##General usage
 
 __Step 1__ Begin auditing one of the auditable methods
 
 __Step 2__ Invoke your method that performs a table operation
 
 __Step 3__ Check that the expected operations and parameters were used
 
 __Step 4__ End auditing of table view methods
 
 ##Specific examples
 
 __Reloading a table view__
 
     [LTTTableViewAuditor auditReloadDataMethod:<#tableView#> forward:YES];
     [<#controller#> <#refreshMethod#>];
     XCTAssertTrue([LTTTableViewAuditor didCallReloadData:<#tableView#>],
                   @"The table view should be reloaded");
     [LTTTableViewAuditor stopAuditingReloadDataMethod:<#tableView#>];
 
 __Grouping table updates (begin)__
 
     [LTTTableViewAuditor auditBeginUpdatesMethod:<#tableView#> forward:YES];
     [<#controller#> controllerWillChangeContent:<#fetchedResultsController#>];
     XCTAssertTrue([LTTTableViewAuditor didCallBeginUpdates:<#tableView#>],
                   @"The table should be put into update mode");
     [LTTTableViewAuditor stopAuditingBeginUpdatesMethod:<#tableView#>];

 __Grouping table updates (end)__
 
     [LTTTableViewAuditor auditEndUpdatesMethod:<#tableView#> forward:YES];
     [<#controller#> controllerDidChangeContent:<#fetchedResultsController#>];
     XCTAssertTrue([LTTTableViewAuditor didCallEndUpdates:<#tableView#>],
                   @"The table should be taken out of update mode");
     [LTTTableViewAuditor stopAuditingEndUpdatesMethod:<#tableView#>];
 
 __Table updates (insert sections)__
 
     [LTTTableViewAuditor auditInsertSectionsMethod:<#tableView#> forward:YES];
     //  insert code that will cause your fetched results controller to have new sections of data
     XCTAssertEqualObjects([LTTTableViewAuditor insertSectionsIndexSet:<#tableView#>],
                           <#newIndices#>,
                           @"The table should have new sections at the following indices: <#indices#>");
     XCTAssertEqual([LTTTableViewAuditor insertSectionsRowAnimation:<#tableView#>],
                    <#rowAnimation#>,
                    @"The sections should be inserted with <#animationDescription#>");
     [LTTTableViewAuditor stopAuditingInsertSectionsMethod:<#tableView#>];

 __Table updates (delete sections)__
 
     [LTTTableViewAuditor auditDeleteSectionsMethod:<#tableView#> forward:YES];
     //  insert code that will cause your fetched results controller to have sections of data removed
     XCTAssertEqualObjects([LTTTableViewAuditor deleteSectionsIndexSet:<#tableView#>],
                           <#indicesToDelete#>,
                           @"The table should have sections removed from the following indices: <#indices#>");
     XCTAssertEqual([LTTTableViewAuditor deleteSectionsRowAnimation:<#tableView#>],
                    <#rowAnimation#>,
                    @"The sections should be deleted with <#animationDescription#>");
     [LTTTableViewAuditor stopAuditingDeleteSectionsMethod:<#tableView#>];

 __Table updates (reload sections)__
 
     [LTTTableViewAuditor auditReloadSectionsMethod:<#tableView#> forward:YES];
     //  insert code that will cause your fetched results controller to have sections of data updated
     XCTAssertEqualObjects([LTTTableViewAuditor reloadSectionsIndexSet:<#tableView#>],
                           <#indicesToReload#>,
                           @"The table should have sections reloaded at the following indices: <#indices#>");
     XCTAssertEqual([LTTTableViewAuditor reloadSectionsRowAnimation:<#tableView#>],
                    <#rowAnimation#>,
                    @"The sections should be reloaded with <#animationDescription#>");
     [LTTTableViewAuditor stopAuditingReloadSectionsMethod:<#tableView#>];

 __Table updates (insert rows)__
 
     [LTTTableViewAuditor auditInsertRowsMethod:<#tableView#> forward:YES];
     //  insert code that will cause your fetched results controller to have new rows of data
     XCTAssertEqualObjects([LTTTableViewAuditor insertRowsIndexPaths:<#tableView#>],
                           <#newIndexPaths#>,
                           @"The table should have new rows at the following index paths: <#indexPaths#>");
     XCTAssertEqual([LTTTableViewAuditor insertRowsRowAnimation:<#tableView#>],
                    <#rowAnimation#>,
                    @"The rows should be inserted with <#animationDescription#>");
     [LTTTableViewAuditor stopAuditingInsertRowsMethod:<#tableView#>];

 __Table updates (delete rows)__
 
     [LTTTableViewAuditor auditDeleteRowsMethod:<#tableView#> forward:YES];
     //  insert code that will cause your fetched results controller to delete rows of data
     XCTAssertEqualObjects([LTTTableViewAuditor deleteRowsIndexPaths:<#tableView#>],
                           <#deletedIndexPaths#>,
                           @"The table should have deleted rows at the following index paths: <#indexPaths#>");
     XCTAssertEqual([LTTTableViewAuditor deleteRowsRowAnimation:<#tableView#>],
                    <#rowAnimation#>,
                    @"The rows should be deleted with <#animationDescription#>");
     [LTTTableViewAuditor stopAuditingDeleteRowsMethod:<#tableView#>];

 __Table updates (move row)__
 
     [LTTTableViewAuditor auditMoveRowMethod:<#tableView#> forward:YES];
     //  insert code that will cause a row of your fetched results controller data to move to a new index path
     XCTAssertEqualObjects([LTTTableViewAuditor moveRowSourceIndexPath:<#tableView#>],
                           <#sourceIndexPath#>,
                           @"The table should move the row from the original index path");
     XCTAssertEqualObjects([LTTTableViewAuditor moveRowDestinationIndexPath:<#tableView#>],
                           <#destinationIndexPath#>,
                           @"The table should have move the row to the new index path");
     [LTTTableViewAuditor stopAuditingMoveRowMethod:<#tableView#>];

 __Table updates (reload rows)__
 
     [LTTTableViewAuditor auditReloadRowsMethod:<#tableView#> forward:YES];
     //  insert code that will cause your fetched results controller to update rows of data
     XCTAssertEqualObjects([LTTTableViewAuditor reloadRowsIndexPaths:<#tableView#>],
                           <#reloadIndexPath#>,
                           @"The table should have reloaded rows at the following index paths: <#indexPaths#>");
     XCTAssertEqual([LTTTableViewAuditor reloadRowsRowAnimation:<#tableView#>],
                    <#rowAnimation#>,
                    @"The rows should be reloaded with <#animationDescription#>");
     [LTTTableViewAuditor stopAuditingReloadRowsMethod:<#tableView#>];
 */
@interface LTTTableViewAuditor : NSObject

#pragma mark - Update and reload methods

#pragma mark -reloadData

/** @name Auditing data reload */

/**
 Audits calls to reload a table view's data

 @param tableView The UITableView to audit for `reloadData` calls
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UITableView reloadData]` with another method that captures the call to reload and optionally forwards the call to the real method implementation
*/
+ (void)auditReloadDataMethod:(UITableView*)tableView forward:(BOOL)forward;

/**
 Ends auditing of `reloadData` and clears captured data
 
 @param tableView UITableView being audited
 */
+ (void)stopAuditingReloadDataMethod:(UITableView*)tableView;

/**
 Indicates whether or not the table view was asked to reload its data
 
 @return BOOL indicating whether or not the table view was asked to reload its data
 
 @param tableView UITableView being audited
 */
+ (BOOL)didCallReloadData:(UITableView*)tableView;

#pragma mark -beginUpdates

/** @name Auditing of grouped updates */

/**
 Audits calls to enter update mode

 @param tableView The UITableView to audit for `beginUpdates` calls
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UITableView beginUpdates]` with another method that captures the call to begin updates and optionally forwards the call to the real method implementation
*/
+ (void)auditBeginUpdatesMethod:(UITableView*)tableView forward:(BOOL)forward;

/**
 Ends auditing of `beginUpdates` and clears captured data
 
 @param tableView UITableView being audited
 */
+ (void)stopAuditingBeginUpdatesMethod:(UITableView*)tableView;

/**
 Indicates whether or not the table view was asked to enter update mode
 
 @return BOOL indicating whether or not the table view was asked to enter update mode
 
 @param tableView UITableView being audited
 */
+ (BOOL)didCallBeginUpdates:(UITableView*)tableView;

#pragma mark -endUpdates

/**
 Audits calls to end update mode

 @param tableView The UITableView to audit for `endUpdates` calls
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UITableView endUpdates]` with another method that captures the call to end updates and optionally forwards the call to the real method implementation
*/
+ (void)auditEndUpdatesMethod:(UITableView*)tableView forward:(BOOL)forward;

/**
 Ends auditing of `endUpdates` and clears captured data
 
 @param tableView UITableView being audited
 */
+ (void)stopAuditingEndUpdatesMethod:(UITableView*)tableView;

/**
 Indicates whether or not the table view was asked to exit update mode
 
 @return BOOL indicating whether or not the table view was asked to exit update mode
 
 @param tableView UITableView being audited
 */
+ (BOOL)didCallEndUpdates:(UITableView*)tableView;

#pragma mark -insertSections:withRowAnimation:

/** @name Auditing of section operations */

/**
 Audits calls to insert sections

 @param tableView The UITableView to audit for section insertion
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UITableView insertSections:withRowAnimation:]` with another method that captures the call to insert sections and optionally forwards the call to the real method implementation
*/
+ (void)auditInsertSectionsMethod:(UITableView*)tableView forward:(BOOL)forward;

/**
 Ends auditing of `insertSections:withRowAnimation:` and clears captured data
 
 @param tableView UITableView being audited
 */
+ (void)stopAuditingInsertSectionsMethod:(UITableView*)tableView;

/**
 Returns the index set at which to insert new sections
 
 @return NSIndexSet specifying sactions to insert
 
 @param tableView UITableView being audited
 */
+ (NSIndexSet*)insertSectionsIndexSet:(UITableView*)tableView;

/**
 Provides animation to use for section insertion
 
 @return UITableViewRowAnimation value specifying animation type
 
 @param tableView UITableView being audited
 */
+ (UITableViewRowAnimation)insertSectionsRowAnimation:(UITableView*)tableView;

#pragma mark -deleteSections:withRowAnimation:

/**
 Audits calls to delete sections
 
 @param tableView The UITableView to audit for section deletion
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UITableView deleteSections:withRowAnimation:]` with another method that captures the call to delete sections and optionally forwards the call to the real method implementation
 */
+ (void)auditDeleteSectionsMethod:(UITableView*)tableView forward:(BOOL)forward;

/**
 Ends auditing of `deleteSections:withRowAnimation:` and clears captured data
 
 @param tableView UITableView being audited
 */
+ (void)stopAuditingDeleteSectionsMethod:(UITableView*)tableView;

/**
 Returns the index set from which to delete sections
 
 @return NSIndexSet specifying sactions to delete
 
 @param tableView UITableView being audited
 */
+ (NSIndexSet*)deleteSectionsIndexSet:(UITableView*)tableView;

/**
 Provides animation to use for section deletion
 
 @return UITableViewRowAnimation value specifying animation type
 
 @param tableView UITableView being audited
 */
+ (UITableViewRowAnimation)deleteSectionsRowAnimation:(UITableView*)tableView;

#pragma mark -reloadSections:withRowAnimation:

/**
 Audits calls to reload sections
 
 @param tableView The UITableView to audit for section reload
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UITableView reloadSections:withRowAnimation:]` with another method that captures the call to reload sections and optionally forwards the call to the real method implementation
 */
+ (void)auditReloadSectionsMethod:(UITableView*)tableView forward:(BOOL)forward;

/**
 Ends auditing of `reloadSections:withRowAnimation:` and clears captured data
 
 @param tableView UITableView being audited
 */
+ (void)stopAuditingReloadSectionsMethod:(UITableView*)tableView;

/**
 Returns the index set of sections to reload
 
 @return NSIndexSet specifying sactions to reload
 
 @param tableView UITableView being audited
 */
+ (NSIndexSet*)reloadSectionsIndexSet:(UITableView*)tableView;

/**
 Provides animation to use for section reload
 
 @return UITableViewRowAnimation value specifying animation type
 
 @param tableView UITableView being audited
 */
+ (UITableViewRowAnimation)reloadSectionsRowAnimation:(UITableView*)tableView;


#pragma mark -insertRowsAtIndexPaths:withRowAnimation:

/** @name Auditing of row operations */

/**
 Audits calls to insert rows
 
 @param tableView The UITableView to audit for row insertion
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UITableView insertRowsAtIndexPaths:withRowAnimation:]` with another method that captures the call to insert rows and optionally forwards the call to the real method implementation
 */
+ (void)auditInsertRowsMethod:(UITableView*)tableView forward:(BOOL)forward;

/**
 Ends auditing of `insertRowsAtIndexPaths:withRowAnimation:` and clears captured data
 
 @param tableView UITableView being audited
 */
+ (void)stopAuditingInsertRowsMethod:(UITableView*)tableView;

/**
 Returns the index paths at which to insert new rows
 
 @return NSArray of NSIndexPath objects specifying rows to insert
 
 @param tableView UITableView being audited
 */
+ (NSArray*)insertRowsIndexPaths:(UITableView*)tableView;

/**
 Provides animation to use for row insertion
 
 @return UITableViewRowAnimation value specifying animation type
 
 @param tableView UITableView being audited
 */
+ (UITableViewRowAnimation)insertRowsRowAnimation:(UITableView*)tableView;

#pragma mark -deleteRowsAtIndexPaths:withRowAnimation:

/**
 Audits calls to delete rows
 
 @param tableView The UITableView to audit for row deletion
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UITableView deleteRowsAtIndexPaths:withRowAnimation:]` with another method that captures the call to delete rows and optionally forwards the call to the real method implementation
 */
+ (void)auditDeleteRowsMethod:(UITableView*)tableView forward:(BOOL)forward;

/**
 Ends auditing of `deleteRowsAtIndexPaths:withRowAnimation:` and clears captured data
 
 @param tableView UITableView being audited
 */
+ (void)stopAuditingDeleteRowsMethod:(UITableView*)tableView;

/**
 Returns the index paths from which to delete rows
 
 @return NSArray of NSIndexPath objects specifying rows to delete
 
 @param tableView UITableView being audited
 */
+ (NSArray*)deleteRowsIndexPaths:(UITableView*)tableView;

/**
 Provides animation to use for row deletion
 
 @return UITableViewRowAnimation value specifying animation type
 
 @param tableView UITableView being audited
 */
+ (UITableViewRowAnimation)deleteRowsRowAnimation:(UITableView*)tableView;

#pragma mark -moveRowAtIndexPaths:toIndexPath:

/**
 Audits calls to move row
 
 @param tableView The UITableView to audit for moving rows
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UITableView moveRowAtIndexPath:toIndexPath:]` with another method that captures the call to move the row and optionally forwards the call to the real method implementation
 */
+ (void)auditMoveRowMethod:(UITableView*)tableView forward:(BOOL)forward;

/**
 Ends auditing of `moveRowAtIndexPath:toIndexPath:` and clears captured data
 
 @param tableView UITableView being audited
 */
+ (void)stopAuditingMoveRowMethod:(UITableView*)tableView;

/**
 Returns the index path from which to move a row
 
 @return NSIndexPath specifying row to move
 
 @param tableView UITableView being audited
 */
+ (NSIndexPath*)moveRowSourceIndexPath:(UITableView*)tableView;

/**
 Returns the index path to which a row should be moved
 
 @return NSIndexPath specifying where to move row
 
 @param tableView UITableView being audited
 */
+ (NSIndexPath*)moveRowDestinationIndexPath:(UITableView*)tableView;

#pragma mark -reloadRowsAtIndexPaths:withRowAnimation:

/**
 Audits calls to reload rows
 
 @param tableView The UITableView to audit for row reload
 @param forward BOOL specifying whether or not to forward the call to the real method implementation
 
 @discussion This method replaces the real method implementation of `-[UITableView reloadRowsAtIndexPaths:withRowAnimation:]` with another method that captures the call to reload rows and optionally forwards the call to the real method implementation
 */
+ (void)auditReloadRowsMethod:(UITableView*)tableView forward:(BOOL)forward;

/**
 Ends auditing of `reloadRowsAtIndexPaths:withRowAnimation:` and clears captured data
 
 @param tableView UITableView being audited
 */
+ (void)stopAuditingReloadRowsMethod:(UITableView*)tableView;

/**
 Returns the index paths of rows to reload
 
 @return NSArray of NSIndexPath objects specifying rows to reload
 
 @param tableView UITableView being audited
 */
+ (NSArray*)reloadRowsIndexPaths:(UITableView*)tableView;

/**
 Provides animation to use for row reload
 
 @return UITableViewRowAnimation value specifying animation type
 
 @param tableView UITableView being audited
 */
+ (UITableViewRowAnimation)reloadRowsRowAnimation:(UITableView*)tableView;


@end
