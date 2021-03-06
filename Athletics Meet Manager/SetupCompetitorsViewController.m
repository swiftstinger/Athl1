//
//  SetupCompetitorsViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 02/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "SetupCompetitorsViewController.h"
#import "CompetitorTableViewCell.h"
#import "Competitor.h"
#import "CEventScore.h"
#import "Event.h"
#import "GEvent.h"
#import "Division.h"
#import "Meet.h"
#import "AppDelegate.h"
#import "Entry.h"


@interface SetupCompetitorsViewController ()
@property BOOL newCScore;
@end

@implementation SetupCompetitorsViewController

#pragma mark - Managing the managedobjectcontext item

- (void)setManagedObjectContext:(NSManagedObjectContext *)newcontext
{
    if (_managedObjectContext != newcontext) {
        _managedObjectContext = newcontext;
       
    }
}

#pragma mark - Managing the detail item

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        _teamObject = _detailItem;
        // Update the view.
        NSLog(@"teamObjectname: %@", _teamObject.teamName);
        [self configureView];
        
       
        
    }
}



- (void)configureView
{

// nslog(@"in view");
    // Update the user interface for the detail item.
    if (self.teamObject) {
      
      _navBar.title = [self.teamObject valueForKey:@"teamName"];

    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
     if (appDelegate.csvDataArray != nil) {
         NSLog(@"importing csv");
         
         /// show button
         
         self.importButton.enabled = TRUE;
         
         
         

     }
     else
     {
        
            // hide button
            self.importButton.enabled = FALSE;
            NSLog(@"not importing");

     }
    

    
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (CompetitorTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompetitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CompetitorCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    BOOL var = YES;
    
    if ([self.teamObject.meet.onlineMeet boolValue]) {
            if (![self.teamObject.meet.isOwner boolValue]) {

                var = NO;
            }
          
        }
    
    
    return var;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
       
        
          context = [self checkBeforeDeleteCompObject: [self.fetchedResultsController objectAtIndexPath:indexPath] InContext:context];
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
           // abort();
        }
    }
}
- (NSManagedObjectContext*) checkBeforeDeleteCompObject: (Competitor*) comp InContext: (NSManagedObjectContext*) context

{

  
        


    if ([comp.entries count] > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"Confirm Delete"
                                    message:@"This Competitor has already been entered into one or more events. Deleting this Competitor will remove it from these events as well as remove any scores entered. This cannot be undone."
                                    preferredStyle:UIAlertControllerStyleAlert];
     
     
                UIAlertAction* delete = [UIAlertAction
                        actionWithTitle:@"DELETE"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                        
                            [context deleteObject:comp];
                            NSError *error = nil;
                                if (![context save:&error]) {
                                    // Replace this implementation with code to handle the error appropriately.
                                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                    // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
                                   // abort();
                                }

                            [alert dismissViewControllerAnimated:YES completion:nil];
                            
                             
                        }];
                        UIAlertAction* cancel = [UIAlertAction
                        actionWithTitle:@"CANCEL"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            [alert dismissViewControllerAnimated:YES completion:nil];
                            
                             
                        }];
    
                [alert addAction:delete];
                [alert addAction:cancel];
     
                [self presentViewController:alert animated:YES completion:nil];
        });
    }
    else
    {
        
                            
                        
                            [context deleteObject:comp];
    }



 return context;
}
#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    
   
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Competitor" inManagedObjectContext:self.managedObjectContext];
          [fetchRequest setEntity:entity];
     ;
     // limit to those entities that belong to the particular item
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(team == %@)", _teamObject];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"compID" ascending:YES];
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
	   // abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(CompetitorTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
          cell.competitorTitleLabel.text = [[object valueForKey:@"compName"] description];
    
        cell.numberOfEventsLabel.text = [NSString stringWithFormat:@"Events: %@",  @([[object valueForKey:@"entries"] count] )];
    
  }

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     
    if ([[segue identifier] isEqualToString:@"eventSetupForC"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    }
    
     if ([[segue identifier] isEqualToString:@"editCompetitor"]) {
        
       NSIndexPath *indexPath = self.indexPathForLongPressCell;
        
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
    CompetitorAddViewController* competitorAddController = (CompetitorAddViewController*)[navController topViewController];
        
        
        [competitorAddController setDetailItem:object];
       
        [competitorAddController setManagedObjectContext:self.managedObjectContext];
        
    }
    
}




#pragma mark - MeetAddViewControllerUnwinds

- (IBAction)unwindToSetupCompetitorsDone:(UIStoryboardSegue *)unwindSegue
{


    if ([unwindSegue.sourceViewController isKindOfClass:[CompetitorAddViewController class]])
    {
        // nslog(@"Coming from CompetitorAdd Done!");
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
        Competitor *competitor;
       
         CompetitorAddViewController *sourceViewController = unwindSegue.sourceViewController;
        
        
      if (!sourceViewController.editing) {

    
     competitor = [NSEntityDescription insertNewObjectForEntityForName:@"Competitor" inManagedObjectContext:context];
        }
        else
        {
        
        competitor = sourceViewController.detailItem;
        }
        
        ////////
        /////   set values
        ///////
     
           if (sourceViewController.competitorName) {
        [competitor setValue: sourceViewController.competitorName.text forKey:@"compName"];
    
        }
        
        if (!sourceViewController.editing) {
        
         //////
        // link relationships
        /////
        
       
        
       competitor.team = self.teamObject;
        
        
        [competitor setValue:_teamObject.meet forKey:@"meet"];
       
        [competitor setValue:_teamObject.teamName forKey:@"teamName"];

        
        //////
        
          // Store CompID data
 
     
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
  
     int tempint =  [_teamObject.meet.meetID intValue];
     
     NSString * keystring = [NSString stringWithFormat:@"%dlastCompID",tempint];  ////
     
     
     
     if (![defaults objectForKey:keystring]) {                    /////
     
     int idint = 0;
     NSNumber *idnumber = [NSNumber numberWithInt:idint];
     [defaults setObject:idnumber forKey:keystring];             ///////
     
     }
NSNumber *oldnumber = [defaults objectForKey:keystring];   ///
       int oldint = [oldnumber intValue];
       int newint = oldint + 1;
       NSNumber *newnumber = [NSNumber numberWithInt:newint];
       [competitor setValue: newnumber forKey: @"compID"];                  //////////
     

    [defaults setObject: newnumber forKey:keystring];            /////////
     
    [defaults synchronize];
  }
    ////
    
        
                NSError *error = nil;

        
        

        // Save the context.
        
            if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
        
    }
   
   

}
- (IBAction)unwindToSetupCompetitorsCancel:(UIStoryboardSegue *)unwindSegue
{

UIViewController* sourceViewController = unwindSegue.sourceViewController;

if ([sourceViewController isKindOfClass:[CompetitorAddViewController class]])
    {
        // nslog(@"Coming from CompetitorsAdd Cancel!");
    }
}




- (IBAction)longPressRecognizer:(UILongPressGestureRecognizer *)sender {

if (sender.state == UIGestureRecognizerStateBegan)
	{
		CGPoint location = [sender locationInView:self.tableView];
  self.indexPathForLongPressCell = [self.tableView indexPathForRowAtPoint:location];
        
        
		// nslog(@"Long-pressed cell at row %@", self.indexPathForLongPressCell);
        
        [self performSegueWithIdentifier:@"editCompetitor" sender:self];
	}

}

- (void)loadCSVArray {
NSLog(@"here");

AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

NSArray  *newArray = appDelegate.csvDataArray;
appDelegate.csvDataArray = nil;
self.importButton.enabled = FALSE;

 NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];

        for (NSString* stringWhole in newArray) {
                    NSLog(@"%@",stringWhole);
            
                        //create objects here
            
                    // nslog(@"Coming from CompetitorAdd Done!");
                    NSArray  *CArray =  [stringWhole componentsSeparatedByString:@","];
            
                
                    Competitor *competitor = [NSEntityDescription insertNewObjectForEntityForName:@"Competitor" inManagedObjectContext:context];
            
                    
                    ////////
                    /////   set values
                    ///////
                    if (CArray.count > 0) {
    
                      competitor.compName = CArray[0];
                    
                    }
                    int total = (int)CArray.count;
            
            
                     NSLog(@"xxxxxxxxxxxxxxxxxxx");
            
            
                    for (int i = 4; i<total; i = i + 4) {
                        
                        NSLog(@"1 : %d  %@", i-3, CArray[i-3]);
                        NSLog(@"2: %d  %@", i-2, CArray[i-2]);
                        NSLog(@"3: %d  %@", i-1, CArray[i-1]);
                        NSLog(@"4: %d  %@", i, CArray[i]);
                       
                        
                        NSString* entityname = @"Event";
                        NSError *error;
                        
                            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                            NSEntityDescription *entity = [NSEntityDescription entityForName: entityname inManagedObjectContext:self.managedObjectContext];
                            [fetchRequest setEntity:entity];
                            
                        NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"(meet == %@)", self.teamObject.meet];
                        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"(gEvent.gEventName == %@)", CArray[i-3]];
                        NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"(division.divName == %@)", CArray[i-2]];
                    
                    NSArray *preds = [NSArray arrayWithObjects: predicate1,predicate2, predicate3,  nil];
                    NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

                    [fetchRequest setPredicate:andPred];
                    
                        
                    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"eventID" ascending:YES];
                   NSArray *sortDescriptors = @[sortDescriptor];
                    
                    [fetchRequest setSortDescriptors:sortDescriptors];
    
                            
                    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                        
                            if (fetchedObjects.count > 0) {
    
                                Event* thisEvent = fetchedObjects[0];
                        
                        
                                            NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
                                
                                            CEventScore *ceventscore;
                                
                                            if ([thisEvent.gEvent.gEventType isEqualToString:@"Relay"]) {
                                            
                                                NSSet* cScoresSet = thisEvent.cEventScores;
                                                
                                                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"relayDisc == %@", CArray[i-1]];
                                                NSSet *filteredSet = [cScoresSet filteredSetUsingPredicate:predicate];
                                                
                                                ceventscore = [filteredSet anyObject];
                                                
                                                if (ceventscore != nil) {
                                                    
                                                    self.newCScore = NO;

                                                }
                                                else
                                                {
                                                    
                                                    ceventscore = [NSEntityDescription insertNewObjectForEntityForName:@"CEventScore" inManagedObjectContext:context];
                                                    
                                                    ceventscore.relayDisc = CArray[i-1];
                                                    
                                                    
                                                     self.newCScore = YES;

                                                
                                                }

                                            
                                            }
                                            else
                                            {
                                
                                                ceventscore = [NSEntityDescription insertNewObjectForEntityForName:@"CEventScore" inManagedObjectContext:context];
                                                self.newCScore = YES;
                                                    
                                            }
                                
                                            if (self.newCScore) {
 
                                                    ////
                                                            ////////
                                                            /////   set values
                                                            ///////
                                                        
                                                           [ceventscore setValue: nil forKey:@"result"];
                                                           [ceventscore setValue:nil forKey:@"personalBest"];
                                                           [ceventscore setValue:nil forKey:@"placing"];
                                                           [ceventscore setValue:nil forKey:@"score"];
                                                           [ceventscore setValue:nil forKey:@"resultEntered"];
                                                
                                                
                                                
                                        
                                                             //////
                                                            // link relationships
                                                            /////
                                                
                                                           
                                                           ceventscore.event = thisEvent;
                                                             
                                                
                                                             
                                                             thisEvent.eventEdited = [NSNumber numberWithBool:YES];

                                                
                                                
                                                
                                                            ceventscore.team = competitor.team;
                                                
                                                            ceventscore.meet = competitor.meet;
                                                
                                                           
                                                           
                                                            
                                                            //////
                                                            
                                                            
                                                            
                                                              // Store CscoreID data
                                                            //  if (!sourceViewController.editing) {
                                                          
                                                            
                                                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                                        
                                                         
                                                         int tempint =  [competitor.meet.meetID intValue];
                                                         
                                                         NSString * keystring = [NSString stringWithFormat:@"%dlastcEventScoreID",tempint];  ////
                                                         
                                                        
                                                         
                                                         if (![defaults objectForKey:keystring]) {                    /////
                                                         
                                                         int idint = 0;
                                                         NSNumber *idnumber = [NSNumber numberWithInt:idint];
                                                         [defaults setObject:idnumber forKey:keystring];             ///////
                                                         
                                                         }
                                                    NSNumber *oldnumber = [defaults objectForKey:keystring];   ///
                                                           int oldint = [oldnumber intValue];
                                                           int newint = oldint + 1;
                                                           NSNumber *newnumber = [NSNumber numberWithInt:newint];
                                                           [ceventscore setValue: newnumber forKey: @"cEventScoreID"];                  //////////
                                                          
                                                        [defaults setObject: newnumber forKey:keystring];            /////////
                                                         
                                                        [defaults synchronize];
                                                    // }
                                                        ////
                                                }
                                
                                                ceventscore.competitor = competitor;
                                
                                
                                                //////  Entry Add
            
                                
                                                Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:context];
                                                

                                                
                                                 //////
                                                // link relationships
                                                /////
                                                
                                               
                                                
                                                entry.competitor = competitor;
                                                entry.cEventScore = ceventscore;
                                                entry.meet = competitor.meet;
                                                
                                                
                                                
                                                //////
                                                
                                                         // Store entryID data

                                                
                                             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                            
                                             
                                             int tempint =  [competitor.meet.meetID intValue];
                                             
                                             NSString* keystring = [NSString stringWithFormat:@"%dlastentryID",tempint];  ////
                                             
                                             // nslog(@"%@",keystring);
                                             
                                             if (![defaults objectForKey:keystring]) {                    /////
                                             
                                             int idint = 0;
                                             NSNumber *idnumber = [NSNumber numberWithInt:idint];
                                             [defaults setObject:idnumber forKey:keystring];             ///////
                                             
                                             }
                                              NSNumber*  oldnumber = [defaults objectForKey:keystring];   ///
                                              int  oldint = [oldnumber intValue];
                                               int newint = oldint + 1;
                                               NSNumber* newnumber = [NSNumber numberWithInt:newint];
                                               entry.entryID = newnumber;                  //////////
                                               

                                            [defaults setObject: newnumber forKey:keystring];            /////////
                                             
                                            [defaults synchronize];
                                         
                                            ////
                                                 
                                
                                
                                            
                                                    NSError *error = nil;

                                            
                                            

                                            // Save the context.
                                            
                                                if (![context save:&error]) {
                                            // Replace this implementation with code to handle the error appropriately.
                                            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                                // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
                                                //abort();
                                                }
                       
                            }
                            else
                            {
                                NSLog(@"no event found for gEvent %@  div %@ ",CArray[i-3],CArray[i-2] );
                            }
                    }
                    
                    NSLog(@"xxxxxxxxxxxxxxxxxxx");
                    
                     //////
                    // link relationships
                    /////
                    
                   
                    
                   competitor.team = self.teamObject;
                    
                    
                    [competitor setValue:_teamObject.meet forKey:@"meet"];
                   
                    [competitor setValue:_teamObject.teamName forKey:@"teamName"];

                    
                    //////
                    
                      // Store CompID data
             
                 
                    
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
              
                 int tempint =  [_teamObject.meet.meetID intValue];
                 
                 NSString * keystring = [NSString stringWithFormat:@"%dlastCompID",tempint];  ////
                 
                 
                 
                 if (![defaults objectForKey:keystring]) {                    /////
                 
                 int idint = 0;
                 NSNumber *idnumber = [NSNumber numberWithInt:idint];
                 [defaults setObject:idnumber forKey:keystring];             ///////
                 
                 }
            NSNumber *oldnumber = [defaults objectForKey:keystring];   ///
                   int oldint = [oldnumber intValue];
                   int newint = oldint + 1;
                   NSNumber *newnumber = [NSNumber numberWithInt:newint];
                   [competitor setValue: newnumber forKey: @"compID"];                  //////////
                 

                [defaults setObject: newnumber forKey:keystring];            /////////
                 
                [defaults synchronize];
              
                ////

            
        }
    
    
    
    
         NSError *error = nil;

                    
                    

                    // Save the context.
                    
                        if (![context save:&error]) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                        // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
                        //abort();
                        }


}
- (IBAction)importButtonPressed:(UIBarButtonItem *)sender {
dispatch_async(dispatch_get_main_queue(), ^{
                
        UIAlertController * alert=   [UIAlertController
                            alertControllerWithTitle:@"Importing Competitors"
                            message:@"Competitors imported from csv file. \n\n First item in row will be treated as the Competitor Name. In every subsequent 4 items (as seperated by comma), the first two will be checked against Event and Division names. Competitor will be entered if both correspond to a valid Event. \n If the Event name Corresponds to a Relay Event, the next item will be treated as the Discription of a Relay team to enter the competitor into.\n If this discription does not match any current relay groups from this team in this event, a new one will be created and entered.\n The 4th Item is not currently used but necessary to maintain consistency  \n\n e.g. 'CompetitorName, Event1, Division1,,,Event2, Division2,,,RelayEvent3,Division3, ATeam,,Event4,Division4,,, ... Etc '\n\n These can later be edited by long pressing on the relavant competitor cell or adding/deleting events for the Competitor."
                            preferredStyle:UIAlertControllerStyleAlert];


        UIAlertAction* ok = [UIAlertAction
                actionWithTitle:@"OK"
                style:UIAlertActionStyleDefault
                handler:^(UIAlertAction * action)
                {
                    
                    [alert dismissViewControllerAnimated:YES completion:nil];
                    [self loadCSVArray];
               
                }];
                
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    });
}
- (IBAction)exportButtonPressed:(UIBarButtonItem *)sender {

NSMutableString *resultscsv = [NSMutableString stringWithString:@""];


/// fetch divisions
NSString* entityname = @"Competitor";
    NSError *error;
                        
                            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                            NSEntityDescription *entity = [NSEntityDescription
                    entityForName: entityname inManagedObjectContext:self.managedObjectContext];
                            [fetchRequest setEntity:entity];
                            
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(meet == %@)", self.teamObject.meet];
                    [fetchRequest setPredicate:predicate];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"compID" ascending:YES];
                   NSArray *sortDescriptors = @[sortDescriptor];
                    
                    [fetchRequest setSortDescriptors:sortDescriptors];
    
                            
                            NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

/// end fetch divisions

    for (Competitor* comp in fetchedObjects) {
        
        [resultscsv appendString:[NSString stringWithFormat:@"%@",comp.compName]];
        
        NSSet* entries= comp.entries;
        
        for (Entry* entry in entries) {
            NSString* geventname = entry.cEventScore.event.gEvent.gEventName;
            
            
            NSString* divname = entry.cEventScore.event.division.divName;
            
            if  ([entry.cEventScore.event.gEvent.gEventType isEqualToString:@"Relay"]&&(entry.cEventScore.relayDisc != nil))
            {
            
                [resultscsv appendString:[NSString stringWithFormat:@",%@,%@,%@,",geventname,divname,entry.cEventScore.relayDisc]];
                
            }
            else
            {
                [resultscsv appendString:[NSString stringWithFormat:@",%@,%@,,",geventname,divname]];
            }
            
        }
        
        [resultscsv appendString:[NSString stringWithFormat:@"\n"]];
        
    }

NSString *emailTitle = @"Export Competitors";
    
    NSString* subjectString = [NSString stringWithFormat:@"Competitors From Athletics Meet %@", self.teamObject.meet.meetName];
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Competitors From Athletics Meet %@ \n\n Can Be Imported Into Athletics Meet Manager IOS App. \n\n Long press csv file and choose 'Open in Athletics Meet Manager' to Import", self.teamObject.meet.meetName];
    // To address
    
    NSString* filename = [NSString stringWithFormat:@"%@_Competitors.csv", self.teamObject.meet.meetName];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setSubject:subjectString];
    
    [mc setMessageBody:messageBody isHTML:NO];
    
    [mc addAttachmentData:[resultscsv dataUsingEncoding:NSUTF8StringEncoding]
    
  //  [mailer addAttachmentData:[NSData dataWithContentsOfFile:@"PathToFile.csv"]
                     mimeType:@"text/csv" 
                     fileName:filename];
    
    
    // Present mail view controller on screen
    
    
    
    [self presentViewController:mc animated:YES completion:NULL];

}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{



dispatch_async(dispatch_get_main_queue(), ^{
UIAlertController * alert;
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
                     alert=   [UIAlertController
                                        alertControllerWithTitle:@"Export Cancelled"
                                        message:@"Export Via Email Cancelled By User"
                                        preferredStyle:UIAlertControllerStyleAlert];
     
     
                    UIAlertAction* ok = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                             
                            }];
                        
                    [alert addAction:ok];
     
                //    [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"Mail cancelled");
           
            break;
        }
        //
        case MFMailComposeResultSaved:
        {
                    alert=   [UIAlertController
                                        alertControllerWithTitle:@"Mail Saved"
                                        message:@"Email With Exported Item Names Saved For Later Sending"
                                        preferredStyle:UIAlertControllerStyleAlert];
     
     
                    UIAlertAction* ok = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                             
                            }];
                        
                    [alert addAction:ok];
     
              //      [self presentViewController:alert animated:YES completion:nil];

           NSLog(@"Mail saved");
            break;
        }
            
           
        case MFMailComposeResultSent:
        {
                     alert=   [UIAlertController
                                        alertControllerWithTitle:@"Export Successfull"
                                        message:@"Item Names Exported Via Email And Mail Sent Successfully"
                                        preferredStyle:UIAlertControllerStyleAlert];
     
     
                    UIAlertAction* ok = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                             
                            }];
                        
                    [alert addAction:ok];
     
             //       [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"Mail sent");
           
            break;
        }
            //
            
        case MFMailComposeResultFailed:
        {
                    alert=   [UIAlertController
                                        alertControllerWithTitle:@"Export Failed"
                                        message:@"Sending Mail Failed, Please Check Your Email Settings"
                                        preferredStyle:UIAlertControllerStyleAlert];
     
     
                    UIAlertAction* ok = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                             
                            }];
                        
                    [alert addAction:ok];
     
              //      [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
           
            break;
        }
         //
            
        default:
            break;
    }
    
    // Close the Mail Interface
        [self dismissViewControllerAnimated:YES completion:^{
            [self presentViewController:alert animated:YES completion:nil];
        }];
  
  });
    
 
}

@end
