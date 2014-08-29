//
// This file is part of IdentityMapper
//
// Created by JC on 8/29/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

@class IDMMetadata;

/**
 * Identity role is to store an object for further retrieval (through IDMIdentityMap) with all its related data
 * Storage is done using a weak link/reference to avoid keeping objects no more used by application into memory
 */
@interface IDMIdentity : NSObject

/**
 * Related metadata giving insights about object state
 * @param metadata metadata related to object. One instance of IDMMetadata is linked to one object only
 */
@property(nonatomic, strong)IDMMetadata *metadata;

/**
 * Object that we wish to store in order to being able to retrieve it
 * 
 * Weakly referenced so that as soon as no one is referencing it, it is "removed" from the identity map
 * @param identityObject the object to store
 */
@property(nonatomic, weak)id            object;

@end
