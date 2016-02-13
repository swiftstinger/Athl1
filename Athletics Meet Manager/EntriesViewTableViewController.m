//
//  EntriesViewTableViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 18/01/2016.
//  Copyright (c) 2016 rudi huysamen. All rights reserved.
//

#import "EntriesViewTableViewController.h"
#import "EntriesViewTableViewCell.h"
#import "EventScoreAddViewController.h"
#import "CompetitorAddInResultSheetViewController.h"
#import "EditRelayDiscViewController.h"
#import "GEvent.h"
#import "Entry.h"
#import "Competitor.h"
#import "Division.h"
#import "Event.h"
#import "CEventScore.h"


@interface EntriesViewTableViewController ()

@end

@implementation EntriesViewTableViewController

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
        _cScoreItem = _detailItem;
        _eventObject = _cScoreItem.event;
        
        NSLog(@"score event div %@  event gevent %@ ", _cScoreItem.event.division.divName, _eventObject.gEvent.gEventName);
        
        // Update the view.
        [self configureView];
        NSLog(@"in entryview");
       
        
    }
}



- (void)configureView
{


    // Update the user interface for the detail item.
    if (_cScoreItem) {
     
     NSString *discText;
     
        if ([self.eventObject.gEvent.gEventType isEqualToString:@"Relay" ]) {
            discText = self.cScoreItem.relayDisc;
            self.editRelayDiscButton.title = @"Edit Relay Disc";
            self.editRelayDiscButton.enabled = true;
        }
        else
        {
            discText = self.cScoreItem.team.teamName;
            self.editRelayDiscButton.title = @"";
            self.editRelayDiscButton.enabled = false;
        
        }
      
      _navBar.title = discText;

      
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if ([self.eventObject.gEvent.gEventType isEqualToString:@"Relay"]) {
        self.addButton.enabled = true;
    }
    else
    {
        if ([self.cScoreItem.entries count] > 0) {
            self.addButton.enabled = false;
        }
    
        
    }
    
    
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

- (EntriesViewTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EntriesViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"entryCell" forIndexPath:indexPath];
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
        
        if ([self.eventObject.gEvent.gEventType isEqualToString:@"Relay"]) {
            //set limit mabe
            self.addButton.enabled = true;
        }
        else
        {
            self.addButton.enabled = true;
        }
        
                self.cScoreItem.edited = [NSNumber numberWithBool:YES];
                self.cScoreItem.editDone = [NSNumber numberWithBool:NO];
                self.eventObject.edited = [NSNumber numberWithBool:YES];
                self.eventObject.editDone = [NSNumber numberWithBool:NO];
        
        
        
   
            
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
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
     // limit to those entities that belong to the particular item
NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(cEventScore == %@)", self.cScoreItem];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
   NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"entryID" ascending:YES];
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

- (void)configureCell:(EntriesViewTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    Entry *entry = (Entry*)object;
    
    
    Competitor* comp = entry.competitor;
    
    
     NSString* compName  = comp.compName;

    
    NSString* compTeam  = entry.cEventScore.team.teamName;
    
    cell.Title.text = compName;
    cell.subtitle.text = compTeam;

  }


/////////
///////
/////////

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

    if ([[segue identifier] isEqualToString:@"pickCompRelay"]) {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        EventScoreAddViewController* eventScoreAddController = (EventScoreAddViewController*)[navController topViewController];
        
        [eventScoreAddController setEventObject:self.eventObject];
        [eventScoreAddController setTeamObject:self.cScoreItem.team];
        
        [eventScoreAddController setManagedObjectContext:self.managedObjectContext];
    }
    
    
    if ([[segue identifier] isEqualToString:@"editRelayDiscSegue"]) {
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
        EditRelayDiscViewController* editRelayDiscController = (EditRelayDiscViewController*)[navController topViewController];
        
       
        [editRelayDiscController setDetailItem:self.cScoreItem];
        
        [editRelayDiscController setManagedObjectContext:self.managedObjectContext];
    }
}


/////////
////////


- (IBAction)unwindToEntriesViewSheetDone:(UIStoryboardSegue *)unwindSegue
{


    if ([unwindSegue.sourceViewController isKindOfClass:[EventScoreAddViewController class]])
    {
        NSLog(@"from comp pick picked ");
        
        // add entry with comp in source viewcontroller to ceventscore here
        
        EventScoreAddViewController *sourceViewController = unwindSegue.sourceViewController;
        
        Competitor* comp = sourceViewController.competitorObject;
        
        CEventScore* cscore = self.cScoreItem;
        
        
        //////  Entry Add
            
            
                Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
        
                
                ////////
                /////   set values
                ///////
                
              
                entry.edited = [NSNumber numberWithBool:YES];
                entry.editDone = [NSNumber numberWithBool:NO];
                self.cScoreItem.edited = [NSNumber numberWithBool:YES];
                self.cScoreItem.editDone = [NSNumber numberWithBool:NO];
                self.eventObject.edited = [NSNumber numberWithBool:YES];
                self.eventObject.editDone = [NSNumber numberWithBool:NO];
                 //////
                // link relationships
                /////
                
               
                
                entry.competitor = comp;
                entry.cEventScore = cscore;
                entry.meet = self.cScoreItem.meet;
                
                
                
                //////
                
                         // Store entryID data
          
              
                
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
             
              int tempint =  [self.eventObject.meet.meetID intValue];
             
              NSString *keystring = [NSString stringWithFormat:@"%dlastentryID",tempint];  ////
             
             // nslog(@"%@",keystring);
             
             if (![defaults objectForKey:keystring]) {                    /////
             
             int idint = 0;
             NSNumber *idnumber = [NSNumber numberWithInt:idint];
             [defaults setObject:idnumber forKey:keystring];             ///////
             
             }
                NSNumber* oldnumber = [defaults objectForKey:keystring];   ///
                int oldint = [oldnumber intValue];
                int newint = oldint + 1;
                NSNumber* newnumber = [NSNumber numberWithInt:newint];
               entry.entryID = newnumber;                  //////////
               

            [defaults setObject: newnumber forKey:keystring];            /////////
             
            [defaults synchronize];
         
            ////
            
            
        
                NSError *error = nil;

        
       // [self setAllEditedAndNotDoneForEvent:self.eventObject]; ???

        // Save the context.
        
            if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
        
    

        
        
        /////
        ////
        
         if ([self.eventObject.gEvent.gEventType isEqualToString:@"Relay"]) {
            //set limit mabe
            self.addButton.enabled = true;
        }
        else
        {
            self.addButton.enabled = false;
        }
        
    }
    if ([unwindSegue.sourceViewController isKindOfClass:[CompetitorAddInResultSheetViewController class]])
    {
        NSLog(@"from comp added  ");
        
        // add new comp , add entry with comp  to ceventscore here
        
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
                
                newcompetitorObject.team = sourceViewController.teamItem;
                newcompetitorObject.meet = self.eventObject.meet;
                newcompetitorObject.teamName = sourceViewController.teamItem.teamName;
                newcompetitorObject.edited = [NSNumber numberWithBool:YES];
                newcompetitorObject.editDone = [NSNumber numberWithBool:NO];
                
                
                
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
            
            
            
            
            
        
                
                
        
                self.cScoreItem.competitor = newcompetitorObject;
        
                
                
        
             //////
            //////  Entry Add
            
            
                Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:context];
                
                
                
                
                
                ////////
                /////   set values
                ///////
                
              
                entry.edited = [NSNumber numberWithBool:YES];
                entry.editDone = [NSNumber numberWithBool:NO];
                
                
                 //////
                // link relationships
                /////
                
               
                
                entry.competitor = newcompetitorObject;
                entry.cEventScore = self.cScoreItem;
                entry.meet = self.eventObject.meet;
                
                
                
                //////
                
                         // Store entryID data
          
              
                
            defaults = [NSUserDefaults standardUserDefaults];
            
             
              tempint =  [self.eventObject.meet.meetID intValue];
             
              keystring = [NSString stringWithFormat:@"%dlastentryID",tempint];  ////
             
             // nslog(@"%@",keystring);
             
             if (![defaults objectForKey:keystring]) {                    /////
             
             int idint = 0;
             NSNumber *idnumber = [NSNumber numberWithInt:idint];
             [defaults setObject:idnumber forKey:keystring];             ///////
             
             }
                oldnumber = [defaults objectForKey:keystring];   ///
                oldint = [oldnumber intValue];
                newint = oldint + 1;
                newnumber = [NSNumber numberWithInt:newint];
               entry.entryID = newnumber;                  //////////
               

            [defaults setObject: newnumber forKey:keystring];            /////////
             
            [defaults synchronize];
         
            ////
                 
                  

        
        
        
        
        
        
                self.cScoreItem.edited = [NSNumber numberWithBool:YES];
                self.cScoreItem.editDone = [NSNumber numberWithBool:NO];
                self.eventObject.edited = [NSNumber numberWithBool:YES];
                self.eventObject.editDone = [NSNumber numberWithBool:NO];
        
        
        
              NSError *error = nil;

        // Save the context.
            if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
        
        
        if ([self.eventObject.gEvent.gEventType isEqualToString:@"Relay"]) {
            //set limit mabe
            self.addButton.enabled = true;
        }
        else
        {
            self.addButton.enabled = false;
        }
        
    }
    if ([unwindSegue.sourceViewController isKindOfClass:[EditRelayDiscViewController class]])
    {
        NSLog(@"from edit relay disc done");
        
        // pull relay disc from textfield and add cscore. relay disc
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
        
        EditRelayDiscViewController *sourceViewController = unwindSegue.sourceViewController;
        
        self.cScoreItem.relayDisc = sourceViewController.textfield.text;
        
        
                self.cScoreItem.edited = [NSNumber numberWithBool:YES];
                self.cScoreItem.editDone = [NSNumber numberWithBool:NO];
                self.eventObject.edited = [NSNumber numberWithBool:YES];
                self.eventObject.editDone = [NSNumber numberWithBool:NO];
        
        
        
                NSError *error = nil;

        // Save the context.
            if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
        
            NSString *discText = self.cScoreItem.relayDisc;
    
            _navBar.title = discText;
  
    }

    
    
}

- (IBAction)unwindToEntriesViewSheetCancel:(UIStoryboardSegue *)unwindSegue
{


    if ([unwindSegue.sourceViewController isKindOfClass:[EventScoreAddViewController class]])
    {
        NSLog(@"from comp pick cancelled /eventscoreadd cancelled");
    }
    if ([unwindSegue.sourceViewController isKindOfClass:[EditRelayDiscViewController class]])
    {
        NSLog(@"from edit relay disc cancelled");
    }
    
}
@end
