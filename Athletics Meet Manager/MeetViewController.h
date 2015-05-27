//
//  DetailViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 22/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface MeetViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UITableView *TestLabel;

@end

