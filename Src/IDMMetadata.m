//
// This file is part of IdentityMapper
//
// Created by JC on 8/29/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
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
