//
//  EventForCAddViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 02/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventForCAddViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate>
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property BOOL isEditing;
@property BOOL isOnTextField;


@property Event* event;

@end