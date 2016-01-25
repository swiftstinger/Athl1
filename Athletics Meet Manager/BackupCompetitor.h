//
//  BackupCompetitor.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 20/01/2016.
//  Copyright (c) 2016 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BackupCEventScore, BackupEntry, BackupEvent, Meet, Team;

@interface BackupCompetitor : NSManagedObject

@property (nonatomic, retain) NSNumber * compID;
@property (nonatomic, retain) NSString * compName;
@property (nonatomic, retain) NSNumber * editDone;
@property (nonatomic, retain) NSNumber * edited;
@property (nonatomic, retain) NSString * onlineID;
@property (nonatomic, retain) NSString * teamName;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) NSSet *backupCEventScores;
@property (nonatomic, retain) BackupEvent *backupEvent;
@property (nonatomic, retain) Meet *meet;
@property (nonatomic, retain) Team *team;
@property (nonatomic, retain) NSSet *backupEntries;
@end

@interface BackupCompetitor (CoreDataGeneratedAccessors)

- (void)addBackupCEventScoresObject:(BackupCEventScore *)value;
- (void)removeBackupCEventScoresObject:(BackupCEventScore *)value;
- (void)addBackupCEventScores:(NSSet *)values;
- (void)removeBackupCEventScores:(NSSet *)values;

- (void)addBackupEntriesObject:(BackupEntry *)value;
- (void)removeBackupEntriesObject:(BackupEntry *)value;
- (void)addBackupEntries:(NSSet *)values;
- (void)removeBackupEntries:(NSSet *)values;

@end
