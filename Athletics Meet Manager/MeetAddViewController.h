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

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UITextField *meetName;

@property (weak, nonatomic) IBOutlet UIDatePicker *meetDate;


- (IBAction)cEventLimitStepperValueChanged:(UIStepper *)sender;

@property (weak, nonatomic) IBOutlet UIStepper *ceventLimitStepper;
@property (weak, nonatomic) IBOutlet UILabel *cEventLimitLabel;



@end
