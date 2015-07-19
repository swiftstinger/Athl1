//
//  FinalResultsViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "FinalResultsViewController.h"
#import "TeamDivResultViewController.h"
#import "TeamFinalResultsTableViewCell.h"
#import "Team.h"
#import "CEventScore.h"

@interface FinalResultsViewController ()

@end

@implementation FinalResultsViewController

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
    
    // nslog(@"nib");
    
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        _meetObject = _detailItem;
        // Update the view.
        [self configureView];
        
       
        
    }
    
    // nslog(@"setdetails");
}



- (void)configureView
{

// nslog(@"in view");
    // Update the user interface for the detail item.
    if (_detailItem) {
        _navBar.title = @"FINAL RESULTS";
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
  //  self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    for (Team *object in _meetObject.teams) {
        
        [self sumResultsForTeam:object];
    
    
    }
    
    for (Team *object in _meetObject.teams) {
        
        [self sumResultsForTeam:object];
    
    
    }
    
    [self setPlaceForTeamsInMeet:_meetObject];
    
    [self configureView];
    
    // nslog(@"viewdidload");
}

- (void) setPlaceForTeamsInMeet: (Meet*) meet {

            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"Team" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];

           NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(teamScore != NULL)", nil];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(meet == %@)", _meetObject];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];
    
    
               NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"teamScore" ascending:NO];

    
                NSArray *sortDescriptors = @[highestToLowest];
    
                [fetchRequest setSortDescriptors:sortDescriptors];


                NSError *error;
                NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    
    int count = 0;
   
    int placing;
    int lastplacegiven = 0;
    
    NSNumber *lastScore = 0;
    NSNumber *currentScore;
    for(Team *object in results) {
       
         currentScore = object.teamScore;
      //  score = score + [currentScore intValue];
        
        if ([currentScore intValue] == [lastScore intValue]) {
            // nslog(@"same lastScore %@ currentScore %@", lastScore,currentScore);
            
            placing = lastplacegiven;
        }
        else
        {
        // nslog(@"not same lastScore %@ currentScore %@", lastScore,currentScore);
        
        placing = count + 1;
        }
        
        count++;
        
        lastplacegiven = placing;
        lastScore = currentScore;
        
        object.teamPlace = [NSNumber numberWithInt:placing];
        
        // nslog(@" team : %@  ranking =  %@  and Points =  %@",object.teamName, object.teamPlace,object.teamScore);
        
       
    }



}

- (void) sumResultsForTeam: (Team*) teamobject
{

  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];

           NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(score != NULL)", nil];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(team == %@)", teamobject];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];
    
    
               NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
                       NSArray *sortDescriptors = @[highestToLowest];
    
                [fetchRequest setSortDescriptors:sortDescriptors];


                NSError *error;
                NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
 
    
    
    int score = 0;

    NSNumber *currentScore;
    for(CEventScore *object in results) {
       
         currentScore = object.score;
        score = score + [currentScore intValue];
        
       }

teamobject.teamScore = [NSNumber numberWithInt:score];
// nslog(@" team : %@ score set at %@", teamobject.teamName,teamobject.teamScore);

}


- (void) viewDidAppear:(BOOL)animated {

// nslog(@"viewdidappear");
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

- (TeamFinalResultsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamFinalResultsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teamCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
          //  abort();
        }
        
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    // nslog(@"fetchresultscontroller");
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
   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"teamPlace" ascending:YES];
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

- (void)configureCell:(TeamFinalResultsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    Team * teamobject = (Team*) object;
  
// nslog(@"configurecell");
//

  
        cell.teamLabel.text = [[teamobject valueForKey:@"teamName"] description];
    
        cell.scoreLabel.text = [NSString stringWithFormat:@" Score: %@",  [[teamobject valueForKey:@"teamScore"] description]];

    
        cell.placeLabel.text = [NSString stringWithFormat:@" Place: %@",  [[teamobject valueForKey:@"teamPlace"] description]];



  }





#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

    if ([[segue identifier] isEqualToString:@"showTeamDivResults"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
       
        // nslog(@"in segue");
          [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
        
    }
    
  
    
}


@end
