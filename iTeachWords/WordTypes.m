//
//  WordTypes.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/16/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "WordTypes.h"


@implementation WordTypes
@dynamic descriptionStr;
@dynamic name;
@dynamic createBy;
@dynamic createDate;
@dynamic changeBy;
@dynamic changeDate;
@dynamic delete;
@dynamic sorted;
@dynamic typeID;
@dynamic words;

- (void)addWordsObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"words" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"words"] addObject:value];
    [self didChangeValueForKey:@"words" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeWordsObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"words" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"words"] removeObject:value];
    [self didChangeValueForKey:@"words" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addWords:(NSSet *)value {    
    [self willChangeValueForKey:@"words" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"words"] unionSet:value];
    [self didChangeValueForKey:@"words" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeWords:(NSSet *)value {
    [self willChangeValueForKey:@"words" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"words"] minusSet:value];
    [self didChangeValueForKey:@"words" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
