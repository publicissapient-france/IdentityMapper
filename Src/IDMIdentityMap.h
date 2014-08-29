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

@interface IDMIdentityMap : NSObject

- (void)findObject:(Class)objectClass
               key:(id)objectKey
         whenFound:(IDMIdentityFoundBlock)found;

- (BOOL)addObject:(id)object key:(id<NSCopying>)objectKey;

- (void)removeObject:(id)object key:(id<NSCopying>)objectKey;

@end
