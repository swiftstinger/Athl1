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
#import "ResultsWebViewController.h"
#import "TeamPlacesViewController.h"
#import "Division.h"
#import "Team.h"
#import "GEvent.h"
#import "CEventScore.h"
#import "BackupCEventScore.h"
#import "Event.h"
#import "BackupEvent.h"
#import "Competitor.h"
#import "BackupCompetitor.h"


@interface MeetMenuViewController ()
@property  BOOL updateOnlineSuccess;
@property  BOOL sharing;
@property  BOOL exportresults;
@property  BOOL exportmeet;
@property  BOOL sendpermission;
@property BOOL doUpdate;
@property NSMutableArray *divServerMutableArray;
@property NSMutableArray *geventServerMutableArray;
@property NSMutableArray *teamServerMutableArray;
@property NSMutableArray *eventServerMutableArray;
@property NSMutableArray *compServerMutableArray;
@property NSMutableArray *cscoreServerMutableArray;
@property NSMutableArray *divLocalMutableArray;
@property NSMutableArray *geventLocalMutableArray;
@property NSMutableArray *teamLocalMutableArray;
@property NSMutableArray *eventLocalMutableArray;
@property NSMutableArray *compLocalMutableArray;
@property NSMutableArray *cscoreLocalMutableArray;
@property NSMutableArray *serverdeletes;
@property NSMutableArray *updatedNonOwnerEventIDsMutableArray;
@property NSMutableArray *updatedNonOwnerEventRecordIDsMutableArray;
@property NSOperationQueue *queue;
@property NSMutableArray *eventsIDSUpdatedSuccesfullyToDelete;
@property int updateFromServerIndexCounter;
@property int updateFromServerIndexTotal;

@property CKRecord *ownerUpdateDiv;
@property CKRecord *ownerUpdateGEvent;
@property NSMutableDictionary *ownerUpdateTeamMutableDict;
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
    
            self.updateOnlineButton.enabled = NO;
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
        self.groupDivLabel.text = @"Group Divisions (locked)";
        self.gEventLabel.text = @"Events (locked)";
        self.enterTeamLabel.text = @"Teams (Competitor entry only)";
      //  self.finalResultCell.hidden = YES;
    }


}


/**
if ([self.meetObject.onlineMeet boolValue]) {
    if (![self.meetObject.isOwner boolValue]) {
        self.groupDivCell.hidden = YES;
        self.gEventCell.hidden = YES;
        self.enterTeamCell.hidden = YES;
      //  self.finalResultCell.hidden = YES;
    }


}
**/
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    self.exportmeet = NO;
    self.exportresults = NO;
    self.sendpermission = NO;
    
    if ([self.meetObject.onlineMeet boolValue]&&(![self.meetObject.isOwner boolValue])) {
        [self updateOnlineMeet];
    
    // fixme
    }
    else
    {
        NSLog(@"not doing it online %@  owner %@", self.meetObject.onlineMeet, self.meetObject.isOwner);
        
    }
    
    
    
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
        
        /*
        
        ResultsWebViewController* finalResultsController = (ResultsWebViewController*)[barController.viewControllers objectAtIndex:0];
       
        [finalResultsController setDetailItem:self.meetObject];
       
       [finalResultsController setManagedObjectContext:self.managedObjectContext];
     */
     
         UINavigationController *navController = (UINavigationController *)[barController.viewControllers objectAtIndex:0];
       // UINavigationController *navController = (UINavigationController *) viewController;
        
        TeamPlacesViewController* resultsController = (TeamPlacesViewController*)[navController topViewController];
        [resultsController setDetailItem:self.meetObject];
        [resultsController setManagedObjectContext:self.managedObjectContext];


    
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
                dispatch_async(dispatch_get_main_queue(), ^{
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
                });
                return NO;
                }
                
    }
    if ([identifier isEqualToString:@"teamsSetup"]) {
        
        //checks
        bool divsdone = [[self.meetObject valueForKey: @"divsDone"] boolValue];
        bool eventsdone = [[self.meetObject valueForKey: @"eventsDone"] boolValue];
        
        if (!divsdone && !eventsdone) {
            dispatch_async(dispatch_get_main_queue(), ^{
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
                });
                return NO;
            
        }
        else
        {
        
        
            if (!eventsdone) {
                dispatch_async(dispatch_get_main_queue(), ^{
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
                });
                return NO;

            
            }
            else if (!divsdone)
            {
              dispatch_async(dispatch_get_main_queue(), ^{
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
                
                
                });
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
            dispatch_async(dispatch_get_main_queue(), ^{
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
                });
                return NO;
            
        }
        else
        {
            if (!divsdone && !eventsdone) {
                dispatch_async(dispatch_get_main_queue(), ^{
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
                    });
                        return NO;
            
            }
            else if (!divsdone && !teamsdone) {
            dispatch_async(dispatch_get_main_queue(), ^{
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
                });
                        return NO;
            
            
            
            
            
            }
            else if (!eventsdone && !teamsdone) {
            dispatch_async(dispatch_get_main_queue(), ^{
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
                });
                        return NO;
            
            
            
            
            
            }

            else
            {
        
        
                if (!eventsdone) {
                    dispatch_async(dispatch_get_main_queue(), ^{
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
                    });
                    return NO;

            
                }
                else if (!divsdone)
                {
                dispatch_async(dispatch_get_main_queue(), ^{
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
                    });
                    return NO;

                }
                else if (!teamsdone)
                {
                dispatch_async(dispatch_get_main_queue(), ^{
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
                    });
                    return NO;

                }

          
            }
        
            
        }
                
    }
   
    
    return YES;              
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
        
     
        
            
            if (!(4>currentEventNumber)) {
                
              // self.competitorObject = nil;
                dispatch_async(dispatch_get_main_queue(), ^{
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
                });
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
   NSMutableArray *localChangesMute = [[NSMutableArray alloc] init];
   NSMutableArray *localDeletionsMute = [[NSMutableArray alloc] init];
   
    
   
     CKRecord* meetrecord = [self addMeetOnline:self.meetObject];
    [localChangesMute addObject:meetrecord];
    
    CKReference* ref = [[CKReference alloc] initWithRecord:meetrecord action:CKReferenceActionDeleteSelf];
   
    for (Division* div in self.meetObject.divisions) {
        CKRecord *divrecord = [self addDivisionOnline:div];
        
        
        [divrecord setObject:ref forKey:@"owningMeet"];
        
        [localChangesMute addObject:divrecord];
    }
    
    for (GEvent* gevent in self.meetObject.gEvents) {
        CKRecord *geventrecord = [self addGEventOnline:gevent];
        
        [geventrecord setObject:ref forKey:@"owningMeet"];
        
        [localChangesMute addObject:geventrecord];
    }
    
    for (Team* team in self.meetObject.teams) {
        CKRecord *teamrecord = [self addTeamOnline:team];
        
        [teamrecord setObject:ref forKey:@"owningMeet"];
        
        [localChangesMute addObject:teamrecord];
    }
    
    for (Event* event in self.meetObject.events) {
        CKRecord *eventrecord = [self addEventOnline:event];
        
        [eventrecord setObject:ref forKey:@"owningMeet"];
        
        [localChangesMute addObject:eventrecord];
    }
    
    for (Competitor* comp in self.meetObject.competitors) {
        CKRecord *comprecord = [self addCompOnline:comp];
        
        [comprecord setObject:ref forKey:@"owningMeet"];
        
        [localChangesMute addObject:comprecord];
    }
    
    for (CEventScore* cscore in self.meetObject.cEventsScores) {
        CKRecord *cscorerecord = [self addCScoreOnline:cscore];
        
        [cscorerecord setObject:ref forKey:@"owningMeet"];
        
        [localChangesMute addObject:cscorerecord];
    }
  

  [self modifyOnlineWithChanges:localChangesMute AndDeletions:localDeletionsMute];
  
    
}

- (CKRecord*)addMeetOnline:(Meet*)meetObject {
    //create a new RecordType

    CKRecordID *meetrecordID = [[CKRecordID alloc] initWithRecordName:meetObject.onlineID];
    CKRecord *meet = [[CKRecord alloc] initWithRecordType:@"Meet" recordID:meetrecordID];
    
    //create and set record instance properties
    
    
meet[@"editDone"] = meetObject.editDone;
meet[@"edited"] = meetObject.edited;
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
meet[@"onlineMeet"] = [NSNumber numberWithBool:YES];
meet[@"updateDateAndTime"] = [NSDate date];
meet[@"updateByUser"] = @"owner";
meet[@"isOwner"] = [NSNumber numberWithBool:NO];
meet[@"onlineID"] = meetObject.onlineID;


for(CEventScore* object in meetObject.cEventsScores) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
    if (numberrange.location != NSNotFound) {
        newdevID = [devID substringFromIndex:numberrange.location + 2];
    } else {
     newdevID = devID;
    }

    devID = newdevID;
        
        NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.cEventScoreID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    
}


for(Competitor* object in meetObject.competitors) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
if (numberrange.location != NSNotFound) {
     newdevID = [devID substringFromIndex:numberrange.location + 2];
} else {
     newdevID = devID;
}

    devID = newdevID;
        
        NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.compID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    
}


for(Division* object in meetObject.divisions) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
if (numberrange.location != NSNotFound) {
     newdevID = [devID substringFromIndex:numberrange.location + 2];
} else {
     newdevID = devID;
}

    devID = newdevID;
    
        NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
     NSLog(@"timestamp : %@ ",timestamp);
     NSLog(@"divID: %@", object.divID);
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.divID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    
}


for(Event* object in meetObject.events) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
if (numberrange.location != NSNotFound) {
     newdevID = [devID substringFromIndex:numberrange.location + 2];
} else {
     newdevID = devID;
}

    devID = newdevID;
        
        NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
       
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.eventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
}

for(GEvent* object in meetObject.gEvents) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
if (numberrange.location != NSNotFound) {
     newdevID = [devID substringFromIndex:numberrange.location + 2];
} else {
     newdevID = devID;
}

    devID = newdevID;
        
        NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.gEventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
}

for(Team* object in meetObject.teams) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
if (numberrange.location != NSNotFound) {
     newdevID = [devID substringFromIndex:numberrange.location + 2];
} else {
     newdevID = devID;
}

    devID = newdevID;
        
        NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.teamID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
}
    

return meet;

}

- (CKRecord*)addDivisionOnline:(Division*)divObject {
    //create a new RecordType
    
    CKRecordID *divrecordID = [[CKRecordID alloc] initWithRecordName:divObject.onlineID];
    CKRecord *div = [[CKRecord alloc] initWithRecordType:@"Division" recordID:divrecordID];
    
    //create and set record instance properties
    
div[@"editDone"] = divObject.editDone;
div[@"edited"] = divObject.edited;
div[@"divID"] = divObject.divID;
div[@"divName"] = divObject.divName;
div[@"onlineID"] = divObject.onlineID;
div[@"updateByUser"] = @"owner";
div[@"updateDateAndTime"] = [NSDate date];





//NSNumber *num = [NSNumber numberWithFloat:10.0f];
//[array addObject:num];

/**
NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
NSArray *array = [mutableArray copy];

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Event* object in divObject.events) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
       NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
       NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
if (numberrange.location != NSNotFound) {
     newdevID = [devID substringFromIndex:numberrange.location + 2];
} else {
     newdevID = devID;
}

    devID = newdevID;
       
        NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.eventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

div[@"events"] = array;

//////////////
//////////////

**/

div[@"meetOnlineID"] = divObject.meet.onlineID;
    
div[@"eventRecordID"] = divObject.meet.onlineID;
 
 
return div;

}

- (CKRecord*)addGEventOnline:(GEvent*)gEventObject {
    //create a new RecordType

    CKRecordID *geventrecordID = [[CKRecordID alloc] initWithRecordName:gEventObject.onlineID];
    CKRecord *gevent = [[CKRecord alloc] initWithRecordType:@"GEvent" recordID: geventrecordID];    //create and set record instance properties
gevent[@"editDone"] = gEventObject.editDone;
gevent[@"edited"] = gEventObject.edited;
gevent[@"competitorsPerTeam"] = gEventObject.competitorsPerTeam;
gevent[@"decrementPerPlace"] = gEventObject.decrementPerPlace;
gevent[@"gEventID"] = gEventObject.gEventID;
gevent[@"gEventName"] = gEventObject.gEventName;
gevent[@"gEventTiming"] = gEventObject.gEventTiming;
gevent[@"gEventType"] = gEventObject.gEventType;
gevent[@"maxScoringCompetitors"] = gEventObject.maxScoringCompetitors;
gevent[@"onlineID"] = gEventObject.onlineID;
gevent[@"scoreForFirstPlace"] = gEventObject.scoreForFirstPlace;
gevent[@"scoreMultiplier"] = gEventObject.scoreMultiplier;
gevent[@"updateByUser"] = @"owner";
gevent[@"updateDateAndTime"] = [NSDate date];






//NSNumber *num = [NSNumber numberWithFloat:10.0f];
//[array addObject:num];

/**
NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
NSArray *array = [mutableArray copy];

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Event* object in gEventObject.events) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
       NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
       
       NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
if (numberrange.location != NSNotFound) {
     newdevID = [devID substringFromIndex:numberrange.location + 2];
} else {
     newdevID = devID;
}

    devID = newdevID;
       
        NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.eventID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

gevent[@"events"] = array;

//////////////
//////////////

**/

gevent[@"meetOnlineID"] = gEventObject.meet.onlineID;

gevent[@"eventRecordID"] = gEventObject.meet.onlineID;
    
    
 
 
return gevent;

}

- (CKRecord*)addTeamOnline:(Team*)teamObject {
    //create a new RecordType

    CKRecordID *teamrecordID = [[CKRecordID alloc] initWithRecordName:teamObject.onlineID];
    CKRecord *team = [[CKRecord alloc] initWithRecordType:@"Team" recordID:teamrecordID];
    
    //create and set record instance properties
team[@"editDone"] = teamObject.editDone;
team[@"edited"] = teamObject.edited;
team[@"onlineID"] = teamObject.onlineID;
team[@"teamAbr"] = teamObject.teamAbr;
team[@"teamID"] = teamObject.teamID;
team[@"teamName"] = teamObject.teamName;
team[@"teamPlace"] = teamObject.teamPlace;
team[@"teamScore"] = teamObject.teamScore;
team[@"updateByUser"] = @"owner";
team[@"updateDateAndTime"] = [NSDate date];

//NSNumber *num = [NSNumber numberWithFloat:10.0f];
//[array addObject:num];
/**

NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
NSArray *array = [mutableArray copy];

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(CEventScore* object in teamObject.cEventScores) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
if (numberrange.location != NSNotFound) {
     newdevID = [devID substringFromIndex:numberrange.location + 2];
} else {
     newdevID = devID;
}

    devID = newdevID;
        
        NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.cEventScoreID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

team[@"cEventScores"] = array;

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(Competitor* object in teamObject.competitors) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
       NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
       
       NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
if (numberrange.location != NSNotFound) {
     newdevID = [devID substringFromIndex:numberrange.location + 2];
} else {
     newdevID = devID;
}

    devID = newdevID;
       
        NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.compID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

team[@"competitors"] = array;

//////////////
//////////////

**/
  team[@"meetOnlineID"] = teamObject.meet.onlineID;
    
 team[@"eventRecordID"] = teamObject.meet.onlineID;
 
return team;

}

- (CKRecord*)addEventOnline:(Event*)eventObject {
    //create a new RecordType

    CKRecordID *eventrecordID = [[CKRecordID alloc] initWithRecordName:eventObject.onlineID];
    CKRecord *event = [[CKRecord alloc] initWithRecordType:@"Event" recordID:eventrecordID];
    
    //create and set record instance properties
event[@"editDone"] = eventObject.editDone;
event[@"edited"] = eventObject.edited;
event[@"eventDone"] = eventObject.eventDone;
event[@"eventEdited"] = eventObject.eventEdited;
event[@"eventID"] = eventObject.eventID;
event[@"onlineID"] = eventObject.onlineID;
event[@"startTime"] = eventObject.startTime;
event[@"updateByUser"] = @"owner";
event[@"updateDateAndTime"] = [NSDate date];

//NSNumber *num = [NSNumber numberWithFloat:10.0f];
//[array addObject:num];
/**

NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
NSArray *array = [mutableArray copy];

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(CEventScore* object in eventObject.cEventScores) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
if (numberrange.location != NSNotFound) {
     newdevID = [devID substringFromIndex:numberrange.location + 2];
} else {
     newdevID = devID;
}

    devID = newdevID;
        
        NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.cEventScoreID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

event[@"cEventScores"] = array;

//////////////
//////////////

//////////////
//////////////
  **/
    
    event[@"division"] = eventObject.division.onlineID;
    event[@"gEvent"] = eventObject.gEvent.onlineID;
    event[@"meetOnlineID"] = eventObject.meet.onlineID;
    
 
 
return event;

}

- (CKRecord*)addCompOnline:(Competitor*)compObject {
    //create a new RecordType

    CKRecordID *comprecordID = [[CKRecordID alloc] initWithRecordName:compObject.onlineID];
    CKRecord *comp = [[CKRecord alloc] initWithRecordType:@"Competitor" recordID:comprecordID];
    
    //create and set record instance properties
comp[@"editDone"] = compObject.editDone;
comp[@"edited"] = compObject.edited;
comp[@"compID"] = compObject.compID;
comp[@"compName"] = compObject.compName;
comp[@"onlineID"] = compObject.onlineID;
comp[@"teamName"] = compObject.teamName;
comp[@"updateByUser"] = @"owner";
comp[@"updateDateAndTime"] = [NSDate date];


//NSNumber *num = [NSNumber numberWithFloat:10.0f];
//[array addObject:num];
/**

NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
NSArray *array = [mutableArray copy];

//////////////
//////////////

mutableArray = [[NSMutableArray alloc] init];

for(CEventScore* object in compObject.cEventScores) {
    if (object.onlineID) {
    NSLog(@"onlineid is there %@",object.onlineID);
    }
    else
    {
    
        NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
if (numberrange.location != NSNotFound) {
     newdevID = [devID substringFromIndex:numberrange.location + 2];
} else {
     newdevID = devID;
}

    devID = newdevID;
        
        NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
        timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
        devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, object.cEventScoreID,timestamp];
      [object setValue: onlineID forKey: @"onlineID"];
       NSLog(@"onlineid not found %@",object.onlineID);
    }
    [mutableArray addObject:object.onlineID];
}
array = [mutableArray copy];

///////////

comp[@"cEventScores"] = array;

//////////////
//////////////


//////////////
//////////////
**/
    comp[@"team"] = compObject.team.onlineID;
    comp[@"meetOnlineID"] = compObject.meet.onlineID;
    
    comp[@"eventRecordID"] = compObject.meet.onlineID;
 
 
return comp;

}

- (CKRecord*)addCScoreOnline:(CEventScore*)cscoreObject {
    //create a new RecordType

    CKRecordID *cscorerecordID = [[CKRecordID alloc] initWithRecordName:cscoreObject.onlineID];
    CKRecord *cscore = [[CKRecord alloc] initWithRecordType:@"CEventScore" recordID:cscorerecordID];
    
    //create and set record instance properties
cscore[@"editDone"] = cscoreObject.editDone;
cscore[@"edited"] = cscoreObject.edited;
cscore[@"cEventScoreID"] = cscoreObject.cEventScoreID;
cscore[@"highJumpPlacingManual"] = cscoreObject.highJumpPlacingManual;
cscore[@"onlineID"] = cscoreObject.onlineID;
cscore[@"personalBest"] = cscoreObject.personalBest;
cscore[@"placing"] = cscoreObject.placing;
cscore[@"result"] = cscoreObject.result;
cscore[@"resultEntered"] = cscoreObject.resultEntered;
cscore[@"score"] = cscoreObject.score;
cscore[@"updateByUser"] = @"owner";
cscore[@"updateDateAndTime"] = [NSDate date];


//NSNumber *num = [NSNumber numberWithFloat:10.0f];
//[array addObject:num];
/**

NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
NSArray *array = [mutableArray copy];
**/
//////////////
//////////////

//[later attempts]


//////////////
//////////////

    cscore[@"competitor"] = cscoreObject.competitor.onlineID;
    cscore[@"event"] = cscoreObject.event.onlineID;
    cscore[@"team"] = cscoreObject.team.onlineID;
    cscore[@"meetOnlineID"] = cscoreObject.meet.onlineID;
    
    cscore[@"eventRecordID"] = cscoreObject.meet.onlineID;
 
return cscore;

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
    dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertController * alert;
    
    if (self.updateOnlineSuccess) {
        
        
        
        if (self.sharing) {
   
            self.meetObject.onlineMeet = [NSNumber numberWithBool:YES];
            self.sendPermissionButton.enabled = YES;
            self.meetObject.isOwner = [NSNumber numberWithBool:YES];
            
            
            
            alert=   [UIAlertController
                                    alertControllerWithTitle:@"Online Share Successful"
                                    message:@"Meet shared for online result entry by other users, send permission files to users to get started"
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
                                    alertControllerWithTitle:@"Meet Unshared Successfully"
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
                                    message:@"Failed to save to online database, please check your internet connection, ensure you are signed in to iCloud and you have upgraded to iCloud Drive before trying again"
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
                                    alertControllerWithTitle:@"Unshare meet unsuccessfull"
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

    });

}

- (void)removeAllOnline {

self.sharing = NO;
// Initialize the data
   NSMutableArray *localChangesMute = [[NSMutableArray alloc] init];
  NSMutableArray *localDeletionsMute = [[NSMutableArray alloc] init];
   
   
    
   
     CKRecordID* meetrecordID = [self removeMeetOnline:self.meetObject];
   [localDeletionsMute addObject:meetrecordID];
    
    /**
    
    ///////////
    // rest
    /////////
    //NSMutableArray *fetchedRecords = [[NSMutableArray alloc] init];
    
    
    //fetchedRecords = [self removeDivsOnline:self.meetObject.onlineID];
    
    
    //get the Container for the App
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    
    //get the PublicDatabase inside the Container
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    
    //predicate for query
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"meetOnlineID = %@", self.meetObject.onlineID];
    
    CKQuery *query;
    
    /////
    // Division
    ////
    
    
    
    //create query
    query = [[CKQuery alloc] initWithRecordType:@"Division" predicate:predicate];
    
    //execute query
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        
        //handle query error
        if(error) {
            
            NSLog(@"Uh oh, there was an error querying ... %@", error);

        } else {
            
            //handle query results
            if([results count] > 0) {
                
                //iterate query results
                for(CKRecord *record in results) {
                    
                    [localDeletionsMute addObject:[record recordID]];
                    NSLog(@"Query was successfully");
                    NSLog(@"meetOnlineID: %@ recordType: %@", record[@"meetOnlineID"], [record recordType]);
                    
                }
                
            //handle no query results
            } else {
                
                NSLog(@"Query returned zero results");
            }
        }
    }];
    
    
    /////
    // Division end
    /////
    
    /////
    // GEvent
    ////
    
    
    
    //create query
    query = [[CKQuery alloc] initWithRecordType:@"GEvent" predicate:predicate];
    
    //execute query
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        
        //handle query error
        if(error) {
            
            NSLog(@"Uh oh, there was an error querying ... %@", error);

        } else {
            
            //handle query results
            if([results count] > 0) {
                
                //iterate query results
                for(CKRecord *record in results) {
                    
                    [localDeletionsMute addObject:[record recordID]];
                    NSLog(@"Query was successfully");
                    NSLog(@"meetOnlineID: %@ recordType: %@", record[@"meetOnlineID"], [record recordType]);
                    
                }
                
            //handle no query results
            } else {
                
                NSLog(@"Query returned zero results");
            }
        }
    }];
    
    
    /////
    // GEvent end
    /////

    /////
    // Team
    ////
    
    
    
    //create query
    query = [[CKQuery alloc] initWithRecordType:@"Team" predicate:predicate];
    
    //execute query
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        
        //handle query error
        if(error) {
            
            NSLog(@"Uh oh, there was an error querying ... %@", error);

        } else {
            
            //handle query results
            if([results count] > 0) {
                
                //iterate query results
                for(CKRecord *record in results) {
                    
                    [localDeletionsMute addObject:[record recordID]];
                    NSLog(@"Query was successfully");
                    NSLog(@"meetOnlineID: %@ recordType: %@", record[@"meetOnlineID"], [record recordType]);
                    
                }
                
            //handle no query results
            } else {
                
                NSLog(@"Query returned zero results");
            }
        }
    }];
    
    
    /////
    // Team end
    /////
    
    /////
    // Event
    ////
    
    
    
    //create query
    query = [[CKQuery alloc] initWithRecordType:@"Event" predicate:predicate];
    
    //execute query
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        
        //handle query error
        if(error) {
            
            NSLog(@"Uh oh, there was an error querying ... %@", error);

        } else {
            
            //handle query results
            if([results count] > 0) {
                
                //iterate query results
                for(CKRecord *record in results) {
                    
                    [localDeletionsMute addObject:[record recordID]];
                    NSLog(@"Query was successfully");
                    NSLog(@"meetOnlineID: %@ recordType: %@", record[@"meetOnlineID"], [record recordType]);
                    
                }
                
            //handle no query results
            } else {
                
                NSLog(@"Query returned zero results");
            }
        }
    }];
    
    
    /////
    // Event end
    /////
    
    /////
    // Competitor
    ////
    
    
    
    //create query
    query = [[CKQuery alloc] initWithRecordType:@"Competitor" predicate:predicate];
    
    //execute query
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        
        //handle query error
        if(error) {
            
            NSLog(@"Uh oh, there was an error querying ... %@", error);

        } else {
            
            //handle query results
            if([results count] > 0) {
                
                //iterate query results
                for(CKRecord *record in results) {
                    
                    [localDeletionsMute addObject:[record recordID]];
                    NSLog(@"Query was successfully");
                    NSLog(@"meetOnlineID: %@ recordType: %@", record[@"meetOnlineID"], [record recordType]);
                    
                }
                
            //handle no query results
            } else {
                
                NSLog(@"Query returned zero results");
            }
        }
    }];
    
    
    /////
    // Competitor end
    /////
    
    /////
    // CEventScore
    ////
    
    
    
    //create query
    query = [[CKQuery alloc] initWithRecordType:@"CEventScore" predicate:predicate];
    
    //execute query
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        
        //handle query error
        if(error) {
            
            NSLog(@"Uh oh, there was an error querying ... %@", error);

        } else {
            
            //handle query results
            if([results count] > 0) {
                
                //iterate query results
                for(CKRecord *record in results) {
                    
                    [localDeletionsMute addObject:[record recordID]];
                    NSLog(@"Query was successfully");
                    NSLog(@"meetOnlineID: %@ recordType: %@", record[@"meetOnlineID"], [record recordType]);
                    
                }
                
            //handle no query results
            } else {
                
                NSLog(@"Query returned zero results");
            }
        }
    }];
    
    
    /////
    // CEventScore end
    /////
    
    **/
  
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

- (NSMutableArray*)removeDivsOnline:(NSString*)meetOnlineID {



        NSMutableArray *fetchedRecords = [[NSMutableArray alloc] init];

    //get the Container for the App
    CKContainer *defaultContainer = [CKContainer defaultContainer];
    
    //get the PublicDatabase inside the Container
    CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    
    //predicate for query
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"meetOnlineID = %@", meetOnlineID];
    
    //create query
    CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Divisions" predicate:predicate];
    
    //execute query
    [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        
        //handle query error
        if(error) {
            
            NSLog(@"Uh oh, there was an error querying ... %@", error);

        } else {
            
            //handle query results
            if([results count] > 0) {
                
                //iterate query results
                for(CKRecord *record in results) {
                    
                    [fetchedRecords addObject:record];
                    NSLog(@"Query was successfully");
                    NSLog(@"meetOnlineID: %@", record[@"meetOnlineID"]);
                    
                }
                
            //handle no query results
            } else {
                
                NSLog(@"Query returned zero results");
            }
        }
    }];




    return fetchedRecords;
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

NSString *newonlineID = self.meetObject.onlineID;


NSLog(@"online id before: %@", newonlineID);
NSData* data = [newonlineID dataUsingEncoding:NSUTF8StringEncoding];



NSString* newStr = [NSString stringWithUTF8String:[data bytes]];

NSLog(@"online id after: %@", newStr);


    NSString *emailTitle = @"Athletics Meet Manager Permission File";
    
    NSString* subjectString = [NSString stringWithFormat:@"Permission file From Athletics Meet %@", self.meetObject.meetName];
    // Email Content
    
    NSMutableString *body = [NSMutableString string];
// add HTML before the link here with line breaks (\n)
[body appendString:@"<h2>Permission file for Athletics Meet Recorded With Athletics Meet Manager IOS App.</h2>\n"];

[body appendString:@"<div>Open file with Athletics Meet Manager to be able to  view and enter results for this athletics meet.</div>\n"];

[body appendString:@"<a href=\"https://appsto.re/gb/f7KB8.i \">https://appsto.re/gb/f7KB8.i</a>\n"];

    
  //  NSString *messageBody = [NSString stringWithFormat:@"Permission file for Athletics Meet %@ Recorded With Athletics Meet Manager IOS App.  \n \n Open file with Athletics Meet Manager to be able to  view and enter results for this athletics meet \n \n https://appsto.re/gb/f7KB8.i ", self.meetObject.meetName];;
    // To address
    
    NSString *filename = [NSString stringWithFormat:@"%@PermissionFile.ammp", self.meetObject.meetName];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setSubject:subjectString];
    
    [mc setMessageBody:body isHTML:YES];
    
    [mc addAttachmentData:data
    
  //  [mailer addAttachmentData:[NSData dataWithContentsOfFile:@"PathToFile.csv"]
                     mimeType:@"application/AthleticsMeetManagerPermissionFile"
                     fileName:filename];
    
    
    
    self.sendpermission = YES;
    [self presentViewController:mc animated:YES completion:NULL];



}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{


 if (self.sendpermission)
 {
    self.sendpermission = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertController * alert;
    switch (result)
    {
        case MFMailComposeResultCancelled:
        {
                     alert=   [UIAlertController
                                        alertControllerWithTitle:@"Send Cancelled"
                                        message:@"Send Via Email Cancelled By User"
                                        preferredStyle:UIAlertControllerStyleAlert];
     
     
                    UIAlertAction* ok = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                             
                            }];
                        
                    [alert addAction:ok];
     
              //      [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"Mail cancelled");
           
            break;
        }
        //
        case MFMailComposeResultSaved:
        {
                    alert=   [UIAlertController
                                        alertControllerWithTitle:@"Mail Saved"
                                        message:@"Email With Sent Permission File Saved For Later Sending"
                                        preferredStyle:UIAlertControllerStyleAlert];
     
     
                    UIAlertAction* ok = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                             
                            }];
                        
                    [alert addAction:ok];
     
            //        [self presentViewController:alert animated:YES completion:nil];

           NSLog(@"Mail saved");
            break;
        }
            
           
        case MFMailComposeResultSent:
        {
                     alert=   [UIAlertController
                                        alertControllerWithTitle:@"Mail Sent Successfully"
                                        message:@"Meet Permission File Sent Via Email And Mail Sent Successfully"
                                        preferredStyle:UIAlertControllerStyleAlert];
     
     
                    UIAlertAction* ok = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                             
                            }];
                        
                    [alert addAction:ok];
     
                 //   [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"Mail sent");
           
            break;
        }
            //
            
        case MFMailComposeResultFailed:
        {
                    alert=   [UIAlertController
                                        alertControllerWithTitle:@"Send Failed"
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
     
               //     [self presentViewController:alert animated:YES completion:nil];
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
  });

 }

 if (self.exportresults)
 {
  
 self.exportresults = NO;
dispatch_async(dispatch_get_main_queue(), ^{
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
     
                //    [self presentViewController:alert animated:YES completion:nil];
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
     
              //      [self presentViewController:alert animated:YES completion:nil];

           NSLog(@"Mail saved");
            break;
        }
            
           
        case MFMailComposeResultSent:
        {
                     alert=   [UIAlertController
                                        alertControllerWithTitle:@"Export Successfull"
                                        message:@"Meet Results Exported Via Email And Mail Sent Successfully"
                                        preferredStyle:UIAlertControllerStyleAlert];
     
     
                    UIAlertAction* ok = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                             
                            }];
                        
                    [alert addAction:ok];
     
             //       [self presentViewController:alert animated:YES completion:nil];
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
     
              //      [self presentViewController:alert animated:YES completion:nil];
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
  
  });
    
 }
if (self.exportmeet) {
    self.exportmeet = NO;
 dispatch_async(dispatch_get_main_queue(), ^{
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
     
                //    [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"Mail cancelled");
           
            break;
        }
        //
        case MFMailComposeResultSaved:
        {
                    alert=   [UIAlertController
                                        alertControllerWithTitle:@"Mail Saved"
                                        message:@"Email With Exported Item Names Saved For Later Sending"
                                        preferredStyle:UIAlertControllerStyleAlert];
     
     
                    UIAlertAction* ok = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                             
                            }];
                        
                    [alert addAction:ok];
     
              //      [self presentViewController:alert animated:YES completion:nil];

           NSLog(@"Mail saved");
            break;
        }
            
           
        case MFMailComposeResultSent:
        {
                     alert=   [UIAlertController
                                        alertControllerWithTitle:@"Export Successfull"
                                        message:@"Item Names Exported Via Email And Mail Sent Successfully"
                                        preferredStyle:UIAlertControllerStyleAlert];
     
     
                    UIAlertAction* ok = [UIAlertAction
                            actionWithTitle:@"OK"
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [alert dismissViewControllerAnimated:YES completion:nil];
                             
                            }];
                        
                    [alert addAction:ok];
     
             //       [self presentViewController:alert animated:YES completion:nil];
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
     
              //      [self presentViewController:alert animated:YES completion:nil];
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
  
  });
    
}
 
 
}
- (void)endUpdateOnlineMeetWithSuccess: (BOOL) success {

        NSLog(@"update ended %d", success);
    
         NSError *errorscore = nil;
                        
                    // Save the context.
    
    
    
        if (success) {
        NSLog(@"update successfull now do deletes");
                for (Division* object in self.meetObject.divisions) {
                    if ([self.divServerMutableArray containsObject:object.onlineID]) {
                        NSLog(@"div exists dont delete divname %@", object.divName);
                    }
                    else
                    {
                            NSLog(@"div not on server delete divname %@", object.divName);
                        
                            if ([object.editDone boolValue]||(![object.edited boolValue])) {
                                 NSLog(@" editDone or not edited so deleted");
                                [self.managedObjectContext deleteObject:object];
    
                            }
                            else
                            {
                                NSLog(@"edited and not edit done so not deleted");
                            }
                        
                        
                    }
                
                
                }
                for (GEvent* object in self.meetObject.gEvents) {
                    if ([self.geventServerMutableArray containsObject:object.onlineID]) {
                        NSLog(@"gevent exists dont delete geventname %@", object.gEventName);
                    }
                    else
                    {
                            NSLog(@"gevent not on server delete geventname %@", object.gEventName);
                        
                            if ([object.editDone boolValue]||(![object.edited boolValue])) {
                                 NSLog(@" editDone or not edited so deleted");
                                [self.managedObjectContext deleteObject:object];
    
                            }
                            else
                            {
                                NSLog(@"edited and not edit done so not deleted");
                            }
                        
                        
                    }
                
                
                }
                for (Team* object in self.meetObject.teams) {
                    if ([self.teamServerMutableArray containsObject:object.onlineID]) {
                        NSLog(@"team exists dont delete teamname %@", object.teamName);
                    }
                    else
                    {
                            NSLog(@"team not on server delete teamname %@", object.teamName);
                            if ([object.editDone boolValue]||(![object.edited boolValue])) {
                                 NSLog(@" editDone or not edited so deleted");
                                [self.managedObjectContext deleteObject:object];
    
                            }
                            else
                            {
                                NSLog(@"edited and not edit done so not deleted");
                            }
                        
                    }
                
                
                }
                for (Event* object in self.meetObject.events) {
                    if ([self.eventServerMutableArray containsObject:object.onlineID]) {
                        NSLog(@"event exists dont delete eventid %@", object.eventID);
                    }
                    else
                    {
                            NSLog(@"event not on server delete eventid %@", object.eventID);
                            if ([object.editDone boolValue]||(![object.edited boolValue])) {
                                 NSLog(@" editDone or not edited so deleted");
                                [self.managedObjectContext deleteObject:object];
    
                            }
                            else
                            {
                                NSLog(@"edited and not edit done so not deleted");
                            }
                    }
                
                
                }
                for (Competitor* object in self.meetObject.competitors) {
                    if ([self.compServerMutableArray containsObject:object.onlineID]) {
                        NSLog(@"comp exists dont delete compname %@", object.compName);
                    }
                    else
                    {
                            NSLog(@"comp not on server delete compname %@", object.compName);
                            if ([object.editDone boolValue]||(![object.edited boolValue])) {
                                 NSLog(@" editDone or not edited so deleted");
                                [self.managedObjectContext deleteObject:object];
    
                            }
                            else
                            {
                                NSLog(@"edited and not edit done so not deleted");
                            }
                        
                    }
                
                
                }
                for (CEventScore* object in self.meetObject.cEventsScores) {
                    if ([self.cscoreServerMutableArray containsObject:object.onlineID]) {
                        NSLog(@"cscore exists dont delete cscoreid %@", object.cEventScoreID);
                    }
                    else
                    {
                            NSLog(@"cscore not on server delete cscoreid %@", object.cEventScoreID);
                            if ([object.editDone boolValue]||(![object.edited boolValue])) {
                                 NSLog(@" editDone or not edited so deleted");
                                [self.managedObjectContext deleteObject:object];
                                
                                NSLog(@"^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
    
                            }
                            else
                            {
                                NSLog(@"edited and not edit done so not deleted");
                            }
                    }
                
                
                }
            
                        if (![self.managedObjectContext save:&errorscore]) {
                        }
            
                         NSLog(@"successful update");
            dispatch_async(dispatch_get_main_queue(), ^{
            [self resumeMethod];
            });
        }
        else
        {
                NSLog(@"unsuccesful update");
             dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"Update From Server Failed"
                                    message:@"Failed to update from online database, please check your internet connection, ensure you are signed in to iCloud and you have upgraded to iCloud Drive before trying again\n \n You may continue to enter results and send them when you re-establish a working connection. \n \n Please be aware that your event information may not be up to date"
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
                });

        }
         
    
        
}


- (id) fetchObjectType:(NSString*) entityName WithOnlineID: (NSString*) onlineID IsOwnerNumber: (NSNumber*) isOwner {
   
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSLog(@"in fetch object %@  ", entityName);
NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"onlineID == %@", onlineID];



NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"meet.isOwner == %@", isOwner];

     NSArray *preds = [NSArray arrayWithObjects: pred1, pred2, nil];
            NSPredicate *predall = [NSCompoundPredicate andPredicateWithSubpredicates:preds];


            [fetchRequest setPredicate:predall];


    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if ([results count] > 0) {
    return results[0];
    }
    else
    {
    
        return nil;
    }


}


- (void)updateOnlineMeet {
    
    
        NSLog(@"updating meet");
        [self pauseMethod];
    
            NSDateComponents *comps = [[NSDateComponents alloc] init];
    
                [comps setYear:1970];
                NSDate *oldDate = [[NSCalendar currentCalendar] dateFromComponents:comps];
    
    
            Meet* meetObject = self.meetObject;
    
            NSMutableDictionary* objectsDictionary = [[NSMutableDictionary alloc] init];

    
            NSManagedObjectContext* context = self.managedObjectContext;
    
            CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];

            NSPredicate *predicatemeet = [NSPredicate predicateWithFormat:@"onlineID = %@", meetObject.onlineID];
    
            NSPredicate *predicaterest = [NSPredicate predicateWithFormat:@"meetOnlineID = %@", meetObject.onlineID];
    
            NSPredicate *predicateowner = [NSPredicate predicateWithFormat:@"updateByUser = %@", @"owner"];

    
    
    
         //   NSArray *preds1 = [NSArray arrayWithObjects: predicatemeet, predicateuser, nil];
    
         NSArray *preds1 = [NSArray arrayWithObjects: predicatemeet,predicateowner, nil];
            NSPredicate *predicateM = [NSCompoundPredicate andPredicateWithSubpredicates:preds1];
            //NSArray *preds2 = [NSArray arrayWithObjects: predicaterest, predicateuser, nil];
    
            NSArray *preds2 = [NSArray arrayWithObjects: predicaterest, predicateowner, nil];
            NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:preds2];
    
    
                 //////// start query 1 meet
    
    
    
                CKQuery *queryMeet = [[CKQuery alloc] initWithRecordType:@"Meet" predicate:predicateM];
                CKQueryOperation *queryOpMeet = [[CKQueryOperation alloc] initWithQuery:queryMeet];
    
               queryOpMeet.database = publicDatabase;
    
            //execute query
    
    
    
    
    
                queryOpMeet.recordFetchedBlock = ^(CKRecord *meet)
                {
                
                
                
                NSLog(@"in queryopmeet recordfetchedblock");
                    Meet* meetObject = self.meetObject;
                    bool updating = NO;
                NSString* objectType = @"Meet";
                    
                    
                    if (meetObject != nil) {
                        NSLog(@" %@ exists",objectType);
                    }
                    else
                    {
                        meetObject = [NSEntityDescription insertNewObjectForEntityForName:objectType inManagedObjectContext:context];
                        
                         NSLog(@" new %@ created",objectType);
                        
                        
                         meetObject.updateDateAndTime = oldDate;
                        
                    }

                
                
                if (self.meetObject.updateDateAndTime != nil)
                    {
                    }
                    else
                    {
                        meetObject.updateDateAndTime = oldDate;
                    }
                        
                    
                    
                    
                        if( [meet[@"updateDateAndTime"] timeIntervalSinceDate: meetObject.updateDateAndTime] > 0 ) {

                            
                            NSLog(@"needs an update %@ ", meet[@"meetName"]);
                            
                            if ( meetObject.edited) {
                                updating = NO;
                            
                            }
                            if ( meetObject.editDone) {
                                updating = YES;
                            }
                           
                        }
                        else
                        {
                            NSLog(@"no update needed %@ ", meet[@"meetName"]);
                            updating = NO;
                        }
                    
                    
                    
                        if (updating)
                            {

                            meetObject.editDone = [NSNumber numberWithBool:YES];
                            meetObject.edited = [NSNumber numberWithBool:NO];
                            meetObject.meetDate = meet[@"meetDate"];
                            meetObject.meetName = meet[@"meetName"];
                            meetObject.cEventLimit = meet[@"cEventLimit"];
                            meetObject.competitorPerTeam = meet[@"competitorPerTeam"];
                            meetObject.decrementPerPlace = meet[@"decrementPerPlace"];
                            meetObject.divsDone = meet[@"divsDone"];
                            meetObject.eventsDone = meet[@"eventsDone"];
                            meetObject.maxScoringCompetitors = meet[@"maxScoringCompetitors"];
                            meetObject.meetDate = meet[@"meetDate"];
                            meetObject.meetEndTime = meet[@"meetEndTime"];
                            meetObject.meetID = meet[@"meetID"];
                            meetObject.meetName = meet[@"meetName"];
                            meetObject.meetStartTime = meet[@"meetStartTime"];
                            meetObject.scoreForFirstPlace = meet[@"scoreForFirstPlace"];
                            meetObject.scoreMultiplier = meet[@"scoreMultiplier"];
                            meetObject.teamsDone = meet[@"teamsDone"];
                            meetObject.onlineMeet = meet[@"onlineMeet"];
                            meetObject.updateDateAndTime = [NSDate date];
                            meetObject.updateByUser = meet[@"updateByUser"];
                            meetObject.isOwner = meet[@"isOwner"];
                            meetObject.onlineID = meet[@"onlineID"];
                    
                            [objectsDictionary setValue:meetObject forKey:meetObject.onlineID];


                            NSLog(@"updating meet %@ ", meetObject.meetName);
                            _navBar.title = meetObject.meetName;
                            }
                    
                };

                queryOpMeet.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  meet query error %@", error);
                    [self endUpdateOnlineMeetWithSuccess:NO];
                    }
                    else
                    {
                     NSLog(@"query meet succesful");
                     
                     }
                };

    
    //////// end query 1 meet

    //////// start query 2 div
    
    
    
                CKQuery *queryDiv = [[CKQuery alloc] initWithRecordType:@"Division" predicate:predicate];
                CKQueryOperation *queryOpDiv = [[CKQueryOperation alloc] initWithQuery:queryDiv];
    
               queryOpDiv.database = publicDatabase;
            //execute query
    
                self.divServerMutableArray = [[NSMutableArray alloc] init];
    
                queryOpDiv.recordFetchedBlock = ^(CKRecord *div)
                {
                    //do something
                    
                    [self.divServerMutableArray addObject:div[@"onlineID"]];
                    
                    NSString* objectType = @"Division";
                    
                    Division *divObject = [self fetchObjectType:objectType WithOnlineID:div[@"onlineID"] IsOwnerNumber:[NSNumber numberWithBool:NO]];
                    if (divObject != nil) {
                        NSLog(@" %@ exists",objectType);
                    }
                    else
                    {
                        divObject = [NSEntityDescription insertNewObjectForEntityForName:@"Division" inManagedObjectContext:context];
                        
                         NSLog(@" new %@ created",objectType);
                        
                         divObject.updateDateAndTime = oldDate;
                    }
                    
                    if (divObject.updateDateAndTime != nil)
                    {
                    }
                    else
                    {
                        divObject.updateDateAndTime = oldDate;
                    }
                        
                    
                    
                    
                    bool updating = NO;
                    
                        if( [div[@"updateDateAndTime"] timeIntervalSinceDate:divObject.updateDateAndTime] > 0 ) {

                            if (divObject.edited) {
                                updating = NO;
                                NSLog(@"locked for editing %@ ", div[@"divName"]);
                            
                            }
                            if (divObject.editDone) {
                                updating = YES;
                                NSLog(@"editing done %@ ", div[@"divName"]);
                            }
                        }
                        else
                        {
                            NSLog(@"local object date %@ and server date %@",divObject.updateDateAndTime,div[@"updateDateAndTime"] );
                            NSLog(@"no update needed %@ ", div[@"divName"]);
                            updating = NO;
                        }
                    
                    
                    
                        if (updating)
                            {

   
                    
                    
                 //   Division* divObject = [NSEntityDescription insertNewObjectForEntityForName:@"Division" inManagedObjectContext:context];
                            divObject.editDone = [NSNumber numberWithBool:YES];
                            divObject.edited = [NSNumber numberWithBool:NO];
                            divObject.divID = div[@"divID"];
                            divObject.divName = div[@"divName"];
                            divObject.onlineID = div[@"onlineID"];
                            divObject.updateByUser = div[@"updateByUser"];
                            divObject.updateDateAndTime = [NSDate date];
                    
                            divObject.meet = meetObject;
                    
                            [objectsDictionary setValue:divObject forKey:divObject.onlineID];

                            NSLog(@"updating div %@ ", divObject.divName);
                            
                            }
                    
                };

                queryOpDiv.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  div query error %@", error);
                    [self endUpdateOnlineMeetWithSuccess:NO];
                    }
                    else
                    {
                     NSLog(@"query div succesful");
                     
                     }
                };

                [queryOpDiv addDependency:queryOpMeet];
    
    //////// end query 2 div

    //////// start query 3 gevent
    
    
    
                CKQuery *queryGEvent = [[CKQuery alloc] initWithRecordType:@"GEvent" predicate:predicate];
                CKQueryOperation *queryOpGEvent = [[CKQueryOperation alloc] initWithQuery:queryGEvent];
    
               queryOpGEvent.database = publicDatabase;
            //execute query
    self.geventServerMutableArray = [[NSMutableArray alloc] init];
    
                queryOpGEvent.recordFetchedBlock = ^(CKRecord *gevent)
                {
                    //do something
                    [self.geventServerMutableArray addObject:gevent[@"onlineID"]];
                    NSString* objectType = @"GEvent";
                    
                    GEvent* gEventObject = [self fetchObjectType:objectType WithOnlineID:gevent[@"onlineID"] IsOwnerNumber:[NSNumber numberWithBool:NO]];
                    if (gEventObject != nil) {
                        NSLog(@" %@ exists",objectType);
                    }
                    else
                    {
                        gEventObject = [NSEntityDescription insertNewObjectForEntityForName:@"GEvent" inManagedObjectContext:context];
                        
                         NSLog(@" new %@ created",objectType);
                             gEventObject.updateDateAndTime = oldDate;
                    }
                    
                    if (gEventObject.updateDateAndTime != nil)
                    {
                    }
                    else
                    {
                        gEventObject.updateDateAndTime = oldDate;
                    }
                        
                    
                    bool updating = NO;
                    
                        if( [gevent[@"updateDateAndTime"] timeIntervalSinceDate:gEventObject.updateDateAndTime] > 0 ) {

                            if (gEventObject.edited) {
                                updating = NO;
                                NSLog(@"locked for editing %@ ", gevent[@"gEventName"]);
                            }
                            if (gEventObject.editDone) {
                                updating = YES;
                                NSLog(@"editing done %@ ", gevent[@"gEventName"]);
                            }
                        }
                        else
                        {
                            NSLog(@"no update needed %@ ", gevent[@"gEventName"]);
                            updating = NO;
                        }
                    
                    
                    
                        if (updating)
                            {
                            gEventObject.editDone = [NSNumber numberWithBool:YES];
                            gEventObject.edited = [NSNumber numberWithBool:NO];
                            gEventObject.competitorsPerTeam = gevent[@"competitorsPerTeam"];
                            gEventObject.decrementPerPlace = gevent[@"decrementPerPlace"];
                            gEventObject.gEventID = gevent[@"gEventID"];
                            gEventObject.gEventName = gevent[@"gEventName"];
                            gEventObject.gEventTiming = gevent[@"gEventTiming"];
                            gEventObject.gEventType = gevent[@"gEventType"];
                            gEventObject.maxScoringCompetitors = gevent[@"maxScoringCompetitors"];
                            gEventObject.onlineID = gevent[@"onlineID"];
                            gEventObject.scoreForFirstPlace = gevent[@"scoreForFirstPlace"];
                            gEventObject.scoreMultiplier = gevent[@"scoreMultiplier"];
                            gEventObject.updateByUser = gevent[@"updateByUser"];
                            gEventObject.updateDateAndTime = [NSDate date];
                    
                            gEventObject.meet = meetObject;
                    
                            [objectsDictionary setValue:gEventObject forKey:gEventObject.onlineID];

                            NSLog(@"updating gevent %@ ", gEventObject.gEventName);
                            }
                    
                };

                queryOpGEvent.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  gevent query error %@", error);
                    [self endUpdateOnlineMeetWithSuccess:NO];
                    }
                    else
                    {
                     NSLog(@"query gevent succesful");
                     
                     }
                };

                [queryOpGEvent addDependency:queryOpDiv];
    
    //////// end query 3 gevent

    //////// start query 4 team
    
    
                CKQuery *queryTeam = [[CKQuery alloc] initWithRecordType:@"Team" predicate:predicate];
                CKQueryOperation *queryOpTeam = [[CKQueryOperation alloc] initWithQuery:queryTeam];
    
               queryOpTeam.database = publicDatabase;
            //execute query
                self.teamServerMutableArray = [[NSMutableArray alloc] init];
    
                queryOpTeam.recordFetchedBlock = ^(CKRecord *team)
                {
                    //do something
                    [self.teamServerMutableArray addObject:team[@"onlineID"]];
                    NSString* objectType = @"Team";
                    
                    Team* teamObject = [self fetchObjectType:objectType WithOnlineID:team[@"onlineID"] IsOwnerNumber:[NSNumber numberWithBool:NO]];
                    if (teamObject != nil) {
                        NSLog(@" %@ exists",objectType);
                    }
                    else
                    {
                        teamObject = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:context];
                        
                         NSLog(@" new %@ created",objectType);
                        teamObject.updateDateAndTime = oldDate;
                    }
                    
                    if (teamObject.updateDateAndTime != nil)
                    {
                    }
                    else
                    {
                        teamObject.updateDateAndTime = oldDate;
                    }
                        
                    
                    bool updating = NO;
                    
                        if( [team[@"updateDateAndTime"] timeIntervalSinceDate:teamObject.updateDateAndTime] > 0 ) {

                            if (teamObject.edited) {
                                updating = NO;
                                NSLog(@"locked for editing %@ ", team[@"teamName"]);
                            }
                            if (teamObject.editDone) {
                                updating = YES;
                                NSLog(@"editing done %@ ", team[@"teamName"]);
                            }
                        }
                        else
                        {
                            NSLog(@"no update needed %@ ", team[@"teamName"]);
                            updating = NO;
                        }
                    
                    
                    
                    if (updating)
                        {

                        teamObject.editDone = [NSNumber numberWithBool:YES];
                            teamObject.edited = [NSNumber numberWithBool:NO];
                        teamObject.onlineID = team[@"onlineID"];
                        teamObject.teamAbr = team[@"teamAbr"];
                        teamObject.teamID = team[@"teamID"];
                        teamObject.teamName = team[@"teamName"];
                        teamObject.teamPlace = team[@"teamPlace"];
                        teamObject.teamScore = team[@"teamScore"];
                        teamObject.updateByUser = team[@"updateByUser"];
                        teamObject.updateDateAndTime = [NSDate date];
                    
                            teamObject.meet = meetObject;
                    
                            [objectsDictionary setValue:teamObject forKey:teamObject.onlineID];
                    
                            

                            NSLog(@"updating team %@ ", teamObject.teamName);
                        }
                };

                queryOpTeam.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  Team query error %@", error);
                    [self endUpdateOnlineMeetWithSuccess:NO];
                    }
                    else
                    {
                     NSLog(@"query Team succesful");
                     
                     }
                };

                [queryOpTeam addDependency:queryOpGEvent];
    
    //////// end query 4 team
    
    
        //////// start query 5 Event
    
    
    
                CKQuery *queryEvent = [[CKQuery alloc] initWithRecordType:@"Event" predicate:predicate];
                CKQueryOperation *queryOpEvent = [[CKQueryOperation alloc] initWithQuery:queryEvent];
    
               queryOpEvent.database = publicDatabase;
            //execute query
    self.eventServerMutableArray = [[NSMutableArray alloc] init];
    
                queryOpEvent.recordFetchedBlock = ^(CKRecord *event)
                {
                    //do something
                    [self.eventServerMutableArray addObject:event[@"onlineID"]];
                    NSString* objectType = @"Event";
                    
                    Event* eventObject = [self fetchObjectType:objectType WithOnlineID:event[@"onlineID"] IsOwnerNumber:[NSNumber numberWithBool:NO]];
                    if (eventObject != nil) {
                        NSLog(@" %@ exists",objectType);
                    }
                    else
                    {
                        eventObject = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
                        
                         NSLog(@" new %@ created",objectType);
                         eventObject.updateDateAndTime = oldDate;
                         eventObject.eventDone = [NSNumber numberWithBool:NO];
                    }
                    
                    if (eventObject.updateDateAndTime != nil)
                    {
                    }
                    else
                    {
                        eventObject.updateDateAndTime = oldDate;
                    }
                        
                    
                    bool updating = NO;
                    
                        if( [event[@"updateDateAndTime"] timeIntervalSinceDate:eventObject.updateDateAndTime] > 0 ) {

                            if (eventObject.edited) {
                                updating = NO;
                                NSLog(@"locked for editing %@ ", event[@"eventID"]);
                            }
                            if (eventObject.editDone) {
                                updating = YES;
                                NSLog(@"editing done %@ ", event[@"eventID"]);
                            }
                        }
                        else
                        {
                            NSLog(@"no update needed %@ ", event[@"eventID"]);
                            updating = NO;
                        }
                    
                    
                    
                    if (updating)
                        {
                        
                        if (eventObject.eventDone) {
                            [self copyEventToBackUpAndDeleteWithOnlineId:eventObject.onlineID];
                        }
                        
                        eventObject.editDone = [NSNumber numberWithBool:YES];
                            eventObject.edited = [NSNumber numberWithBool:NO];
                        eventObject.eventDone = event[@"eventDone"];
                        eventObject.eventEdited = event[@"eventEdited"];
                        eventObject.eventID = event[@"eventID"];
                        eventObject.onlineID = event[@"onlineID"];
                        eventObject.startTime = event[@"startTime"];
                        eventObject.updateByUser = event[@"updateByUser"];
                        eventObject.updateDateAndTime = [NSDate date];
                    
                        eventObject.meet = meetObject;
                    
                        eventObject.division = [objectsDictionary valueForKey:event[@"division"]];
                        eventObject.gEvent = [objectsDictionary valueForKey: event[@"gEvent"]];
                    
                    
                    
                            [objectsDictionary setValue:eventObject forKey:eventObject.onlineID];

                            NSLog(@"updating event %@ %@", eventObject.gEvent.gEventName, eventObject.division.divName);
                        }
                    
                };

                queryOpEvent.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  Event query error %@", error);
                        [self endUpdateOnlineMeetWithSuccess:NO];
                    }
                    else
                    {
                     NSLog(@"query Event succesful");
                     
                     }
                };

                [queryOpEvent addDependency:queryOpGEvent];
                [queryOpEvent addDependency:queryOpDiv];
    
    //////// end query 5 Event
    
    //////// start query 6 Comp
    
    
    
                CKQuery *queryComp = [[CKQuery alloc] initWithRecordType:@"Competitor" predicate:predicate];
                CKQueryOperation *queryOpComp = [[CKQueryOperation alloc] initWithQuery:queryComp];
    
               queryOpComp.database = publicDatabase;
            //execute query
    self.compServerMutableArray = [[NSMutableArray alloc] init];
    
                queryOpComp.recordFetchedBlock = ^(CKRecord *comp)
                {
                    //do something
                    [self.compServerMutableArray addObject:comp[@"onlineID"]];
                    NSString* objectType = @"Competitor";
                    
                    Competitor* compObject  = [self fetchObjectType:objectType WithOnlineID:comp[@"onlineID"] IsOwnerNumber:[NSNumber numberWithBool:NO]];
                    if (compObject != nil) {
                        NSLog(@" %@ exists",objectType);
                    }
                    else
                    {
                        compObject = [NSEntityDescription insertNewObjectForEntityForName:@"Competitor" inManagedObjectContext:context];
                        
                         NSLog(@" new %@ created",objectType);
                         compObject.updateDateAndTime = oldDate;
                    }
                    
                    if (compObject.updateDateAndTime != nil)
                    {
                    }
                    else
                    {
                        compObject.updateDateAndTime = oldDate;
                    }
                        
                    
                    bool updating = NO;
                    
                        if( [comp[@"updateDateAndTime"] timeIntervalSinceDate:compObject.updateDateAndTime] > 0 ) {

                            if (compObject.edited) {
                                updating = NO;
                                NSLog(@"locked for editing %@ ", comp[@"compName"]);
                            }
                            if (compObject.editDone) {
                                updating = YES;
                                NSLog(@"editing done %@ ", comp[@"compName"]);
                            }
                        }
                        else
                        {
                            NSLog(@"no update needed %@ ", comp[@"compName"]);
                            updating = NO;
                        }
                    
                    
                    
                    if (updating)
                        {
                        compObject.editDone = [NSNumber numberWithBool:YES];
                            compObject.edited = [NSNumber numberWithBool:NO];
                        compObject.compID = comp[@"compID"];
                        compObject.compName = comp[@"compName"];
                        compObject.onlineID = comp[@"onlineID"];
                        compObject.teamName = comp[@"teamName"];
                        compObject.updateByUser = comp[@"updateByUser"];
                    compObject.updateDateAndTime = [NSDate date];
                    
                        compObject.meet = meetObject;
                    
                    
                        compObject.team = [objectsDictionary valueForKey:comp[@"team"]];
                    
                    
                    
                            [objectsDictionary setValue:compObject forKey:compObject.onlineID];

                            NSLog(@"updating comp %@ in team : %@", compObject.compName, compObject.team.teamName);
                            
                        }
                    
                };

                queryOpComp.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  Comp query error %@", error);
                        [self endUpdateOnlineMeetWithSuccess:NO];
                    }
                    else
                    {
                     NSLog(@"query Comp succesful");
                     
                     }
                };

                [queryOpComp addDependency:queryOpTeam];
    
    
    //////// end query 6 Comp

    //////// start query 7 cscore
    
    
    
                CKQuery *queryCScore = [[CKQuery alloc] initWithRecordType:@"CEventScore" predicate:predicate];
                CKQueryOperation *queryOpCScore = [[CKQueryOperation alloc] initWithQuery:queryCScore];
    
               queryOpCScore.database = publicDatabase;
            //execute query
    self.cscoreServerMutableArray = [[NSMutableArray alloc] init];
    
                queryOpCScore.recordFetchedBlock = ^(CKRecord *cscore)
                {
                    //do something
                    
                    [self.cscoreServerMutableArray addObject:cscore[@"onlineID"]];
                    NSString* objectType = @"CEventScore" ;
                    
                     CEventScore* cscoreObject  = [self fetchObjectType:objectType WithOnlineID:cscore[@"onlineID"] IsOwnerNumber:[NSNumber numberWithBool:NO]];
                    if (cscoreObject != nil) {
                        NSLog(@" %@ exists",objectType);
                    }
                    else
                    {
                        cscoreObject = [NSEntityDescription insertNewObjectForEntityForName:@"CEventScore" inManagedObjectContext:context];
                        
                         NSLog(@" new %@ created",objectType);
                         cscoreObject.updateDateAndTime = oldDate;
                    }
                    
                    if (cscoreObject.updateDateAndTime != nil)
                    {
                    }
                    else
                    {
                        cscoreObject.updateDateAndTime = oldDate;
                    }
                        
                    
                    bool updating = NO;
                    
                        if( [cscore[@"updateDateAndTime"] timeIntervalSinceDate:cscoreObject.updateDateAndTime] > 0 ) {

                            if (cscoreObject.edited) {
                                updating = NO;
                                NSLog(@"locked for editing cscore %@ ", cscore[@"cEventScoreID"]);
                            }
                            if (cscoreObject.editDone) {
                                updating = YES;
                                NSLog(@"editing done cscore %@ ", cscore[@"cEventScoreID"]);
                            }
                        }
                        else
                        {
                            NSLog(@"no update needed cscore %@ ", cscore[@"cEventScoreID"]);
                            updating = NO;
                        }
                    
                    
                    
                    if (updating)
                        {
                    cscoreObject.editDone = [NSNumber numberWithBool:YES];
                    cscoreObject.edited = [NSNumber numberWithBool:NO];
                    cscoreObject.cEventScoreID = cscore[@"cEventScoreID"];
                    cscoreObject.highJumpPlacingManual = cscore[@"highJumpPlacingManual"];
                    cscoreObject.onlineID = cscore[@"onlineID"];
                    cscoreObject.personalBest = cscore[@"personalBest"];
                    cscoreObject.placing = cscore[@"placing"];
                    cscoreObject.result = cscore[@"result"];
                    cscoreObject.resultEntered = cscore[@"resultEntered"];
                    cscoreObject.score = cscore[@"score"];
                    cscoreObject.updateByUser = cscore[@"updateByUser"];
                    cscoreObject.updateDateAndTime = [NSDate date];

                        cscoreObject.meet = meetObject;

                        cscoreObject.event = [objectsDictionary valueForKey:cscore[@"event"]];
                        cscoreObject.team = [objectsDictionary valueForKey:cscore[@"team"]];
                        cscoreObject.competitor = [objectsDictionary valueForKey:cscore[@"competitor"]];
                    
                    
                    
                            [objectsDictionary setValue:cscoreObject forKey:cscoreObject.onlineID];

                            NSLog(@"updating cscore for comp %@", cscoreObject.competitor.compName);
                        }
                    
                };

                queryOpCScore.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  cscore query error %@", error);
                        [self endUpdateOnlineMeetWithSuccess:NO];
                    }
                    else
                    {
                     NSLog(@"query cscore succesful");
                        
                       [self endUpdateOnlineMeetWithSuccess:YES];

                     }
                    
                };

                [queryOpCScore addDependency:queryOpComp];
                [queryOpCScore addDependency:queryOpEvent];
    
    
    //////// end query 7 Event
    
   
    
    
    
    

                NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                [queue addOperation: queryOpMeet];
                [queue addOperation: queryOpDiv];
                [queue addOperation: queryOpGEvent];
                [queue addOperation: queryOpTeam];
                [queue addOperation: queryOpEvent];
                [queue addOperation: queryOpComp];
                [queue addOperation: queryOpCScore];

}



- (IBAction)updateOnlineButtonPressed:(UIBarButtonItem *)sender {
    
    if ([self.meetObject.isOwner boolValue]) {
        NSLog(@"owner item updatemeet");
               [self updateOwnerFromServer];
               // [self updateOwnerToOnline];

    }
    else
    {
        NSLog(@"just update");
        [self updateOnlineMeet];
    }
}

////////////
/// owner refresh
///////////

- (void)updateOwnerFromServer {
NSLog(@"updating owner meet");
    
    
        [self pauseMethod];
    
    
            Meet* meetObject = self.meetObject;
    
            self.queue = [[NSOperationQueue alloc] init];

    
            NSManagedObjectContext* context = self.managedObjectContext;
    
            CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    
    
            /////////////
            ///// Get updatebyuser values
            /////////////
    
            NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"meetOnlineID = %@", meetObject.onlineID];
    
             NSPredicate *predicateuser = [NSPredicate predicateWithFormat:@"updateByUser != %@",@"owner" ];
    
    
    
            NSArray *preds = [NSArray arrayWithObjects: predicateID, predicateuser, nil];
    
    
                NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:preds];
    
    
                 //////// start query 1 meet
    
    
                CKQuery *queryEvent = [[CKQuery alloc] initWithRecordType:@"Event" predicate:predicate];
                CKQueryOperation *queryOpEventID = [[CKQueryOperation alloc] initWithQuery:queryEvent];
    
               queryOpEventID.database = publicDatabase;
            //execute query

                self.updatedNonOwnerEventIDsMutableArray = [[NSMutableArray alloc] init];
                self.updatedNonOwnerEventRecordIDsMutableArray = [[NSMutableArray alloc] init];
    
                queryOpEventID.recordFetchedBlock = ^(CKRecord *event)
                {
                    
                      [self.updatedNonOwnerEventIDsMutableArray addObject:event[@"onlineID"] ];
                      [self.updatedNonOwnerEventRecordIDsMutableArray addObject:event.recordID ];
                       // [self updateOwnerFromServerTwo:event[@"updateByUser"]];
                    
                      //  [self copyEventToBackUpAndDeleteWithOnlineId:event[@"onlineID"]];
                    
                };

                queryOpEventID.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor event for local owner query error %@", error);
                    
                    self.updateOnlineSuccess = NO;
                    [self updateOwnerDone];
                    }
                    else
                    {
                     NSLog(@"query event for local owner update succesful");
                        if ([self.updatedNonOwnerEventIDsMutableArray count ]>0) {
                            
                            NSLog(@"number of events updating %lu and recordIDs %lu",(unsigned long)[self.updatedNonOwnerEventIDsMutableArray count ],(unsigned long)[self.updatedNonOwnerEventRecordIDsMutableArray count ]);
                            self.updateFromServerIndexTotal = [self.updatedNonOwnerEventRecordIDsMutableArray count ];
                            self.updateFromServerIndexCounter = 0;
                               [self updateOwnerFromServerTwo:self.updateFromServerIndexCounter];
                            
                        }
                        else
                        {
                            NSLog(@"nothing to update");
                            
                            self.updateOnlineSuccess = YES;
                            [self updateOwnerDone];
                        }
                        
                    }
                };
                [self.queue addOperation: queryOpEventID];
                ///////////
                ////    end get updatebyuser get ids
                ///////////
    
    
    
    

}

- (void)updateOwnerFromServerTwo: (int) indexOfArray {
    
    NSLog(@"&&&&&&&&&&&&& uodate server two index %d",indexOfArray);
            Meet* meetObject = self.meetObject;
            NSManagedObjectContext* context = self.managedObjectContext;

            NSString* objectType = @"Event";
    
    
            Event* thisEventObject = [self fetchObjectType:objectType WithOnlineID:self.updatedNonOwnerEventIDsMutableArray[indexOfArray] IsOwnerNumber:[NSNumber numberWithBool:YES]];
    
    
                    if (thisEventObject != nil) {
                        NSLog(@" %@ exists in first bit",objectType);
                        NSLog(@"******** found an online event and will update owner local ****");
                        [self copyEventToBackUpAndDeleteWithOnlineId:self.updatedNonOwnerEventIDsMutableArray[indexOfArray]];
                    }
                    else
                    {
                        thisEventObject = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
                        
                         NSLog(@" new %@ created in first bit",objectType);
                        
                    }
    
            CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
    

    
            NSPredicate *predicateID = [NSPredicate predicateWithFormat:@"meetOnlineID = %@", meetObject.onlineID];
    
             NSPredicate *predicateUser = [NSPredicate predicateWithFormat:@"updateByUser != %@",@"owner" ];
    
          //  NSPredicate *predicateE = [NSPredicate predicateWithFormat:@"onlineID = %@",self.updatedNonOwnerEventIDsMutableArray[indexOfArray] ];
    
    // changes to take back if failed
             NSPredicate *predicateE = [NSPredicate predicateWithFormat:@"recordID = %@",self.updatedNonOwnerEventRecordIDsMutableArray[indexOfArray] ];

    
            NSArray *predsEvent = [NSArray arrayWithObjects: predicateID, predicateUser, predicateE ,nil];
    
    
                NSPredicate *predicateForEvent = [NSCompoundPredicate andPredicateWithSubpredicates:predsEvent];
    
    
        CKRecordID* tempRecordID = self.updatedNonOwnerEventRecordIDsMutableArray[indexOfArray];
        NSPredicate *predicateEventRecordName = [NSPredicate predicateWithFormat:@"eventRecordID = %@", tempRecordID.recordName];
    
        //// start query 3 div
             //  NSPredicate *predicateDiv = [NSPredicate predicateWithFormat:@"event = %@",self.updatedNonOwnerEventIDsMutableArray[indexOfArray] ];
    
                NSArray *predsDiv = [NSArray arrayWithObjects: predicateID, predicateUser,  predicateEventRecordName ,nil];
    
    
                NSPredicate *predicateForDiv = [NSCompoundPredicate andPredicateWithSubpredicates:predsDiv];
    
    
    
    
    
                CKQuery *queryDiv = [[CKQuery alloc] initWithRecordType:@"Division" predicate:predicateForDiv];
                CKQueryOperation *queryOpDiv = [[CKQueryOperation alloc] initWithQuery:queryDiv];
    
               queryOpDiv.database = publicDatabase;
            //execute query
   
    
                queryOpDiv.recordFetchedBlock = ^(CKRecord *div)
                {
                    //do something
                    
                    self.ownerUpdateDiv = div;
                    
                    
                };

                queryOpDiv.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  cscore query error %@", error);
                       self.updateOnlineSuccess = NO;
                       [self updateOwnerDone];
                    }
                    else
                    {
                     NSLog(@"query div succesful");
                        self.updateOnlineSuccess = YES;
                     }
                    
                };

    
    
        // end query 3 div
    
         //// start query 4 gevent
    
             //   NSPredicate *predicateGEvent = [NSPredicate predicateWithFormat:@"event = %@",self.updatedNonOwnerEventIDsMutableArray[indexOfArray] ];
    
                NSArray *predsGEvent = [NSArray arrayWithObjects: predicateID, predicateUser, predicateEventRecordName ,nil];
    
    
                NSPredicate *predicateForGEvent = [NSCompoundPredicate andPredicateWithSubpredicates:predsGEvent];
    
    
    
    
    
                CKQuery *queryGEvent = [[CKQuery alloc] initWithRecordType:@"GEvent" predicate:predicateForGEvent];
                CKQueryOperation *queryOpGEvent = [[CKQueryOperation alloc] initWithQuery:queryGEvent];
    
               queryOpGEvent.database = publicDatabase;
            //execute query
   
    
                queryOpGEvent.recordFetchedBlock = ^(CKRecord *gevent)
                {
                    //do something
                    
                    self.ownerUpdateGEvent = gevent;
                    
                    
                };

                queryOpGEvent.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  cscore query error %@", error);
                       self.updateOnlineSuccess = NO;
                       [self updateOwnerDone];
                    }
                    else
                    {
                     NSLog(@"query GEvent succesful");
                        self.updateOnlineSuccess = YES;
                     }
                    
                };


    
    
    
        // end query 4 gevent
        //////// start query 5 Event
    
                self.eventsIDSUpdatedSuccesfullyToDelete = [[NSMutableArray alloc] init];
    
    
    
    
    
                CKQuery *queryEvent = [[CKQuery alloc] initWithRecordType:@"Event" predicate:predicateForEvent];
                CKQueryOperation *queryOpEvent = [[CKQueryOperation alloc] initWithQuery:queryEvent];
    
               queryOpEvent.database = publicDatabase;
            //execute query
   
    
                queryOpEvent.recordFetchedBlock = ^(CKRecord *event)
                {
                    //do something
                 
                    NSString* objectType = @"Event";
                    
                    Event* eventObject = [self fetchObjectType:objectType WithOnlineID:event[@"onlineID"] IsOwnerNumber:[NSNumber numberWithBool:YES]];
                    
                    
                    if (eventObject != nil) {
                        NSLog(@" %@ exists ",objectType);
                        
                    }
                    else
                    {
                        eventObject = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
                        
                         NSLog(@" new %@ created",objectType);
                        
                    }
                    
                    
                    
                        eventObject.editDone = [NSNumber numberWithBool:YES];
                        eventObject.edited = [NSNumber numberWithBool:NO];
                        eventObject.eventDone = [NSNumber numberWithBool:YES];
                        eventObject.eventEdited = event[@"eventEdited"];
                        eventObject.eventID = event[@"eventID"];
                        eventObject.onlineID = event[@"onlineID"];
                        eventObject.startTime = event[@"startTime"];
                        eventObject.updateByUser = @"owner";
                        eventObject.updateDateAndTime = [NSDate date];
                    
                        eventObject.meet = meetObject;
                    
                        Division* divObject = [self fetchObjectType:@"Division" WithOnlineID:event[@"division"] IsOwnerNumber:[NSNumber numberWithBool:YES]];
                    
                        if (divObject != nil) {
                        NSLog(@" %@ exists ",@"Division");
                            
                        }
                        else
                        {
                            divObject = [NSEntityDescription insertNewObjectForEntityForName:@"Division" inManagedObjectContext:context];
                            
                              CKRecord *div = self.ownerUpdateDiv;
                            
                            ////add div load from online div
                            divObject.editDone = [NSNumber numberWithBool:YES];
                            divObject.edited = [NSNumber numberWithBool:NO];
                            divObject.divID = div[@"divID"];
                            divObject.divName = div[@"divName"];
                            divObject.onlineID = div[@"onlineID"];
                            divObject.updateByUser = @"owner";
                            divObject.updateDateAndTime = [NSDate date];
                    
                            divObject.meet = meetObject;

                            
                            
                             NSLog(@" new %@ created",@"Division");
                            
                        }
                    
                    
                    
                        GEvent* gEventObject = [self fetchObjectType:@"GEvent" WithOnlineID:event[@"gEvent"] IsOwnerNumber:[NSNumber numberWithBool:YES]];
                    
                        if (gEventObject != nil) {
                        NSLog(@" %@ exists ",@"GEvent");
                            
                        }
                        else
                        {
                            gEventObject = [NSEntityDescription insertNewObjectForEntityForName:@"GEvent" inManagedObjectContext:context];
                            
                            CKRecord *gevent = self.ownerUpdateGEvent;
                            
                            ////add gevent load from online div
                            gEventObject.editDone = [NSNumber numberWithBool:YES];
                            gEventObject.edited = [NSNumber numberWithBool:NO];
                            gEventObject.competitorsPerTeam = gevent[@"competitorsPerTeam"];
                            gEventObject.decrementPerPlace = gevent[@"decrementPerPlace"];
                            gEventObject.gEventID = gevent[@"gEventID"];
                            gEventObject.gEventName = gevent[@"gEventName"];
                            gEventObject.gEventTiming = gevent[@"gEventTiming"];
                            gEventObject.gEventType = gevent[@"gEventType"];
                            gEventObject.maxScoringCompetitors = gevent[@"maxScoringCompetitors"];
                            gEventObject.onlineID = gevent[@"onlineID"];
                            gEventObject.scoreForFirstPlace = gevent[@"scoreForFirstPlace"];
                            gEventObject.scoreMultiplier = gevent[@"scoreMultiplier"];
                            gEventObject.updateByUser = @"owner";
                            gEventObject.updateDateAndTime = [NSDate date];
                    
                            gEventObject.meet = meetObject;

                            
                            
                             NSLog(@" new %@ created",@"GEvent");
                            
                        }
                    
                    
                    
                    
                        /// add divs and gevents and teams here if needed
                    
                        eventObject.division = divObject;
                        eventObject.gEvent = gEventObject;
                    
                    

                            NSLog(@"updating owner event  %@ %@", eventObject.gEvent.gEventName, eventObject.division.divName);
                           [self.eventsIDSUpdatedSuccesfullyToDelete addObject:event.recordID];
                    
                    
                };

                queryOpEvent.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  Event query error %@", error);
                        self.updateOnlineSuccess = NO;
                        [self updateOwnerDone];
                    }
                    else
                    {
                     NSLog(@"query Event succesful");
                     
                     
                     }
                };

            [queryOpEvent addDependency:queryOpDiv];
            [queryOpEvent addDependency:queryOpGEvent];
    
    //////// end query 5 Event
    
    
    //// query teams
    
                  //  NSPredicate *predicateTeam = [NSPredicate predicateWithFormat:@"event = %@",self.updatedNonOwnerEventIDsMutableArray[indexOfArray] ];
    
                NSArray *predsTeam = [NSArray arrayWithObjects: predicateID, predicateUser, predicateEventRecordName ,nil];
    
    
                NSPredicate *predicateForTeam = [NSCompoundPredicate andPredicateWithSubpredicates:predsTeam];
    
    
    
    
    
                CKQuery *queryTeam = [[CKQuery alloc] initWithRecordType:@"Team" predicate:predicateForTeam];
                CKQueryOperation *queryOpTeam = [[CKQueryOperation alloc] initWithQuery:queryTeam];
    
               queryOpTeam.database = publicDatabase;
            //execute query
    
                self.ownerUpdateTeamMutableDict = [[NSMutableDictionary alloc] init];
    
                queryOpTeam.recordFetchedBlock = ^(CKRecord *team)
                {
                    //do something
                    NSString* onlineID = team[@"onlineID"];
                    
                    [self.ownerUpdateTeamMutableDict setValue:team forKey:onlineID];
                    
                    
                };

                queryOpTeam.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  cscore query error %@", error);
                       self.updateOnlineSuccess = NO;
                       [self updateOwnerDone];
                    }
                    else
                    {
                     NSLog(@"query Team succesful");
                        self.updateOnlineSuccess = YES;
                     }
                    
                };


    
    
    
    
    [queryOpTeam addDependency:queryOpEvent];
    
    //// query teams end
    
    
    
    /////
    //// end operation
    
    NSOperation *saveContextOp = [NSBlockOperation blockOperationWithBlock:^(void)
    { /* code here */
    
            [self saveContext];
            NSLog(@"savecontextopp");
        
        
        
    } ];
    NSOperation *saveContextAfterTeamOp = [NSBlockOperation blockOperationWithBlock:^(void)
    { /* code here */
    
            [self saveContext];
            NSLog(@"savecontextopp");
        
        
        
    } ];
    
    ////
    ////
    
    //////// start query 7 cscore
    
    NSPredicate *predicateScore = [NSPredicate predicateWithFormat:@"event = %@",self.updatedNonOwnerEventIDsMutableArray[indexOfArray] ];
    
    
            NSArray *predsScore = [NSArray arrayWithObjects: predicateID, predicateUser, predicateScore, predicateEventRecordName ,nil];
    
    
                NSPredicate *predicateForScore = [NSCompoundPredicate andPredicateWithSubpredicates:predsScore];
    
    
    
    
    
                CKQuery *queryCScore = [[CKQuery alloc] initWithRecordType:@"CEventScore" predicate:predicateForScore];
                CKQueryOperation *queryOpCScore = [[CKQueryOperation alloc] initWithQuery:queryCScore];
    
               queryOpCScore.database = publicDatabase;
            //execute query
   
    
                queryOpCScore.recordFetchedBlock = ^(CKRecord *cscore)
                {
                    //do something
                    
                    NSLog(@"cscore fetched in import with EventRecordName %@", cscore[@"eventRecordID"]);
                    
                     CEventScore* cscoreObject  = [self fetchObjectType:@"CEventScore" WithOnlineID:cscore[@"onlineID"] IsOwnerNumber:[NSNumber numberWithBool:YES]];
                    if (cscoreObject != nil) {
                        NSLog(@" %@ exists",@"CEventScore");
                    }
                    else
                    {
                        cscoreObject = [NSEntityDescription insertNewObjectForEntityForName:@"CEventScore" inManagedObjectContext:context];
                        
                         NSLog(@" new %@ created",@"CEventScore");
                        
                    }
                    
                    NSLog(@"score id %@", cscore[@"competitor"]);
                    cscoreObject.editDone = [NSNumber numberWithBool:YES];
                    cscoreObject.edited = [NSNumber numberWithBool:NO];
                    cscoreObject.cEventScoreID = cscore[@"cEventScoreID"];
                    cscoreObject.highJumpPlacingManual = cscore[@"highJumpPlacingManual"];
                    cscoreObject.onlineID = cscore[@"onlineID"];
                    cscoreObject.personalBest = cscore[@"personalBest"];
                    cscoreObject.placing = cscore[@"placing"];
                    cscoreObject.result = cscore[@"result"];
                    cscoreObject.resultEntered = cscore[@"resultEntered"];
                    cscoreObject.score = cscore[@"score"];
                    cscoreObject.updateByUser = @"owner";
                    cscoreObject.updateDateAndTime = [NSDate date];

                        cscoreObject.meet = meetObject;

                        cscoreObject.event = thisEventObject;
                    
                    
                        Team* teamObject = [self fetchObjectType:@"Team" WithOnlineID:cscore[@"team"] IsOwnerNumber:[NSNumber numberWithBool:YES]];
                    
                        if (teamObject != nil) {
                        NSLog(@" %@ exists ",@"Team");
                            
                        }
                        else
                        {
                            teamObject = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:context];
                            
                            CKRecord* team = [self.ownerUpdateTeamMutableDict valueForKey:cscore[@"team"]];
                            
                            ////add @"Team" load from online @"Team"
                            teamObject.editDone = [NSNumber numberWithBool:YES];
                            teamObject.edited = [NSNumber numberWithBool:NO];
                            teamObject.onlineID = team[@"onlineID"];
                            teamObject.teamAbr = team[@"teamAbr"];
                            teamObject.teamID = team[@"teamID"];
                            teamObject.teamName = team[@"teamName"];
                            teamObject.teamPlace = team[@"teamPlace"];
                            teamObject.teamScore = team[@"teamScore"];
                            teamObject.updateByUser = @"owner";
                            teamObject.updateDateAndTime = [NSDate date];
                    
                            teamObject.meet = meetObject;

                            
                            
                             NSLog(@" new %@ created",@"Team");
                            
                        }
                    
                        cscoreObject.team = teamObject;
                   
                    
                    
                    
                    //////// start query 6 Comp
                    
                    NSLog(@"score id %@", cscore[@"competitor"]);
    
                    NSPredicate *predicateComp = [NSPredicate predicateWithFormat:@"onlineID = %@", cscore[@"competitor"] ];
    
    
                    NSArray *predsComp = [NSArray arrayWithObjects: predicateID, predicateUser, predicateComp,predicateEventRecordName ,nil];
    
    
                        NSPredicate *predicateForComp = [NSCompoundPredicate andPredicateWithSubpredicates:predsComp];
    
                        CKQuery *queryComp = [[CKQuery alloc] initWithRecordType:@"Competitor" predicate:predicateForComp];
                        CKQueryOperation *queryOpComp = [[CKQueryOperation alloc] initWithQuery:queryComp];
    
                        queryOpComp.database = publicDatabase;
                        //execute query
        
                        queryOpComp.recordFetchedBlock = ^(CKRecord *comp)
                        {
                            //do something
                   
                        NSLog(@"comp fetched in import with EventRecordName %@", comp[@"eventRecordID"]);
                    
                        Competitor* compObject  = [self fetchObjectType:@"Competitor" WithOnlineID:comp[@"onlineID"] IsOwnerNumber:[NSNumber numberWithBool:YES]];
                            if (compObject != nil) {
                            NSLog(@" %@ 2 exists",@"competitor");
                            }
                            else
                            {
                                compObject = [NSEntityDescription insertNewObjectForEntityForName:@"Competitor" inManagedObjectContext:context];
                        
                                    NSLog(@" new %@ 2 created",@"competitor");
                        
                            }
                    
                            compObject.editDone = [NSNumber numberWithBool:YES];
                            compObject.edited = [NSNumber numberWithBool:NO];
                            compObject.compID = comp[@"compID"];
                            compObject.compName = comp[@"compName"];
                            compObject.onlineID = comp[@"onlineID"];
                            compObject.teamName = comp[@"teamName"];
                            compObject.updateByUser = @"owner";
                            compObject.updateDateAndTime = [NSDate date];
                    
                            compObject.meet = meetObject;
                    
                    
                            compObject.team = teamObject;
                    

                            NSLog(@"updating comp %@ in team : %@", compObject.compName, compObject.team.teamName);
                            cscoreObject.competitor = compObject;
                    
                    
                            };

                            queryOpComp.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                            {
                
                                if (error) {
                                NSLog(@"CKQueryCursor  Comp query error %@", error);
                                    self.updateOnlineSuccess = NO;
                                    [self updateOwnerDone];
                                }
                                else
                                {
                                NSLog(@"query Comp succesful");
                                    self.updateOnlineSuccess = YES;
                                    
                                }
                                
                            };

                                [queryOpComp addDependency:queryOpEvent];
                                [queryOpComp addDependency:queryOpTeam];
    
                            //////// end query 6 Comp
    

                            [saveContextOp addDependency:queryOpComp];

    
                            [self.queue addOperation: queryOpComp];
                    
                
                    
                    
                };

                queryOpCScore.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  cscore query error %@", error);
                       self.updateOnlineSuccess = NO;
                       [self updateOwnerDone];
                    }
                    else
                    {
                     NSLog(@"query cscore succesful");
                        self.updateOnlineSuccess = YES;
                     }
                    
                };

    
                [queryOpCScore addDependency:saveContextAfterTeamOp];
    
    
    
    //////// end query 7 cscore

    
    ////////// end operation start
    [saveContextOp addDependency:queryOpEvent];
    [saveContextOp addDependency:queryOpCScore];
    
    [saveContextAfterTeamOp addDependency:queryOpTeam];
  
  [self.queue addOperation: queryOpDiv];
  [self.queue addOperation: queryOpGEvent];
  [self.queue addOperation: queryOpEvent];
   [self.queue addOperation: queryOpTeam];
   [self.queue addOperation: saveContextAfterTeamOp];
     [self.queue addOperation: queryOpCScore];
    
    [self.queue addOperation: saveContextOp];
    
     NSOperation *endUpdateOwnerOp = [NSBlockOperation blockOperationWithBlock:^(void)
    { /* code here */
        
        
        
            NSLog(@"ended");
            [self updateOwnerDone];
        
    } ];
    
    [endUpdateOwnerOp addDependency:saveContextOp];
    
    [self.queue addOperation: endUpdateOwnerOp];

    
}
- (void) copyEventToBackUpAndDeleteWithOnlineId: (NSString*) onlineid {
    
    
    NSLog(@"copyEventToBackupAndDeleteWithOnlineId");
                //Meet* meetObject = self.meetObject;
            NSManagedObjectContext* context = self.managedObjectContext;

            NSString* objectType = @"Event";
    
    bool var = YES;
    
    if ([self.meetObject.isOwner boolValue]) {
        var = YES;
    }
    else
    {
    var = NO;
    }
    
             Event* thisEventObject = [self fetchObjectType:objectType WithOnlineID:onlineid IsOwnerNumber:[NSNumber numberWithBool:var]];
    
    
    
    ////////////////
    //// Create backups
    ////////////////
    if ([thisEventObject.eventDone boolValue]) {
    
    
    
        BackupEvent *event = [NSEntityDescription insertNewObjectForEntityForName:@"BackupEvent" inManagedObjectContext:context];
                event.meet = self.meetObject;
                event.gEvent = thisEventObject.gEvent;
                event.division = thisEventObject.division;
                event.eventEdited = thisEventObject.eventEdited;
                event.eventDone = thisEventObject.eventDone;
    
    
 
                event.editDone  = thisEventObject.editDone;
                event.edited = thisEventObject.edited;


                event.eventID = thisEventObject.eventID;
                event.onlineID = thisEventObject.onlineID;
                event.startTime = thisEventObject.startTime;
                event.updateByUser = thisEventObject.updateByUser;
                event.updateDateAndTime = thisEventObject.updateDateAndTime;
                event.backupDate = [NSDate date];

                for (CEventScore* oldcscore in thisEventObject.cEventScores) {

                    BackupCEventScore *cscore = [NSEntityDescription insertNewObjectForEntityForName:@"BackupCEventScore" inManagedObjectContext:context];
                    
                    
                        cscore.cEventScoreID = oldcscore.cEventScoreID;
                        cscore.editDone  = oldcscore.editDone;
                        cscore.edited = oldcscore.edited;
                        cscore.highJumpPlacingManual = oldcscore.highJumpPlacingManual;
                        cscore.onlineID = oldcscore.onlineID;
                        cscore.personalBest = oldcscore.personalBest;
                        cscore.placing = oldcscore.placing;
                        cscore.result = oldcscore.result;
                        cscore.resultEntered = oldcscore.resultEntered;
                        cscore.score = oldcscore.score;
                        cscore.updateByUser = oldcscore.updateByUser;
                        cscore.updateDateAndTime = oldcscore.updateDateAndTime;

                        cscore.backupEvent = event;
                    
                        NSLog(@"event gevent name %@ ", cscore.backupEvent.gEvent.gEventName);
                        cscore.meet = oldcscore.meet;
                        cscore.team = oldcscore.team;

                    
                        BackupCompetitor *comp = [NSEntityDescription insertNewObjectForEntityForName:@"BackupCompetitor" inManagedObjectContext:context];
                    
                        Competitor *oldcomp = oldcscore.competitor;
                    
                    
                        comp.compID = oldcomp.compID;
                        comp.compName = oldcomp.compName;
                        comp.editDone = oldcomp.editDone;
                        comp.edited = oldcomp.edited;
                        comp.onlineID = oldcomp.onlineID;
                        comp.teamName = oldcomp.teamName;
                        comp.updateByUser = oldcomp.updateByUser;
                        comp.updateDateAndTime = oldcomp.updateDateAndTime ;

                        comp.meet = oldcomp.meet;
                        comp.team = oldcomp.team;
                        comp.backupEvent = event;
                    
                    
    
                        cscore.backupCompetitor = comp;
    
    
                }
    }
    NSLog(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
    if ([self.meetObject.isOwner boolValue]) {
    
    NSLog(@"backed up and is owner so now deleting");
    
    
            for (CEventScore* cscore in thisEventObject.cEventScores) {
            
                NSLog(@"deleting object x cscore with value  %@", cscore.result);
                [context deleteObject:cscore];
            
            }
    }
    else
    {
        
        NSLog(@"backed up and is not owner so not deleting");
    
    }
    
    [self saveContext];


}
- (void) revertEventFromBackup {


}
- (void)updateOwnerDone {
    
    
    
    
    if (self.updateOnlineSuccess) {
        NSLog(@"update success");
        
                        NSMutableArray* changesMute = [[NSMutableArray alloc] init];
                        NSArray *localChanges = [changesMute copy];
                        NSArray *localDeletions = [self.eventsIDSUpdatedSuccesfullyToDelete copy];
              
                
               // Initialize the database and modify records operation
             
               CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
             
             
               CKModifyRecordsOperation *modifyRecordsOperation = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:localChanges recordIDsToDelete:localDeletions];
               modifyRecordsOperation.savePolicy = CKRecordSaveAllKeys;

               NSLog(@"CLOUDKIT Changes Uploading: %lu", (unsigned long)localChanges.count);

               // Add the completion block
               modifyRecordsOperation.modifyRecordsCompletionBlock = ^(NSArray *savedRecords, NSArray *deletedRecordIDs, NSError *error) {
                   
                   
                   if (error) {
                       NSLog(@"[%@] Error pushing local data: %@", self.class, error);
                       
                        NSLog(@"Uh oh, there was an error deleting stored events ... %@", error);
                       
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


                       
                       
                   
                   }
                   
                   self.updateFromServerIndexCounter++;
                    NSLog(@"updatefromservercounter %d",self.updateFromServerIndexCounter);
                  if (self.updateFromServerIndexCounter<self.updateFromServerIndexTotal) {
                      [self updateOwnerFromServerTwo:self.updateFromServerIndexCounter];
                      
                      //for testing loop below
                      /** for testing loop
                      dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertController * alert=   [UIAlertController
                                                    alertControllerWithTitle:@"next event"
                                                    message:@"next event doing now"
                                                    preferredStyle:UIAlertControllerStyleAlert];
                     
                     
                                UIAlertAction* ok = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            [self updateOwnerFromServerTwo:self.updateFromServerIndexCounter];
                                            [alert dismissViewControllerAnimated:YES completion:nil];
                                             
                                        }];
                                        
                                [alert addAction:ok];
                     
                                [self presentViewController:alert animated:YES completion:nil];
                                });
                      
                      **/
                      
                    }
                    else
                    {
                        [self updateOwnerToOnline];
                    
                    }

                 
                   

               };
               
               

               // Start the operation
               [database addOperation:modifyRecordsOperation];

        
        
    }
    else
    {
        NSLog(@"update failed");
        dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"Update From Server Failed"
                                    message:@"Failed to update from online database, please check your internet connection, ensure you are signed in to iCloud and you have upgraded to iCloud Drive before trying again"
                                    preferredStyle:UIAlertControllerStyleAlert];
     
     
                UIAlertAction* ok = [UIAlertAction
                        actionWithTitle:@"OK"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            
                            
                            
                            [alert dismissViewControllerAnimated:YES completion:nil];
                            
                              [self updateOwnerToOnline];
                           
                             
                        }];
                        
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                });

        
    }
    
    
    
    
    

}

- (void)updateOwnerToOnline {




// Initialize the data
   NSMutableArray *localChangesMute = [[NSMutableArray alloc] init];;
   self.serverdeletes = [[NSMutableArray alloc] init];
   
   
     CKRecord* meetrecord = [self addMeetOnline:self.meetObject];
    [localChangesMute addObject:meetrecord];
    
    CKReference* ref = [[CKReference alloc] initWithRecord:meetrecord action:CKReferenceActionDeleteSelf];
   
    self.divLocalMutableArray = [[NSMutableArray alloc] init];
    self.geventLocalMutableArray = [[NSMutableArray alloc] init];
    self.teamLocalMutableArray = [[NSMutableArray alloc] init];
    self.eventLocalMutableArray = [[NSMutableArray alloc] init];
    self.compLocalMutableArray = [[NSMutableArray alloc] init];
    self.cscoreLocalMutableArray = [[NSMutableArray alloc] init];
    
    
    
   
    for (Division* div in self.meetObject.divisions) {
        
        [self.divLocalMutableArray addObject:div.onlineID];
        
        CKRecord *divrecord = [self addDivisionOnline:div];
        
        
        [divrecord setObject:ref forKey:@"owningMeet"];
        
        [localChangesMute addObject:divrecord];
    }
    
    for (GEvent* gevent in self.meetObject.gEvents) {
        [self.geventLocalMutableArray addObject:gevent.onlineID];
        CKRecord *geventrecord = [self addGEventOnline:gevent];
        
        [geventrecord setObject:ref forKey:@"owningMeet"];
        
        [localChangesMute addObject:geventrecord];
    }
    
    for (Team* team in self.meetObject.teams) {
        
        [self.teamLocalMutableArray addObject:team.onlineID];
        CKRecord *teamrecord = [self addTeamOnline:team];
        
        [teamrecord setObject:ref forKey:@"owningMeet"];
        
        [localChangesMute addObject:teamrecord];
    }
    
    for (Event* event in self.meetObject.events) {
        
        [self.eventLocalMutableArray addObject:event.onlineID];
        CKRecord *eventrecord = [self addEventOnline:event];
        
        [eventrecord setObject:ref forKey:@"owningMeet"];
        
        [localChangesMute addObject:eventrecord];
    }
    
    for (Competitor* comp in self.meetObject.competitors) {
        
        [self.compLocalMutableArray addObject:comp.onlineID];
        CKRecord *comprecord = [self addCompOnline:comp];
        
        [comprecord setObject:ref forKey:@"owningMeet"];
        
        [localChangesMute addObject:comprecord];
    }
    
    
    
    for (CEventScore* cscore in self.meetObject.cEventsScores) {
        
        [self.cscoreLocalMutableArray addObject:cscore.onlineID];
        CKRecord *cscorerecord = [self addCScoreOnline:cscore];
        
        [cscorerecord setObject:ref forKey:@"owningMeet"];
        
        [localChangesMute addObject:cscorerecord];
    }
    
    
    //////////
    ////
    //////////
 
    
    Meet* meetObject = self.meetObject;

    
            CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];

    
            NSPredicate *predicaterest = [NSPredicate predicateWithFormat:@"meetOnlineID = %@", meetObject.onlineID];
    
            //NSPredicate *predicateuser = [NSPredicate predicateWithFormat:@"updateByUser = %@",@"owner" ];
    
    
            //NSArray *preds2 = [NSArray arrayWithObjects: predicaterest, predicateuser, nil];
    
            NSArray *preds2 = [NSArray arrayWithObjects: predicaterest, nil];
            NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:preds2];
    
    
    
    //////// start query 2 div
    
    
    
                CKQuery *queryDiv = [[CKQuery alloc] initWithRecordType:@"Division" predicate:predicate];
                CKQueryOperation *queryOpDiv = [[CKQueryOperation alloc] initWithQuery:queryDiv];
    
               queryOpDiv.database = publicDatabase;
            //execute query
    
    
    
                queryOpDiv.recordFetchedBlock = ^(CKRecord *div)
                {
                    //do something
                    
                    if ([self.divLocalMutableArray containsObject: div[@"onlineID"]]) {
                        NSLog(@"div exists dont delete ");
                    }
                    else
                    {
                            NSLog(@"div not on server delete ");
                        
                        [self.serverdeletes addObject:[div recordID]];
                    
                    }
                };

                queryOpDiv.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  div query error %@", error);
                        
                    }
                    else
                    {
                     NSLog(@"query div succesful");
                        
                        
                        
                     }
                };


    
    //////// end query 2 div

    //////// start query 3 gevent
    
    
    
                CKQuery *queryGEvent = [[CKQuery alloc] initWithRecordType:@"GEvent" predicate:predicate];
                CKQueryOperation *queryOpGEvent = [[CKQueryOperation alloc] initWithQuery:queryGEvent];
    
               queryOpGEvent.database = publicDatabase;
            //execute query
    
    
                queryOpGEvent.recordFetchedBlock = ^(CKRecord *gevent)
                {
                    //do something
                    if ([self.geventLocalMutableArray containsObject: gevent[@"onlineID"]]) {
                        NSLog(@"gevent exists dont delete ");
                    }
                    else
                    {
                            NSLog(@"gevent not in local delete ");
                    
                        [self.serverdeletes addObject:[gevent recordID]];
                    
                    }

                    
                };

                queryOpGEvent.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  gevent query error %@", error);
                    }
                    else
                    {
                     NSLog(@"query gevent succesful");
                     
                     }
                };

                [queryOpGEvent addDependency:queryOpDiv];
    
    //////// end query 3 gevent

    //////// start query 4 team
    
    
                CKQuery *queryTeam = [[CKQuery alloc] initWithRecordType:@"Team" predicate:predicate];
                CKQueryOperation *queryOpTeam = [[CKQueryOperation alloc] initWithQuery:queryTeam];
    
               queryOpTeam.database = publicDatabase;
            //execute query
    
    
                queryOpTeam.recordFetchedBlock = ^(CKRecord *team)
                {
                    //do something
                    if ([self.teamLocalMutableArray containsObject: team[@"onlineID"]]) {
                        NSLog(@"team exists dont delete ");
                    }
                    else
                    {
                            NSLog(@"team not on server delete ");
                    
                        
                        [self.serverdeletes addObject:[team recordID]];
                    
                    }
                };

                queryOpTeam.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  Team query error %@", error);
                    
                    }
                    else
                    {
                     NSLog(@"query Team succesful");
                     
                    }
                };

                [queryOpTeam addDependency:queryOpGEvent];
    
    //////// end query 4 team
    
    
        //////// start query 5 Event
    
    
    
                CKQuery *queryEvent = [[CKQuery alloc] initWithRecordType:@"Event" predicate:predicate];
                CKQueryOperation *queryOpEvent = [[CKQueryOperation alloc] initWithQuery:queryEvent];
    
               queryOpEvent.database = publicDatabase;
            //execute query
    
    
                queryOpEvent.recordFetchedBlock = ^(CKRecord *event)
                {
                    //do something
                   if ([self.eventLocalMutableArray containsObject: event[@"onlineID"]]) {
                        NSLog(@"event exists dont delete ");
                    }
                    else
                    {
                            NSLog(@"event not on server delete ");
                    
                        [self.serverdeletes addObject:[event recordID]];
                    }
                    
                };

                queryOpEvent.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  Event query error %@", error);
                        
                    }
                    else
                    {
                     NSLog(@"query Event succesful");
                    
                     }
                };

                [queryOpEvent addDependency:queryOpGEvent];
                [queryOpEvent addDependency:queryOpDiv];
    
    //////// end query 5 Event
    
    //////// start query 6 Comp
    
    
    
                CKQuery *queryComp = [[CKQuery alloc] initWithRecordType:@"Competitor" predicate:predicate];
                CKQueryOperation *queryOpComp = [[CKQueryOperation alloc] initWithQuery:queryComp];
    
               queryOpComp.database = publicDatabase;
            //execute query
    
    
                queryOpComp.recordFetchedBlock = ^(CKRecord *comp)
                {
                    //do something
                     if ([self.compLocalMutableArray containsObject: comp[@"onlineID"]]) {
                        NSLog(@"comp exists dont delete ");
                    }
                    else
                    {
                            NSLog(@"comp not on server delete ");
                    
                        [self.serverdeletes addObject:[comp recordID]];
                    
                    }
                };

                queryOpComp.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  Comp query error %@", error);
                        
                    }
                    else
                    {
                     NSLog(@"query Comp succesful");
                     
                     }
                };

                [queryOpComp addDependency:queryOpTeam];
    
    
    //////// end query 6 Comp

    //////// start query 7 cscore
    
    
    
                CKQuery *queryCScore = [[CKQuery alloc] initWithRecordType:@"CEventScore" predicate:predicate];
                CKQueryOperation *queryOpCScore = [[CKQueryOperation alloc] initWithQuery:queryCScore];
    
               queryOpCScore.database = publicDatabase;
            //execute query
    
                queryOpCScore.recordFetchedBlock = ^(CKRecord *cscore)
                {
                    //do something
                    
                     if ([self.cscoreLocalMutableArray containsObject: cscore[@"onlineID"]]) {
                        NSLog(@"cscore exists dont delete ");
                    }
                    else
                    {
                            NSLog(@"cscore not local delete ");
                    
                        [self.serverdeletes addObject:[cscore recordID]];
                    
                    }
                    
                };

                queryOpCScore.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                {
                
                    if (error) {
                    NSLog(@"CKQueryCursor  cscore query error %@", error);
                        
                    }
                    else
                    {
                     NSLog(@"query cscore succesful");
                       
                       
                       NSLog(@"all deletes and all adds done sending");
                       
                        [self ownerUpdateOnlineWithChanges:localChangesMute AndDeletions:self.serverdeletes];
                     }
                    
                };

                [queryOpCScore addDependency:queryOpComp];
                [queryOpCScore addDependency:queryOpEvent];
    
    
    //////// end query 7 Event
    
   
    
    
    
    

                NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
                [queue addOperation: queryOpDiv];
                [queue addOperation: queryOpGEvent];
                [queue addOperation: queryOpTeam];
                [queue addOperation: queryOpEvent];
                [queue addOperation: queryOpComp];
                [queue addOperation: queryOpCScore];

    
    
    
 
  
    
      
}



- (void) ownerUpdateOnlineWithChanges: (NSMutableArray*) changesMute AndDeletions: (NSMutableArray*) deletionsMute {


  
  
  
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
            
                NSLog(@"OnlineID of saved: %@", record[@"onlineID"]);
            
            }
           
            for(CKRecord* recordID in deletedRecordIDs) {
            
                NSLog(@"Deleted record id: %@", recordID);
            }


           
           
            self.updateOnlineSuccess = YES;
       
       }
        
      // [localChanges removeObjectsInArray:savedRecords];
      // [self.localDeletions removeObjectsInArray:deletedRecordIDs];

       [self ownerUpdateOnlineDone];
       

   };
   
   

   // Start the operation
   [database addOperation:modifyRecordsOperation];
   
   
   
    

}



- (void) ownerUpdateOnlineDone {
    dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertController * alert;
    
    if (self.updateOnlineSuccess) {
            
            
            
            alert=   [UIAlertController
                                    alertControllerWithTitle:@"Database Update Successful"
                                    message:@"Current changes updated to online database"
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
        
        [self saveContext];
 

    }
    else
    {
    
        
        
       
    
                alert=   [UIAlertController
                                    alertControllerWithTitle:@"Update To Database Failed"
                                    message:@"Failed to save to online database, please check your internet connection, ensure you are signed in to iCloud and you have upgraded to iCloud Drive before trying again"
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
    
        [self presentViewController:alert animated:YES completion:nil];

    });

}


- (void) saveMeetToPlist {
//create array and dictionaries from objects with core data model as basis
//writetofile and initfromfile

//self.meetObject

Meet* meet = self.meetObject;

NSMutableDictionary * meetDict = [[NSMutableDictionary alloc] init];

meetDict[@"cEventLimit"] = meet.cEventLimit;
meetDict[@"competitorPerTeam"] = meet.competitorPerTeam;
meetDict[@"decrementPerPlace"] = meet.decrementPerPlace;
meetDict[@"divsDone"] = meet.divsDone;
meetDict[@"eventsDone"] = meet.eventsDone;
meetDict[@"maxScoringCompetitors"] = meet.maxScoringCompetitors;
meetDict[@"meetDate"] = meet.meetDate;
//meetDict[@"meetEndTime"] = meet.meetEndTime;
meetDict[@"meetID"] = meet.meetID;
meetDict[@"meetName"] = meet.meetName;
//meetDict[@"meetStartTime"] = meet.meetStartTime;
meetDict[@"scoreForFirstPlace"] = meet.scoreForFirstPlace;
meetDict[@"scoreMultiplier"] = meet.scoreMultiplier;
meetDict[@"teamsDone"] = meet.teamsDone;
meetDict[@"onlineMeet"] = meet.onlineMeet;
//meetDict[@"updateDateAndTime"] = meet.updateDateAndTime;
meetDict[@"updateByUser"] = meet.updateByUser;
meetDict[@"isOwner"] = meet.isOwner;
//meetDict[@"onlineID"] = meet.onlineID;
meetDict[@"editDone"] = meet.editDone;
meetDict[@"edited"] = meet.edited;

///////
//@property (nonatomic, retain) NSSet *divisions;

NSMutableArray* divisionsArray = [[NSMutableArray alloc] init];
    for (Division* div in meet.divisions) {
       NSMutableDictionary * divDict = [[NSMutableDictionary alloc] init];
       
        divDict[@"divID"] =  div.divID;
        divDict[@"divName"] = div.divName;
        divDict[@"updateByUser"] = div.updateByUser;
        //divDict[@"updateDateAndTime"] = div.updateDateAndTime;
        //divDict[@"onlineID"] = div.onlineID;
        divDict[@"editDone"] = div.editDone;
        divDict[@"edited"] = div.edited;
        
        // events
        divDict[@"meet"] = div.meet.meetID;
        
        [divisionsArray addObject:divDict];
    }

meetDict[@"divisions"] = divisionsArray;

//////
//@property (nonatomic, retain) NSSet *gEvents;

NSMutableArray* gEventsArray = [[NSMutableArray alloc] init];
    for (GEvent* gevent in meet.gEvents) {
       NSMutableDictionary * gEventDict = [[NSMutableDictionary alloc] init];
       
        gEventDict[@"competitorsPerTeam"] = gevent.competitorsPerTeam;
        gEventDict[@"decrementPerPlace"] = gevent.decrementPerPlace;
        gEventDict[@"gEventID"] = gevent.gEventID;
        gEventDict[@"gEventName"] = gevent.gEventName;
       // gEventDict[@"gEventTiming"] = gevent.gEventTiming;
        gEventDict[@"gEventType"] = gevent.gEventType;
        gEventDict[@"maxScoringCompetitors"] = gevent.maxScoringCompetitors;
        gEventDict[@"scoreForFirstPlace"] = gevent.scoreForFirstPlace;
        gEventDict[@"scoreMultiplier"] = gevent.scoreMultiplier;
        gEventDict[@"updateByUser"] = gevent.updateByUser;
        //gEventDict[@"updateDateAndTime"] = gevent.updateDateAndTime;
       // gEventDict[@"onlineID"] = gevent.onlineID;
        gEventDict[@"editDone"] = gevent.editDone;
        gEventDict[@"edited"] = gevent.edited;
        
        // events = do in event
        gEventDict[@"meet"] = gevent.meet.meetID;
        
        [gEventsArray addObject:gEventDict];
    }

meetDict[@"gEvents"] = gEventsArray;

//////
//@property (nonatomic, retain) NSSet *teams;

NSMutableArray* teamsArray = [[NSMutableArray alloc] init];
    for (Team* team in meet.teams) {
       NSMutableDictionary * teamDict = [[NSMutableDictionary alloc] init];
       
        teamDict[@"teamAbr"] = team.teamAbr;
        teamDict[@"teamID"] = team.teamID;
        teamDict[@"teamName"] = team.teamName;
        teamDict[@"teamPlace"] = team.teamPlace;
        teamDict[@"teamScore"] = team.teamScore;
        //teamDict[@"updateDateAndTime"] = team.updateDateAndTime;
        teamDict[@"updateByUser"] = team.updateByUser;
        //teamDict[@"onlineID"] = team.onlineID;
        teamDict[@"editDone"] = team.editDone;
        teamDict[@"edited"] = team.edited;


        
        //competitors, ceventscores do in them
        teamDict[@"meet"] = team.meet.meetID;
        
        [teamsArray addObject:teamDict];
    }

meetDict[@"teams"] = teamsArray;



//////
//@property (nonatomic, retain) NSSet *competitors;

NSMutableArray* compsArray = [[NSMutableArray alloc] init];
    for (Competitor* comp in meet.competitors) {
       NSMutableDictionary * compDict = [[NSMutableDictionary alloc] init];
       
        compDict[@"compID"] = comp.compID;
        compDict[@"compName"] = comp.compName;
        compDict[@"teamName"] = comp.teamName;
        compDict[@"updateByUser"] = comp.updateByUser;
       // compDict[@"updateDateAndTime"] = comp.updateDateAndTime;
       // compDict[@"onlineID"] = comp.onlineID;
        compDict[@"editDone"] = comp.editDone;
        compDict[@"edited"] = comp.edited;
        
        //ceventscores do in them
        compDict[@"team"] = comp.team.teamID;
        compDict[@"meet"] = comp.meet.meetID;
        [compsArray addObject:compDict];
    }

meetDict[@"competitors"] = compsArray;


//////
//@property (nonatomic, retain) NSSet *events;

NSMutableArray* eventsArray = [[NSMutableArray alloc] init];
    for (Event* event in meet.events) {
       NSMutableDictionary * eventDict = [[NSMutableDictionary alloc] init];
       
        eventDict[@"eventDone"] = event.eventDone;
        eventDict[@"eventEdited"] = event.eventEdited;
        eventDict[@"eventID"] = event.eventID;
       // eventDict[@"startTime"] = event.startTime;
        eventDict[@"updateByUser"] = event.updateByUser;
       // eventDict[@"updateDateAndTime"] = event.updateDateAndTime;
       // eventDict[@"onlineID"] = event.onlineID;
        eventDict[@"editDone"] = event.editDone;
        eventDict[@"edited"] = event.edited;


        
        //ceventscores do in them
        eventDict[@"division"] = event.division.divID;
        eventDict[@"gEvent"] = event.gEvent.gEventID;
        eventDict[@"meet"] = event.meet.meetID;
        [eventsArray addObject:eventDict];
    }

meetDict[@"events"] = eventsArray;



//////
//@property (nonatomic, retain) NSSet *cEventsScores;

NSMutableArray* cscoresArray = [[NSMutableArray alloc] init];
    for (CEventScore* cscore in meet.cEventsScores) {
       NSMutableDictionary * cscoreDict = [[NSMutableDictionary alloc] init];
       
       if (cscore.cEventScoreID) {
        cscoreDict[@"cEventScoreID"] = cscore.cEventScoreID;
        }
        if (cscore.highJumpPlacingManual) {
        cscoreDict[@"highJumpPlacingManual"] = cscore.highJumpPlacingManual;
        }
        //cscoreDict[@"personalBest"] = cscore.personalBest;
        if (cscore.placing) {
        cscoreDict[@"placing"] = cscore.placing;
        }
        if (cscore.result) {
        cscoreDict[@"result"] = cscore.result;
        }
        if (cscore.resultEntered) {
            cscoreDict[@"resultEntered"] = cscore.resultEntered;
        }
       
        if (cscore.score) {
        cscoreDict[@"score"] = cscore.score;
        }
        if (cscore.updateByUser) {
        cscoreDict[@"updateByUser"] = cscore.updateByUser;
        }
        //cscoreDict[@"updateDateAndTime"] = cscore.updateDateAndTime;
        //cscoreDict[@"onlineID"] = cscore.onlineID;
        if (cscore.edited) {
        cscoreDict[@"edited"] = cscore.edited;
        }
        if (cscore.editDone) {
        cscoreDict[@"editDone"] = cscore.editDone;
        }
        
        cscoreDict[@"competitor"] = cscore.competitor.compID;
        cscoreDict[@"event"] = cscore.event.eventID;
        cscoreDict[@"team"] = cscore.team.teamID;
        cscoreDict[@"meet"] = cscore.meet.meetID;
        
        
        [cscoresArray addObject:cscoreDict];
    }

meetDict[@"cEventsScores"] = cscoresArray;


NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    
    NSString *plistFileName = [NSString stringWithFormat:@"%@.plist",self.meetObject.meetName];
    
NSString*plistPath = [documentDirectory stringByAppendingPathComponent:plistFileName];

[meetDict writeToFile:plistPath atomically: YES];


NSString *emailTitle = @"Export Meet Plist";
    
    NSString* subjectString = [NSString stringWithFormat:@"Plist Of Athletics Meet %@", self.meetObject.meetName];
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Plist of Athletics Meet %@ ", self.meetObject.meetName];
    // To address
    
    
    NSData *myData = [NSData dataWithContentsOfFile:plistPath];
    
    
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setSubject:subjectString];
    
    [mc setMessageBody:messageBody isHTML:NO];
    
    [mc addAttachmentData:myData mimeType:@"application/xml" fileName:plistFileName];
    
   
    
    
    // Present mail view controller on screen
    
    self.exportmeet = YES;
    
    [self presentViewController:mc animated:YES completion:NULL];

}
/**
- (IBAction)ExportResultsButton:(UIBarButtonItem *)sender {
    [self saveMeetToPlist];
}
**/

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
    
    self.exportresults = YES;
    
    [self presentViewController:mc animated:YES completion:NULL];

}


- (IBAction)unwindToMeetMenu:(UIStoryboardSegue *)unwindSegue
{


    /*
    if ([unwindSegue.sourceViewController isKindOfClass:[MeetAddViewController class]])
    {
    
    }
    */
}

@end
