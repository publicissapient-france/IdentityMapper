//
// This file is part of IdentityMapper
//
// Created by JC on 8/29/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "IDMIdentity.h"

#import "IDMMetadata.h"

@interface IDMIdentity ()
@property(nonatomic, strong)IDMMetadata *metadata;
@property(nonatomic, weak)id            object;
@end

@implementation IDMIdentity

+ (instancetype)identityWithObject:(id)object {
    return [[self alloc] initWithObject:object];
}

- (instancetype)initWithObject:(id)object {
    if (!(self = [super init]))
        return nil;
    
    self.object = object;
    self.metadata = [IDMMetadata new];
    
    return self;
}

@end
