//
//  Competitor.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 27/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Division, Event, GEvent, Meet, NSManagedObject, Team;

@interface Competitor : NSManagedObject

@property (nonatomic, retain) NSNumber * compID;
@property (nonatomic, retain) NSString * compName;
@property (nonatomic, retain) Meet *meet;
@property (nonatomic, retain) Team *team;
@property (nonatomic, retain) NSSet *divisions;
@property (nonatomic, retain) NSSet *gEvents;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *cEventScores;
@end

@interface Competitor (CoreDataGeneratedAccessors)

- (void)addDivisionsObject:(Division *)value;
- (void)removeDivisionsObject:(Division *)value;
- (void)addDivisions:(NSSet *)values;
- (void)removeDivisions:(NSSet *)values;

- (void)addGEventsObject:(GEvent *)value;
- (void)removeGEventsObject:(GEvent *)value;
- (void)addGEvents:(NSSet *)values;
- (void)removeGEvents:(NSSet *)values;

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

- (void)addCEventScoresObject:(NSManagedObject *)value;
- (void)removeCEventScoresObject:(NSManagedObject *)value;
- (void)addCEventScores:(NSSet *)values;
- (void)removeCEventScores:(NSSet *)values;

@end
