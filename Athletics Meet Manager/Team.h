//
//  Team.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 30/07/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CEventScore, Competitor, Meet;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSString * teamAbr;
@property (nonatomic, retain) NSNumber * teamID;
@property (nonatomic, retain) NSString * teamName;
@property (nonatomic, retain) NSNumber * teamPlace;
@property (nonatomic, retain) NSNumber * teamScore;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSString * onlineID;
@property (nonatomic, retain) NSSet *cEventScores;
@property (nonatomic, retain) NSSet *competitors;
@property (nonatomic, retain) Meet *meet;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addCEventScoresObject:(CEventScore *)value;
- (void)removeCEventScoresObject:(CEventScore *)value;
- (void)addCEventScores:(NSSet *)values;
- (void)removeCEventScores:(NSSet *)values;

- (void)addCompetitorsObject:(Competitor *)value;
- (void)removeCompetitorsObject:(Competitor *)value;
- (void)addCompetitors:(NSSet *)values;
- (void)removeCompetitors:(NSSet *)values;

@end
