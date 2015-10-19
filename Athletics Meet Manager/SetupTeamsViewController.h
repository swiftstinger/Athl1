//
//  SetupTeamsViewController.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TeamAddViewController.h"
#import "Meet.h"

@interface SetupTeamsViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Meet* meetObject;
- (IBAction)longPressRecognizer:(UILongPressGestureRecognizer *)sender;

 
@property (weak, nonatomic) NSIndexPath * indexPathForLongPressCell;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *importButton;
- (IBAction)importButtonPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exportButton;
- (IBAction)exportButtonPressed:(UIBarButtonItem *)sender;

@end
