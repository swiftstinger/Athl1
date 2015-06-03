//
//  SetupCompetitorsViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 02/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TeamAddViewController.h"
#import "Meet.h"

@interface SetupCompetitorsViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id detailItem;


@end
