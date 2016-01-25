//
//  Team.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 24/11/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BackupCEventScore, BackupCompetitor, CEventScore, Competitor, Meet;

@interface Team : NSManagedObject

@property (nonatomic, retain) NSNumber * editDone;
@property (nonatomic, retain) NSNumber * edited;
@property (nonatomic, retain) NSString * onlineID;
@property (nonatomic, retain) NSString * teamAbr;
@property (nonatomic, retain) NSNumber * teamID;
@property (nonatomic, retain) NSString * teamName;
@property (nonatomic, retain) NSNumber * teamPlace;
@property (nonatomic, retain) NSNumber * teamScore;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) NSSet *backupCEventScores;
@property (nonatomic, retain) NSSet *backupCompetitors;
@property (nonatomic, retain) NSSet *cEventScores;
@property (nonatomic, retain) NSSet *competitors;
@property (nonatomic, retain) Meet *meet;
@end

@interface Team (CoreDataGeneratedAccessors)

- (void)addBackupCEventScoresObject:(BackupCEventScore *)value;
- (void)removeBackupCEventScoresObject:(BackupCEventScore *)value;
- (void)addBackupCEventScores:(NSSet *)values;
- (void)removeBackupCEventScores:(NSSet *)values;

- (void)addBackupCompetitorsObject:(BackupCompetitor *)value;
- (void)removeBackupCompetitorsObject:(BackupCompetitor *)value;
- (void)addBackupCompetitors:(NSSet *)values;
- (void)removeBackupCompetitors:(NSSet *)values;

- (void)addCEventScoresObject:(CEventScore *)value;
- (void)removeCEventScoresObject:(CEventScore *)value;
- (void)addCEventScores:(NSSet *)values;
- (void)removeCEventScores:(NSSet *)values;

- (void)addCompetitorsObject:(Competitor *)value;
- (void)removeCompetitorsObject:(Competitor *)value;
- (void)addCompetitors:(NSSet *)values;
- (void)removeCompetitors:(NSSet *)values;

@end
