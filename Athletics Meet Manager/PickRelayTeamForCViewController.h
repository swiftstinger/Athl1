//
//  PickRelayTeamForCViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 03/02/2016.
//  Copyright (c) 2016 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EventForCAddViewController.h"
#import "Competitor.h"
#import "Event.h"
#import "CEventScore.h"


@interface PickRelayTeamForCViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Competitor* competitorObject;
@property (strong, nonatomic) Event* eventObject;
@property (strong, nonatomic) CEventScore* cEventScoreSelected;
@property Meet* meet;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end
