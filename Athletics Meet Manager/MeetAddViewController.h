//
//  MeetAddViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 27/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface MeetAddViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *meetName;

@property (weak, nonatomic) IBOutlet UILabel *meetID;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
