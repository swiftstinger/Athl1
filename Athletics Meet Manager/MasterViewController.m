//
//  MasterViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 22/05/2015.
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
/**
-(void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
   //something here
   
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
     
     
     if (![defaults objectForKey:@"importingOnlineMeet"]) {

     }
     else
     {
        if ([[defaults objectForKey:@"importingOnlineMeet"] boolValue]) {
            

            
        }
        
         NSNumber *importing = [NSNumber numberWithBool:FALSE];
        [defaults setObject: importing forKey:@"importingOnlineMeet"];
        [defaults synchronize];
         
     }
    
    
}
**/
- (void) importedMeet {
    self.segmentedControl.selectedSegmentIndex = 1;
            NSLog(@"here");
    
            [self segmentedControlValueChanged:self.segmentedControl];
                    dispatch_async(dispatch_get_main_queue(), ^{
                
                    UIAlertController * alert=   [UIAlertController
                                            alertControllerWithTitle:@"Online Meet Imported"
                                            message:@"Imported online meet successfully. \n Tap on meet labeled 'NewOnlineMeet' to download the new meet's name and details. \n\n Notice! \n\n After this the name will change"
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

}
- (void) importedCsv {
    
    
dispatch_async(dispatch_get_main_queue(), ^{
                
    UIAlertController * alert=   [UIAlertController
                        alertControllerWithTitle:@"CSV File Imported"
                        message:@"Imported CSV file succesfully. \n\n Please navigate to the Meet and Section in which you would like to import the items listed in the .csv file and click Import \n\n Please remember that any text between comma's will be seen as a single entry"
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




}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(importedMeet) name:@"importedMeet" object:nil];
    [center addObserver:self selector:@selector(importedCsv) name:@"importedCsv" object:nil];
   
   // self.navigationItem.leftBarButtonItem = self.editButtonItem;
 /**
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    **/
    
    NSLog(@"view did load");
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
     
     
     if (![defaults objectForKey:@"firstTimeDone"]) {

        [defaults setObject: @"1" forKey:@"firstTimeDone"];
    
            [self performSegueWithIdentifier:@"showTut" sender:self];
        
        }
        else
        {
            NSLog(@"not first time");
           // [self performSegueWithIdentifier:@"showTut" sender:self];
        }
    

    
    
   // [self updateOnlineMeets];
    
    /**
    
    
    
    
    NSError *error = nil;

        // Save the context.
        
            if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
        
    }
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
        // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
       // abort();
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
     bool isOnlineMeet = [self.segmentedControl selectedSegmentIndex] == 0 ? FALSE : TRUE;
    
    if (isOnlineMeet) {        
        return YES;
        }
        else {
        return YES;
        }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        bool isOnlineMeet = [self.segmentedControl selectedSegmentIndex] == 0 ? FALSE : TRUE;
        Meet* meetObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if (isOnlineMeet&&([meetObject.isOwner boolValue]))
         {
          
          context = [self deleteOnlineMeet: meetObject InContext: context];
        }
        
        NSLog(@"here");
            [context deleteObject:meetObject];
        
        
        
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
          //  abort();
        }
    }
}
- (NSManagedObjectContext*)deleteOnlineMeet:(Meet*)meetObject InContext: (NSManagedObjectContext*) context {

NSLog(@"deleteonlinemeet");

    CKRecordID *meetrecordID = [[CKRecordID alloc] initWithRecordName:meetObject.onlineID];
    
    
            //get the Container for the App
            CKContainer *defaultContainer = [CKContainer defaultContainer];
    
            //get the PublicDatabase inside the Container
            CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    
    
      [publicDatabase deleteRecordWithID:meetrecordID completionHandler:^(CKRecordID *recordID, NSError *error) {
        
          if(error) {
            
                NSLog(@"Uh oh, there was an error deleting ... %@", error);
          
            //handle successful save
            } else {
            
                NSLog(@"deleted successfully");
   
            }
  
        }];
    
        return context;
}
- (void)configureCell:(MeetTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  Meet *meetobject = (Meet*) object;
    
    
    cell.meetTitleLabel.text = [[object valueForKey:@"meetName"] description];

    NSDate *fulldate = [object valueForKey:@"meetDate"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd MMM yyyy";
    

    if ([meetobject.onlineMeet boolValue]) {
   
        if ([meetobject.isOwner boolValue]) {
            NSLog(@"is owner");
             cell.hostLabel.hidden = NO;
            
        }
        else
        {
           cell.hostLabel.hidden = YES;
           
           // Fetch the record from the database
            
           

           
        }
    }
    else
    {
     cell.hostLabel.hidden = YES;
     
    }
        NSLog(@"in configurecell");
    NSLog(@"MEET NAME %@  owner value %hhd online %hhd", [[object valueForKey:@"meetName"] description],[[object valueForKey:@"isOwner"] boolValue],[[object valueForKey:@"onlineMeet"] boolValue]);

    
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
    
    
    bool isOnlineMeet = [self.segmentedControl selectedSegmentIndex] == 0 ? FALSE : TRUE;
    
    if (!isOnlineMeet) {
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"onlineMeet == FALSE"];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"onlineMeet = nil"];
       
       
       NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *orPred = [NSCompoundPredicate orPredicateWithSubpredicates:preds];

       
       [fetchRequest setPredicate:orPred];
        }
    else
    {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(onlineMeet == TRUE)"];
    [fetchRequest setPredicate:predicate];

    }
    
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"meetDate" ascending:NO];
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
        // nslog(@"Coming from MeetAdd Done!");
        
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
        [meet setValue: [NSNumber numberWithInteger: sourceViewController.maxCompPerTeamStepper.value] forKey:@"competitorPerTeam"];
    
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
        
     //   [meet setValue:[NSNumber numberWithBool:YES] forKey:@"onlineMeet"];

        
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
    
    NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
    
    NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
if (numberrange.location != NSNotFound) {
     newdevID = [devID substringFromIndex:numberrange.location + 2];
} else {
     newdevID = devID;
}

    devID = newdevID;
    
       
    NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, newnumber,timestamp];
      [meet setValue: onlineID forKey: @"onlineID"];

        NSLog(@"timestamp %@  onlineID: %@",timestamp, onlineID);

    [defaults setObject: newnumber forKey:@"lastMeetID"];
     
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
   
   

}
- (IBAction)unwindToMainCancel:(UIStoryboardSegue *)unwindSegue
{

UIViewController* sourceViewController = unwindSegue.sourceViewController;

if ([sourceViewController isKindOfClass:[MeetAddViewController class]])
    {
        // nslog(@"Coming from MeetAdd Cancel!");
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
// nslog(@"long press fire");
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
		// nslog(@"Long-pressed cell at row %@", self.indexPathForLongPressCell);
        
        [self performSegueWithIdentifier:@"editMeet" sender:self];
	}


}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {

self.fetchedResultsController = nil;
    NSLog(@"here 2");
    [self.tableView reloadData];
    bool isOnlineMeet = [self.segmentedControl selectedSegmentIndex] == 0 ? FALSE : TRUE;
    
    if (!isOnlineMeet) {
    
    
    //self.navigationItem.rightBarButtonItem = addButton;
    self.addButton.enabled = YES;
    
    }
    else
    {
    
      self.addButton.enabled = NO;
        
    }
    

}

/**
- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yourCustomMethod:)
                                                 name:SELECT_INDEX_NOTIFICATION object:nil];
}


-(void)yourCustomMethod:(NSNotification*)_notification
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
    NSString *selectedIndex=[[_notification userInfo] objectForKey:SELECTED_INDEX];
    NSLog(@"selectedIndex  : %@",selectedIndex);

}

- (void)setOnlineMeet:(NSString *)meetOnlineID {

    NSLog(@"in masteviewcontrooler with string %@", meetOnlineID);
   
     NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
        Meet *meet;
    
        meet = [NSEntityDescription insertNewObjectForEntityForName:@"Meet" inManagedObjectContext:context];
    
        [meet setValue: @"Online Meet Updating..." forKey:@"meetName"];
    
        [meet setValue: [NSNumber numberWithBool:YES] forKey:@"onlineMeet"];
    
        [meet setValue: [NSNumber numberWithBool:NO] forKey:@"isOwner"];

    
        [meet setValue: meetOnlineID forKey: @"onlineID"];

        NSLog(@"new meet set with onlineID onlineID: %@", meetOnlineID);
    
    
    
    NSError *error = nil;

        // Save the context.
        
            if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
    
            [self updateOnlineMeets];

    
}
**/


- (void)updateOnlineMeets {
    
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"Meet" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];

           NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(onlineMeet == TRUE)"];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(isOwner == FALSE)"];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];
    
    

                NSError *error;
                NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    
            CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
            CKRecordID *meetRecordID;
    
    for (Meet* meetobject in results) {
        
        
                NSLog(@"updating meet %@ %@", meetobject.meetName, meetobject.onlineID);
        
                 /**
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"onlineID = %@", meetobject.onlineID];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"onlineID = %@", @"1"];
                //create query
                CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Meet" predicate:predicate];
    
            //execute query
                [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        
                //handle query error
                if(error) {
            
                NSLog(@"Uh oh, there was an error querying ... %@", error);

                } else {
            
                    //handle query results
                    if([results count] > 0) {
                
                    //iterate query results
                        for(CKRecord *meetRecord in results) {
                    
                            meetobject.meetDate = meetRecord[@"meetDate"];
                            meetobject.meetName = meetRecord[@"meetName"];
                
                            NSError *error = nil;

                            // Save the context.
        
                            if (![self.managedObjectContext save:&error]) {
                           
                            }
                            NSLog(@"meet update succesfull %@", meetobject.meetName);

                            }
                
                    //handle no query results
                    } else {
                
                        NSLog(@"Query returned zero results");
                    }
                }
                }];
        
        
                **/
            
        
            
                NSLog(@"updating meet %@ %@", meetobject.meetName, meetobject.onlineID);
        

                meetRecordID = [[CKRecordID alloc] initWithRecordName:meetobject.onlineID];
                [publicDatabase fetchRecordWithID:meetRecordID completionHandler:^(CKRecord *meetRecord, NSError *error) {
                    if (error) {
                        // Error handling for failed fetch from public database
                
                        NSLog(@"Uh oh, there was an error getting meetname %@  %@ online ... %@",meetobject.meetName, meetobject.onlineID, error);
                    }
                    else {
                        // Modify the record and save it to the database
                        
                        meetobject.meetDate = meetRecord[@"meetDate"];
                        meetobject.meetName = meetRecord[@"meetName"];
                
                        NSError *error = nil;

                        // Save the context.
        
                        if (![self.managedObjectContext save:&error]) {
                           
                        }
                        NSLog(@"meet update succesfull %@", meetobject.meetName);
                
                
                    }
                }];
                
                
        }
}

- (IBAction)InfoButton:(UIBarButtonItem *)sender {
}
@end
