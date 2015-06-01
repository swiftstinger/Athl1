//
//  GEventAddViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 29/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface GEventAddViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *gEventName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gEventType;
@property (weak, nonatomic) IBOutlet UILabel *maxCompPerTeamLabel;
@property (weak, nonatomic) IBOutlet UIStepper *maxCompStepper;

- (IBAction)maxCompStepperValueChanged:(id)sender;
- (IBAction)gEventTypeSelecterValueChanged:(id)sender;

@property (weak, nonatomic) NSString* gEventTypeValue;


@end
