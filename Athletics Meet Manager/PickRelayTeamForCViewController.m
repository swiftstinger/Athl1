//
//  PickRelayTeamForCViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 03/02/2016.
//  Copyright (c) 2016 rudi huysamen. All rights reserved.
//

#import "PickRelayTeamForCViewController.h"
#import "relayTeamForCTableViewCell.h"
#import "addRelayTeamForCViewController.h"


@interface PickRelayTeamForCViewController ()

@end

@implementation PickRelayTeamForCViewController

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

- (void)setCompetitorObject:(Competitor *)newcompetitorObject
{
    if (_competitorObject != newcompetitorObject) {
        
        
        _competitorObject = newcompetitorObject;
        // Update the view.
        [self configureView];
        
       
        
    }
}

- (void)setEventObject:(Event *)neweventObject
{
    if (_eventObject != neweventObject) {
        _eventObject = neweventObject;
        
        // Update the view.
        [self configureView];
        
       
        
    }
}


- (void)configureView
{


    // Update the user interface for the detail item.
    if (self.eventObject) {
     
      _navBar.title = [NSString stringWithFormat:@"%@ %@ Teams", self.eventObject.division.divName, self.eventObject.gEvent.gEventName];

    
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

- (relayTeamForCTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    relayTeamForCTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teamForCCell" forIndexPath:indexPath];
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
/** from pick eventscore
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchController.active && (![self.searchController.searchBar.text isEqual: @""])) {
    
    NSLog(@"table search on");
       
       if ([self.eventObject.gEvent.gEventType isEqualToString:@"Relay"])
        {
            
            if ([self shouldPerformSegueWithIdentifier:@"eventScoreAddRelaySelectedSeque" sender:self])
            {
                [self performSegueWithIdentifier:@"eventScoreAddRelaySelectedSeque" sender:self];
            }
            
        
        }
        else
        {
                if ([self shouldPerformSegueWithIdentifier:@"eventScoreAddNormSelectedSeque" sender:self])
                {
                    [self performSegueWithIdentifier:@"eventScoreAddNormSelectedSeque" sender:self];
        
        
                }
        }
    }
    else
    {
        NSLog(@"table search off");
        if ([self.eventObject.gEvent.gEventType isEqualToString:@"Relay"])
        {
            
            if ([self shouldPerformSegueWithIdentifier:@"eventScoreAddRelaySelectedSeque" sender:self])
            {
                [self performSegueWithIdentifier:@"eventScoreAddRelaySelectedSeque" sender:self];
            }
            
        
        }
        else
        {
                if ([self shouldPerformSegueWithIdentifier:@"eventScoreAddNormSelectedSeque" sender:self])
                {
                    [self performSegueWithIdentifier:@"eventScoreAddNormSelectedSeque" sender:self];
        
        
                }
        }

    }
}
**/

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
     // limit to those entities that belong to the particular item
      //  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event == %@)", self.eventObject];
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(event == %@)", self.eventObject];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(team == %@)", self.competitorObject.team];
    
             NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];


    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cEventScoreID" ascending:YES];
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

- (void)configureCell:(relayTeamForCTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    CEventScore *ceventscore = (CEventScore*)object;
  
    
    if (ceventscore.relayDisc) {
        NSString *relayDisc = ceventscore.relayDisc;
        NSString *teamName = ceventscore.team.teamName;
        cell.title.text = relayDisc;
        cell.subTitle.text = teamName;

    }
    else
    {
        NSString *relayDisc = @"relayTeam";
        NSString *teamName = ceventscore.team.teamName;
        cell.title.text = relayDisc;
        cell.subTitle.text = teamName;
    
    }


  }
#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

    if ([[segue identifier] isEqualToString:@"addRelayTeamForCSegue"]) { ///////////////
        
        
        [[segue destinationViewController] setDetailItem:self.eventObject];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
        
    }
    
    if ([[segue identifier] isEqualToString:@"unwindToSetupEventForCDoneSegue"]) { 
            NSLog(@"segue");
    
    
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        CEventScore* ceventscore = (CEventScore*) object;
        self.cEventScoreSelected = ceventscore;

    
    }
    
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender { //// not done
     NSLog(@"segue should");
    
    if ([identifier isEqualToString:@"addRelayTeamForCSegue"]) {
        
        
        // check if too many ceventscores from team in event (that one is is setupeventsforc i think
        //checks
        
        
    /////////  check if too many ceventscores in event
    
        
        
        
        
        int limitperteam = [self.eventObject.gEvent.competitorsPerTeam intValue ];
        if (limitperteam != 0) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        NSEntityDescription *description = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];


            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(team == %@)", self.competitorObject.team];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(event == %@)", self.eventObject];
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

    
        //////////////
        
        
        
        
        ////////////
    }
    
    return YES;              
}


#pragma mark - MeetAddViewControllerUnwinds

- (IBAction)unwindToPickRelayTeamForCDone:(UIStoryboardSegue *)unwindSegue
{


    if ([unwindSegue.sourceViewController isKindOfClass:[addRelayTeamForCViewController class]])
    {
        // nslog(@"Coming from EventsForCAdd Done!");
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
        CEventScore *ceventscore = [NSEntityDescription insertNewObjectForEntityForName:@"CEventScore" inManagedObjectContext:context];
        
        addRelayTeamForCViewController *sourceViewController = unwindSegue.sourceViewController;
        
        
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
      
       ceventscore.relayDisc = sourceViewController.relayDiscTextField.text;
       
        
        ceventscore.team = self.competitorObject.team;
        ceventscore.meet = self.competitorObject.meet;
        
       
       
        
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
- (IBAction)unwindToPickRelayTeamForCCancel:(UIStoryboardSegue *)unwindSegue //not done
{

UIViewController* sourceViewController = unwindSegue.sourceViewController;

if ([sourceViewController isKindOfClass:[EventForCAddViewController class]])
    {
        // nslog(@"Coming from cEventScoreAdd Cancel!");
    }
}
@end
