//
//  FinalResultsViewController.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "Meet.h"

@interface FinalResultsViewController : UITableViewController <NSFetchedResultsControllerDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Meet* meetObject;

@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;


@end
