//
//  BackupCEventScore.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 24/11/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BackupCompetitor, BackupEvent, Meet, Team;

@interface BackupCEventScore : NSManagedObject

@property (nonatomic, retain) NSNumber * cEventScoreID;
@property (nonatomic, retain) NSNumber * editDone;
@property (nonatomic, retain) NSNumber * edited;
@property (nonatomic, retain) NSNumber * highJumpPlacingManual;
@property (nonatomic, retain) NSString * onlineID;
@property (nonatomic, retain) NSNumber * personalBest;
@property (nonatomic, retain) NSNumber * placing;
@property (nonatomic, retain) NSNumber * result;
@property (nonatomic, retain) NSNumber * resultEntered;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) BackupCompetitor *backupCompetitor;
@property (nonatomic, retain) BackupEvent *backupEvent;
@property (nonatomic, retain) Meet *meet;
@property (nonatomic, retain) Team *team;

@end
