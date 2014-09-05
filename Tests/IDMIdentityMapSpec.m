//
// This file is part of IdentityMapper
//
// Created by JC on 8/30/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "IDMIdentityMap.h"
#import "IDMMetadata.h"

SPEC_BEGIN(IDMIdentityMapTests)

__block IDMIdentityMap  *identityMap;
const NSNumber  *objectKey = @22;

describe(@"with an empty identity map", ^{
    beforeEach(^{
        identityMap = [IDMIdentityMap new];
    });
    
    context(@"when adding an object", ^{
        __block NSURL *object;
        
        beforeEach(^{
            object = [NSURL nullMock];
        });
        
        it(@"should return TRUE", ^{
            [[theValue([identityMap addObject:object key:objectKey]) should] beTrue];
        });
    });
    
    context(nil, ^{
        it(@"should NOT find anything", ^{
            __block BOOL found = NO;
            
            [identityMap findObject:[NSObject class]
                                key:objectKey
                          whenFound:^(id object, IDMMetadata *metadata) { found = YES; }];
            
            [[theValue(found) should] beFalse];
        });
    });
});

describe(@"with an identity map with one object", ^{
    __block NSURL *object;
    
    beforeEach(^{
        identityMap = [IDMIdentityMap new];
        object = [NSURL URLWithString:@"http://google.com"];
        
        [identityMap addObject:object key:objectKey];
    });
    
    context(nil, ^{
        it(@"should find the object", ^{
            __block BOOL found = NO;
            
            [identityMap findObject:[object class]
                                key:objectKey
                          whenFound:^(id object, IDMMetadata *metadata) { found = YES; }];
            
            [[theValue(found) should] beTrue];
        });
        
        it(@"should remove the object from identity map", ^{
            __block BOOL found = NO;
            
            [identityMap removeObject:object key:objectKey];
            
            [identityMap findObject:[object class]
                                key:objectKey
                          whenFound:^(id object, IDMMetadata *metadata) { found = YES; }];
            
            [[theValue(found) should] beFalse];
        });
    });
    
    context(@"when adding an object with similar type", ^{
        __block NSURL *similar;
        
        beforeEach(^{
            similar = [NSURL URLWithString:@"http://google.com"];
        });
        
        it(@"should add when key is different", ^{
            [[theValue([identityMap addObject:similar key:@23]) should] beTrue];
        });
        
        it(@"should NOT add when key is same",  ^{
            [[theValue([identityMap addObject:similar key:objectKey]) should] beFalse];
        });
    });
    
    context(@"when adding an object with another type", ^{
        __block NSArray *object2;

        beforeEach(^{
            object2 = @[];
        });
        
        it(@"should add when key is different", ^{
            [[theValue([identityMap addObject:object2 key:@23]) should] beTrue];
        });
        
        it(@"should add when key is similar",  ^{
            [[theValue([identityMap addObject:object2 key:objectKey]) should] beTrue];
        });
        
        it(@"should remove both objects when key is same", ^{
            __block int notFound = 2;
            
            [identityMap addObject:object2 key:objectKey];
            
            [identityMap removeObject:object key:objectKey];
            [identityMap removeObject:object2 key:objectKey];
            
            [identityMap findObject:[object class]
                                key:objectKey
                          whenFound:^(id object, IDMMetadata *metadata) { notFound -= 1; }];
            
            [identityMap findObject:[object2 class]
                                key:objectKey
                          whenFound:^(id object, IDMMetadata *metadata) { notFound -= 1; }];
            
            [[theValue(notFound) should] equal:theValue(2)];
        });
    });
});

describe(@"with a Zeroing Weak References object", ^{
    __block NSObject *zwrObject;
    
    context(nil, ^{
        beforeEach(^{
            @autoreleasepool {
                NSNumber *weakKey = @22;
                zwrObject = [NSObject nullMock];
                
                [identityMap addObject:zwrObject key:weakKey];
                
                zwrObject = nil;
            }
        });
        
        it(@"should not find the object", ^{
            __block BOOL found = NO;

            [identityMap findObject:[KWMock class]
                                key:objectKey
                          whenFound:^(id object, IDMMetadata *metadata) { found = YES; }];
            
            [[theValue(found) should] beFalse];
        });
        
        context(@"when adding an object with similar type", ^{
            it(@"should add when key is same", ^ {
                NSObject *similarObject = [NSObject nullMock];
                
                [[theValue([identityMap addObject:similarObject key:objectKey]) should] beTrue];
            });
        });
    });
    
    context(@"with maptable", ^{
        __block NSMapTable *mapTable;

        beforeEach(^{
            @autoreleasepool {
                NSNumber *weakKey = @22;
                zwrObject = [NSObject nullMock];
                
                [identityMap addObject:zwrObject key:weakKey];
                mapTable = [[identityMap valueForKey:@"map"] objectForKey:@"KWMock"];

                zwrObject = nil;
            }
        });
        
        it(@"should be empty", ^{
            [[mapTable should] beNonNil];
            
            [[theValue(mapTable.count) should] equal:theValue(0)];
            [[theValue(mapTable.objectEnumerator.allObjects.count) should] equal:theValue(0)];
            [[theValue(mapTable.keyEnumerator.allObjects.count) should] equal:theValue(0)];
        });
    });
});

SPEC_END
