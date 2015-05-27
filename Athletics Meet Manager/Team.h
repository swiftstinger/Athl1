//
//  Team.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 27/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event, GEvent, Meet, NSManagedObject;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSNumber * teamID;
@property (nonatomic, retain) NSString * teamName;
@property (nonatomic, retain) NSString * teamAbr;
@property (nonatomic, retain) Meet *meet;
@property (nonatomic, retain) NSSet *divisions;
@property (nonatomic, retain) NSSet *gEvents;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) NSSet *competitors;
@property (nonatomic, retain) NSSet *cEventScores;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addDivisionsObject:(NSManagedObject *)value;
- (void)removeDivisionsObject:(NSManagedObject *)value;
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

- (void)addCompetitorsObject:(NSManagedObject *)value;
- (void)removeCompetitorsObject:(NSManagedObject *)value;
- (void)addCompetitors:(NSSet *)values;
- (void)removeCompetitors:(NSSet *)values;

- (void)addCEventScoresObject:(NSManagedObject *)value;
- (void)removeCEventScoresObject:(NSManagedObject *)value;
- (void)addCEventScores:(NSSet *)values;
- (void)removeCEventScores:(NSSet *)values;

@end
