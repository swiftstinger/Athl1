//
//  Event.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 10/08/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "Event.h"
#import "CEventScore.h"
#import "Division.h"
#import "GEvent.h"
#import "Meet.h"


@implementation Event

@dynamic eventDone;
@dynamic eventEdited;
@dynamic eventID;
@dynamic startTime;
@dynamic updateByUser;
@dynamic updateDateAndTime;
@dynamic onlineID;
@dynamic editDone;
@dynamic edited;
@dynamic cEventScores;
@dynamic division;
@dynamic gEvent;
@dynamic meet;

- (void) awakeFromInsert
{
[super awakeFromInsert];
[self setValue:[NSDate date] forKey:@"updateDateAndTime"];
}

@end
