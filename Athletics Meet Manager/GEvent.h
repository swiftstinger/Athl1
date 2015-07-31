//
//  GEvent.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 30/07/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Meet;

@interface GEvent : NSManagedObject

@property (nonatomic, retain) NSNumber * competitorsPerTeam;
@property (nonatomic, retain) NSNumber * decrementPerPlace;
@property (nonatomic, retain) NSNumber * gEventID;
@property (nonatomic, retain) NSString * gEventName;
@property (nonatomic, retain) NSDate * gEventTiming;
@property (nonatomic, retain) NSString * gEventType;
@property (nonatomic, retain) NSNumber * maxScoringCompetitors;
@property (nonatomic, retain) NSNumber * scoreForFirstPlace;
@property (nonatomic, retain) NSNumber * scoreMultiplier;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) NSString * onlineID;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) Meet *meet;
@end

@interface GEvent (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
