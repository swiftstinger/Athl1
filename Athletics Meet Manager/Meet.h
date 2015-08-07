//
//  Meet.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 07/08/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CEventScore, Competitor, Division, Event, GEvent, Team;

@interface Meet : NSManagedObject

@property (nonatomic, retain) NSNumber * cEventLimit;
@property (nonatomic, retain) NSNumber * competitorPerTeam;
@property (nonatomic, retain) NSNumber * decrementPerPlace;
@property (nonatomic, retain) NSNumber * divsDone;
@property (nonatomic, retain) NSNumber * eventsDone;
@property (nonatomic, retain) NSNumber * maxScoringCompetitors;
@property (nonatomic, retain) NSDate * meetDate;
@property (nonatomic, retain) NSDate * meetEndTime;
@property (nonatomic, retain) NSNumber * meetID;
@property (nonatomic, retain) NSString * meetName;
@property (nonatomic, retain) NSDate * meetStartTime;
@property (nonatomic, retain) NSNumber * scoreForFirstPlace;
@property (nonatomic, retain) NSNumber * scoreMultiplier;
@property (nonatomic, retain) NSNumber * teamsDone;
@property (nonatomic, retain) NSNumber * onlineMeet;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSNumber * isOwner;
@property (nonatomic, retain) NSString * onlineID;
@property (nonatomic, retain) NSSet *cEventsScores;
@property (nonatomic, retain) NSSet *competitors;
@property (nonatomic, retain) NSSet *divisions;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *gEvents;
@property (nonatomic, retain) NSSet *teams;
@end

@interface Meet (CoreDataGeneratedAccessors)

- (void)addCEventsScoresObject:(CEventScore *)value;
- (void)removeCEventsScoresObject:(CEventScore *)value;
- (void)addCEventsScores:(NSSet *)values;
- (void)removeCEventsScores:(NSSet *)values;

- (void)addCompetitorsObject:(Competitor *)value;
- (void)removeCompetitorsObject:(Competitor *)value;
- (void)addCompetitors:(NSSet *)values;
- (void)removeCompetitors:(NSSet *)values;

- (void)addDivisionsObject:(Division *)value;
- (void)removeDivisionsObject:(Division *)value;
- (void)addDivisions:(NSSet *)values;
- (void)removeDivisions:(NSSet *)values;

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addGEventsObject:(GEvent *)value;
- (void)removeGEventsObject:(GEvent *)value;
- (void)addGEvents:(NSSet *)values;
- (void)removeGEvents:(NSSet *)values;

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

@end
