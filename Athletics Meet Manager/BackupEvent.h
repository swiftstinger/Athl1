//
//  BackupEvent.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 24/11/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BackupCEventScore, BackupCompetitor, Division, GEvent, Meet;

@interface BackupEvent : NSManagedObject

@property (nonatomic, retain) NSDate * backupDate;
@property (nonatomic, retain) NSNumber * editDone;
@property (nonatomic, retain) NSNumber * edited;
@property (nonatomic, retain) NSNumber * eventDone;
@property (nonatomic, retain) NSNumber * eventEdited;
@property (nonatomic, retain) NSNumber * eventID;
@property (nonatomic, retain) NSString * onlineID;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) NSSet *backupCEventScores;
@property (nonatomic, retain) NSSet *backupCompetitor;
@property (nonatomic, retain) Division *division;
@property (nonatomic, retain) GEvent *gEvent;
@property (nonatomic, retain) Meet *meet;
@end

@interface BackupEvent (CoreDataGeneratedAccessors)

- (void)addBackupCEventScoresObject:(BackupCEventScore *)value;
- (void)removeBackupCEventScoresObject:(BackupCEventScore *)value;
- (void)addBackupCEventScores:(NSSet *)values;
- (void)removeBackupCEventScores:(NSSet *)values;

- (void)addBackupCompetitorObject:(BackupCompetitor *)value;
- (void)removeBackupCompetitorObject:(BackupCompetitor *)value;
- (void)addBackupCompetitor:(NSSet *)values;
- (void)removeBackupCompetitor:(NSSet *)values;

@end
