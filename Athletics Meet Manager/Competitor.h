//
//  Competitor.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 30/01/2016.
//  Copyright (c) 2016 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CEventScore, Entry, Meet, Team;

@interface Competitor : NSManagedObject

@property (nonatomic, retain) NSNumber * compID;
@property (nonatomic, retain) NSString * compName;
@property (nonatomic, retain) NSNumber * editDone;
@property (nonatomic, retain) NSNumber * edited;
@property (nonatomic, retain) NSString * onlineID;
@property (nonatomic, retain) NSString * teamName;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) NSSet *cEventScores;
@property (nonatomic, retain) Meet *meet;
@property (nonatomic, retain) Team *team;
@property (nonatomic, retain) NSSet *entries;
@end

@interface Competitor (CoreDataGeneratedAccessors)

- (void)addCEventScoresObject:(CEventScore *)value;
- (void)removeCEventScoresObject:(CEventScore *)value;
- (void)addCEventScores:(NSSet *)values;
- (void)removeCEventScores:(NSSet *)values;

- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

@end
