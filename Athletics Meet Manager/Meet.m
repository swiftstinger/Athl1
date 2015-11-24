//
//  Meet.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 24/11/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "Meet.h"
#import "BackupCEventScore.h"
#import "BackupCompetitor.h"
#import "BackupEvent.h"
#import "CEventScore.h"
#import "Competitor.h"
#import "Division.h"
#import "Event.h"
#import "GEvent.h"
#import "Team.h"


@implementation Meet

@dynamic cEventLimit;
@dynamic competitorPerTeam;
@dynamic decrementPerPlace;
@dynamic divsDone;
@dynamic editDone;
@dynamic edited;
@dynamic eventsDone;
@dynamic isOwner;
@dynamic maxScoringCompetitors;
@dynamic meetDate;
@dynamic meetEndTime;
@dynamic meetID;
@dynamic meetName;
@dynamic meetStartTime;
@dynamic onlineID;
@dynamic onlineMeet;
@dynamic scoreForFirstPlace;
@dynamic scoreMultiplier;
@dynamic teamsDone;
@dynamic updateByUser;
@dynamic updateDateAndTime;
@dynamic backupCEventScores;
@dynamic backupCompetitors;
@dynamic backupEvents;
@dynamic cEventsScores;
@dynamic competitors;
@dynamic divisions;
@dynamic events;
@dynamic gEvents;
@dynamic teams;

@end
