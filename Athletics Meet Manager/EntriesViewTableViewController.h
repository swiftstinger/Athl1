//
//  EntriesViewTableViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 18/01/2016.
//  Copyright (c) 2016 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "EventScoreAddViewController.h"
#import "EditRelayDiscViewController.h"
#import "Event.h"
#import "CEventScore.h"

@interface EntriesViewTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) CEventScore* cScoreItem;
@property (strong, nonatomic) Event* eventObject;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editRelayDiscButton;

@end
