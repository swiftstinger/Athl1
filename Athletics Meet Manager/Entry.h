//
//  Entry.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 25/01/2016.
//  Copyright (c) 2016 rudi huysamen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CEventScore, Competitor, Meet;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSNumber * entryID;
@property (nonatomic, retain) NSNumber * editDone;
@property (nonatomic, retain) NSNumber * edited;
@property (nonatomic, retain) NSString * onlineID;
@property (nonatomic, retain) NSString * updateByUser;
@property (nonatomic, retain) NSDate * updateDateAndTime;
@property (nonatomic, retain) Competitor *competitor;
@property (nonatomic, retain) CEventScore *cEventScore;
@property (nonatomic, retain) Meet *meet;

@end
