//
//  SetupTeamsViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "SetupTeamsViewController.h"
#import "TeamTableViewCell.h"
#import "Team.h"
#import "Competitor.h"
#import "AppDelegate.h"

@interface SetupTeamsViewController ()

@end

@implementation SetupTeamsViewController

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

// nslog(@"in view");
    // Update the user interface for the detail item.
    if (_detailItem) {
        if (([self.meetObject.onlineMeet boolValue])&&(![self.meetObject.isOwner boolValue])) {
        
            self.addButton.enabled = NO;
        }
        else
        {
            self.addButton.enabled = YES;
        
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
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
    
  //  self.navigationItem.leftBarButtonItem = self.editButtonItem;
  /**
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapped:)];
    [self.tableView addGestureRecognizer:tap];
    **/
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

- (TeamTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TeamCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    BOOL var = YES;
    
    if ([self.meetObject.onlineMeet boolValue]) {
            if (![self.meetObject.isOwner boolValue]) {

                var = NO;
            }
          
        }
    
    
    return var;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
      // nslog(@"Teams before delete: %lu",  (unsigned long)[self.meetObject.teams count]);
        context = [self checkBeforeDeleteTeamObject: [self.fetchedResultsController objectAtIndexPath:indexPath] InContext:context];
        // nslog(@"Teams before save: %lu",  (unsigned long)[self.meetObject.teams count]);
        NSError *error = nil;
                            if (![context save:&error]) {
                                // Replace this implementation with code to handle the error appropriately.
                                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
                           // abort();
                            }
                            // nslog(@"Tthis system unneccisary save: %lu",  (unsigned long)[self.meetObject.teams count]);
    }
}
- (NSManagedObjectContext*) checkBeforeDeleteTeamObject: (Team*) team InContext: (NSManagedObjectContext*) context

{

    NSSet *competitorarray = team.competitors;
    int count = 0;
    for (Competitor *comp in competitorarray) {
        

        if ([comp.entries count] > 0) {
        
            count = count +1;
           
        }
    
    
    }

    if (count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"Confirm Delete"
                                    message:@"Some competitors in this Team have already been entered into events. Deleting this Team will delete these competitors and any scores entered for them. This cannot be undone."
                                    preferredStyle:UIAlertControllerStyleAlert];
     
     
                UIAlertAction* delete = [UIAlertAction
                        actionWithTitle:@"DELETE"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            Meet* thismeet = team.meet;
        
                            NSSet *teamSet = thismeet.teams;
        
                
                            if ([teamSet count] < 2) {
            
            
                                thismeet.teamsDone = [NSNumber numberWithBool:NO];
        
                            }
        
                            
                        
                            [context deleteObject:team];
                            
                             NSError *error = nil;
                            if (![context save:&error]) {
                                // Replace this implementation with code to handle the error appropriately.
                                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
                          //  abort();
                            }
                            // nslog(@"Teams after delete and save in other system pressed: %lu",  (unsigned long)[self.meetObject.teams count]);
                            
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
    
                            Meet* thismeet = team.meet;
        
                            NSSet *teamSet = thismeet.teams;
        
                
                            if ([teamSet count] < 2) {
            
            
                                thismeet.teamsDone = [NSNumber numberWithBool:NO];
        
                            }
        
                            
                        
                            [context deleteObject:team];
        
                            NSError *error = nil;
                            if (![context save:&error]) {
                                // Replace this implementation with code to handle the error appropriately.
                                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
                         //   abort();
                            }
                            // nslog(@"Teams after delete and save in other system not pressed: %lu",  (unsigned long)[self.meetObject.teams count]);
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
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
     // limit to those entities that belong to the particular item
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(meet == %@)", _meetObject];
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

- (void)configureCell:(TeamTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
          cell.teamTitleLabel.text = [[object valueForKey:@"teamName"] description];
    
          cell.numberOfCompetitorsLabel.text = [NSString stringWithFormat:@"Competitors: %@",  @([[object valueForKey:@"competitors"] count] )];
    
    
    

  }

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

    if ([[segue identifier] isEqualToString:@"showTeam"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
      //NSIndexPath *indexPath = self.indexPathForLongPressCell;
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
       
        // nslog(@"in segue");
          [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
        
    }
    
     if ([[segue identifier] isEqualToString:@"editTeam"]) {
        
       NSIndexPath *indexPath = self.indexPathForLongPressCell;
        
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
    TeamAddViewController* teamAddController = (TeamAddViewController*)[navController topViewController];
        
        
        [teamAddController setDetailItem:object];
       
        [teamAddController setManagedObjectContext:self.managedObjectContext];
       
    }
    
}




#pragma mark - MeetAddViewControllerUnwinds

- (IBAction)unwindToSetupTeamDone:(UIStoryboardSegue *)unwindSegue
{


    if ([unwindSegue.sourceViewController isKindOfClass:[TeamAddViewController class]])
    {
        // nslog(@"Coming from TeamsAdd Done!");
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
     
        
        
        TeamAddViewController *sourceViewController = unwindSegue.sourceViewController;
        
        Team *team ;
        
        if (!sourceViewController.editing) {

    
       team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:context];
        }
        else
        {
        
        team = sourceViewController.detailItem;
        }
        
        
        
        ////////
        /////   set values
        ///////
     
           if (sourceViewController.teamName) {
        [team setValue: sourceViewController.teamName.text forKey:@"teamName"];
    
        }
        
         if (sourceViewController.teamAbr) {
        [team setValue: sourceViewController.teamAbr.text forKey:@"teamAbr"];
    
        }
       if (!sourceViewController.editing) {
        
            [self.meetObject setValue:[NSNumber numberWithBool:YES] forKey:@"teamsDone"];
         //////
        // link relationship
        /////
        team.meet = self.meetObject;
       
        
        
        //////
        
          // Store teamID data
 
      
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
     
     int tempint =  [_meetObject.meetID intValue];
     
     NSString * keystring = [NSString stringWithFormat:@"%dlastTeamID",tempint];  ////
     
    
     
     if (![defaults objectForKey:keystring]) {                    /////
     
     int idint = 0;
     NSNumber *idnumber = [NSNumber numberWithInt:idint];
     [defaults setObject:idnumber forKey:keystring];             ///////
     
     }
    NSNumber *oldnumber = [defaults objectForKey:keystring];   ///
       int oldint = [oldnumber intValue];
       int newint = oldint + 1;
       NSNumber *newnumber = [NSNumber numberWithInt:newint];
       [team setValue: newnumber forKey: @"teamID"];                  //////////
      

    [defaults setObject: newnumber forKey:keystring];            /////////
     
    [defaults synchronize];
  }
  else
  {
  
    for(Competitor* comp in team.competitors) {
       ;
      
       comp.teamName = comp.team.teamName;
           }
  
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
- (IBAction)unwindToSetupTeamCancel:(UIStoryboardSegue *)unwindSegue
{

UIViewController* sourceViewController = unwindSegue.sourceViewController;

if ([sourceViewController isKindOfClass:[TeamAddViewController class]])
    {
        // nslog(@"Coming from TeamsAdd Cancel!");
    }
}


- (IBAction)longPressRecognizer:(UILongPressGestureRecognizer *)sender {
    if ((![self.meetObject.onlineMeet boolValue])||([self.meetObject.isOwner boolValue])) {
        if (sender.state == UIGestureRecognizerStateBegan)
        {
    
            CGPoint location = [sender locationInView:self.tableView];
            self.indexPathForLongPressCell = [self.tableView indexPathForRowAtPoint:location];
        
        
            // nslog(@"Long-pressed cell at row %@", self.indexPathForLongPressCell);
        
            [self performSegueWithIdentifier:@"editTeam" sender:self];
        }
	}
    else
    {
        NSLog(@"online and not owner meet so no touches for you  : ) ");
    }




}

- (void)loadCSVArray {
NSLog(@"here");

AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];

NSArray  *newArray = appDelegate.csvDataArray;
appDelegate.csvDataArray = nil;
 self.importButton.enabled = FALSE;
   NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
        for (NSString* stringwhole in newArray) {
                    NSLog(@"%@",stringwhole);
            
            //create objects here

                
                Team *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:context];
                
                
                
                
                ////////
                /////   set values
                ///////
                NSArray  *tmArray =  [stringwhole componentsSeparatedByString:@","];
                NSString *abr = nil;
                if (tmArray.count > 0) {
                    
                   team.teamName = tmArray[0];
                    if ([tmArray[0] length] >= 3) {
                    
                        abr = [tmArray[0] substringToIndex:3];
                    }
                    else
                    {
                        abr = tmArray[0];
                    }
                }
            
            

                if (tmArray.count > 1) {
                    abr = tmArray[1];
                    NSLog(@"abr found");
                }
                else
                {
                
                    NSLog(@"no abr found");
            
                    
                }
                team.teamAbr = abr;
            
            
            
            
            
                 //////
                // link relationship
                /////
                team.meet = self.meetObject;
               
                
                
                //////
                
                  // Store teamID data
         
              
                
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
             
             int tempint =  [_meetObject.meetID intValue];
             
             NSString * keystring = [NSString stringWithFormat:@"%dlastTeamID",tempint];  ////
             
            
             
             if (![defaults objectForKey:keystring]) {                    /////
             
             int idint = 0;
             NSNumber *idnumber = [NSNumber numberWithInt:idint];
             [defaults setObject:idnumber forKey:keystring];             ///////
             
             }
            NSNumber *oldnumber = [defaults objectForKey:keystring];   ///
               int oldint = [oldnumber intValue];
               int newint = oldint + 1;
               NSNumber *newnumber = [NSNumber numberWithInt:newint];
               [team setValue: newnumber forKey: @"teamID"];                  //////////
              

            [defaults setObject: newnumber forKey:keystring];            /////////
             
            [defaults synchronize];
          
            ////
            
      }
    

        [self.meetObject setValue:[NSNumber numberWithBool:YES] forKey:@"teamsDone"];
    
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
                            alertControllerWithTitle:@"Importing Teams"
                            message:@"Team names imported from csv file. \n\n First item in row will be treated as the Team Name. The second the Team Abbreviation. \n\n These can be edited by long pressing on the relavant team cell."
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
NSString* entityname = @"Team";
    NSError *error;
                        
                            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                            NSEntityDescription *entity = [NSEntityDescription
                    entityForName: entityname inManagedObjectContext:self.managedObjectContext];
                            [fetchRequest setEntity:entity];
                            
                            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(meet == %@)", self.meetObject];
                    [fetchRequest setPredicate:predicate];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"teamID" ascending:YES];
                   NSArray *sortDescriptors = @[sortDescriptor];
                    
                    [fetchRequest setSortDescriptors:sortDescriptors];
    
                            
                            NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];

/// end fetch divisions

    for (Team* team in fetchedObjects) {
        
        [resultscsv appendString:[NSString stringWithFormat:@"%@,%@",team.teamName, team.teamAbr]];
        
        [resultscsv appendString:[NSString stringWithFormat:@"\n"]];
        
    }

NSString *emailTitle = @"Export Teams";
    
    NSString* subjectString = [NSString stringWithFormat:@"Teams From Athletics Meet %@", self.meetObject.meetName];
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Teams From Athletics Meet %@ \n\n Can Be Imported Into Athletics Meet Manager IOS App. \n\n Long press csv file and choose 'Open in Athletics Meet Manager' to Import", self.meetObject.meetName];
    // To address
    
    NSString* filename = [NSString stringWithFormat:@"%@_Teams.csv", self.meetObject.meetName];
    
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
