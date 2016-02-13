//
//  SetupEventsForCViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 02/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "SetupEventsForCViewController.h"
#import "EventForCTableViewCell.h"
#import "PickRelayTeamForCViewController.h"
#import "CEventScore.h"
#import "GEvent.h"
#import "Division.h"
#import "Event.h"
#import "Meet.h"
#import "Entry.h"


@interface SetupEventsForCViewController ()

@end

@implementation SetupEventsForCViewController

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
        _competitorObject = _detailItem;
        // Update the view.
        [self configureView];
        
       
        
    }
}



- (void)configureView
{


    // Update the user interface for the detail item.
    if (self.competitorObject) {
      
      _navBar.title = self.competitorObject.compName;

    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
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

- (EventForCTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventForCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventForCCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
           // abort();
        }
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
     // limit to those entities that belong to the particular item
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(competitor == %@)", self.competitorObject];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"entryID" ascending:YES];
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

- (void)configureCell:(EventForCTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    Entry *entry = (Entry*)object;
    
    CEventScore *ceventscore = entry.cEventScore;
  
     GEvent* gevent  = (GEvent*)ceventscore.event.gEvent;
   NSString *geventname = gevent.gEventName;
   Division* division  = (Division*)ceventscore.event.division;
   NSString *divisionname = division.divName;
   
   NSString *eventname = [NSString stringWithFormat:@"%@ %@", geventname, divisionname];

   
  cell.eventTitleLabel.text = eventname;

  }
#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    if ([[segue identifier] isEqualToString:@"showEventResult"]) {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
            Entry* entry = (Entry*) object;
        
        
              [[segue destinationViewController] setDetailItem:entry.cEventScore.event];
            [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
        }
    
    if ([[segue identifier] isEqualToString:@"addEventForC"]) {
    
    UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
    EventForCAddViewController* compAddController = (EventForCAddViewController*)[navController topViewController];

    
        [compAddController setCompetitorItem:self.competitorObject];
        [compAddController setManagedObjectContext:self.managedObjectContext];

    
    }
    
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   
    
    if ([identifier isEqualToString:@"addEventForC"]) {
        
        //checks
        
            self.meet = self.competitorObject.meet;
            int competitorEventLimit = [self.meet.cEventLimit intValue];
    
        int currentEventNumber = (int)[[self.competitorObject valueForKey:@"entries"] count] ;
            if (competitorEventLimit != 0) {
            
                    if (!(competitorEventLimit>currentEventNumber)) {
    
                // nslog(@"in shouldperformsegue no");
                dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"Too many Events For Competitor"
                                    message:@"Please delete an event or change the number of events allowed per competitor"
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


#pragma mark - SetupEventViewControllerUnwinds

- (IBAction)unwindToSetupEventsForCDone:(UIStoryboardSegue *)unwindSegue
{


    if ([unwindSegue.sourceViewController isKindOfClass:[EventForCAddViewController class]])
    {
        // nslog(@"Coming from EventsForCAdd Done!");
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
        CEventScore *ceventscore = [NSEntityDescription insertNewObjectForEntityForName:@"CEventScore" inManagedObjectContext:context];
        
        EventForCAddViewController *sourceViewController = unwindSegue.sourceViewController;
        
        
        //// Test
        
      //  // nslog(@"Gevent %@ Division %@ ",sourceViewController.event.gEvent.gEventName, sourceViewController.event.division.divName);

        
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
        if (sourceViewController.event) {
       
       
          Event* event = sourceViewController.event;
         
        [ceventscore setValue:event forKey:@"event"];
         
         event.eventEdited = [NSNumber numberWithBool:YES];

        }
        
            
        [ceventscore setValue:self.competitorObject forKey:@"competitor"];
        
         [ceventscore setValue:self.competitorObject.team forKey:@"team"];
        
        [ceventscore setValue:self.competitorObject.meet forKey:@"meet"];
       
       
        
        //////
        
        
        
          // Store EventID data
//  if (!sourceViewController.editing) {
      
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
     
     int tempint =  [self.competitorObject.meet.meetID intValue];
     
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
    
    
                 //////
            //////  Entry Add
            
            
                Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:context];
                
                
                
                
                
                ////////
                /////   set values
                ///////
                
              
                entry.edited = [NSNumber numberWithBool:YES];
                entry.editDone = [NSNumber numberWithBool:NO];
                
                
                 //////
                // link relationships
                /////
                
               
                
                entry.competitor = self.competitorObject;
                entry.cEventScore = ceventscore;
                entry.meet = self.competitorObject.meet;
                
                
                
                //////
                
                         // Store entryID data
          
              
                
            defaults = [NSUserDefaults standardUserDefaults];
            
             
              tempint =  [self.competitorObject.meet.meetID intValue];
             
              keystring = [NSString stringWithFormat:@"%dlastentryID",tempint];  ////
             
             // nslog(@"%@",keystring);
             
             if (![defaults objectForKey:keystring]) {                    /////
             
             int idint = 0;
             NSNumber *idnumber = [NSNumber numberWithInt:idint];
             [defaults setObject:idnumber forKey:keystring];             ///////
             
             }
                oldnumber = [defaults objectForKey:keystring];   ///
                oldint = [oldnumber intValue];
                newint = oldint + 1;
                newnumber = [NSNumber numberWithInt:newint];
               entry.entryID = newnumber;                  //////////
               

            [defaults setObject: newnumber forKey:keystring];            /////////
             
            [defaults synchronize];
         
            ////
                 
     
                ceventscore.edited = [NSNumber numberWithBool:YES];
                ceventscore.editDone = [NSNumber numberWithBool:NO];
                ceventscore.event.edited = [NSNumber numberWithBool:YES];
                ceventscore.event.editDone = [NSNumber numberWithBool:NO];
        

        
                NSError *error = nil;

        
        

        // Save the context.
        
            if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
        
        
        
        
      
        
        
    }
   
    if ([unwindSegue.sourceViewController isKindOfClass:[PickRelayTeamForCViewController class]])
    {
        // nslog(@"Coming from pickrelay Done!");
        
                NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
        
        
        PickRelayTeamForCViewController *sourceViewController = unwindSegue.sourceViewController;
        
   
        CEventScore *ceventscore = sourceViewController.cEventScoreSelected;
       
         //////
            //////  Entry Add
            
            
                Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:context];
                
                
                
                
                
                ////////
                /////   set values
                ///////
                
              
                entry.edited = [NSNumber numberWithBool:YES];
                entry.editDone = [NSNumber numberWithBool:NO];
                
                
                 //////
                // link relationships
                /////
                
               
                
                entry.competitor = self.competitorObject;
                entry.cEventScore = ceventscore;
                entry.meet = self.competitorObject.meet;
                
                
                
                //////
                
                         // Store entryID data

                
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
             
             int tempint =  [self.competitorObject.meet.meetID intValue];
             
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
                 
     
                ceventscore.edited = [NSNumber numberWithBool:YES];
                ceventscore.editDone = [NSNumber numberWithBool:NO];
                ceventscore.event.edited = [NSNumber numberWithBool:YES];
                ceventscore.event.editDone = [NSNumber numberWithBool:NO];
        

        
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
- (IBAction)unwindToSetupEventsForCCancel:(UIStoryboardSegue *)unwindSegue
{

UIViewController* sourceViewController = unwindSegue.sourceViewController;

if ([sourceViewController isKindOfClass:[EventForCAddViewController class]])
    {
        // nslog(@"Coming from cEventScoreAdd Cancel!");
    }
}



@end
