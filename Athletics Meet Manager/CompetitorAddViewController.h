//
//  CompetitorAddViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 02/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CompetitorAddViewController : UITableViewController  <NSFetchedResultsControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *competitorName;

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property BOOL isEditing;
@property BOOL isOnTextField;


@end
