//
//  MasterViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 22/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "MasterViewController.h"
#import "MeetMenuViewController.h"
#import "MeetTableViewCell.h"
#import "Meet.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   
   // self.navigationItem.leftBarButtonItem = self.editButtonItem;
 /**
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    **/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    Meet *meet = [NSEntityDescription insertNewObjectForEntityForName:@"Meet" inManagedObjectContext:context];
        
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
   
    [meet setValue: @"Mymeet" forKey:@"meetName"];
    [meet setValue: [NSDate date] forKey:@"meetDate"];
   
        
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (MeetTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetCell" forIndexPath:indexPath];
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
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(MeetTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
    cell.meetTitleLabel.text = [[object valueForKey:@"meetName"] description];

    NSDate *fulldate = [object valueForKey:@"meetDate"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
format.dateFormat = @"dd MMM yyyy";



    
 //   [[object valueForKey:@"meetDate"] description];
    cell.meetDateLabel.text = [format stringFromDate:fulldate];
    cell.numberOfTeamsLabel.text = [NSString stringWithFormat:@"Teams: %@",  @([[object valueForKey:@"teams"] count] )];  
    //[[@"hello"] description];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meet" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"meetDate" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
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

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */
#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 /*
 
    if ([[segue identifier] isEqualToString:@"addMeet"]) {
        
        
    }
  */
    if ([[segue identifier] isEqualToString:@"meetMenu"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    }
    
    if ([[segue identifier] isEqualToString:@"editMeet"]) {
        
       NSIndexPath *indexPath = self.indexPathForLongPressCell;
      //  NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
       
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
    MeetAddViewController* meetAddController = (MeetAddViewController*)[navController topViewController];
        
        
        [meetAddController setDetailItem:object];
       
        [meetAddController setManagedObjectContext:self.managedObjectContext];
       
    }

    
}
#pragma mark - MeetAddViewControllerUnwinds

- (IBAction)unwindToMainDone:(UIStoryboardSegue *)unwindSegue
{


    if ([unwindSegue.sourceViewController isKindOfClass:[MeetAddViewController class]])
    {
        NSLog(@"Coming from MeetAdd Done!");
        
        MeetAddViewController *sourceViewController = unwindSegue.sourceViewController;
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    Meet *meet;
    
      if (!sourceViewController.editing) {

    
        meet = [NSEntityDescription insertNewObjectForEntityForName:@"Meet" inManagedObjectContext:context];
        }
        else
        {
        
        meet = sourceViewController.detailItem;
        }
        
        
        ////////
        /////   set values
        ///////
        if (sourceViewController.meetName) {
        [meet setValue: sourceViewController.meetName.text forKey:@"meetName"];
            
        }
        if (sourceViewController.meetDate) {
        [meet setValue: sourceViewController.meetDate.date forKey:@"meetDate"];
            
        }
        if (sourceViewController.ceventLimitStepper) {
        [meet setValue: [NSNumber numberWithInteger:sourceViewController.ceventLimitStepper.value ]forKey:@"cEventLimit"];
            
        }
        
        
        if (sourceViewController.maxCompPerTeamStepper) {
        [meet setValue: [NSNumber numberWithInteger: sourceViewController.maxCompPerTeamStepper.value] forKey:@"competitorsPerTeam"];
    
        }

        
        if (sourceViewController.maxScoringCompPerTeamStepper) {
        [meet setValue: [NSNumber numberWithInteger: sourceViewController.maxScoringCompPerTeamStepper.value] forKey:@"maxScoringCompetitors"];
    
        }
        
        if (sourceViewController.firstPlaceScoreStepper) {
        [meet setValue: [NSNumber numberWithInteger: sourceViewController.firstPlaceScoreStepper.value] forKey:@"scoreForFirstPlace"];
    
        }
        
        if (sourceViewController.reductionPerPlaceStepper) {
        [meet setValue: [NSNumber numberWithInteger: sourceViewController.reductionPerPlaceStepper.value] forKey:@"decrementPerPlace"];
    
        }
        
        
         if (sourceViewController.scoreMultiplierStepper) {
        [meet setValue: [NSNumber numberWithInteger: sourceViewController.scoreMultiplierStepper.value] forKey:@"scoreMultiplier"];
    
        }
        
        
        
        
        
        ////////
        
        
        if (!sourceViewController.editing) {
        
        [meet setValue:[NSNumber numberWithBool:NO] forKey:@"divsDone"];

        [meet setValue:[NSNumber numberWithBool:NO] forKey:@"eventsDone"];

        [meet setValue:[NSNumber numberWithBool:NO] forKey:@"teamsDone"];

        
        // Store meetID data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
     
     
     if (![defaults objectForKey:@"lastMeetID"]) {
     
     int idint = 0;
     NSNumber *idnumber = [NSNumber numberWithInt:idint];
     
     
     [defaults setObject:idnumber forKey:@"lastMeetID"];
     
     }
       
       NSNumber *oldnumber = [defaults objectForKey:@"lastMeetID"];
       
       
       int oldint = [oldnumber intValue];
       
       int newint = oldint + 1;
       
       NSNumber *newnumber = [NSNumber numberWithInt:newint];
       
       [meet setValue: newnumber forKey: @"meetID"];
       
        

        NSLog(@"meetname %@  meetID %@", meet.meetName, meet.meetID);

    [defaults setObject: newnumber forKey:@"lastMeetID"];
     
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
- (IBAction)unwindToMainCancel:(UIStoryboardSegue *)unwindSegue
{

UIViewController* sourceViewController = unwindSegue.sourceViewController;

if ([sourceViewController isKindOfClass:[MeetAddViewController class]])
    {
        NSLog(@"Coming from MeetAdd Cancel!");
    }
}

/**
#pragma mark - MeetAddViewControllerDelegate



- (void)MeetAddViewControllerDidCancel:(MeetAddViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
 
- (void)MeetAddViewControllerDidSave:(MeetAddViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

**/
- (IBAction)longPressRecognizer:(UILongPressGestureRecognizer *)sender {
NSLog(@"long press fire");
// only when gesture was recognized, not when ended
	if (sender.state == UIGestureRecognizerStateBegan)
	{
		CGPoint location = [sender locationInView:self.tableView];
  self.indexPathForLongPressCell = [self.tableView indexPathForRowAtPoint:location];
        
        
        // get affected cell
	//	MeetMenuViewCell *cell = (MeetMenuViewCell *)[sender view];
 
		// get indexPath of cell
		//self.indexPathForLongPressCell = [self.tableView indexPathForCell:cell];
 
		// do something with this action
		NSLog(@"Long-pressed cell at row %@", self.indexPathForLongPressCell);
        
        [self performSegueWithIdentifier:@"editMeet" sender:self];
	}


}

@end
