//
// This file is part of IdentityMapper
//
// Created by JC on 8/29/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "IDMIdentityMap.h"

#import "IDMMetadata.h"
#import <objc/objc-runtime.h>

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
    NSString *type = NSStringFromClass(objectClass);
    id object = [self.map[type] objectForKey:objectKey];
    
    if (object)
        found(object, objc_getAssociatedObject(object, &IDMObjectMetadataAttribute));
}

- (BOOL)addObject:(id)object key:(id)objectKey {
    NSString *type = NSStringFromClass([object class]);
    NSMapTable *mapType = self.map[type];
    
    if (!mapType) {
        mapType = [NSMapTable weakToWeakObjectsMapTable];
        self.map[type] = mapType;
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
