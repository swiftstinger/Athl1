//
//  Competitor.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 30/07/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CEventScore, Meet, Team;

@interface Competitor : NSManagedObject

@property (nonatomic, retain) NSNumber * compID;
@property (nonatomic, retain) NSString * compName;
@property (nonatomic, retain) NSString * teamName;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) NSString * onlineID;
@property (nonatomic, retain) NSSet *cEventScores;
@property (nonatomic, retain) Meet *meet;
@property (nonatomic, retain) Team *team;
@end

@interface Competitor (CoreDataGeneratedAccessors)

- (void)addCEventScoresObject:(CEventScore *)value;
- (void)removeCEventScoresObject:(CEventScore *)value;
- (void)addCEventScores:(NSSet *)values;
- (void)removeCEventScores:(NSSet *)values;

@end
