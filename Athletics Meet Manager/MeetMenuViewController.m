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



}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
   //  // nslog(@"Teams in configure view: %lu",  (unsigned long)[self.meetObject.teams count]);
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
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

get all teams in meet in array

new dictionary for divs


loop divs in Meet
{

=== write new line


new dictionary for teams  //set at after loop



=== write div name //not comma

    loop teamsarray
    {
    inttemp = 0;
    set inttemp for value teamid in teamdict
    === write , team name

    }
 
 set teamdict in div dict for value divid
 


    Loop events in meet
    {
   === write new line
      ===  write event name
        teamdict =  divdict for value divid
            loop teams in teamarray
            {
            
                get all score with div and event and team
                int resultstotal = 0;
                loop scores
                {
                    resultstotal = resultstotal + score.score
                }
                === write ,resultstotal
                
                int teamvalue = teamdicst for value teamid
                teamvalue = teamvalue + resultstotal
                teamdict deleteentry for key teamid
                teamdict set teamvalue for key teamid
                
                
            }
        divdict delete for key divid
        divdict set teamdict for key divid
    
    }
    
=== write new line
=== write Total

    teamdict = divdict value for divid
    loop team array {
      
      int = teamdict value for teamid
      === write , int
      
      
        
      
    }
   
    NSArray *sortedKeysArray =
    [teamdict keysSortedByValueUsingSelector:@selector(compare:)];
    
    // sortedKeysArray contains: Geography, History, Mathematics, English ascending
    teamindexnumber = [teamarray count];
    NS Array *newsortedkeysarray;
    
    new  placedictionary
    
   int lastplace = nil;
   int lastvalue = nil;
    
    for (i = 0; i < teamindexnumber; i++) {
    
    
      
     newsortedkeysarray[i] = sortedkeysarray[(teamindexnumber - 1) - i];
      
     
       
            if ([teamdict value for key [newsortedarray[i] ] == lastvalue)
            {
                placedictionary setvalue lastplace for newsortedarray[i];
                
                
            
            }
            else
            {
                
                placedictionary setvalue (i + 1) for newsortedarray[i];
                lastplace = i + 1;
                lastvalue = teamdict value for key newsortedarray[i];
            }
            

      
    }
    
   
    
    
    
    
    
=== write new line
=== write Rank

    loop team array {
      
      
      === write , placedictionary value for teamid
      
      
        
      
    }
    
===write line
    loop team array {
      
      
      === write ,
      
        
      
    }
//end of div loop
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






@end
