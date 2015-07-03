//
//  MeetAddViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 27/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface MeetAddViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) id detailItem;

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *meetName;

@property (weak, nonatomic) IBOutlet UIDatePicker *meetDate;


- (IBAction)cEventLimitStepperValueChanged:(UIStepper *)sender;

@property (weak, nonatomic) IBOutlet UIStepper *ceventLimitStepper;
@property (weak, nonatomic) IBOutlet UILabel *cEventLimitLabel;


- (IBAction)maxCompPerTeamStepperValueChanged:(UIStepper *)sender;

@property (weak, nonatomic) IBOutlet UILabel *maxCompPerTeamLabel;
@property (weak, nonatomic) IBOutlet UIStepper *maxCompPerTeamStepper;


- (IBAction)maxScoringCompPerTeamStepperValueChanged:(UIStepper *)sender;

@property (weak, nonatomic) IBOutlet UILabel *maxScoringCompPerTeamLabel;
@property (weak, nonatomic) IBOutlet UIStepper *maxScoringCompPerTeamStepper;


- (IBAction)firstPlaceScoreStepperValueChanged:(UIStepper *)sender;

@property (weak, nonatomic) IBOutlet UILabel *firstPlaceScoreLabel;
@property (weak, nonatomic) IBOutlet UIStepper *firstPlaceScoreStepper;


- (IBAction)reductionPerPlaceStepperValueChanged:(UIStepper *)sender;

@property (weak, nonatomic) IBOutlet UILabel *reductionPerPlaceLabel;
@property (weak, nonatomic) IBOutlet UIStepper *reductionPerPlaceStepper;


- (IBAction)scoreMultiplierStepperValueChanged:(UIStepper *)sender;

@property (weak, nonatomic) IBOutlet UILabel *scoreMultiplierLabel;
@property (weak, nonatomic) IBOutlet UIStepper *scoreMultiplierStepper;


@property BOOL isEditing;
@property BOOL isOnTextField;

@end
