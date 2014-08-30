//
// This file is part of IdentityMapper
//
// Created by JC on 8/30/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "IDMIdentityMap.h"
#import "IDMMetadata.h"
#import "IDMIdentity.h"

SPEC_BEGIN(IDMIdentityMapSpec)

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
        object = [NSURL nullMock];
        
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
        __block NSURL *clone;
        
        beforeEach(^{
            clone = [NSURL nullMock];
        });
        
        it(@"should add when key is different", ^{
            [[theValue([identityMap addObject:clone key:@23]) should] beTrue];
        });
        
        it(@"should NOT add when key is same",  ^{
            [[theValue([identityMap addObject:clone key:objectKey]) should] beFalse];
        });
    });
    
    context(@"when adding an object with another type", ^{
        __block NSArray *object2;

        beforeEach(^{
            object2 = [NSArray nullMock];
        });
        
        it(@"should add when key is different", ^{
            [[theValue([identityMap addObject:object2 key:@23]) should] beTrue];
        });
        
        it(@"should add when key is same",  ^{
            [[theValue([identityMap addObject:object2 key:objectKey]) should] beTrue];
        });
        
        it(@"should remove both objects when key is same", ^{
            __block int found = 0;
            
            [identityMap addObject:object2 key:objectKey];
            
            [identityMap removeObject:object key:objectKey];
            [identityMap removeObject:object2 key:objectKey];
            
            [identityMap findObject:[object class]
                                key:objectKey
                          whenFound:^(id object, IDMMetadata *metadata) { found += 1; }];
            
            [identityMap findObject:[object2 class]
                                key:objectKey
                          whenFound:^(id object, IDMMetadata *metadata) { found += 1; }];
            
            [[theValue(found) should] equal:theValue(2)];
        });
    });
});

describe(@"with a Zeroing Weak References object", ^{
    __block NSObject *zwrObject;
    __block IDMIdentity *objectIdentity;
    
    beforeEach(^{
        @autoreleasepool {
            zwrObject = [NSObject nullMock];
            objectIdentity = [IDMIdentity identityWithObject:zwrObject];
            
            [IDMIdentity stub:@selector(identityWithObject:) andReturn:objectIdentity];
            [identityMap addObject:zwrObject key:objectKey];
            
            zwrObject = nil;
        }
    });
    
    context(nil, ^{
        it(@"should not find the object", ^{
            __block BOOL found = NO;

            [identityMap findObject:[NSObject class]
                                key:objectKey
                          whenFound:^(id object, IDMMetadata *metadata) { found = YES; }];
            
            [[theValue(found) should] beFalse];
        });
        
        it(@"object identity should be nil", ^{
            [[objectIdentity.object should] beNil];
        });
    });
    
    context(@"when adding an object with similar type", ^{
        it(@"should add when key is same", ^ {
            NSObject *similarObject = [NSObject nullMock];
            
            [[theValue([identityMap addObject:similarObject key:objectKey]) should] beTrue];
        });
    });
});

SPEC_END
