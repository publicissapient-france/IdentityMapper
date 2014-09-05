//
// This file is part of IdentityMapper
//
// Created by JC on 8/29/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "IDMIdentityMap.h"

#import "IDMMetadata.h"
#import "IDMIdentityStorage.h"
#import <objc/runtime.h>

NSString *const IDMObjectMetadataAttribute;

@interface IDMIdentityMap ()
@property(nonatomic, strong)NSMutableDictionary *map;
@end

@implementation IDMIdentityMap

- (instancetype)init {
    if (!(self = [super init]))
        return nil;
    
    self.map = [NSMutableDictionary new];
    
    return self;
}

- (void)findObject:(Class)objectClass key:(id)objectKey whenFound:(IDMIdentityFoundBlock)found {
    return [self findObjectWithIdentifier:NSStringFromClass(objectClass) key:objectKey whenFound:found];
}

- (void)findObjectWithIdentifier:(NSString *)classIdentifier key:(id)objectKey whenFound:(IDMIdentityFoundBlock)found {
    id object = [self.map[classIdentifier] objectForKey:objectKey];
    
    if (object) {
        IDMIdentityStorage *storage = objc_getAssociatedObject(object, &IDMObjectMetadataAttribute);
        found(object, storage.metadata);
    }
}

- (BOOL)addObject:(id)object key:(id)objectKey {
    return [self addObject:object identifier:NSStringFromClass([object class]) key:objectKey];
}

- (BOOL)addObject:(id)object identifier:(NSString *)classIdentifier key:(id)objectKey {
    NSMapTable *classType = self.map[classIdentifier];
    
    if (!classType) {
        classType = [NSMapTable weakToWeakObjectsMapTable];

        self.map[classIdentifier] = classType;
    }
    
    if (![classType objectForKey:objectKey]) {
        IDMIdentityStorage *objectStorage = [IDMIdentityStorage storageWithIdentityMap:self identifier:classIdentifier key:objectKey];

        objectStorage.metadata = [IDMMetadata new];

        [classType setObject:object forKey:objectKey];
        objc_setAssociatedObject(object, &IDMObjectMetadataAttribute, objectStorage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        return YES;
    }
    
    return NO;
}

- (void)removeObject:(id)object key:(id)objectKey {
    [self removeIdentifier:NSStringFromClass([object class]) key:objectKey];
}

- (void)removeIdentifier:(NSString *)classIdentifier key:(id)objectKey {
    [self.map[classIdentifier] removeObjectForKey:objectKey];
}

@end
