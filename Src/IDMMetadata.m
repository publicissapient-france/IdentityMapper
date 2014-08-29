//
//  IDMMetadata.m
//  IdentityMapper
//
//  Created by JC on 29/08/14.
//  Copyright (c) 2014 fr.milkshake. All rights reserved.
//

#import "IDMMetadata.h"

@interface IDMMetadata ()
@property(nonatomic, assign)IDMObjectState  state;
@end

@implementation IDMMetadata

- (id)init {
    if (!(self = [super init]))
        return nil;

    [self fresh];

    return self;
}

- (void)stale {
    if (self.state != IDMObjectStateFresh)
        return;

    self.state = IDMObjectStateStale;
}

- (void)refreshing {
    if (self.state != IDMObjectStateStale)
        return;

    self.state = IDMObjectStateRefreshing;
}

- (void)fresh {
    self.freshDate = [NSDate date];
    self.state = IDMObjectStateFresh;
}

@end
