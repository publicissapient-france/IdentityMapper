//
// This file is part of IdentityMapper
//
// Created by JC on 8/29/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "IDMIdentityMap.h"

#import "IDMIdentity.h"

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
    IDMIdentity *identity = self.map[type][objectKey];
    
    if (identity) {
        // object found
        if (identity.object)
            return found(identity.object, identity.metadata);
        
        // object identity found but object has been released: clean a little bit
        [self.map[type] removeObjectForKey:objectKey];
    }
}

- (BOOL)addObject:(id)object key:(id<NSCopying>)objectKey {
    NSString *type = NSStringFromClass([object class]);
    NSMutableDictionary *mapType = self.map[type];
    
    if (!mapType) {
        mapType = [NSMutableDictionary new];
        self.map[type] = mapType;
    }
    
    // No identity or identity object has been released
    if (!mapType[objectKey] || ![mapType[objectKey] object]) {
        IDMIdentity *identity = [IDMIdentity identityWithObject:object];
        
        mapType[objectKey] = identity;
        
        return YES;
    }
    
    return NO;
}

- (void)removeObject:(id)object key:(id<NSCopying>)objectKey {
    [self.map[NSStringFromClass([object class])] removeObjectForKey:objectKey];
}

@end
