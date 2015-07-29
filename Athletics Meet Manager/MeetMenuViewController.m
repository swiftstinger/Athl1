//
//  MeetMenuViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "MeetMenuViewController.h"
#import "MeetMenuViewCell.h"
#import "FinalResultsViewController.h"
#import "Division.h"
#import "Team.h"
#import "GEvent.h"
#import "CEventScore.h"
#import "Event.h"
#import "Competitor.h"
#import <CloudKit/CloudKit.h> 

@interface MeetMenuViewController ()

@end

@implementation MeetMenuViewController


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        _meetObject = _detailItem;
        
        
        
        // Update the view.
        [self configureView];
    }
}
#pragma mark - Managing the managedobjectcontext item

- (void)setManagedObjectContext:(NSManagedObjectContext *)newcontext
{
    if (_managedObjectContext != newcontext) {
        _managedObjectContext = newcontext;
        
    }
}

- (void)configureView
{

    // Update the user interface for the detail item.
    if (_detailItem) {
      _navBar.title = [self.meetObject valueForKey:@"meetName"];
      
   
      
        if (![self.meetObject.onlineMeet boolValue]) {
    
    
            self.sendPermissionButton.enabled = NO;
            self.shareOnlineButton.title = @"Share Online";
    
        }
        else
        {
            if ([self.meetObject.isOwner boolValue]) {
    
    
                self.sendPermissionButton.enabled = YES;
                self.shareOnlineButton.title = @"Unshare Meet";
            }
            else
            {
                self.sendPermissionButton.enabled = NO;
                self.shareOnlineButton.title = @"N/A";
                self.shareOnlineButton.enabled = NO;
                self.exportResultsButton.enabled = NO;
            }

        }
    

      
               /*
          self.titleField.text = [_detailItem valueForKey:@"title"];
        self.episodeIDField.text = [NSString stringWithFormat:@"%d", [[_detailItem valueForKey:@"episodeID"] integerValue]];
        self.descriptionView.text = [_detailItem valueForKey:@"desc"];
        self.firstRunSegmentedControl.selectedSegmentIndex = [[_detailItem valueForKey:@"firstRun"] boolValue];
        self.showTimeLabel.text = [[_detailItem valueForKey:@"showTime"] description];
        
        */
      
       

        
    }
}
- (void)viewWillAppear:(BOOL)animated
{

if ([[self.meetObject valueForKey: @"divsDone"] boolValue]) {
    
            self.groupDivCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            self.groupDivCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if ([[self.meetObject valueForKey: @"eventsDone"] boolValue]) {
            self.gEventCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            self.gEventCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if ([[self.meetObject valueForKey: @"teamsDone"] boolValue]) {
            self.enterTeamCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        else
        {
       
            self.enterTeamCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

if ([self.meetObject.onlineMeet boolValue]) {
    if (![self.meetObject.isOwner boolValue]) {
        self.groupDivCell.hidden = YES;
        self.gEventCell.hidden = YES;
        self.enterTeamCell.hidden = YES;
      //  self.finalResultCell.hidden = YES;
    }



}

}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
   //  // nslog(@"Teams in configure view: %lu",  (unsigned long)[self.meetObject.teams count]);
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *description = [NSEntityDescription entityForName:@"Team" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];


            NSPredicate *pred = [NSPredicate predicateWithFormat:@"(meet == %@)", self.meetObject];
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

      //   // nslog(@"Teams in configure view from fetch : %d",  intvalue);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

if (FALSE) {
    
}
else
{

    if ([[segue identifier] isEqualToString:@"finalResults"]) {
        // nslog(@"final results");
        
        
      
        UITabBarController *barController = (UITabBarController*)[segue destinationViewController];
        FinalResultsViewController* finalResultsController = (FinalResultsViewController*)[barController.viewControllers objectAtIndex:0];
       
        [finalResultsController setDetailItem:self.meetObject];
       
       [finalResultsController setManagedObjectContext:self.managedObjectContext];
     /*
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    */
}

    else
    {

        [[segue destinationViewController] setDetailItem:self.meetObject];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    // nslog(@"in segue in meetmenu prepareforsegue");
    }
  /*
    if ([[segue identifier] isEqualToString:@"divSetup"]) {
        
        [[segue destinationViewController] setDetailItem:self.meetObject];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];

    }
    */
}
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   
    
    if ([identifier isEqualToString:@"gEventsSetup"]) {
        
        //checks
        bool divsdone = [[self.meetObject valueForKey: @"divsDone"] boolValue];
        
        if (!divsdone) {
            
                UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"No Group Divisions Set Up"
                                    message:@"Please set up at least one Group Division for this Meet"
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
                return NO;
                }
                
    }
    if ([identifier isEqualToString:@"teamsSetup"]) {
        
        //checks
        bool divsdone = [[self.meetObject valueForKey: @"divsDone"] boolValue];
        bool eventsdone = [[self.meetObject valueForKey: @"eventsDone"] boolValue];
        
        if (!divsdone && !eventsdone) {
            
            UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"No Group Divisions or Events Set Up"
                                    message:@"Please set up at least one Group Division and at least on Event for this Meet"
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
                return NO;
            
        }
        else
        {
        
        
            if (!eventsdone) {
            
                UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"No Events Set Up"
                                    message:@"Please set up at least one Event for this Meet"
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
                return NO;

            
            }
            else if (!divsdone)
            {
              UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"No Divisions Set Up"
                                    message:@"Please set up at least one Division for this Meet"
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
                return NO;

            }
          
        }
                
    }

    if ([identifier isEqualToString:@"enterResults"]) {
        
        //checks
        bool divsdone = [[self.meetObject valueForKey: @"divsDone"] boolValue];
        bool eventsdone = [[self.meetObject valueForKey: @"eventsDone"] boolValue];
        bool teamsdone = [[self.meetObject valueForKey: @"teamsDone"] boolValue];
        
        if (!divsdone && !eventsdone && !teamsdone) {
            
            UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"No Group Divisions, Events or Teams Set Up"
                                    message:@"Please set up at least one Group Division, Event and Team for this Meet"
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
                return NO;
            
        }
        else
        {
            if (!divsdone && !eventsdone) {
            
                UIAlertController * alert=   [UIAlertController
                                        alertControllerWithTitle:@"No Group Divisions or Events Set Up"
                                        message:@"Please set up at least one Group Division and at least on Event for this Meet"
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
                        return NO;
            
            }
            else if (!divsdone && !teamsdone) {
            
                UIAlertController * alert=   [UIAlertController
                                        alertControllerWithTitle:@"No Group Divisions or Teams Set Up"
                                        message:@"Please set up at least one Group Division and at least on Team for this Meet"
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
                        return NO;
            
            
            
            
            
            }
            else if (!eventsdone && !teamsdone) {
            
                UIAlertController * alert=   [UIAlertController
                                        alertControllerWithTitle:@"No Group Events or Teams Set Up"
                                        message:@"Please set up at least one Event and at least on Team for this Meet"
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
                        return NO;
            
            
            
            
            
            }

            else
            {
        
        
                if (!eventsdone) {
            
                    UIAlertController * alert=   [UIAlertController
                                        alertControllerWithTitle:@"No Events Set Up"
                                        message:@"Please set up at least one Event for this Meet"
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
                    return NO;

            
                }
                else if (!divsdone)
                {
                UIAlertController * alert=   [UIAlertController
                                        alertControllerWithTitle:@"No Divisions Set Up"
                                        message:@"Please set up at least one Division for this Meet"
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
                    return NO;

                }
                else if (!teamsdone)
                {
                UIAlertController * alert=   [UIAlertController
                                        alertControllerWithTitle:@"No Teams Set Up"
                                        message:@"Please set up at least one Team for this Meet"
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
                    return NO;

                }

          
            }
        
            
        }
                
    }
   
    
    return YES;              
}

- (IBAction)ExportResultsButton:(UIBarButtonItem *)sender {

//check objects vs string values in itterations

NSSet* teamSet = self.meetObject.teams;
NSSet* divSet = self.meetObject.divisions;
NSSet* gEventSet = self.meetObject.gEvents;


//NSArray *teamsArray = [[NSMutableArray alloc] init];
double teamArray[[teamSet count]];

//[teamsArray addObject:object];
int teamcounter;

NSMutableString *resultscsv = [NSMutableString stringWithString:@""];

//add your content to the csv
//[csv appendFormat:@"MY DATA YADA YADA"];
    
    double globalTeamArray[[teamSet count]];

    
        for (int i = 0; i < [teamSet count]; i++) {
        
            globalTeamArray[i] = 0.0;
            
        }
    
        




for (Division *divobject in divSet )
    {

    //=== write new line
    [resultscsv appendString:[NSString stringWithFormat:@"\n"]];



    //=== write div name //not comma


    [resultscsv appendString:[NSString stringWithFormat:@"%@",divobject.divName]];

        teamcounter = 0;
        for (Team *teamobject in teamSet )
        {
    
        //int inttemp = 0;
    
        teamArray[teamcounter] = 0.0;
        // === write , team name
        [resultscsv appendString:[NSString stringWithFormat:@",%@",teamobject.teamName]];
        teamcounter++;
        }
 
 
 


        for (GEvent *geventobject in gEventSet )
        {
            //=== write new line
            [resultscsv appendString:[NSString stringWithFormat:@"\n"]];
        
            //===  write event name
            [resultscsv appendString:[NSString stringWithFormat:@"%@",geventobject.gEventName]];
        
        
                //loop teams in teamarray
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *description = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext: self.managedObjectContext];
        
                [fetchRequest setEntity:description];
        
                teamcounter = 0;
        
            for (Team *teamobject in teamSet )
            {
            
                    //get all score with div and event and team
                
                
            

                NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(score != NULL)", nil];
                NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(event.division == %@)", divobject];
                NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"(event.gEvent == %@)", geventobject];
                NSPredicate *pred4 = [NSPredicate predicateWithFormat:@"(team == %@)", teamobject];
            
                NSArray *preds = [NSArray arrayWithObjects: pred1,pred2,pred3,pred4, nil];
                NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

                [fetchRequest setPredicate:andPred];
    
    
                NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
                       NSArray *sortDescriptors = @[highestToLowest];
    
                [fetchRequest setSortDescriptors:sortDescriptors];


                NSError *error;
                NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
 
    
    
                double score = 0.0;

                NSNumber *currentScore;
                for(CEventScore *object in results) {
       
                    currentScore = object.score;
                    score = score + [currentScore doubleValue];
        
                }

               // teamobject.teamScore = [NSNumber numberWithInt:score];
// nslog(@" team : %@ score set at %@", teamobject.teamName,teamobject.teamScore);
                
                
                
               // === write ,resultstotal
               [resultscsv appendString:[NSString stringWithFormat:@", %f",score]];
               
               
            
                
                double teamvalue = teamArray[teamcounter];
                
                teamvalue = teamvalue + score;
                teamArray[teamcounter] = teamvalue;
                
                teamcounter++;
            //end team loop
            }
        
        //end geventloop
        }
    
        //=== write new line
        [resultscsv appendString:[NSString stringWithFormat:@"\n"]];
        //=== write Total
        [resultscsv appendString:[NSString stringWithFormat:@"Total"]];
    
    
        teamcounter = 0;
        NSMutableDictionary *teamDictInDiv = [[NSMutableDictionary alloc] init];
        
        for (Team *teamobject in teamSet )
            {
                
                //=== write , doubleteamscore
                [resultscsv appendString:[NSString stringWithFormat:@", %f",teamArray[teamcounter]]];
               // NSLog(@"teamresult for %@ is %f",teamobject.teamName,teamArray[teamcounter]);
                
                 double globalteamvalue = globalTeamArray[teamcounter];
                
                globalteamvalue = globalteamvalue + teamArray[teamcounter];
                globalTeamArray[teamcounter] = globalteamvalue;
                
                [teamDictInDiv setObject:[NSNumber numberWithDouble: teamArray[teamcounter]] forKey: teamobject.teamID];
               
                 teamcounter++;
            }
 
        
        //work out ranking
   
        NSArray *sortedKeysArray =
        [teamDictInDiv keysSortedByValueUsingSelector:@selector(compare:)];
    
        
        // sortedKeysArray contains: Geography, History, Mathematics, English ascending
        int teamnumber = [teamSet count];
     
        NSMutableArray *newsortedkeysarray = [[NSMutableArray alloc] init];
    
        NSMutableDictionary*placedictionary = [[NSMutableDictionary alloc]  init];
    
        int lastplace = 0;
        double lastvalue = 0.0;
        double currentResultDouble = 0.0;
        for (int i = 0; i < teamnumber; i++)
        {
    
    
      
        [newsortedkeysarray addObject: sortedKeysArray[(teamnumber - 1) - i]];
      
        NSString* currentResultKey = sortedKeysArray[(teamnumber - 1) - i];
        NSNumber* currentResultsNumber = [teamDictInDiv objectForKey:currentResultKey];
        currentResultDouble = [currentResultsNumber doubleValue];
      //   currentResultDouble = currentResultDouble + 1;
            
                 if (  currentResultDouble == lastvalue)
                {
                    NSNumber* lastplacenumber = [NSNumber numberWithInt:lastplace];
                    
                    [placedictionary setObject:lastplacenumber forKey:currentResultKey];
                
                
            
                }
                else
                {
                    lastplace = i + 1;
                
                    NSNumber* lastplacenumber = [NSNumber numberWithInt:lastplace];
                    
                    [placedictionary setObject:lastplacenumber forKey:currentResultKey];
                
                    
                    lastvalue = currentResultDouble;
                }
            

      
        }
    
        // end work out rankings
    
    
        
        
    
    
        //=== write new line
        [resultscsv appendString:[NSString stringWithFormat:@"\n"]];
        //== write Rank
        [resultscsv appendString:[NSString stringWithFormat:@"Rank"]];
        
        for (Team *teamobject in teamSet )
        {
      
            NSNumber* placenumber =  [placedictionary objectForKey:teamobject.teamID];
            int placeint = [placenumber intValue];
           
             //=== write , placedictionary value for teamid
            [resultscsv appendString:[NSString stringWithFormat:@", %d",placeint]];
      
        
      
        }

        [resultscsv appendString:[NSString stringWithFormat:@"\n"]];
        
        for (int j = 0; j < ([teamSet count]-1); j++)
        
        {
            
            [resultscsv appendString:[NSString stringWithFormat:@","]];
      
        }

        
    //end of div loop
    }

[resultscsv appendString:[NSString stringWithFormat:@"\n"]];
 [resultscsv appendString:[NSString stringWithFormat:@"\n"]];
        
        for (int k = 0; k < ([teamSet count]-1); k++)
        
        {
            
            [resultscsv appendString:[NSString stringWithFormat:@","]];
      
        }





// final rankings

        //=== write new line
        [resultscsv appendString:[NSString stringWithFormat:@"\n"]];
        //=== write Overall Total
        [resultscsv appendString:[NSString stringWithFormat:@"Overall Total"]];
    
    
        teamcounter = 0;
        NSMutableDictionary *teamTotalDict = [[NSMutableDictionary alloc] init];
        
        for (Team *teamobject in teamSet )
            {
                
                //=== write , doubleteamscore
                [resultscsv appendString:[NSString stringWithFormat:@", %f",globalTeamArray[teamcounter]]];
               // NSLog(@"teamresult for %@ is %f",teamobject.teamName,teamArray[teamcounter]);
                
                [teamTotalDict setObject:[NSNumber numberWithDouble: globalTeamArray[teamcounter]] forKey: teamobject.teamID];
                teamcounter++;
            }
   
        
        //work out ranking
   
        NSArray *sortedKeysArray =
        [teamTotalDict keysSortedByValueUsingSelector:@selector(compare:)];
    
        // sortedKeysArray contains: Geography, History, Mathematics, English ascending
        int teamnumber = [teamSet count];
     
        NSMutableArray *newsortedkeysarray = [[NSMutableArray alloc] init];
    
        NSMutableDictionary*finalplacedictionary = [[NSMutableDictionary alloc] init];
    
        int lastplace = 0;
        double lastvalue = 0.0;
    
        for (int i = 0; i < teamnumber; i++)
        {
    
    
      
        [newsortedkeysarray addObject: sortedKeysArray[(teamnumber - 1) - i]];
      
        NSString* currentResultKey = sortedKeysArray[(teamnumber - 1) - i];
        NSNumber* currentResultsNumber = [teamTotalDict objectForKey:currentResultKey];
       double currentResultDouble = [currentResultsNumber doubleValue];
            
                 if (  currentResultDouble == lastvalue)
                {
                    NSNumber* lastplacenumber = [NSNumber numberWithInt:lastplace];
                    
                    [finalplacedictionary setObject:lastplacenumber forKey:currentResultKey];
                
                
            
                }
                else
                {
                    lastplace = i + 1;
                
                    NSNumber* lastplacenumber = [NSNumber numberWithInt:lastplace];
                    
                    [finalplacedictionary setObject:lastplacenumber forKey:currentResultKey];
                
                    
                    lastvalue = currentResultDouble;
                }
            

      
        }
    
        // end work out rankings
    
    
        
        
    
    
        //=== write new line
        [resultscsv appendString:[NSString stringWithFormat:@"\n"]];
        //== write Rank
        [resultscsv appendString:[NSString stringWithFormat:@"Overall Rank"]];
    
        for (Team *teamobject in teamSet )
        {
      
            NSNumber* placenumber =  [finalplacedictionary objectForKey:teamobject.teamID];
            int placeint = [placenumber intValue];
           
             //=== write , placedictionary value for teamid
            [resultscsv appendString:[NSString stringWithFormat:@", %d",placeint]];
      
        
      
        }
        










//NSLog(@"%@",resultscsv);


///////////

// event results


//////


NSMutableString *eventscsv = [NSMutableString stringWithString:@""];

NSSet* eventSet = self.meetObject.events;
NSSet* scoreSet;
for (Event *eventobject in eventSet )
    {
        [eventscsv appendString:[NSString stringWithFormat:@"%@,%@,Name, Team, Result, Placing, Score", eventobject.gEvent.gEventName,eventobject.division.divName]];
    scoreSet = eventobject.cEventScores;
    
    for (CEventScore *scoreobject in scoreSet )
        {
            [eventscsv appendString:[NSString stringWithFormat:@"\n"]];
            
            [eventscsv appendString:[NSString stringWithFormat:@"%@,%@,%@,%@,%f,%d,%d", eventobject.gEvent.gEventName,eventobject.division.divName,scoreobject.competitor.compName,scoreobject.team.teamName,[scoreobject.result doubleValue],[scoreobject.placing intValue],[scoreobject.score intValue]]];
        
        
        
        }
    
    [eventscsv appendString:[NSString stringWithFormat:@"\n"]];
    for (int k = 0; k < 6; k++)
        
        {
            
            [eventscsv appendString:[NSString stringWithFormat:@","]];
      
        }
    [eventscsv appendString:[NSString stringWithFormat:@"\n"]];
    
    }
    




    NSString *emailTitle = @"Export Results";
    
    NSString* subjectString = [NSString stringWithFormat:@"Results From Athletics Meet %@", self.meetObject.meetName];
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Results From Athletics Meet %@ Recorded With Athletics Meet Manager IOS App", self.meetObject.meetName];;
    // To address
    
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setSubject:subjectString];
    
    [mc setMessageBody:messageBody isHTML:NO];
    
    [mc addAttachmentData:[resultscsv dataUsingEncoding:NSUTF8StringEncoding]
    
  //  [mailer addAttachmentData:[NSData dataWithContentsOfFile:@"PathToFile.csv"]
                     mimeType:@"text/csv" 
                     fileName:@"Overall Results.csv"];
    
    [mc addAttachmentData:[eventscsv dataUsingEncoding:NSUTF8StringEncoding]
    
  //  [mailer addAttachmentData:[NSData dataWithContentsOfFile:@"PathToFile.csv"]
                     mimeType:@"text/csv" 
                     fileName:@"Event Results.csv"];

    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{

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
     
                    [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"Mail cancelled");
           
            break;
        }
        //
        case MFMailComposeResultSaved:
        {
                    alert=   [UIAlertController
                                        alertControllerWithTitle:@"Mail Saved"
                                        message:@"Email With Exported Results Saved For Later Sending"
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

           NSLog(@"Mail saved");
            break;
        }
            
           
        case MFMailComposeResultSent:
        {
                     alert=   [UIAlertController
                                        alertControllerWithTitle:@"Export Succesfull"
                                        message:@"Meet Results Exported Via Email And Mail Sent Succesfully"
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
     
                    [self presentViewController:alert animated:YES completion:nil];
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
    
}

- (IBAction)shareMeetButtonPressed:(id)sender {

NSLog(@"share meet button pressed");



if (![self.meetObject.onlineMeet boolValue]) {

NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"Meet" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];


            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(isOwner == YES)"];
            

            [fetchRequest setPredicate:pred1];


            NSError *err;
            NSUInteger eventscorecountforc = [self.managedObjectContext countForFetchRequest:fetchRequest error:&err];
        
        
            if(eventscorecountforc == NSNotFound) {
                //Handle error
            }
        
    
    
    
    
            int currentEventNumber = (int)eventscorecountforc ;
        
     
        
            
            if (!(2>currentEventNumber)) {
    
              // self.competitorObject = nil;
                
                UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"Already Hosting Too Many Events"
                                    message:@"Please unshare another event before sharing this event online"
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
                
            }
            else
            {
                self.meetObject.onlineMeet = [NSNumber numberWithBool:YES];
                self.sendPermissionButton.enabled = YES;
                self.shareOnlineButton.title = @"Unshare Meet";
                self.meetObject.isOwner = [NSNumber numberWithBool:YES];
            }
}
else
{
    self.meetObject.onlineMeet = [NSNumber numberWithBool:NO];
    self.sendPermissionButton.enabled = NO;
    self.shareOnlineButton.title = @"Share Online";
    self.meetObject.isOwner = [NSNumber numberWithBool:NO];
}

        NSError *error = nil;

        // Save the context.
        
            if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
   


}

- (IBAction)sendPermissionButtonPressed:(id)sender {

NSLog(@"send permittion button pressed");

}

@end
