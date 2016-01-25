//
//  Division.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 24/11/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BackupEvent, Event, Meet;

@interface Division : NSManagedObject

@property (nonatomic, retain) NSNumber * divID;
@property (nonatomic, retain) NSString * divName;
@property (nonatomic, retain) NSNumber * editDone;
@property (nonatomic, retain) NSNumber * edited;
@property (nonatomic, retain) NSString * onlineID;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) NSSet *backupEvents;
@property (nonatomic, retain) NSSet *events;
@property (nonatomic, retain) Meet *meet;
@end

@interface Division (CoreDataGeneratedAccessors)

- (void)addBackupEventsObject:(BackupEvent *)value;
- (void)removeBackupEventsObject:(BackupEvent *)value;
- (void)addBackupEvents:(NSSet *)values;
- (void)removeBackupEvents:(NSSet *)values;

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
