//
//  DivAddViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface DivAddViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *divName;
@property (strong, nonatomic) id detailItem;

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property BOOL isEditing;
@property BOOL isOnTextField;


@end
