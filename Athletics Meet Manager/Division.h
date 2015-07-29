//
//  Division.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 29/07/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Meet;

@interface Division : NSManagedObject

@property (nonatomic, retain) NSNumber * divID;
@property (nonatomic, retain) NSString * divName;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) Meet *meet;
@end

@interface Division (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
