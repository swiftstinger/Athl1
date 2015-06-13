//
//  EventScoreSheetViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 03/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "EventScoreSheetViewController.h"
#import "CompetitorScoreEnterViewController.h"
#import "CompetitorAddInResultSheetViewController.h"
#import "EventScoreTableViewCell.h"
#import "CEventScore.h"
#import "Competitor.h"
#import "GEvent.h"
#import "Division.h"
#import "Event.h"
#import "Meet.h"

@interface EventScoreSheetViewController ()

@end

@implementation EventScoreSheetViewController

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

- (EventScoreTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"eventScoreCell" forIndexPath:indexPath];
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
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(event == %@)", self.eventObject];
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

- (void)configureCell:(EventScoreTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    CEventScore *ceventscore = (CEventScore*)object;
  
     NSString* compName  = ceventscore.competitor.compName;
    NSString* compTeam  = ceventscore.competitor.teamName;
     cell.competitorNameLabel.text = compName;
    cell.competitorTeamLabel.text = compTeam;
    
    
    
    if (ceventscore.result) {
       cell.competitorResultLabel.text = [ceventscore.result description];
       NSLog(@"results %@", ceventscore.result);
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

    if ([[segue identifier] isEqualToString:@"enterResult"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
        
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    }
    
    if ([[segue identifier] isEqualToString:@"eventScoreAdd"]) {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        EventScoreAddViewController* eventScoreAddController = (EventScoreAddViewController*)[navController topViewController];
        
        
        [eventScoreAddController setDetailItem:self.eventObject];
         NSLog(@"not added context");
        [eventScoreAddController setManagedObjectContext:self.managedObjectContext];
    }
    
}




#pragma mark - MeetAddViewControllerUnwinds

- (IBAction)unwindToEventScoreSheetDone:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.sourceViewController isKindOfClass:[CompetitorAddInResultSheetViewController class]])
    {
        NSLog(@"Coming from CompertitorAddInResults Done!");
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    CompetitorAddInResultSheetViewController *sourceViewController = unwindSegue.sourceViewController;
    
    /////
    // ad new competitor chosen in source
    ////
    ////
    ////
    ////
    ///
        

    
     Competitor* newcompetitorObject = [NSEntityDescription insertNewObjectForEntityForName:@"Competitor" inManagedObjectContext:context];
        
        
        ////////
        /////   set values
        ///////
     
           if (sourceViewController.competitorName) {
        [newcompetitorObject setValue: sourceViewController.competitorName.text forKey:@"compName"];
    
        }
        
        
        
         //////
        // link relationships
        /////
        
        newcompetitorObject.team = sourceViewController.team;
        newcompetitorObject.meet = self.eventObject.meet;
        newcompetitorObject.teamName = sourceViewController.team.teamName;
       
        
        
        
        
        //////
        
          // Store CompID data

     
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
  
     int tempint =  [self.eventObject.meet.meetID intValue];
     
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
       [newcompetitorObject setValue: newnumber forKey: @"compID"];                  //////////
     

    [defaults setObject: newnumber forKey:keystring];            /////////
     
    [defaults synchronize];
  
    ////
    
    
    
    ////////
    ///////
    ///////
    ///////
    //////
    //////
    
    
        CEventScore *ceventscore = [NSEntityDescription insertNewObjectForEntityForName:@"CEventScore" inManagedObjectContext:context];
        
        
        
        
        
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
        
       
        
        ceventscore.competitor = newcompetitorObject;
        ceventscore.event = self.eventObject;
        ceventscore.meet = self.eventObject.meet;
        ceventscore.team = sourceViewController.team;
        //////
        
                 // Store cEventsScoreID data
  
      
        
    defaults = [NSUserDefaults standardUserDefaults];
    
     
      tempint =  [self.eventObject.meet.meetID intValue];
     
      keystring = [NSString stringWithFormat:@"%dlastcEventScoreID",tempint];  ////
     
     NSLog(@"%@",keystring);
     
     if (![defaults objectForKey:keystring]) {                    /////
     
     int idint = 0;
     NSNumber *idnumber = [NSNumber numberWithInt:idint];
     [defaults setObject:idnumber forKey:keystring];             ///////
     
     }
        oldnumber = [defaults objectForKey:keystring];   ///
        oldint = [oldnumber intValue];
        newint = oldint + 1;
        newnumber = [NSNumber numberWithInt:newint];
       [ceventscore setValue: newnumber forKey: @"cEventScoreID"];                  //////////
       

    [defaults setObject: newnumber forKey:keystring];            /////////
     
    [defaults synchronize];
 
    ////
    
        
                NSError *error = nil;

        
        

        // Save the context.
        
            if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
        
    }

    if ([unwindSegue.sourceViewController isKindOfClass:[EventScoreAddViewController class]])
    {
        NSLog(@"Coming from EventScoreAdd Done!");
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
        CEventScore *ceventscore = [NSEntityDescription insertNewObjectForEntityForName:@"CEventScore" inManagedObjectContext:context];
        
        
        EventScoreAddViewController *sourceViewController = unwindSegue.sourceViewController;
        ////////
        /////   set values
        ///////
     [ceventscore setValue: nil forKey:@"result"];
       [ceventscore setValue:nil forKey:@"personalBest"];
       [ceventscore setValue:nil forKey:@"placing"];
       [ceventscore setValue:nil forKey:@"score"];
       [ceventscore setValue:nil forKey:@"resultEntered"];
    
     
       /*
     
        [ceventscore setValue:[NSNumber numberWithDouble:0] forKey:@"results"];
       [ceventscore setValue:[NSNumber numberWithDouble:0] forKey:@"personalBest"];
       [ceventscore setValue:[NSNumber numberWithInt: 0] forKey:@"placing"];
       [ceventscore setValue:[NSNumber numberWithInt: 0] forKey:@"score"];
       [ceventscore setValue:[NSNumber numberWithBool: NO] forKey:@"resultEntered"];
      */
        
        
        
        //validation in source
             //   ceventscore.result = [NSNumber numberWithDouble:  sourceViewController.result]   ;
        
        
         //////
        // link relationships
        /////
        
       
        
        ceventscore.competitor = sourceViewController.competitorObject;
        ceventscore.event = self.eventObject;
        ceventscore.meet = self.eventObject.meet;
        ceventscore.team = sourceViewController.competitorObject.team;
        //////
        
          // Store cEventsScoreID data
  
      
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
     
     int tempint =  [self.eventObject.meet.meetID intValue];
     
     NSString * keystring = [NSString stringWithFormat:@"%dlastcEventScoreID",tempint];  ////
     
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
       [ceventscore setValue: newnumber forKey: @"cEventScoreID"];                  //////////
        NSLog(@"compname %@  cEventScoreID %@", sourceViewController.competitorObject.compName, ceventscore.cEventScoreID);

    [defaults setObject: newnumber forKey:keystring];            /////////
     
    [defaults synchronize];
 
    ////
    
        
                NSError *error = nil;

        
        

        // Save the context.
        
            if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
        
    }
   
   
   if ([unwindSegue.sourceViewController isKindOfClass:[CompetitorScoreEnterViewController class]])
    {
        NSLog(@"Coming from competitorscoreneter  in eventscoresheet Done!");
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
        
        CompetitorScoreEnterViewController *sourceViewController = unwindSegue.sourceViewController;
        
        CEventScore *ceventscore = sourceViewController.cEventScore;
        
        
        ////////
        /////   set values
        ///////
        
        //validation in source
        NSLog(@"source results %f",sourceViewController.result);
        ceventscore.result = [NSNumber numberWithDouble:  sourceViewController.result];
    
        
            ////
    
        
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
- (IBAction)unwindToEventScoreSheetCancel:(UIStoryboardSegue *)unwindSegue
{

UIViewController* sourceViewController = unwindSegue.sourceViewController;

if ([sourceViewController isKindOfClass:[EventScoreAddViewController class]])
    {
        NSLog(@"Coming from cEventScoreAdd  in eventscoresheet Cancel!");
    }
    
    if ([sourceViewController isKindOfClass:[CompetitorScoreEnterViewController class]])
    {
        NSLog(@"Coming from competitorscoreneter  in eventscoresheet Cancel!");
    }
}



@end
