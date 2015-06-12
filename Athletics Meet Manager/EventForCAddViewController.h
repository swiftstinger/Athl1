//
//  EventForCAddViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 02/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Competitor.h"
#import "Meet.h"
#import "Event.h"
#import "GEvent.h"
#import "Division.h"
#import "Team.h"

@interface EventForCAddViewController : UITableViewController <NSFetchedResultsControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) NSFetchedResultsController *divFetchedResultsController;
@property (strong, nonatomic) NSFetchedResultsController *gEventFetchedResultsController;

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Competitor* competitorItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//@property BOOL isEditing;
//@property BOOL isOnTextField;


@property Meet* meet;
@property Event* event;
@property GEvent* gevent;
@property Division* division;
@property Competitor* competitorObject;
@property (weak, nonatomic) IBOutlet UIPickerView *divPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *eventPicker;

#define divpicker 0
#define eventpicker 1



@end
