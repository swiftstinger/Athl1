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
#import "Meet.h"
#import "AppDelegate.h"

@interface SetupCompetitorsViewController ()

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

  
        


    if ([comp.cEventScores count] > 0) {
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
    
        cell.numberOfEventsLabel.text = [NSString stringWithFormat:@"Events: %@",  @([[object valueForKey:@"cEventScores"] count] )];
    
  }
  /*
-(NSString*) checkNumberOfEventsForCompetitor: (Competitor*)comp {

NSString *eventstring;

NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        NSEntityDescription *description = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];


            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(team == %@)", comp.team];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(competitor == %@)", comp];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];


            NSError *err;
            NSUInteger eventscorecount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&err];
        
        
            if(eventscorecount == NSNotFound) {
                //Handle error
            }
        eventstring = [NSString stringWithFormat:@"Events : %d ",eventscorecount];


return eventstring;
}
*/
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
//appDelegate.csvDataArray = nil

 NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];

        for (NSString* string in newArray) {
                    NSLog(@"%@",string);
            
                        //create objects here
            
                    // nslog(@"Coming from CompetitorAdd Done!");
                    
            
                
                    Competitor *competitor = [NSEntityDescription insertNewObjectForEntityForName:@"Competitor" inManagedObjectContext:context];
            
                    
                    ////////
                    /////   set values
                    ///////
                 
                      competitor.compName = string;
            
                    
            
                    
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
    [self loadCSVArray];
}
- (IBAction)exportButtonPressed:(UIBarButtonItem *)sender {
}
@end
