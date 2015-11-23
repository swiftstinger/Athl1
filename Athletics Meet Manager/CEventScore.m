//
//  CEventScore.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 21/11/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "CEventScore.h"
#import "Competitor.h"
#import "Event.h"
#import "Meet.h"
#import "Team.h"
#import "GEvent.h"

@implementation CEventScore

@dynamic cEventScoreID;
@dynamic editDone;
@dynamic edited;
@dynamic highJumpPlacingManual;
@dynamic onlineID;
@dynamic personalBest;
@dynamic placing;
@dynamic result;
@dynamic resultEntered;
@dynamic score;
@dynamic updateByUser;
@dynamic updateDateAndTime;
@dynamic competitor;
@dynamic event;
@dynamic meet;
@dynamic team;

- (void)willSave
{
    [super willSave];

    if (self.isDeleted)
        return;
    if (![self.event.gEvent.gEventType isEqualToString:@"Relay"]) {
        if (self.competitor.count == 0)
            [self.managedObjectContext deleteObject:self];
    }
    
}

@end
