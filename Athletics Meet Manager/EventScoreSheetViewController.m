//
//  EventScoreSheetViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 03/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "EventScoreSheetViewController.h"
#import "CompetitorScoreEnterViewController.h"
#import "HighJumpScoreEnterViewController.h"
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

        NSLog(@"Event Name: %@ comp per team: %@  max scoring competitors: %@ scorefor first place: %@ decrementperplace: %@ scoreMultiplier: %@",self.eventObject.gEvent.gEventName, self.eventObject.gEvent.competitorsPerTeam,self.eventObject.gEvent.maxScoringCompetitors,self.eventObject.gEvent.scoreForFirstPlace,self.eventObject.gEvent.decrementPerPlace,self.eventObject.gEvent.scoreMultiplier);



    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    
    
    [self configureView];
}

- (void) viewWillAppear:(BOOL)animated{
    
    [self setResultsMain];
    
    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        CEventScore * ceventscore = (CEventScore*)object;

        NSString *eventtypestring = ceventscore.event.gEvent.gEventType;
   
                if ([eventtypestring isEqualToString:@"Track"] ) {
                        [self performSegueWithIdentifier:@"enterResult" sender:self];

                }
                else if ([eventtypestring isEqualToString:@"Field"]){
                     [self performSegueWithIdentifier:@"enterResult" sender:self];

    
                }
                else if ([eventtypestring isEqualToString:@"High Jump"]){
                     [self performSegueWithIdentifier:@"enterHighJumpResult" sender:self];
    
                }
                else
                {
                    NSLog(@"whooooops geventtyp not either %@", eventtypestring);
                }



    
    NSLog(@"in tap and event is %@", eventtypestring);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

    if ([[segue identifier] isEqualToString:@"enterResult"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
        
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    }
    if ([[segue identifier] isEqualToString:@"enterHighJumpResult"]) {
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
    
    
    if ([[segue identifier] isEqualToString:@"unwindToEnterResultsSegue"]) {
        
        self.eventObject.eventDone = [NSNumber numberWithBool:YES];
        NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
}




#pragma mark - MeetAddViewControllerUnwinds

- (IBAction)unwindToEventScoreSheetDone:(UIStoryboardSegue *)unwindSegue
{
    
    
    if ([unwindSegue.sourceViewController isKindOfClass:[CompetitorAddInResultSheetViewController class]])
        {
        NSLog(@"Coming from CompertitorAddInResults Done!");
        self.eventObject.eventEdited = [NSNumber numberWithBool:YES];
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
        [ceventscore setValue: NULL forKey:@"result"];
       [ceventscore setValue:NULL forKey:@"personalBest"];
       [ceventscore setValue:NULL forKey:@"placing"];
       [ceventscore setValue:NULL forKey:@"score"];
       [ceventscore setValue:NULL forKey:@"resultEntered"];
        
        
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
        self.eventObject.eventEdited = [NSNumber numberWithBool:YES];
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
        CEventScore *ceventscore = [NSEntityDescription insertNewObjectForEntityForName:@"CEventScore" inManagedObjectContext:context];
        
        
        EventScoreAddViewController *sourceViewController = unwindSegue.sourceViewController;
        ////////
        /////   set values
        ///////
     [ceventscore setValue: NULL forKey:@"result"];
       [ceventscore setValue:NULL forKey:@"personalBest"];
       [ceventscore setValue:NULL forKey:@"placing"];
       [ceventscore setValue:NULL forKey:@"score"];
       [ceventscore setValue:NULL forKey:@"resultEntered"];
    
     
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
        self.eventObject.eventEdited = [NSNumber numberWithBool:YES];
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
   
   if ([unwindSegue.sourceViewController isKindOfClass:[HighJumpScoreEnterViewController class]])
    {
        NSLog(@"Coming from competitorscoreneter  in eventscoresheet Done!");
        self.eventObject.eventEdited = [NSNumber numberWithBool:YES];
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

/////


// results calculate


//////


- (void) setResultsMain {
    
    /*
    
    if ([_eventObject.gEvent.gEventType isEqualToString:@"Track"] ) {
        
        [self resultsCalculateNormal];
        
    }
    else if ([_eventObject.gEvent.gEventType isEqualToString:@"Field"]){
        
        [self resultsCalculateNormal];
        
    }
    else if ([_eventObject.gEvent.gEventType isEqualToString:@"High Jump"]){
    
        [self resultsCalculateHighJump];
    
    }
    else
    {
        NSLog(@"whooooops geventtyp not either %@", _eventObject.gEvent.gEventType);
    }


   */
    [self resultsCalculate];
    
    NSError *error = nil;
        if (![self.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }



}
- (void) resultsCalculate {
Event * event = _eventObject;


            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];

           NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(result != NULL)", nil];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(event == %@)", event];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];
    
    
               NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"result" ascending:NO];
                NSSortDescriptor *lowestToHighest = [NSSortDescriptor sortDescriptorWithKey:@"result" ascending:YES];
    
                NSSortDescriptor *sorter;
    
                if ([event.gEvent.gEventType isEqualToString:@"Track"] ) {
                    sorter = lowestToHighest;
                }
                else if ([event.gEvent.gEventType isEqualToString:@"Field"]){
                    sorter = highestToLowest;
    
                }
                else if ([event.gEvent.gEventType isEqualToString:@"High Jump"]){
                    sorter = highestToLowest;
    
                }
                else
                {
                    NSLog(@"whooooops geventtyp not either %@", event.gEvent.gEventType);
                    }
    
    
                NSArray *sortDescriptors = @[sorter];
    
                [fetchRequest setSortDescriptors:sortDescriptors];


            NSError *error;
                NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
   
    
    
   /////
   int topresult;
   int decreaseMultiplier = [event.gEvent.decrementPerPlace intValue];
   
    int numberOfTeams = [self getTeamNumberWithEventObject: event];
    
    
    if ([event.gEvent.scoreForFirstPlace intValue] != 0) {
        topresult = [event.gEvent.scoreForFirstPlace intValue];
        NSLog(@"top results set");
    }
    else
    {
       if  ([event.gEvent.maxScoringCompetitors intValue] != 0) {
       
            topresult = [event.gEvent.maxScoringCompetitors intValue] * numberOfTeams;
            NSLog(@"top results maxscore");
       
       }
       else
       {
            if ([event.gEvent.competitorsPerTeam intValue] != 0) {
    
                topresult = [event.gEvent.competitorsPerTeam intValue] * numberOfTeams;
                NSLog(@"top results cperteam");
            }
            else
            {
                topresult = [results count];
                NSLog(@"top results count");
            }
           
       }
        
    
    }
    
    
    //////
    
    
   
    int count = 0;
    int score;
    double placing;
    int lastplacegiven = 0;
    int lastscoregiven = 0;
    NSNumber *lastResult = 0;
    NSNumber *currentResult;
    BOOL lastplacemanual = NO;
    
    for(CEventScore *object in results) {
       
         currentResult = object.result;
       // [number1 doubleValue] < [number2 doubleValue]
       if (![object.highJumpPlacingManual boolValue]) {
        
            if ([currentResult doubleValue] == [lastResult doubleValue]) {
                NSLog(@"same lastResult %@ currentResult %@", lastResult,currentResult);
               
                if (lastplacemanual){
                    placing = lastplacegiven + 1;
                    score = topresult - ((placing - 1) * decreaseMultiplier);
                    NSLog(@" manual and last place given %d", lastplacegiven);
                                    }
                else
                {
                score = lastscoregiven;
                placing = lastplacegiven;
                NSLog(@"not manual and last place given %d", lastplacegiven);

                }
            }
            else
            {
                NSLog(@"not same lastResult %@ currentResult %@", lastResult,currentResult);
                
                placing = count + 1;
                score = topresult - ((placing - 1) * decreaseMultiplier);
                
                NSLog(@"not manual and last place given %d", lastplacegiven);
            }
            lastplacegiven = placing;
            lastscoregiven = score;
            lastResult = currentResult;
           lastplacemanual = NO;
           
        }
        else
        {
        
        NSLog(@"manual");
            placing = [object.placing intValue];
            score = topresult - ((placing - 1) * decreaseMultiplier);
            lastResult = currentResult;
           lastplacemanual = YES;
        }
        
        count++;
        
        
        
        object.placing = [NSNumber numberWithInt:placing];
        
        if (!(score > 0)) {
            score = 0;
        }
        
        object.score = [NSNumber numberWithInt:score];

        NSLog(@" score ranking =  %@  and Points =  %@",object.placing,object.score);
    }

}
-(int) getTeamNumberWithEventObject:(Event*) object {

Meet* meet = object.meet;
NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        NSEntityDescription *description = [NSEntityDescription entityForName:@"Team" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];


            NSPredicate *pred = [NSPredicate predicateWithFormat:@"(meet == %@)", meet];
           // NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(event == %@)", self.event];
           // NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
          //  NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:pred];


            NSError *err;
            NSUInteger teamcount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&err];
        
        
            if(teamcount == NSNotFound) {
                //Handle error
            }
            int intvalue = (int)teamcount;

return intvalue;

}

@end
