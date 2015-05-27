//
//  Event.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 27/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Meet, NSManagedObject, Team;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * eventID;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSNumber * eventEdited;
@property (nonatomic, retain) NSNumber * eventDone;
@property (nonatomic, retain) Meet *meet;
@property (nonatomic, retain) NSSet *teams;
@property (nonatomic, retain) NSManagedObject *gEvent;
@property (nonatomic, retain) NSManagedObject *division;
@property (nonatomic, retain) NSSet *competitors;
@property (nonatomic, retain) NSSet *cEventScores;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(Team *)value;
- (void)removeTeamsObject:(Team *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

- (void)addCompetitorsObject:(NSManagedObject *)value;
- (void)removeCompetitorsObject:(NSManagedObject *)value;
- (void)addCompetitors:(NSSet *)values;
- (void)removeCompetitors:(NSSet *)values;

- (void)addCEventScoresObject:(NSManagedObject *)value;
- (void)removeCEventScoresObject:(NSManagedObject *)value;
- (void)addCEventScores:(NSSet *)values;
- (void)removeCEventScores:(NSSet *)values;

@end
