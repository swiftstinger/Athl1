//
//  SetupGEventsViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "SetupGEventsViewController.h"
#import "GEventTableViewCell.h"
#import "GEvent.h"
#import "Division.h"
#import "Event.h"


@interface SetupGEventsViewController ()

@end

@implementation SetupGEventsViewController

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
        _meetObject = _detailItem;
        // Update the view.
        [self configureView];
        
       
        
    }
}



- (void)configureView
{

NSLog(@"in view");
    // Update the user interface for the detail item.
    if (_detailItem) {
      
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
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

- (GEventTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GEventCell" forIndexPath:indexPath];
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
        
        context = [self checkBeforeDeleteGEventObject: [self.fetchedResultsController objectAtIndexPath:indexPath] InContext:context];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
- (NSManagedObjectContext*) checkBeforeDeleteGEventObject: (GEvent*) gevent InContext: (NSManagedObjectContext*) context

{

    NSSet *events = gevent.events;
    int count = 0;
    for (Event *event in events) {
        

        if ([event.eventEdited boolValue]) {
        
            count = count +1;
           
        }
    
    
    }

    if (count > 0) {
        UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"Confirm Delete"
                                    message:@"Some events in this Event Group already have competitors or scores entered. Deleting this Event Group will delete these events and any scores entered. This cannot be undone. This action will not delete any competitors"
                                    preferredStyle:UIAlertControllerStyleAlert];
     
     
                UIAlertAction* delete = [UIAlertAction
                        actionWithTitle:@"DELETE"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            Meet* thismeet = gevent.meet;
        
                            NSSet *geventSet = thismeet.gEvents;
        
                
                            if ([geventSet count] < 2) {
            
            
                                thismeet.eventsDone = [NSNumber numberWithBool:NO];
        
                            }
        
                            
                        
                            [context deleteObject:gevent];
                            
                            NSError *error = nil;
                            if (![context save:&error]) {
                            // Replace this implementation with code to handle the error appropriately.
                            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                            abort();
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

    }
    else
    {
    
     Meet* thismeet = gevent.meet;
        
                            NSSet *geventSet = thismeet.gEvents;
        
                
                            if ([geventSet count] < 2) {
            
            
                                thismeet.eventsDone = [NSNumber numberWithBool:NO];
        
                            }
        
                            
                        
                            [context deleteObject:gevent];
        
                            NSError *error = nil;
                            if (![context save:&error]) {
                            // Replace this implementation with code to handle the error appropriately.
                            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                            abort();
                            }
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GEvent" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(meet == %@)", _meetObject];
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
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
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

- (void)configureCell:(GEventTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
          cell.gEventTitleLabel.text = [[object valueForKey:@"gEventName"] description];

  }

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

    if ([[segue identifier] isEqualToString:@"showGEvent"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    }
    
    if ([[segue identifier] isEqualToString:@"editGEvent"]) {
        
       NSIndexPath *indexPath = self.indexPathForLongPressCell;
        
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
    GEventAddViewController* gEventAddController = (GEventAddViewController*)[navController topViewController];
        
        
        [gEventAddController setDetailItem:object];
       
        [gEventAddController setManagedObjectContext:self.managedObjectContext];
       
    }


}





#pragma mark - MeetAddViewControllerUnwinds

- (IBAction)unwindToSetupGEventDone:(UIStoryboardSegue *)unwindSegue
{


    if ([unwindSegue.sourceViewController isKindOfClass:[GEventAddViewController class]])
    {
        NSLog(@"Coming from GEventAdd Done!");
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
     GEventAddViewController *sourceViewController = unwindSegue.sourceViewController;
    GEvent *gEvent;
    
    if (!sourceViewController.editing) {

    
       gEvent = [NSEntityDescription insertNewObjectForEntityForName:@"GEvent" inManagedObjectContext:context];
        }
        else
        {
        
        gEvent = sourceViewController.detailItem;
        
        }


    
       
        
        
       
        ////////
        /////   set values
        ///////
     
        if (sourceViewController.gEventName) {
        [gEvent setValue: sourceViewController.gEventName.text forKey:@"gEventName"];
    
        }
                if (sourceViewController.gEventType) {
        [gEvent setValue: [sourceViewController.gEventType titleForSegmentAtIndex:[sourceViewController.gEventType selectedSegmentIndex]] forKey:@"gEventType"];
    
      
          }
        
        [self.meetObject setValue:[NSNumber numberWithBool:YES] forKey:@"eventsDone"];
        
        
        if (sourceViewController.maxCompPerTeamStepper) {
        [gEvent setValue: [NSNumber numberWithInteger: sourceViewController.maxCompPerTeamStepper.value] forKey:@"competitorsPerTeam"];
    
        }

        
        if (sourceViewController.maxScoringCompStepper) {
        [gEvent setValue: [NSNumber numberWithInteger: sourceViewController.maxScoringCompStepper.value] forKey:@"maxScoringCompetitors"];
    
        }
        
        if (sourceViewController.scoreForFirstStepper) {
        [gEvent setValue: [NSNumber numberWithInteger: sourceViewController.scoreForFirstStepper.value] forKey:@"scoreForFirstPlace"];
    
        }
        
        if (sourceViewController.reductionPerPlaceStepper) {
        [gEvent setValue: [NSNumber numberWithInteger: sourceViewController.reductionPerPlaceStepper.value] forKey:@"decrementPerPlace"];
    
        }
        
        
         if (sourceViewController.scoreMultiplierStepper) {
        [gEvent setValue: [NSNumber numberWithInteger: sourceViewController.scoreMultiplierStepper.value] forKey:@"scoreMultiplier"];
    
        }
        
        
        
        /////////
        /// Set Up and link Events
        ////////
        
        if (!sourceViewController.isEditing) {
            
            NSError *error;
        
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription
    entityForName:@"Division" inManagedObjectContext:self.managedObjectContext];
            [fetchRequest setEntity:entity];
           
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(meet == %@)", self.meetObject];
    [fetchRequest setPredicate:predicate];

            
            
            
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
            
            for (Division *div in fetchedObjects) {
                
                Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
                event.meet = self.meetObject;
                event.gEvent = gEvent;
                event.division = div;
                event.eventEdited = [NSNumber numberWithBool:NO];
                event.eventDone = [NSNumber numberWithBool:NO];
                
                
                 ////////// event id
                
                    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
    
     
                    int tempint1 =  [_meetObject.meetID intValue];
     
                    NSString * keystring1 = [NSString stringWithFormat:@"%dlastEventID",tempint1];  ////
     
                    NSLog(@"%@",keystring1);
     
                    if (![defaults1 objectForKey:keystring1]) {                    /////
     
                        int idint1 = 0;
                        NSNumber *idnumber1 = [NSNumber numberWithInt:idint1];
                        [defaults1 setObject:idnumber1 forKey:keystring1];             ///////
     
                        }
                    NSNumber *oldnumber1 = [defaults1 objectForKey:keystring1];   ///
                    int oldint1 = [oldnumber1 intValue];
                    int newint1 = oldint1 + 1;
                    NSNumber *newnumber1 = [NSNumber numberWithInt:newint1];
                    [event setValue: newnumber1 forKey: @"eventID"];                  //////////
                    NSLog(@" eventID %@",  event.eventID);

                    [defaults1 setObject: newnumber1 forKey:keystring1];            /////////
     
                    [defaults1 synchronize];
     
                    ////

        
                int numberofevents = (int)[[self.meetObject valueForKey:@"events"] count] ;

        
        

     
                   NSLog(@"events in meet = %d",numberofevents);

            }
        
            
        
        
        

        
        
        
        
        
    
        //////
        // link relationship
        /////
        
        gEvent.meet = self.meetObject;
        
               
      
        
        
        //////
        
        // Store GEventID data
        
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
     
     int tempint =  [_meetObject.meetID intValue];
     
     NSString * keystring = [NSString stringWithFormat:@"%dlastGEventID",tempint];  ////
     
     NSLog(@"%@",keystring);
     
     if (![defaults objectForKey:keystring]) {                    /////
     
     int idint = 0;
     NSNumber *idnumber = [NSNumber numberWithInt:idint];
     [defaults setObject:idnumber forKey:keystring];             ///////
     
     }
NSNumber *oldnumber = [defaults objectForKey:keystring];   ///
       int oldint = [oldnumber intValue];
       int newint = oldint + 1;
       NSNumber *newnumber = [NSNumber numberWithInt:newint];
       [gEvent setValue: newnumber forKey: @"gEventID"];                  //////////
       

    [defaults setObject: newnumber forKey:keystring];            /////////
     
    [defaults synchronize];
     
    ////
        }
        
                NSError *error = nil;

        
        

        // Save the context.
        
            if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
        
    }
   
   

}
- (IBAction)unwindToSetupGEventCancel:(UIStoryboardSegue *)unwindSegue
{

UIViewController* sourceViewController = unwindSegue.sourceViewController;

if ([sourceViewController isKindOfClass:[GEventAddViewController class]])
    {
        NSLog(@"Coming from GEventAdd Cancel!");
    }
}


- (IBAction)longPressRecognizer:(UILongPressGestureRecognizer*)sender {
NSLog(@"in longpress");

if (sender.state == UIGestureRecognizerStateBegan)
	{
		CGPoint location = [sender locationInView:self.tableView];
  self.indexPathForLongPressCell = [self.tableView indexPathForRowAtPoint:location];
        
        
		NSLog(@"Long-pressed cell at row %@", self.indexPathForLongPressCell);
        
        [self performSegueWithIdentifier:@"editGEvent" sender:self];
	}

}
@end
