// This file is part of IdentityMapper
//
// Created by JC on 9/5/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

@class IDMIdentityMap;
@class IDMMetadata;

/**
 * Storage associated to an object (stored into the identity map) through the use of objc_(get/set)AssociatedObject
 *
 * This object lifecyle is the same as the associating object allowing us to:
 * - perform additional actions when the object is deallocated
 */
@interface IDMIdentityStorage : NSObject

@property(nonatomic, strong)IDMMetadata             *metadata;

/// objectKey of the associating object into the identity map
/// Stored strongly to avoid pitfalls with the NSMapTable used into IDMIdentityMap
/// (http://cocoamine.net/blog/2013/12/13/nsmaptable-and-zeroing-weak-references/)
@property(nonatomic, strong, readonly)id            objectKey;

/// object class identifier used into the identity map
@property(nonatomic, strong, readonly)NSString      *classIdentifier;

/// identity map reference
@property(nonatomic, weak, readonly)IDMIdentityMap  *identityMap;

- (id)init UNAVAILABLE_ATTRIBUTE;
+ (id)new UNAVAILABLE_ATTRIBUTE;

+ (instancetype)storageWithIdentityMap:(IDMIdentityMap *)identityMap
                            identifier:(NSString *)classIdentifier
                                   key:(id)objectKey;
- (instancetype)initWithIdentityMap:(IDMIdentityMap *)identityMap
                         identifier:(NSString *)classIdentifier
                                key:(id)objectKey;

@end
