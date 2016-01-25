//
//  BackupEntry.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 25/01/2016.
//  Copyright (c) 2016 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BackupCEventScore, BackupCompetitor, Meet;

@interface BackupEntry : NSManagedObject

@property (nonatomic, retain) NSNumber * editDone;
@property (nonatomic, retain) NSNumber * edited;
@property (nonatomic, retain) NSNumber * entryID;
@property (nonatomic, retain) NSString * onlineID;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) BackupCompetitor *backupCompetitor;
@property (nonatomic, retain) BackupCEventScore *backupCEventScore;
@property (nonatomic, retain) Meet *meet;

@end
