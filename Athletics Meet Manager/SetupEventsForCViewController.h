//
//  SetupEventsForCViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 02/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EventForCAddViewController.h"
#import "Competitor.h"

@interface SetupEventsForCViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Competitor* competitorObject;

@property Meet* meet;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;


@end
