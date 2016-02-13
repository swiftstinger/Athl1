//
//  EventScoreAddViewController.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 03/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Competitor.h"
#import "Event.h"
#import "Team.h"

@interface EventScoreAddViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Team* teamObject;
@property (strong, nonatomic) Competitor* competitorObject;
@property (strong, nonatomic) Event* eventObject;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *SkipCancel;
- (IBAction)SkipCancel:(UIBarButtonItem *)sender;


@end
