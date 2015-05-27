//
//  GEvent.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 27/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, Meet, NSManagedObject, Team;

@interface GEvent : NSManagedObject

@property (nonatomic, retain) NSNumber * gEventID;
@property (nonatomic, retain) NSString * gEventName;
@property (nonatomic, retain) NSString * gEventType;
@property (nonatomic, retain) NSNumber * competitorsPerTeam;
@property (nonatomic, retain) NSDate * gEventTiming;
@property (nonatomic, retain) Meet *meet;
@property (nonatomic, retain) NSSet *teams;
@property (nonatomic, retain) NSSet *divisions;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *competitors;
@property (nonatomic, retain) NSSet *cEventScores;
@end

@interface GEvent (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

- (void)addDivisionsObject:(NSManagedObject *)value;
- (void)removeDivisionsObject:(NSManagedObject *)value;
- (void)addDivisions:(NSSet *)values;
- (void)removeDivisions:(NSSet *)values;

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addCompetitorsObject:(NSManagedObject *)value;
- (void)removeCompetitorsObject:(NSManagedObject *)value;
- (void)addCompetitors:(NSSet *)values;
- (void)removeCompetitors:(NSSet *)values;

- (void)addCEventScoresObject:(NSManagedObject *)value;
- (void)removeCEventScoresObject:(NSManagedObject *)value;
- (void)addCEventScores:(NSSet *)values;
- (void)removeCEventScores:(NSSet *)values;

@end
