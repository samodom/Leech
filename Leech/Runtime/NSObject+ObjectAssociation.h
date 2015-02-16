//
//  NSObject+ObjectAssociation.h
//  Leech
//
//  Created by Sam Odom on 2/15/15.
//  Copyright (c) 2015 Swagger Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


/*!
    Category for associating objects with one another.  This is a simple set of wrapper methods around the Objective-C runtime functions.
 */
@interface NSObject (ObjectAssociation)

/*!
    Associates an object with this object using the specified key.  The association policy us *assign*.
    @param      key C string to use as the key in the association.
    @param      object Object to associate with the receiver.
 */
- (void)associateKey:(nonnull const char *)key withObject:(nonnull id)object;

/*!
    Associates an object with this object using the specified key.
    @param      key C string to use as the key in the association.
    @param      object Object to associate with the receiver.
    @param      policy The Objective-C object association policy to use.
 */
- (void)associateKey:(nonnull  const char *)key withObject:(nonnull id)object policy:(objc_AssociationPolicy)policy;

/*!
    Retrieves an object associated with the receiver using the provided key, if such an association exists.
    @param      key C string used as the key in the association.
    @return     The object associated with the receiver using the provided key, if the association exists.
 */
- (nullable id)associationForKey:(nonnull const char *)key;

/*!
    Removes the association between the receiver and any object associated using the provided key.
    @param      key C string used as the key in an association of the receiver.
 */
- (void)clearAssociationForKey:(nonnull const char *)key;

/*!
    Removes all object associations of the receiver.
    @discussion     Use this method with extreme caution as there is no way to determine whether or not another object relies on some association(s).
 */
- (void)clearAllAssociations;

@end
