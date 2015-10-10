//
//  EventScoreSheetViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 03/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "EventScoreCopySheetViewController.h"
#import "CompetitorScoreEnterViewController.h"
#import "HighJumpScoreEnterViewController.h"
#import "CompetitorAddInResultSheetViewController.h"
#import "EventScoreCopyTableViewCell.h"
#import "BackupCEventScore.h"
#import "BackupCompetitor.h"
#import "GEvent.h"
#import "Division.h"
#import "BackupEvent.h"
#import "Meet.h"

@interface EventScoreCopySheetViewController ()

@end

@implementation EventScoreCopySheetViewController

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
        _eventObject = _detailItem;
        // Update the view.
        [self configureView];
        
       
        
    }
}



- (void)configureView
{


    // Update the user interface for the detail item.
    if (_detailItem) {
     
      
      NSString *eventname = [NSString stringWithFormat:@"%@ %@",self.eventObject.gEvent.gEventName, self.eventObject.division.divName];
      _navBar.title = eventname;

      //  // nslog(@"Event Name: %@ comp per team: %@  max scoring competitors: %@ scorefor first place: %@ decrementperplace: %@ scoreMultiplier: %@",self.eventObject.gEvent.gEventName, self.eventObject.gEvent.competitorsPerTeam,self.eventObject.gEvent.maxScoringCompetitors,self.eventObject.gEvent.scoreForFirstPlace,self.eventObject.gEvent.decrementPerPlace,self.eventObject.gEvent.scoreMultiplier);



    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
  
    
    
    [self configureView];
}

- (void) viewWillAppear:(BOOL)animated{
    
    
    
    
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

- (EventScoreCopyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventScoreCopyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventScoreCopyCell" forIndexPath:indexPath];
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
    NSLog(@"heeeereee");
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"BackupCEventScore" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
     // limit to those entities that belong to the particular item
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(backupEvent == %@)", self.eventObject];
    [fetchRequest setPredicate:predicate];
    
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

- (void)configureCell:(EventScoreCopyTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    BackupCEventScore *ceventscore = (BackupCEventScore*)object;
  
     NSString* compName  = ceventscore.backupCompetitor.compName;
    NSString* compTeam  = ceventscore.backupCompetitor.teamName;
     cell.competitorNameLabel.text = compName;
    cell.competitorTeamLabel.text = compTeam;
    
    
    
    if (ceventscore.result) {
       cell.competitorResultLabel.text = [ceventscore.result description];
       // nslog(@"results %@", ceventscore.result);
    }
    else
    {
        cell.competitorResultLabel.text = @"";
    }
    if (ceventscore.placing) {
        cell.competitorPlaceLabel.text = [ceventscore.placing description];
    }
    else
    {
        cell.competitorPlaceLabel.text = @"";
    }
    if (ceventscore.score) {
        cell.competitorScoreLabel.text = [ceventscore.score description];
    }
    else
    {
        cell.competitorScoreLabel.text = @"";
    }


    


}
#pragma mark - Segues

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
       NSLog(@"no interaction");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

    
    if ([[segue identifier] isEqualToString:@"unwindToEnterResultsSegue"]) {
        
        // set stuff here to restore backup event?


        
        
        
        self.eventObject.eventDone = [NSNumber numberWithBool:YES];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
          //  abort();
        }
        
    }
    
}




@end
