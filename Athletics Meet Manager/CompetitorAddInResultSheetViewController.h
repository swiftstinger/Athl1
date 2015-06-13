//
//  CompetitorAddInResultSheetViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 13/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Meet.h"
#import "Team.h"
#import "Event.h"

@interface CompetitorAddInResultSheetViewController : UITableViewController  <NSFetchedResultsControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *competitorName;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Meet* meet;
@property (strong, nonatomic) Event* event;
@property (strong, nonatomic) Team* team;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property BOOL isEditing;
@property BOOL isOnTextField;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end
