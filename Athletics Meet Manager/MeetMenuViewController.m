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


@interface MeetMenuViewController ()
@property  BOOL updateOnlineSuccess;
@property  BOOL sharing;
//@property  BOOL meetDeleteSuccess;
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
        /**
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
    
    **/
    
    


    
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
        [setValue:value forKey:@"orientation"];
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

[self pauseMethod];




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
                            [self resumeMethod];
                            
                        }];
                        
                [alert addAction:ok];
     
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else
            {
                
                //[self addMeetOnline:self.meetObject];
                [self shareAllOnline];
                
            }
}
else
{
    
    [self removeAllOnline];
}

    
   


}

- (void)shareAllOnline {
self.sharing = YES;
// Initialize the data
   NSMutableArray *localChangesMute = [[NSMutableArray alloc] init];;
   NSMutableArray *localDeletionsMute = [[NSMutableArray alloc] init];
   
    
   
     CKRecord* meetrecord = [self addMeetOnline:self.meetObject];
    [localChangesMute addObject:meetrecord];
    
   /**
    for (Division* div in self.meetObject.divisions) {
        CKRecord *divrecord = [self addDivisionOnline:div];
        [localChangesMute addObject:divrecord];
    }
    
    for (GEvent* gevent in self.meetObject.gEvents) {
        CKRecord *geventrecord = [self addGEventOnline:gevent];
        [localChangesMute addObject:geventrecord];
    }
    
    for (Team* team in self.meetObject.teams) {
        CKRecord *teamrecord = [self addTeamOnline:team];
        [localChangesMute addObject:teamrecord];
    }
    
    
    for (Event* event in self.meetObject.events) {
        CKRecord *eventrecord = [self addEventOnline:event];
        [localChangesMute addObject:eventrecord];
    }
    
    for (Competitor* comp in self.meetObject.competitors) {
        CKRecord *comprecord = [self addCompOnline:comp];
        [localChangesMute addObject:comprecord];
    }
    
    for (CEventScore* cscore in self.meetObject.cEventsScores) {
        CKRecord *cscorerecord = [self addCScoreOnline:cscore];
        [localChangesMute addObject:cscorerecord];
    }
    
  **/
  [self modifyOnlineWithChanges:localChangesMute AndDeletions:localDeletionsMute];
  
    
}

- (CKRecord*)addMeetOnline:(Meet*)meetObject {
    //create a new RecordType

    CKRecordID *meetrecordID = [[CKRecordID alloc] initWithRecordName:meetObject.onlineID];
    CKRecord *meet = [[CKRecord alloc] initWithRecordType:@"Meet" recordID:meetrecordID];
    
    //create and set record instance properties
    
meet[@"cEventLimit"] = meetObject.cEventLimit;
meet[@"competitorPerTeam"] = meetObject.competitorPerTeam;
meet[@"decrementPerPlace"] = meetObject.decrementPerPlace;
meet[@"divsDone"] = meetObject.divsDone;
meet[@"eventsDone"] = meetObject.eventsDone;
meet[@"maxScoringCompetitors"] = meetObject.maxScoringCompetitors;
meet[@"meetDate"] = meetObject.meetDate;
meet[@"meetEndTime"] = meetObject.meetEndTime;
meet[@"meetID"] = meetObject.meetID;
meet[@"meetName"] = meetObject.meetName;
meet[@"meetStartTime"] = meetObject.meetStartTime;
meet[@"scoreForFirstPlace"] = meetObject.scoreForFirstPlace;
meet[@"scoreMultiplier"] = meetObject.scoreMultiplier;
meet[@"teamsDone"] = meetObject.teamsDone;
meet[@"onlineMeet"] = meetObject.onlineMeet;
meet[@"updateDateAndTime"] = meetObject.updateDateAndTime;
meet[@"updateByUser"] = meetObject.updateByUser;
meet[@"isOwner"] = meetObject.isOwner;
meet[@"onlineID"] = meetObject.onlineID;

//NSNumber *num = [NSNumber numberWithFloat:10.0f];
//[array addObject:num];


NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
NSArray *array = [mutableArray copy];

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(CEventScore* object in meetObject.cEventsScores) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.cEventScoreID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"cEventsScores"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Competitor* object in meetObject.competitors) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.compID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"competitors"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Division* object in meetObject.divisions) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.divID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"divisions"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Event* object in meetObject.events) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.eventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"events"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(GEvent* object in meetObject.gEvents) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.gEventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"gEvents"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Team* object in meetObject.teams) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.teamID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"teams"] = array;


    
    
 
    /**
    
    
    //get the PublicDatabase from the Container for this app
    CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    
    //save the record to the target database
    [publicDatabase saveRecord:meet completionHandler:^(CKRecord *record, NSError *error) {
        
        //handle save error
        if(error) {
            
            NSLog(@"Uh oh, there was an error saving ... %@", error);
            self.meetSaveOnlineSuccess = NO;
        //handle successful save
        } else {
            
            NSLog(@"Saved successfully");
            NSLog(@"Title: %@", record[@"meetName"]);
            self.meetSaveOnlineSuccess = YES;
            
        }
        [self sendOnlineDone];
    }];
    **/
return meet;

}


/**
- (CKRecord*)addDivisionOnline:(Division*)divObject {
    //create a new RecordType

    CKRecordID *meetrecordID = [[CKRecordID alloc] initWithRecordName:divObject.onlineID];
    CKRecord *meet = [[CKRecord alloc] initWithRecordType:@"Meet" recordID:meetrecordID];
    
    //create and set record instance properties
    
meet[@"cEventLimit"] = meetObject.cEventLimit;
meet[@"competitorPerTeam"] = meetObject.competitorPerTeam;
meet[@"decrementPerPlace"] = meetObject.decrementPerPlace;
meet[@"divsDone"] = meetObject.divsDone;
meet[@"eventsDone"] = meetObject.eventsDone;
meet[@"maxScoringCompetitors"] = meetObject.maxScoringCompetitors;
meet[@"meetDate"] = meetObject.meetDate;
meet[@"meetEndTime"] = meetObject.meetEndTime;
meet[@"meetID"] = meetObject.meetID;
meet[@"meetName"] = meetObject.meetName;
meet[@"meetStartTime"] = meetObject.meetStartTime;
meet[@"scoreForFirstPlace"] = meetObject.scoreForFirstPlace;
meet[@"scoreMultiplier"] = meetObject.scoreMultiplier;
meet[@"teamsDone"] = meetObject.teamsDone;
meet[@"onlineMeet"] = meetObject.onlineMeet;
meet[@"updateDateAndTime"] = meetObject.updateDateAndTime;
meet[@"updateByUser"] = meetObject.updateByUser;
meet[@"isOwner"] = meetObject.isOwner;
meet[@"onlineID"] = meetObject.onlineID;

//NSNumber *num = [NSNumber numberWithFloat:10.0f];
//[array addObject:num];


NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
NSArray *array = [mutableArray copy];

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(CEventScore* object in meetObject.cEventsScores) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.cEventScoreID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"cEventsScores"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Competitor* object in meetObject.competitors) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.compID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"competitors"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Division* object in meetObject.divisions) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.divID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"divisions"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Event* object in meetObject.events) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.eventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"events"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(GEvent* object in meetObject.gEvents) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.gEventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"gEvents"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Team* object in meetObject.teams) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.teamID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"teams"] = array;


    
    
 
 
return meet;

}

- (CKRecord*)addGEventOnline:(GEvent*)gEventObject {
    //create a new RecordType

    CKRecordID *geventrecordID = [[CKRecordID alloc] initWithRecordName:divObject.onlineID];
    CKRecord *gevent = [[CKRecord alloc] initWithRecordType:@"Meet" recordID:meetrecordID];
    
    //create and set record instance properties
    
meet[@"cEventLimit"] = meetObject.cEventLimit;
meet[@"competitorPerTeam"] = meetObject.competitorPerTeam;
meet[@"decrementPerPlace"] = meetObject.decrementPerPlace;
meet[@"divsDone"] = meetObject.divsDone;
meet[@"eventsDone"] = meetObject.eventsDone;
meet[@"maxScoringCompetitors"] = meetObject.maxScoringCompetitors;
meet[@"meetDate"] = meetObject.meetDate;
meet[@"meetEndTime"] = meetObject.meetEndTime;
meet[@"meetID"] = meetObject.meetID;
meet[@"meetName"] = meetObject.meetName;
meet[@"meetStartTime"] = meetObject.meetStartTime;
meet[@"scoreForFirstPlace"] = meetObject.scoreForFirstPlace;
meet[@"scoreMultiplier"] = meetObject.scoreMultiplier;
meet[@"teamsDone"] = meetObject.teamsDone;
meet[@"onlineMeet"] = meetObject.onlineMeet;
meet[@"updateDateAndTime"] = meetObject.updateDateAndTime;
meet[@"updateByUser"] = meetObject.updateByUser;
meet[@"isOwner"] = meetObject.isOwner;
meet[@"onlineID"] = meetObject.onlineID;

//NSNumber *num = [NSNumber numberWithFloat:10.0f];
//[array addObject:num];


NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
NSArray *array = [mutableArray copy];

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(CEventScore* object in meetObject.cEventsScores) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.cEventScoreID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"cEventsScores"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Competitor* object in meetObject.competitors) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.compID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"competitors"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Division* object in meetObject.divisions) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.divID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"divisions"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Event* object in meetObject.events) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.eventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"events"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(GEvent* object in meetObject.gEvents) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.gEventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"gEvents"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Team* object in meetObject.teams) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.teamID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"teams"] = array;


    
    
 
 
return gevent;

}

- (CKRecord*)addDivisionOnline:(Division*)divObject {
    //create a new RecordType

    CKRecordID *meetrecordID = [[CKRecordID alloc] initWithRecordName:divObject.onlineID];
    CKRecord *meet = [[CKRecord alloc] initWithRecordType:@"Meet" recordID:meetrecordID];
    
    //create and set record instance properties
    
meet[@"cEventLimit"] = meetObject.cEventLimit;
meet[@"competitorPerTeam"] = meetObject.competitorPerTeam;
meet[@"decrementPerPlace"] = meetObject.decrementPerPlace;
meet[@"divsDone"] = meetObject.divsDone;
meet[@"eventsDone"] = meetObject.eventsDone;
meet[@"maxScoringCompetitors"] = meetObject.maxScoringCompetitors;
meet[@"meetDate"] = meetObject.meetDate;
meet[@"meetEndTime"] = meetObject.meetEndTime;
meet[@"meetID"] = meetObject.meetID;
meet[@"meetName"] = meetObject.meetName;
meet[@"meetStartTime"] = meetObject.meetStartTime;
meet[@"scoreForFirstPlace"] = meetObject.scoreForFirstPlace;
meet[@"scoreMultiplier"] = meetObject.scoreMultiplier;
meet[@"teamsDone"] = meetObject.teamsDone;
meet[@"onlineMeet"] = meetObject.onlineMeet;
meet[@"updateDateAndTime"] = meetObject.updateDateAndTime;
meet[@"updateByUser"] = meetObject.updateByUser;
meet[@"isOwner"] = meetObject.isOwner;
meet[@"onlineID"] = meetObject.onlineID;

//NSNumber *num = [NSNumber numberWithFloat:10.0f];
//[array addObject:num];


NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
NSArray *array = [mutableArray copy];

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(CEventScore* object in meetObject.cEventsScores) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.cEventScoreID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"cEventsScores"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Competitor* object in meetObject.competitors) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.compID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"competitors"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Division* object in meetObject.divisions) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.divID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"divisions"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Event* object in meetObject.events) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.eventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"events"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(GEvent* object in meetObject.gEvents) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.gEventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"gEvents"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Team* object in meetObject.teams) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.teamID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"teams"] = array;


    
    
 
 
return meet;

}

- (CKRecord*)addDivisionOnline:(Division*)divObject {
    //create a new RecordType

    CKRecordID *meetrecordID = [[CKRecordID alloc] initWithRecordName:divObject.onlineID];
    CKRecord *meet = [[CKRecord alloc] initWithRecordType:@"Meet" recordID:meetrecordID];
    
    //create and set record instance properties
    
meet[@"cEventLimit"] = meetObject.cEventLimit;
meet[@"competitorPerTeam"] = meetObject.competitorPerTeam;
meet[@"decrementPerPlace"] = meetObject.decrementPerPlace;
meet[@"divsDone"] = meetObject.divsDone;
meet[@"eventsDone"] = meetObject.eventsDone;
meet[@"maxScoringCompetitors"] = meetObject.maxScoringCompetitors;
meet[@"meetDate"] = meetObject.meetDate;
meet[@"meetEndTime"] = meetObject.meetEndTime;
meet[@"meetID"] = meetObject.meetID;
meet[@"meetName"] = meetObject.meetName;
meet[@"meetStartTime"] = meetObject.meetStartTime;
meet[@"scoreForFirstPlace"] = meetObject.scoreForFirstPlace;
meet[@"scoreMultiplier"] = meetObject.scoreMultiplier;
meet[@"teamsDone"] = meetObject.teamsDone;
meet[@"onlineMeet"] = meetObject.onlineMeet;
meet[@"updateDateAndTime"] = meetObject.updateDateAndTime;
meet[@"updateByUser"] = meetObject.updateByUser;
meet[@"isOwner"] = meetObject.isOwner;
meet[@"onlineID"] = meetObject.onlineID;

//NSNumber *num = [NSNumber numberWithFloat:10.0f];
//[array addObject:num];


NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
NSArray *array = [mutableArray copy];

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(CEventScore* object in meetObject.cEventsScores) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.cEventScoreID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"cEventsScores"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Competitor* object in meetObject.competitors) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.compID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"competitors"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Division* object in meetObject.divisions) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.divID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"divisions"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Event* object in meetObject.events) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.eventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"events"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(GEvent* object in meetObject.gEvents) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.gEventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"gEvents"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Team* object in meetObject.teams) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.teamID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"teams"] = array;


    
    
 
 
return meet;

}

- (CKRecord*)addDivisionOnline:(Division*)divObject {
    //create a new RecordType

    CKRecordID *meetrecordID = [[CKRecordID alloc] initWithRecordName:divObject.onlineID];
    CKRecord *meet = [[CKRecord alloc] initWithRecordType:@"Meet" recordID:meetrecordID];
    
    //create and set record instance properties
    
meet[@"cEventLimit"] = meetObject.cEventLimit;
meet[@"competitorPerTeam"] = meetObject.competitorPerTeam;
meet[@"decrementPerPlace"] = meetObject.decrementPerPlace;
meet[@"divsDone"] = meetObject.divsDone;
meet[@"eventsDone"] = meetObject.eventsDone;
meet[@"maxScoringCompetitors"] = meetObject.maxScoringCompetitors;
meet[@"meetDate"] = meetObject.meetDate;
meet[@"meetEndTime"] = meetObject.meetEndTime;
meet[@"meetID"] = meetObject.meetID;
meet[@"meetName"] = meetObject.meetName;
meet[@"meetStartTime"] = meetObject.meetStartTime;
meet[@"scoreForFirstPlace"] = meetObject.scoreForFirstPlace;
meet[@"scoreMultiplier"] = meetObject.scoreMultiplier;
meet[@"teamsDone"] = meetObject.teamsDone;
meet[@"onlineMeet"] = meetObject.onlineMeet;
meet[@"updateDateAndTime"] = meetObject.updateDateAndTime;
meet[@"updateByUser"] = meetObject.updateByUser;
meet[@"isOwner"] = meetObject.isOwner;
meet[@"onlineID"] = meetObject.onlineID;

//NSNumber *num = [NSNumber numberWithFloat:10.0f];
//[array addObject:num];


NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
NSArray *array = [mutableArray copy];

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(CEventScore* object in meetObject.cEventsScores) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.cEventScoreID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"cEventsScores"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Competitor* object in meetObject.competitors) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.compID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"competitors"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Division* object in meetObject.divisions) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.divID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"divisions"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Event* object in meetObject.events) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.eventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"events"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(GEvent* object in meetObject.gEvents) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.gEventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"gEvents"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Team* object in meetObject.teams) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.teamID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"teams"] = array;


    
    
 
 
return meet;

}

- (CKRecord*)addDivisionOnline:(Division*)divObject {
    //create a new RecordType

    CKRecordID *meetrecordID = [[CKRecordID alloc] initWithRecordName:divObject.onlineID];
    CKRecord *meet = [[CKRecord alloc] initWithRecordType:@"Meet" recordID:meetrecordID];
    
    //create and set record instance properties
    
meet[@"cEventLimit"] = meetObject.cEventLimit;
meet[@"competitorPerTeam"] = meetObject.competitorPerTeam;
meet[@"decrementPerPlace"] = meetObject.decrementPerPlace;
meet[@"divsDone"] = meetObject.divsDone;
meet[@"eventsDone"] = meetObject.eventsDone;
meet[@"maxScoringCompetitors"] = meetObject.maxScoringCompetitors;
meet[@"meetDate"] = meetObject.meetDate;
meet[@"meetEndTime"] = meetObject.meetEndTime;
meet[@"meetID"] = meetObject.meetID;
meet[@"meetName"] = meetObject.meetName;
meet[@"meetStartTime"] = meetObject.meetStartTime;
meet[@"scoreForFirstPlace"] = meetObject.scoreForFirstPlace;
meet[@"scoreMultiplier"] = meetObject.scoreMultiplier;
meet[@"teamsDone"] = meetObject.teamsDone;
meet[@"onlineMeet"] = meetObject.onlineMeet;
meet[@"updateDateAndTime"] = meetObject.updateDateAndTime;
meet[@"updateByUser"] = meetObject.updateByUser;
meet[@"isOwner"] = meetObject.isOwner;
meet[@"onlineID"] = meetObject.onlineID;

//NSNumber *num = [NSNumber numberWithFloat:10.0f];
//[array addObject:num];


NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
NSArray *array = [mutableArray copy];

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(CEventScore* object in meetObject.cEventsScores) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.cEventScoreID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"cEventsScores"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Competitor* object in meetObject.competitors) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.compID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"competitors"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Division* object in meetObject.divisions) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.divID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

meet[@"divisions"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Event* object in meetObject.events) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.eventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"events"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(GEvent* object in meetObject.gEvents) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.gEventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"gEvents"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Team* object in meetObject.teams) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString*   timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSinceReferenceDate]];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@",object.teamID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////


meet[@"teams"] = array;


    
    
 
 
return cscore;

}
**/

- (void)removeAllOnline {

self.sharing = NO;
// Initialize the data
   NSMutableArray *localChangesMute = [[NSMutableArray alloc] init];;
  NSMutableArray *localDeletionsMute = [[NSMutableArray alloc] init];
   
    
   
     CKRecordID* meetrecordID = [self removeMeetOnline:self.meetObject];
   [localDeletionsMute addObject:meetrecordID];
    
    
  
  [self modifyOnlineWithChanges:localChangesMute AndDeletions:localDeletionsMute];


}


- (CKRecordID*)removeMeetOnline:(Meet*)meetObject {

    
    //create the target record id you will use to fetch by
    
    CKRecordID *meetrecordID = [[CKRecordID alloc] initWithRecordName:meetObject.onlineID];
    
    /**
            //get the Container for the App
            CKContainer *defaultContainer = [CKContainer defaultContainer];
    
            //get the PublicDatabase inside the Container
            CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    
    
      [publicDatabase deleteRecordWithID:meetrecordID completionHandler:^(CKRecordID *recordID, NSError *error) {
        
          if(error) {
            
            NSLog(@"Uh oh, there was an error deleting ... %@", error);
           self.updateOnlineSuccess = NO;
        //handle successful save
        } else {
            
            NSLog(@"deleted successfully");
            
           self.updateOnlineSuccess = YES;
          NSLog(@"success? succesfull %hhd", self.meetDeleteSuccess);
         
            
        }
       
        [self sendLocalDone];
    }];

   **/

 return meetrecordID;

}


- (void) modifyOnlineWithChanges: (NSMutableArray*) changesMute AndDeletions: (NSMutableArray*) deletionsMute {


  
  
  
    NSArray *localChanges = [changesMute copy];
    NSArray *localDeletions = [deletionsMute copy];
  
    
   // Initialize the database and modify records operation
 
   CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
 
 
   CKModifyRecordsOperation *modifyRecordsOperation = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:localChanges recordIDsToDelete:localDeletions];
   modifyRecordsOperation.savePolicy = CKRecordSaveAllKeys;

   NSLog(@"CLOUDKIT Changes Uploading: %d", localChanges.count);

   // Add the completion block
   modifyRecordsOperation.modifyRecordsCompletionBlock = ^(NSArray *savedRecords, NSArray *deletedRecordIDs, NSError *error) {
       
       
       if (error) {
           NSLog(@"[%@] Error pushing local data: %@", self.class, error);
           
            NSLog(@"Uh oh, there was an error saving ... %@", error);
            self.updateOnlineSuccess = NO;
       }
       else
       {
       
       
            NSLog(@"Modified successfully");
           
           for(CKRecord* record in savedRecords) {
            
                NSLog(@"OnlineID: %@", record[@"onlineID"]);
            
            }
           
            for(CKRecord* recordID in deletedRecordIDs) {
            
                NSLog(@"Deleted record id: %@", recordID);
            }


           
           
            self.updateOnlineSuccess = YES;
       
       }
        
      // [localChanges removeObjectsInArray:savedRecords];
      // [self.localDeletions removeObjectsInArray:deletedRecordIDs];

       [self modifyOnlineDone];
       

   };
   
   

   // Start the operation
   [database addOperation:modifyRecordsOperation];
   
   
   
     //save the record to the target database
  
    /**
        [publicDatabase saveRecord:meet completionHandler:^(CKRecord *record, NSError *error) {
        
        //handle save error
        if(error) {
            
            NSLog(@"Uh oh, there was an error saving ... %@", error);
            self.meetSaveOnlineSuccess = NO;
        //handle successful save
        } else {
            
            NSLog(@"Saved successfully");
            NSLog(@"Title: %@", record[@"meetName"]);
            self.meetSaveOnlineSuccess = YES;
            
        }
        [self sendOnlineDone];
    }];
    **/

}





- (void) modifyOnlineDone {
    
    UIAlertController * alert;
    
    if (self.updateOnlineSuccess) {
        
        
        
        if (self.sharing) {
   
            self.meetObject.onlineMeet = [NSNumber numberWithBool:YES];
            self.sendPermissionButton.enabled = YES;
            self.meetObject.isOwner = [NSNumber numberWithBool:YES];
            
            
            
            alert=   [UIAlertController
                                    alertControllerWithTitle:@"Online Share Succesful"
                                    message:@"Meet shared for online result entry by other users, sent permission files to users to get started"
                                    preferredStyle:UIAlertControllerStyleAlert];
     
     
                UIAlertAction* ok = [UIAlertAction
                        actionWithTitle:@"OK"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            
                            
                            [alert dismissViewControllerAnimated:YES completion:nil];
                            [self resumeMethod];
                            self.shareOnlineButton.title = @"Unshare Meet";
                             
                        }];
            
                        [alert addAction:ok];
        }
        else
        {
            self.meetObject.onlineMeet = [NSNumber numberWithBool:NO];
            self.sendPermissionButton.enabled = NO;
            self.meetObject.isOwner = [NSNumber numberWithBool:NO];
            
            alert=   [UIAlertController
                                    alertControllerWithTitle:@"Meet Unshared Succesfully"
                                    message:@" Meet will no longer be available for users to update online"
                                    preferredStyle:UIAlertControllerStyleAlert];
     
     
                UIAlertAction* ok = [UIAlertAction
                        actionWithTitle:@"OK"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                           
                            
                            [alert dismissViewControllerAnimated:YES completion:nil];
                            [self resumeMethod];
                            self.shareOnlineButton.title = @"Share Online";
                            
                            
                             
                        }];
                        
                [alert addAction:ok];

        }
            
        [self saveContext];
        
        
        
     
        

    }
    else
    {
    
        
        
        if (self.sharing) {
    
                alert=   [UIAlertController
                                    alertControllerWithTitle:@"Online Share Failed"
                                    message:@"Failed to save to online database, please check your internet connection, ensure you are signed in to iCloud and you have updated to iCloud Drive"
                                    preferredStyle:UIAlertControllerStyleAlert];
     
     
                UIAlertAction* ok = [UIAlertAction
                        actionWithTitle:@"OK"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            
                            
                            [alert dismissViewControllerAnimated:YES completion:nil];
                            [self resumeMethod];
                             
                        }];
                        
                [alert addAction:ok];
        }
        else
        {
                alert=   [UIAlertController
                                    alertControllerWithTitle:@"Unshare meet unsuccesfull"
                                    message:@"There was a problem removing this Meet from online database, please check your internet connection and try again"
                                    preferredStyle:UIAlertControllerStyleAlert];
     
     
                UIAlertAction* ok = [UIAlertAction
                        actionWithTitle:@"OK"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                          
                            
                            [alert dismissViewControllerAnimated:YES completion:nil];
                            
                            [self resumeMethod];
                            
                             
                        }];
                        
                [alert addAction:ok];

        
        }
        
        
        
    
    }
    
        [self presentViewController:alert animated:YES completion:nil];



}



- (void) saveContext {


NSError *error = nil;

        // Save the context.
        
            if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
    

}




- (void) pauseMethod {

self.navigationController.view.userInteractionEnabled = NO;

self.activityindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

CGRect screenRect = [[UIScreen mainScreen] bounds];
CGFloat screenWidth = screenRect.size.width;
CGFloat screenHeight = screenRect.size.height;

UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
[view addSubview:self.activityindicator]; // <-- Your UIActivityIndicatorView
self.tableView.tableHeaderView = view;




[self.activityindicator setCenter:CGPointMake(screenWidth/2.0, screenHeight/3.0)]; // I do this because I'm in landscape mode
[self.view addSubview:self.activityindicator];

self.activityindicator.hidden = NO;
[self.activityindicator startAnimating];

self.exportResultsButton.enabled = NO;
self.sendPermissionButton.enabled = NO;
self.shareOnlineButton.enabled = NO;


[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}


- (void) resumeMethod {


self.navigationController.view.userInteractionEnabled = YES;
  
    [self.activityindicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.tableView.tableHeaderView = nil;
    
    self.exportResultsButton.enabled = YES;
//self.sendPermissionButton.enabled = YES;
self.shareOnlineButton.enabled = YES;

}

- (IBAction)sendPermissionButtonPressed:(id)sender {

NSLog(@"send permittion button pressed");

}

@end
