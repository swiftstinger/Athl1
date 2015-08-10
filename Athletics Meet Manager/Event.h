//
//  Event.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 10/08/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CEventScore, Division, GEvent, Meet;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * eventDone;
@property (nonatomic, retain) NSNumber * eventEdited;
@property (nonatomic, retain) NSNumber * eventID;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) NSString * onlineID;
@property (nonatomic, retain) NSNumber * editDone;
@property (nonatomic, retain) NSNumber * edited;
@property (nonatomic, retain) NSSet *cEventScores;
@property (nonatomic, retain) Division *division;
@property (nonatomic, retain) GEvent *gEvent;
@property (nonatomic, retain) Meet *meet;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addCEventScoresObject:(CEventScore *)value;
- (void)removeCEventScoresObject:(CEventScore *)value;
- (void)addCEventScores:(NSSet *)values;
- (void)removeCEventScores:(NSSet *)values;

@end
