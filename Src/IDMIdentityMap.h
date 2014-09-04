//
// This file is part of IdentityMapper
//
// Created by JC on 8/29/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

@class IDMMetadata;

typedef void(^IDMIdentityFoundBlock)(id object, IDMMetadata *metadata);

/**
 * Weakly store unique instance of objects
 *
 * Objects are stored along with 2 keys:
 * - a **class key** separating object instances into families. Most of the time you will use the object instance classname
 * but any arbitrary string can be used
 * - an **object key** which identify the object uniquely among its family
 *
 * To insert or find an object you will be asked to provide those 2 information. It is up to you to ensure to always
 * provide same class and object keys for a given object to ensure uniqueness
 *
 * Objects are **weakly stored** into the map and so they stay inside it as long as they are used/retained by the application. As soon
 * as an object is released from the application it is removed from the map.
 *
 * Note that object keys are also stored weakly: you should ensure that their lifecyles are the same than their associated objects
 */
@interface IDMIdentityMap : NSObject

/**
 * Find an object inside the identity map matching classIdentifier and objectKey
 *
 * @param classIdentifier string to identify the object family/class
 * @param objectKey key uniquely identifying (among the object family) the object instance
 * @param found block called when object is found
 */
- (void)findObjectWithIdentifier:(NSString *)classIdentifier key:(id)objectKey whenFound:(IDMIdentityFoundBlock)found;

/**
 * Find an object inside the identity map matching class type objectClass and objectKey
 *
 * @param objectClass object class. Will be stringified to use as the class identifier
 * @param objectKey key uniquely identifying (among the object family) the object instance
 * @param found block called when object is found
 */
- (void)findObject:(Class)objectClass key:(id)objectKey whenFound:(IDMIdentityFoundBlock)found;

- (BOOL)addObject:(id)object identifier:(NSString *)classIdentifier key:(id)objectKey;
- (BOOL)addObject:(id)object key:(id)objectKey;

- (void)removeObject:(id)object key:(id)objectKey;

@end
