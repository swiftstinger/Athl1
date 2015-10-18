//
//  EventScoreAddViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 03/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "EventScoreAddViewController.h"
#import "CompetitorAddInResultSheetViewController.h"
#import "GEvent.h"
#import "Team.h"
#import "Meet.h"

@interface EventScoreAddViewController ()
@property (nonatomic, strong) NSFetchedResultsController *searchFetchedResultsController;

- (void)fetchedResultsController:(NSFetchedResultsController *)controller configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation EventScoreAddViewController

#pragma mark - Managing the managedobjectcontext item

- (void)setManagedObjectContext:(NSManagedObjectContext *)newcontext
{
 // nslog(@"not added context");
    if (_managedObjectContext != newcontext) {
        _managedObjectContext = newcontext;
        // nslog(@"adding context");
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
        _eventObject = _detailItem;
        
        // Update the view.
        [self configureView];
        
       
        
    }
}



- (void)configureView
{


    // Update the user interface for the detail item.
    if (_detailItem) {
        
      

    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Actions



#pragma mark - Table View

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView
{
    return [tableView isEqual:self.tableView] ? self.fetchedResultsController : self.searchFetchedResultsController;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[self fetchedResultsControllerForTableView:tableView] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self fetchedResultsControllerForTableView:tableView] sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.tableView]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SearchCell"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    [self fetchedResultsController:[self fetchedResultsControllerForTableView:tableView] configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return [tableView isEqual:self.tableView];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
       if ([self shouldPerformSegueWithIdentifier:@"competitorSelectedSegue" sender:self]) {
            [self performSegueWithIdentifier:@"competitorSelectedSegue" sender:self];
        }
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Competitor" inManagedObjectContext: self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
 
    
    NSArray *array = [self.eventObject.cEventScores allObjects];
    
  
    
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(meet == %@) AND (SUBQUERY(cEventScores, $x, $x IN %@).@count < 1)",self.eventObject.meet, array];
    
 
   
    
    
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSString *sortKey =  @"teamName";
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
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

- (NSFetchedResultsController *)searchFetchedResultsController
{
    if (_searchFetchedResultsController != nil) {
        return _searchFetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Competitor" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    
    //   [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Get the search string and set the predicate.
    NSString *searchText = self.searchDisplayController.searchBar.text;
    if ([searchText length] > 0) {
        
       

        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"teamName contains[cd] %@", searchText];

        
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"compName contains[cd] %@", searchText];

        NSArray *preds1 = [NSArray arrayWithObjects: pred1,pred2, nil];
        NSPredicate *orPred = [NSCompoundPredicate orPredicateWithSubpredicates:preds1];

        
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"(meet == %@)", self.eventObject.meet];
        
        NSArray *preds2 = [NSArray arrayWithObjects: orPred,pred3, nil];
        NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds2];

        
        [fetchRequest setPredicate:andPred];
    
    }
    else
    {
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(meet == %@)", self.eventObject.meet];
     [fetchRequest setPredicate:pred1];
    }
    
    
    
    
    
    
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"compName" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self;
    self.searchFetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.searchFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
	  //  abort();
	}
    
    return _searchFetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = [controller isEqual:self.fetchedResultsController] ? self.tableView : self.searchDisplayController.searchResultsTableView;
    [tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = [controller isEqual:self.fetchedResultsController] ? self.tableView : self.searchDisplayController.searchResultsTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = [controller isEqual:self.fetchedResultsController] ? self.tableView : self.searchDisplayController.searchResultsTableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self fetchedResultsController:controller configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    UITableView *tableView = [controller isEqual:self.fetchedResultsController] ? self.tableView : self.searchDisplayController.searchResultsTableView;
    [tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (void)fetchedResultsController:(NSFetchedResultsController *)controller configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [controller objectAtIndexPath:indexPath];
    Competitor* comp = (Competitor*) object;
    cell.textLabel.text = [comp.compName description];
    cell.detailTextLabel.text = [comp.team.teamName description];
}

#pragma mark -
#pragma mark UISeachDisplayDelegate methods

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView
{
    self.searchFetchedResultsController = nil;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    self.searchFetchedResultsController = nil;
    return YES;
}


/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"competitorSelectedSegue"]) {
        UITableView *tableView = [sender isEqual:self] ? self.searchDisplayController.searchResultsTableView : self.tableView;
        
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
        
        self.competitorObject = (Competitor*)object;
        
    }
}
*/
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   // nslog(@"hahhhhhhhhhhhhhhhhhh");
    
    if ([identifier isEqualToString:@"competitorSelectedSegue"]) {
        
        UITableView *tableView = [sender isEqual:self] ? self.searchDisplayController.searchResultsTableView : self.tableView;
        
        NSIndexPath *indexPath = [tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
        
        self.competitorObject = (Competitor*)object;
// nslog(@"competitor selected and object name is %@", self.competitorObject.compName);
      //  self.eventObject
        
        
        
        
        
        if ([[self.competitorObject valueForKeyPath:@"cEventScores.event"] containsObject:self.eventObject]) {
            dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController * alert =   [UIAlertController
                                    alertControllerWithTitle:@"Chosen competitor is already competing in this event."
                                    message:@"Please pick a different competitor"
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
        

   
        
       
        
        
   /////////////
   ///////////// //check 1 competitors per team
   /////////////
        
        Team *team = self.competitorObject.team;
        
        int limitperteam = [self.eventObject.gEvent.competitorsPerTeam intValue ];
    
    
        if (limitperteam != 0) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];


            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(team == %@)", team];
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
    
               //self.competitorObject = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"Already too many competitors from this team in the Event"
                                    message:@"Please delete a competitor from this event or change the number of competitors allowed per team for this event"
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
        
   /////////////
   /////////////
   /////////////
        
        int limitpercompetitor =  [self.competitorObject.meet.cEventLimit intValue];
        if (limitpercompetitor != 0) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];


            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(competitor == %@)", self.competitorObject];
            

            [fetchRequest setPredicate:pred1];


            NSError *err;
            NSUInteger eventscorecountforc = [self.managedObjectContext countForFetchRequest:fetchRequest error:&err];
        
        
            if(eventscorecountforc == NSNotFound) {
                //Handle error
            }
        
    
    
    
    
            int currentEventNumber = (int)eventscorecountforc ;
        
     
        
            
            if (!(limitpercompetitor>currentEventNumber)) {
    
              // self.competitorObject = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"This competitor is already in too many events"
                                    message:@"Please remove competitor from another event or change the number of events allowed per competitor"
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

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

    
    if ([[segue identifier] isEqualToString:@"competitorAddInResultsSegue"]) {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        CompetitorAddInResultSheetViewController* competitorAddController = (CompetitorAddInResultSheetViewController*)[navController topViewController];
        
        
        [competitorAddController setDetailItem:self.eventObject];
         // nslog(@"not added context");
        [competitorAddController setManagedObjectContext:self.managedObjectContext];
    }
    
}

- (IBAction)unwindToEventScoreAddCancel:(UIStoryboardSegue *)unwindSegue
{

UIViewController* sourceViewController = unwindSegue.sourceViewController;

if ([sourceViewController isKindOfClass:[CompetitorAddInResultSheetViewController class]])
    {
        // nslog(@"Coming from CompertitorAddInResults Cancel!");
    }
    
   
}

@end
