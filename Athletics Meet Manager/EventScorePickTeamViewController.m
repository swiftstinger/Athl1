//
//  EventScorePickTeamViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 18/01/2016.
//  Copyright (c) 2016 rudi huysamen. All rights reserved.
//

#import "EventScorePickTeamViewController.h"
#import "EventScoreAddViewController.h"
#import "GEvent.h"

@interface EventScorePickTeamViewController ()
@property (nonatomic, assign) id currentResponder;
@end

@implementation EventScorePickTeamViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.editing = false;
    self.isOnTextField = false;
    
    
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{

   if (_detailItem != newDetailItem) {

       _detailItem = newDetailItem;
       self.event = (Event*)_detailItem;
       self.meet = self.event.meet;
    //   self.isEditing = TRUE;
      
      [self configureView];
    }
}
#pragma mark - Managing the managedobjectcontext item

- (void)setManagedObjectContext:(NSManagedObjectContext *)newcontext
{
    if (self.managedObjectContext != newcontext) {
        _managedObjectContext = newcontext;
        
    }
}

- (void)configureView
{

    // Update the user interface for the detail item.
    if (self.editing) {
    
        //  _competitorName.text = [_detailItem valueForKey:@"compName"];
      
      
   }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   //[self.competitorName becomeFirstResponder];
   if ([self.event.gEvent.gEventType isEqualToString:@"Relay"]) {
        self.pickerRelay.dataSource = self;
        self.pickerRelay.delegate = self;
    }
    else
    {
        self.pickerNorm.dataSource = self;
        self.pickerNorm.delegate = self;
    
    }
    
    [_relayDisc setDelegate:self];
    
UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Fetched results controllers

- (NSFetchedResultsController *) fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
     // limit to those entities that belong to the particular item
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(meet == %@)", self.meet];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"teamID" ascending:YES];
   NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
	  //  abort();
	}
    
    return _fetchedResultsController;
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
 
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
     
    return [[[self fetchedResultsController] fetchedObjects] count];
     
    
}
// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    NSManagedObject *team = [[[self fetchedResultsController] fetchedObjects] objectAtIndex:row];
    NSString *name = (NSString *)[team valueForKey:@"teamName"];
    return name;
         
         
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    // nslog(@"close keyboard?");
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
    self.isOnTextField = true;
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
    if (_isOnTextField) {
      self.isOnTextField = false;
      [self.currentResponder resignFirstResponder];
    }
}
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   
    
    if ([identifier isEqualToString:@"unwindToEventScoreSheetDone"]) {
        
         NSInteger row = [self.pickerRelay selectedRowInComponent:0];
      
        self.teamSelected= [[[self fetchedResultsController] fetchedObjects] objectAtIndex:row];
        NSLog(@"team selected for relay %@", self.teamSelected.teamName);
        
        
        
        int limitperteam = [self.event.gEvent.competitorsPerTeam intValue ];
        if (limitperteam != 0) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        NSEntityDescription *description = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];


            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(team == %@)", self.teamSelected];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(event == %@)", self.event];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];


            NSError *err;
            NSUInteger eventscorecount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&err];
        
        
            if(eventscorecount == NSNotFound) {
                //Handle error
            }
        
    
    
    
    
        int currentEventNumber = (int)eventscorecount ;
        

        
        
            
                    if (!(limitperteam>currentEventNumber)) {
    
               dispatch_async(dispatch_get_main_queue(), ^{


                
                UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"Too many entries from chosen team in Event"
                                    message:@"Please delete an entry from this team for this event, pick a different team or change the number of entries allowed per event"
                                    preferredStyle:UIAlertControllerStyleAlert];
     
     
                UIAlertAction* ok = [UIAlertAction
                        actionWithTitle:@"OK"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                             
                        }];
                        
                [alert addAction:ok];
     
                [self presentViewController:alert animated:YES completion:nil];
                
              

                });
                
                return NO;
                }
                
            }
   
    }
    if ([identifier isEqualToString:@"pickCompNorm"]) {
        
         NSInteger row = [self.pickerNorm selectedRowInComponent:0];
      
        self.teamSelected= [[[self fetchedResultsController] fetchedObjects] objectAtIndex:row];
        
        
        int limitperteam = [self.event.gEvent.competitorsPerTeam intValue ];
        if (limitperteam != 0) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        NSEntityDescription *description = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];


            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(team == %@)", self.teamSelected];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(event == %@)", self.event];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];


            NSError *err;
            NSUInteger eventscorecount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&err];
        
        
            if(eventscorecount == NSNotFound) {
                //Handle error
            }
        
    
    
    
    
        int currentEventNumber = (int)eventscorecount ;
        

        
        
            
                    if (!(limitperteam>currentEventNumber)) {
    
               dispatch_async(dispatch_get_main_queue(), ^{


                
                UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"Too many entries from chosen team in Event"
                                    message:@"Please delete an entry from this team for this event, pick a different team or change the number of entries allowed per event"
                                    preferredStyle:UIAlertControllerStyleAlert];
     
     
                UIAlertAction* ok = [UIAlertAction
                        actionWithTitle:@"OK"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            [alert dismissViewControllerAnimated:YES completion:nil];
                             
                        }];
                        
                [alert addAction:ok];
     
                [self presentViewController:alert animated:YES completion:nil];
                
              

                });
                
                return NO;
                }
                
            }
   
    }

    return YES;              
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

   
    if ([[segue identifier] isEqualToString:@"pickCompNorm"]) {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        EventScoreAddViewController* eventScoreAddController = (EventScoreAddViewController*)[navController topViewController];
        
        [eventScoreAddController setEventObject:self.event];
        [eventScoreAddController setTeamObject:self.teamSelected];
         // nslog(@"not added context");
        [eventScoreAddController setManagedObjectContext:self.managedObjectContext];
    }
 
    
    
}






@end

