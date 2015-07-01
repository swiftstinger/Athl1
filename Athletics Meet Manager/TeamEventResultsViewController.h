//
//  TeamEventResultsViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 28/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Division.h"
#import "Team.h"


@interface TeamEventResultsViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) id teamDetailItem;
@property (strong, nonatomic) Team* teamObject;
@property (strong, nonatomic) Division* divObject;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;


@end
