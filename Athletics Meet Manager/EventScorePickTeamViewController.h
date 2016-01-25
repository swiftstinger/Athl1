//
//  EventScorePickTeamViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 18/01/2016.
//  Copyright (c) 2016 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Meet.h"
#import "Team.h"
#import "Event.h"

@interface EventScorePickTeamViewController :UITableViewController  <NSFetchedResultsControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Meet* meet;
@property (strong, nonatomic) Event* event;
@property (strong, nonatomic) Team* teamSelected;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property BOOL isOnTextField;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerRelay;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerNorm;

@property (weak, nonatomic) IBOutlet UITextField *relayDisc;

@property (strong, nonatomic) NSString* relayDiscString;




@end
