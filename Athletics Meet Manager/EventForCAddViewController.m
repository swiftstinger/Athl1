//
//  EventForCAddViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 02/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "EventForCAddViewController.h"
#import "CEventScore.h"
#import "Team.h"

@interface EventForCAddViewController ()


 // @property (strong, nonatomic)  NSArray *divPickerData;
 // @property  (strong, nonatomic) NSArray *eventPickerData;

@end



@implementation EventForCAddViewController

- (void)awakeFromNib {
    [super awakeFromNib];
  //  self.editing = false;
  //  self.isOnTextField = false;
    
    
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{

   if (_detailItem != newDetailItem) {

       // _detailItem = newDetailItem;
      //  self.isEditing = TRUE;
      
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
- (void)setCompetitorItem:(Competitor*)newCompetitorItem
{

   if (_competitorItem != newCompetitorItem) {

        _competitorItem = newCompetitorItem;
       self.competitorObject = _competitorItem;
     
      
    }
}


- (void)configureView
{

    // Update the user interface for the detail item.
    if (self.editing) {
      //_competitorName.text = [_detailItem valueForKey:@"competitorName"];
      
      
   }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.divPicker.dataSource = self;
    self.divPicker.delegate = self;
   
   self.eventPicker.dataSource = self;
    self.eventPicker.delegate = self;
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Fetched results controllers

- (NSFetchedResultsController *) divFetchedResultsController
{
    if (_divFetchedResultsController != nil) {
        return _divFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Division" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
     // limit to those entities that belong to the particular item
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(meet == %@)", self.competitorObject.meet];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"divID" ascending:YES];
   NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.divFetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.divFetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _divFetchedResultsController;
}


- (NSFetchedResultsController *) gEventFetchedResultsController
{
    if (_gEventFetchedResultsController != nil) {
        return _gEventFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GEvent" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
     // limit to those entities that belong to the particular item
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(meet == %@)", self.competitorObject.meet];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"gEventID" ascending:YES];
   NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.gEventFetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.gEventFetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _gEventFetchedResultsController;
}

- (Event *) selectedEvent
{
    
   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
   
     // limit to those entities that belong to the particular item
    NSLog(@"division: %@  gEvents %@", self.division.divName, self.gevent.gEventName);
    
NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(division == %@)",self.division];
NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(gEvent == %@)",self.gevent];
NSArray *preds = [NSArray arrayWithObjects:
   pred1,pred2, nil];
  NSPredicate *andPred = [NSCompoundPredicate 
   andPredicateWithSubpredicates:preds];

    [fetchRequest setPredicate:andPred];


    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"eventID" ascending:YES];
   NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
  
    NSError * error = nil;
  
	 NSArray *fetchedObjects;
    fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    if([fetchedObjects count] == 1)
    return [fetchedObjects objectAtIndex:0];
    else
    return nil;  

}


// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
 
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView.tag == divpicker)
     {
     
     
    return [[[self divFetchedResultsController] fetchedObjects] count];
     
       
     }
     else if(pickerView.tag == eventpicker)
     {
     
    
    return [[[self gEventFetchedResultsController] fetchedObjects] count];

     }
    return 0;
}
 
// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

if(pickerView.tag == divpicker)
     {
         
         NSManagedObject *div = [[[self divFetchedResultsController] fetchedObjects] objectAtIndex:row];
    NSString *name = (NSString *)[div valueForKey:@"divName"];
    return name;
         
         
     }
     else if(pickerView.tag == eventpicker)
     {
          NSManagedObject *gevent = [[[self gEventFetchedResultsController] fetchedObjects] objectAtIndex:row];
    NSString *name = (NSString *)[gevent valueForKey:@"gEventName"];
    return name;
    
     }
    return 0;
}
/*
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if(pickerView.tag == divpicker)
     {
     NSLog(@"divpicker");
       self.division =  [[[self divFetchedResultsController] fetchedObjects] objectAtIndex:row];

     }
     else if(pickerView.tag == eventpicker)
     {
     NSLog(@"eventpicker");
        self.gevent =   [[[self gEventFetchedResultsController] fetchedObjects] objectAtIndex:row];
        }
    
    
}

*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

    if ([[segue identifier] isEqualToString:@"unwindToSetupEventsForCDoneSegue"]) {
        
       
       
        
           }
    
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   
    
    if ([identifier isEqualToString:@"unwindToSetupEventsForCDoneSegue"]) {
        
        
        NSInteger divrow = [self.divPicker selectedRowInComponent:0];
      
        self.division = [[[self divFetchedResultsController] fetchedObjects] objectAtIndex:divrow];
       
      NSInteger eventrow = [self.eventPicker selectedRowInComponent:0];
        self.gevent = [[[self gEventFetchedResultsController] fetchedObjects] objectAtIndex:eventrow];
       
     

        self.event = [self selectedEvent];
        
        // check duplicate events
        
     /*

        if ([[self.competitorObject valueForKeyPath:@"c.name"] containsObject:cityName]) {
            // ...
        }
        
      */
       // self.competitorObject.cEventScores
        
        if ([[self.competitorObject valueForKeyPath:@"cEventScores.event"] containsObject:self.event]) {
            
            UIAlertController * alert =   [UIAlertController
                                    alertControllerWithTitle:@"This competitor is already in chosen event"
                                    message:@"Please pick a different event"
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
            return NO;
        }
        
        
        //check if too many people from this team involved
   
            Team *team = self.competitorObject.team;
            int limitperteam = [self.gevent.competitorsPerTeam intValue ];
     if (limitperteam != 0) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        NSEntityDescription *description = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];


            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(team == %@)", team];
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
    
               
                
                UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"Too many competitors from this team in Event"
                                    message:@"Please delete a competitor from this event, pick a different event or change the number of competitors allowed per event"
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
                return NO;
                    }
                
            }
        
   
        
    }
    
   
    
    
    
    return YES;              
}



@end
