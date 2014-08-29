//
// This file is part of IdentityMapper
//
// Created by JC on 8/29/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

/// object data state
/// @see IDMMetadata::state for more information about how to use it
typedef NS_ENUM(NSUInteger, IDMObjectState) {
    IDMObjectStateFresh,
    IDMObjectStateRefreshing,
    IDMObjectStateStale
};

/**
 * Data describing a related identity object stored into the identity map
 * Those metadata should allow you to determine whether or not the related object is still valid
 * Those data are only informational: it's you up to you to decide to follow them or not
 */
@interface IDMMetadata : NSObject

/// last time related object was marked as fresh. Could be used to determine whether or not you may need to fetch data
@property(nonatomic, strong)NSDate                      *freshDate;

/**
 * The related object state
 * Depending on its value you should take different action:
 * - IDMObjectStateStale: you should consider the object as not up-to-date and refresh it by fetching data from DB, WS, etc...
 * - IDMObjectStateRefreshing: it means someone is already updating the object. Therefore you should listen
 * to state changes (KVO) and wait that it comes back to IDMObjectStateFresh
 * - IDMObjectStateFresh: object is ready to be used as-is

 * @param state the related object current state
 */
@property(nonatomic, assign, readonly)IDMObjectState    state;

/// mark the object as requiring update. Only work if current state is IDMObjectStateFresh
- (void)stale;

/// mark the object as being updating. Only work if current state is IDMObjectStateStale
- (void)refreshing;

/// mark the object as being clean
/// It also update freshDate to current date
- (void)fresh;

@end
