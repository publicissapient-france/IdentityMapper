// This file is part of IdentityMapper
//
// Created by JC on 9/5/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "IDMIdentityStorage.h"

#import "IDMIdentityMap.h"

@interface IDMIdentityStorage ()
@property(nonatomic, strong)id              objectKey;
@property(nonatomic, strong)NSString        *classIdentifier;
@property(nonatomic, weak)IDMIdentityMap    *identityMap;
@end

@implementation IDMIdentityStorage

- (void)dealloc {
    [self.identityMap removeIdentifier:self.classIdentifier key:self.objectKey];
}

+ (instancetype)storageWithIdentityMap:(IDMIdentityMap *)identityMap identifier:(NSString *)classIdentifier key:(id)objectKey {
    return [[[self class] alloc] initWithIdentityMap:identityMap identifier:classIdentifier key:objectKey];
}

- (instancetype)initWithIdentityMap:(IDMIdentityMap *)identityMap identifier:(NSString *)classIdentifier key:(id)objectKey {
    if (!(self = [super init]))
        return nil;

    self.identityMap = identityMap;
    self.classIdentifier = classIdentifier;
    self.objectKey = objectKey;

    return self;
}

@end
