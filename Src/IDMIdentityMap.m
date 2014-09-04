//
// This file is part of IdentityMapper
//
// Created by JC on 8/29/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "IDMIdentityMap.h"

#import "IDMMetadata.h"
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
    
    if (object)
        found(object, objc_getAssociatedObject(object, &IDMObjectMetadataAttribute));
}

- (BOOL)addObject:(id)object key:(id)objectKey {
    return [self addObject:object identifier:NSStringFromClass([object class]) key:objectKey];
}

- (BOOL)addObject:(id)object identifier:(NSString *)classIdentifier key:(id)objectKey {
    NSMapTable *mapType = self.map[classIdentifier];
    
    if (!mapType) {
        mapType = [NSMapTable weakToWeakObjectsMapTable];
        self.map[classIdentifier] = mapType;
    }
    
    if (![mapType objectForKey:objectKey]) {
        IDMMetadata *objectMetadata = [IDMMetadata new];
        
        [mapType setObject:object forKey:objectKey];
        objc_setAssociatedObject(object, &IDMObjectMetadataAttribute, objectMetadata, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        return YES;
    }
    
    return NO;
}

- (void)removeObject:(id)object key:(id)objectKey {
    [self.map[NSStringFromClass([object class])] removeObjectForKey:objectKey];
}

@end
