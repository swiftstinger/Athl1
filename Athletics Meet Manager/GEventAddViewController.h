//
//  GEventAddViewController.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 29/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Meet.h"

@interface GEventAddViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *gEventName;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gEventType;

- (IBAction)maxCompStepperValueChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *maxCompPerTeamLabel;
@property (weak, nonatomic) IBOutlet UIStepper *maxCompPerTeamStepper;


- (IBAction)maxScoringCompStepperValueChanged:(UIStepper *)sender;

@property (weak, nonatomic) IBOutlet UILabel *maxScoringCompLabel;
@property (weak, nonatomic) IBOutlet UIStepper *maxScoringCompStepper;



- (IBAction)scoreForFirstStepperValueChanged:(UIStepper *)sender;

@property (weak, nonatomic) IBOutlet UILabel *scoreForFirstLabel;
@property (weak, nonatomic) IBOutlet UIStepper *scoreForFirstStepper;



- (IBAction)scoreMultiplierStepperValueChanged:(UIStepper *)sender;

@property (weak, nonatomic) IBOutlet UILabel *scoreMultiplierLabel;
@property (weak, nonatomic) IBOutlet UIStepper *scoreMultiplierStepper;



- (IBAction)reductionPerPlaceStepperValueChanged:(UIStepper *)sender;

@property (weak, nonatomic) IBOutlet UILabel *reductionPerPlaceLabel;
@property (weak, nonatomic) IBOutlet UIStepper *reductionPerPlaceStepper;








- (IBAction)gEventTypeSelecterValueChanged:(id)sender;

@property (weak, nonatomic) NSString* gEventTypeValue;

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) Meet* meetObject;
@property BOOL isEditing;
@property BOOL isOnTextField;



@end
