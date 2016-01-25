//
//  EditRelayDiscViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 18/01/2016.
//  Copyright (c) 2016 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface EditRelayDiscViewController : UITableViewController
<NSFetchedResultsControllerDelegate, UITextFieldDelegate>


@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextField *textfield;

@end
