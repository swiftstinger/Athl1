//
//  MasterViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 22/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "MasterViewController.h"
#import "MeetMenuViewController.h"
#import "MeetTableViewCell.h"
#import "Meet.h"
#import "Division.h"
#import "GEvent.h"
#import "Team.h"
#import "Competitor.h"
#import "CEventScore.h"
#import "Event.h"
#import "Entry.h"

@interface MasterViewController ()

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    [self tutorialCode];
}

/**
-(void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
   //something here
   
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
     
     
     if (![defaults objectForKey:@"importingOnlineMeet"]) {

     }
     else
     {
        if ([[defaults objectForKey:@"importingOnlineMeet"] boolValue]) {
            

            
        }
        
         NSNumber *importing = [NSNumber numberWithBool:FALSE];
        [defaults setObject: importing forKey:@"importingOnlineMeet"];
        [defaults synchronize];
         
     }
    
    
}
**/
- (void) importedMeet {
    self.segmentedControl.selectedSegmentIndex = 1;
            NSLog(@"here");
    
            [self segmentedControlValueChanged:self.segmentedControl];
                    dispatch_async(dispatch_get_main_queue(), ^{
                
                    UIAlertController * alert=   [UIAlertController
                                            alertControllerWithTitle:@"Online Meet Imported"
                                            message:@"Imported online meet successfully. \n Tap on meet labeled 'NewOnlineMeet' to download the new meet's name and details. \n\n Notice! \n\n After this the name will change"
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

}
- (void) importedCsv {
    
    
dispatch_async(dispatch_get_main_queue(), ^{
                
    UIAlertController * alert=   [UIAlertController
                        alertControllerWithTitle:@"CSV File Imported"
                        message:@"Imported CSV file succesfully. \n\n Please navigate to the Meet and Section in which you would like to import the items listed in the .csv file and click Import \n\n Please remember that any text between comma's will be seen as a single entry"
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




}
- (void) setExampleMeet {

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ExampleMeet" ofType:@"plist"];
NSMutableDictionary *meetDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];

NSLog(@"meetname %@",meetDict[@"meetName"]);

NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    Meet *meet = [NSEntityDescription insertNewObjectForEntityForName:@"Meet" inManagedObjectContext:context];
    
        
        ////////
        /////   set values
        ///////
        if (meetDict[@"meetName"]) {
        [meet setValue: meetDict[@"meetName"] forKey:@"meetName"];
            
        }
        if (meetDict[@"meetDate"]) {
        [meet setValue: meetDict[@"meetDate"] forKey:@"meetDate"];
            
        }
        if (meetDict[@"cEventLimit"]) {
        [meet setValue: meetDict[@"cEventLimit"] forKey:@"cEventLimit"];
            
        }
        
        
        if (meetDict[@"competitorPerTeam"]) {
        [meet setValue: meetDict[@"competitorPerTeam"] forKey:@"competitorPerTeam"];
    
        }

        
        if (meetDict[@"maxScoringCompetitors"]) {
        [meet setValue: meetDict[@"maxScoringCompetitors"] forKey:@"maxScoringCompetitors"];
    
        }
        
        if (meetDict[@"scoreForFirstPlace"]) {
        [meet setValue: meetDict[@"scoreForFirstPlace"] forKey:@"scoreForFirstPlace"];
    
        }
        
        if (meetDict[@"decrementPerPlace"]) {
        [meet setValue: meetDict[@"decrementPerPlace"] forKey:@"decrementPerPlace"];
    
        }
        
        
         if (meetDict[@"scoreMultiplier"]) {
        [meet setValue: meetDict[@"scoreMultiplier"] forKey:@"scoreMultiplier"];
    
        }
        
    
        
        meet.onlineMeet = meetDict[@"onlineMeet"];
        meet.divsDone = meetDict[@"divsDone"];
        meet.eventsDone = meetDict[@"eventsDone"];
        meet.teamsDone = meetDict[@"teamsDone"];
    
        meet.appVersionUpdatedFor = meetDict[@"appVersionUpdatedFor"];
    
    
    
    
    
            // Store meetID data
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             
             
             
             if (![defaults objectForKey:@"lastMeetID"]) {
             
             int idint = 0;
             NSNumber *idnumber = [NSNumber numberWithInt:idint];
             
             
             [defaults setObject:idnumber forKey:@"lastMeetID"];
             
             }
               
               NSNumber *oldnumber = [defaults objectForKey:@"lastMeetID"];
               
               
               int oldint = [oldnumber intValue];
               
               int newint = oldint + 1;
               
               NSNumber *newnumber = [NSNumber numberWithInt:newint];
               
            meet.meetID = newnumber;
            
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
            
            
            
              NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, newnumber,timestamp];
              [meet setValue: onlineID forKey: @"onlineID"];

                NSLog(@"timestamp %@  onlineID: %@",timestamp, onlineID);

            [defaults setObject: newnumber forKey:@"lastMeetID"];
             
            [defaults synchronize];
    
    
    
     
    ////
    
    // Divs
    
    ///
    
    NSArray* divsArray  = meetDict[@"divisions"];
    
        for (NSDictionary* divDict in divsArray) {
                Division *div = [NSEntityDescription insertNewObjectForEntityForName:@"Division" inManagedObjectContext:context];
            
            
            
                div.divName = divDict[@"divName"];
                div.updateByUser = divDict[@"updateByUser"];
                //divDict[@"updateDateAndTime"] = div.updateDateAndTime;
                //divDict[@"onlineID"] = div.onlineID;
                div.editDone = divDict[@"editDone"];
                div.edited = divDict[@"edited"];
                
                // events
                div.meet = meet;
            
            
            
                // Store divID data
        
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
     
     int tempint =  [meet.meetID intValue];
     
     NSString * keystring = [NSString stringWithFormat:@"%dlastDivID",tempint];  ////
     
     // nslog(@"%@",keystring);
     
     if (![defaults objectForKey:keystring]) {                    /////
     
     int idint = 0;
     NSNumber *idnumber = [NSNumber numberWithInt:idint];
     [defaults setObject:idnumber forKey:keystring];             ///////
     
     }
    NSNumber *oldnumber = [defaults objectForKey:keystring];   ///
       int oldint = [oldnumber intValue];
       int newint = oldint + 1;
       NSNumber *newnumber = [NSNumber numberWithInt:newint];
                        //////////
      div.divID = newnumber;

    [defaults setObject: newnumber forKey:keystring];            /////////
     
    [defaults synchronize];
    
        
        }
    /////////////////
    
    
    
      NSArray* gEventsArray  = meetDict[@"gEvents"];
    
        for (NSDictionary* gEventDict in gEventsArray) {
        
        GEvent *gevent = [NSEntityDescription insertNewObjectForEntityForName:@"GEvent" inManagedObjectContext:context];
        
        
            gevent.competitorsPerTeam = gEventDict[@"competitorsPerTeam"];
        gevent.decrementPerPlace = gEventDict[@"decrementPerPlace"];
        
        gevent.gEventName = gEventDict[@"gEventName"];
       // gEventDict[@"gEventTiming"] = gevent.gEventTiming;
        gevent.gEventType = gEventDict[@"gEventType"];
        gevent.maxScoringCompetitors =  gEventDict[@"maxScoringCompetitors"];
        gevent.scoreForFirstPlace = gEventDict[@"scoreForFirstPlace"];
        gevent.scoreMultiplier = gEventDict[@"scoreMultiplier"];
        gevent.updateByUser = gEventDict[@"updateByUser"];
        //gEventDict[@"updateDateAndTime"] = gevent.updateDateAndTime;
       // gEventDict[@"onlineID"] = gevent.onlineID;
        gevent.editDone = gEventDict[@"editDone"];
        gevent.edited = gEventDict[@"edited"];
        
        // events = do in event
        gevent.meet = meet;
        
        
        
        
        // Store GEventID data
        
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
     
     int tempint =  [meet.meetID intValue];
     
     NSString * keystring = [NSString stringWithFormat:@"%dlastGEventID",tempint];  ////
     
     // nslog(@"%@",keystring);
     
     if (![defaults objectForKey:keystring]) {                    /////
     
     int idint = 0;
     NSNumber *idnumber = [NSNumber numberWithInt:idint];
     [defaults setObject:idnumber forKey:keystring];             ///////
     
     }
NSNumber *oldnumber = [defaults objectForKey:keystring];   ///
       int oldint = [oldnumber intValue];
       int newint = oldint + 1;
       NSNumber *newnumber = [NSNumber numberWithInt:newint];
                       //////////
       gevent.gEventID = newnumber ;

    [defaults setObject: newnumber forKey:keystring];            /////////
     
    [defaults synchronize];
        
        
        
        }
    
        //////////////
    
        NSArray* teamsArray  = meetDict[@"teams"];
    
        for (NSDictionary* teamDict in teamsArray) {
    
            Team *team = [NSEntityDescription insertNewObjectForEntityForName:@"Team" inManagedObjectContext:context];
            
            team.teamAbr = teamDict[@"teamAbr"];
            
            team.teamName = teamDict[@"teamName"];
            team.teamPlace = teamDict[@"teamPlace"];
            team.teamScore = teamDict[@"teamScore"];
            //teamDict[@"updateDateAndTime"] = team.updateDateAndTime;
            team.updateByUser = teamDict[@"updateByUser"];
            //teamDict[@"onlineID"] = team.onlineID;
            team.editDone = teamDict[@"editDone"];
            team.edited = teamDict[@"edited"];


            
            //competitors, ceventscores do in them
            team.meet = meet;
            

            
            // Store teamID data
         
              
                
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
             
             int tempint =  [meet.meetID intValue];
             
             NSString * keystring = [NSString stringWithFormat:@"%dlastTeamID",tempint];  ////
             
            
             
             if (![defaults objectForKey:keystring]) {                    /////
             
             int idint = 0;
             NSNumber *idnumber = [NSNumber numberWithInt:idint];
             [defaults setObject:idnumber forKey:keystring];             ///////
             
             }
            NSNumber *oldnumber = [defaults objectForKey:keystring];   ///
               int oldint = [oldnumber intValue];
               int newint = oldint + 1;
               NSNumber *newnumber = [NSNumber numberWithInt:newint];
            
            team.teamID = newnumber;                  //////////
              

            [defaults setObject: newnumber forKey:keystring];            /////////
             
            [defaults synchronize];
            
        }
    
    
[self saveContext];
    
         NSArray* compsArray  = meetDict[@"competitors"];
    
        for (NSDictionary* compDict in compsArray) {
    
            Competitor *comp = [NSEntityDescription insertNewObjectForEntityForName:@"Competitor" inManagedObjectContext:context];
            
            
            comp.compName = compDict[@"compName"];
            comp.teamName = compDict[@"teamName"];
            comp.updateByUser = compDict[@"updateByUser"];
           // compDict[@"updateDateAndTime"] = comp.updateDateAndTime;
           // compDict[@"onlineID"] = comp.onlineID;
            comp.editDone = compDict[@"editDone"];
            comp.edited = compDict[@"edited"];
            
            //ceventscores do in them
            comp.team = (Team*)[self getObjectWithID:compDict[@"team"] IDLabel:@"teamID" AndType:@"Team" FromMeet:meet];
            comp.meet = meet;
            
            
            
            // Store CompID data
             
                 
                    
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
              
                 int tempint =  [meet.meetID intValue];
                 
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
                    comp.compID = newnumber;                  //////////
                 

                [defaults setObject: newnumber forKey:keystring];            /////////
                 
                [defaults synchronize];

        }
    
[self saveContext];
    
        NSArray* eventsArray  = meetDict[@"events"];
    
        for (NSDictionary* eventDict in eventsArray) {
    
            Event *event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:context];
            
            event.eventDone = eventDict[@"eventDone"];
            event.eventEdited = eventDict[@"eventEdited"];
            
           // eventDict[@"startTime"] = event.startTime;
            event.updateByUser = eventDict[@"updateByUser"];
           // eventDict[@"updateDateAndTime"] = event.updateDateAndTime;
           // eventDict[@"onlineID"] = event.onlineID;
            event.editDone = eventDict[@"editDone"];
            event.edited = eventDict[@"edited"];


            
            //ceventscores do in them
            event.division = (Division*)[self getObjectWithID:eventDict[@"division"] IDLabel:@"divID" AndType:@"Division" FromMeet:meet];
            
            
           
            event.gEvent = (GEvent*)[self getObjectWithID:eventDict[@"gEvent"]IDLabel:@"gEventID" AndType:@"GEvent" FromMeet:meet];
            event.meet = meet;
            
            
            
            
             ////////// event id
                
                    NSUserDefaults *defaults1 = [NSUserDefaults standardUserDefaults];
    
     
                    int tempint1 =  [meet.meetID intValue];
     
                    NSString * keystring1 = [NSString stringWithFormat:@"%dlastEventID",tempint1];  ////
     
                    // nslog(@"%@",keystring1);
     
                    if (![defaults1 objectForKey:keystring1]) {                    /////
     
                        int idint1 = 0;
                        NSNumber *idnumber1 = [NSNumber numberWithInt:idint1];
                        [defaults1 setObject:idnumber1 forKey:keystring1];             ///////
     
                        }
                    NSNumber *oldnumber1 = [defaults1 objectForKey:keystring1];   ///
                    int oldint1 = [oldnumber1 intValue];
                    int newint1 = oldint1 + 1;
                    NSNumber *newnumber1 = [NSNumber numberWithInt:newint1];
            
                    event.eventID = newnumber1 ;                  //////////
                    // nslog(@" eventID %@",  event.eventID);

                    [defaults1 setObject: newnumber1 forKey:keystring1];            /////////
     
                    [defaults1 synchronize];
            
            
        }
    
[self saveContext];

        NSArray* cscoresArray  = meetDict[@"cEventsScores"];
    
        for (NSDictionary* cscoreDict in cscoresArray) {
    
            CEventScore *cscore = [NSEntityDescription insertNewObjectForEntityForName:@"CEventScore" inManagedObjectContext:context];
             cscore.competitor = (Competitor*)[self getObjectWithID:cscoreDict[@"competitor"] IDLabel:@"compID" AndType:@"Competitor" FromMeet:meet];
             cscore.event = (Event*)[self getObjectWithID:cscoreDict[@"event"] IDLabel:@"eventID" AndType:@"Event" FromMeet:meet];
            
            if (cscoreDict[@"highJumpPlacingManual"]) {
                cscore.highJumpPlacingManual = cscoreDict[@"highJumpPlacingManual"];
            }
            //cscoreDict[@"personalBest"] = cscore.personalBest;
        //    if (cscoreDict[@"placing"]) {
                cscore.placing = cscoreDict[@"placing"];
        //    }
        //    if (cscoreDict[@"result"]) {
                cscore.result = cscoreDict[@"result"];
              //  NSLog(@"was found  result for %@ in event %@ %@  newresult: %@ oldResult: %@",cscore.competitor.compName,cscore.event.gEvent.gEventName,cscore.event.division.divName,cscore.result,cscoreDict[@"result"]);
        //    }
            
            if (cscoreDict[@"resultEntered"]) {
                 cscore.resultEntered = cscoreDict[@"resultEntered"];
            }
           
        //    if (cscoreDict[@"score"]) {
                cscore.score = cscoreDict[@"score"];
        //    }
            if (cscoreDict[@"updateByUser"]) {
                cscore.updateByUser = cscoreDict[@"updateByUser"];
            }
            //cscoreDict[@"updateDateAndTime"] = cscore.updateDateAndTime;
            //cscoreDict[@"onlineID"] = cscore.onlineID;
            if (cscoreDict[@"edited"]) {
                cscore.edited = cscoreDict[@"edited"];
            }
            if (cscoreDict[@"editDone"]) {
                cscore.editDone = cscoreDict[@"editDone"];
            }
            
           if (cscoreDict[@"relayDisc"]) {
                cscore.relayDisc = cscoreDict[@"relayDisc"];
            }
            
            
           
            
           
            
            cscore.team = (Team*)[self getObjectWithID:cscoreDict[@"team"] IDLabel:@"teamID" AndType:@"Team" FromMeet:meet];
            cscore.meet = meet;
            
            
            
            
           // Store cEventsScoreID data
  
      
        
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
             
             int tempint =  [meet.meetID intValue];
             
             NSString * keystring = [NSString stringWithFormat:@"%dlastcEventScoreID",tempint];  ////
             
             // nslog(@"%@",keystring);
             
             if (![defaults objectForKey:keystring]) {                    /////
             
             int idint = 0;
             NSNumber *idnumber = [NSNumber numberWithInt:idint];
             [defaults setObject:idnumber forKey:keystring];             ///////
             
             }
            NSNumber *oldnumber = [defaults objectForKey:keystring];   ///
               int oldint = [oldnumber intValue];
               int newint = oldint + 1;
               NSNumber *newnumber = [NSNumber numberWithInt:newint];
                cscore.cEventScoreID = newnumber;
            [defaults setObject: newnumber forKey:keystring];            /////////
             
            [defaults synchronize];
         

            
            
        }
    
[self saveContext];

        NSArray* entriesArray  = meetDict[@"entries"];
    
    NSLog(@"hello %@", entriesArray);
    
        for (NSDictionary* entryDict in entriesArray) {
            NSLog(@"hello");
            Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:context];
             entry.competitor = (Competitor*)[self getObjectWithID:entryDict[@"competitor"] IDLabel:@"compID" AndType:@"Competitor" FromMeet:meet];
             entry.cEventScore = (CEventScore*)[self getObjectWithID:entryDict[@"cEventScore"] IDLabel:@"cEventScoreID" AndType:@"CEventScore" FromMeet:meet];
            
            
            if (entryDict[@"updateByUser"]) {
                entry.updateByUser = entryDict[@"updateByUser"];
            }
            //cscoreDict[@"updateDateAndTime"] = cscore.updateDateAndTime;
            //cscoreDict[@"onlineID"] = cscore.onlineID;
            if (entryDict[@"edited"]) {
                entry.edited = entryDict[@"edited"];
            }
            if (entryDict[@"editDone"]) {
                entry.editDone = entryDict[@"editDone"];
            }
            
           
            entry.meet = meet;
            
           
            
             // Store entryID data
          
              
                
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
             
              int tempint =  [meet.meetID intValue];
             
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
            
            
        }
    
[self saveContext];


}

- (void) updateMeetsToCurrent {



            NSError *error;
    
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"Meet" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];


            /**
            
            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(meet == %@)", meet];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(%K == %@)", idLabel,objectID];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];
            
            **/
    
            NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
            for (Meet* meetobject in fetchedObjects) {
    
    
                if ([meetobject.appVersionUpdatedFor isEqualToString:@"6"]) {
                    NSLog(@"Meet %@ Up To Date", meetobject.meetName);
                }
                else
                {
                        //// add different version check and handling here later
                    
                    
                    
                    
                    for (CEventScore* cscoreobject in meetobject.cEventsScores) {
                    
                        
                        Competitor* compobject = cscoreobject.competitor;
                        
                        
                        //////
                        //////  Entry Add
                        
                        
                            Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:self.managedObjectContext];
                            
                            
                            
                            
                            
                            ////////
                            /////   set values
                            ///////
                            
                          
                            entry.edited = [NSNumber numberWithBool:NO];
                            entry.editDone = [NSNumber numberWithBool:YES];
                            
                            
                             //////
                            // link relationships
                            /////
                            
                           
                            
                            entry.competitor = compobject;
                            entry.cEventScore = cscoreobject;
                            entry.meet = meetobject;
                            
                            
                            
                            //////
                            
                                     // Store entryID data

                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         
                         int tempint =  [meetobject.meetID intValue];
                         
                         NSString* keystring = [NSString stringWithFormat:@"%dlastentryID",tempint];  ////
                         
                         // nslog(@"%@",keystring);
                         
                         if (![defaults objectForKey:keystring]) {                    /////
                         
                         int idint = 0;
                         NSNumber *idnumber = [NSNumber numberWithInt:idint];
                         [defaults setObject:idnumber forKey:keystring];             ///////
                         
                         }
                          NSNumber*  oldnumber = [defaults objectForKey:keystring];   ///
                          int  oldint = [oldnumber intValue];
                           int newint = oldint + 1;
                           NSNumber* newnumber = [NSNumber numberWithInt:newint];
                           entry.entryID = newnumber;                  //////////
                           

                        [defaults setObject: newnumber forKey:keystring];            /////////
                         
                        [defaults synchronize];
                     
                        ////

                    
                        
                    
                    

                    [self saveContext];
                    

                    
                    
                    
                    } // end for eventscores




                

                meetobject.appVersionUpdatedFor = @"6";
                [self saveContext];


                NSLog(@"meet %@ updated",meetobject.meetName);
                } //end else meet not up to date
    
    
    
    
    
            } // end for meets

}

- (id) getObjectWithID: (NSString*) objectID IDLabel: (NSString*)idLabel AndType: (NSString*) type FromMeet: (Meet*) meet
{

        NSError *error;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *description = [NSEntityDescription entityForName:type inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];


            NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(meet == %@)", meet];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(%K == %@)", idLabel,objectID];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];
    
            NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
            if (fetchedObjects.count > 0) {
               // NSLog(@"object found");
                return fetchedObjects[0];
                
            }
            else
            {
                NSLog(@"no object found");
                return nil;
            }

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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
   NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(importedMeet) name:@"importedMeet" object:nil];
    [center addObserver:self selector:@selector(importedCsv) name:@"importedCsv" object:nil];
   
   // self.navigationItem.leftBarButtonItem = self.editButtonItem;
 
    self.latestAppVersion = @"6";
 
    NSLog(@"view did load");
     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
     


     
     if (![defaults objectForKey:@"firstTimeDone"]) {

        [defaults setObject: @"1" forKey:@"firstTimeDone"];
         
            [self performSegueWithIdentifier:@"showTut" sender:self];
        
        }
        else
        {
            NSLog(@"not first time");
           // [self performSegueWithIdentifier:@"showTut" sender:self];
        }
   
    
    
    
    
    
     if (![defaults objectForKey:@"defaultAdded"]) {

        [defaults setObject: @"1" forKey:@"defaultAdded"];
            [self setExampleMeet];
        
        
        }
        else
        {
            NSLog(@"not first time");
          // [self setExampleMeet];  /// comment/uncomment to test
        }

    

        if ([defaults objectForKey:@"appVersionMeetsUpdatedFor"]) {

            if ([[defaults objectForKey:@"appVersionMeetsUpdatedFor"] isEqualToString:self.latestAppVersion]) {
                NSLog(@"all meets up to date");
                
              //  [self updateMeetsToCurrent];  // comment/uncomment to test
            }
            else
            {
                
                [self updateMeetsToCurrent];
                
                [defaults setObject: @"6" forKey:@"appVersionMeetsUpdatedFor"];
                
            }
            
            
        
        }
        else
        {
        
                [self updateMeetsToCurrent];
        
                [defaults setObject: @"6" forKey:@"appVersionMeetsUpdatedFor"];
            
        }

    
    
   // [self updateOnlineMeets];
    
    /**
    
    
    
    
    NSError *error = nil;

        // Save the context.
        
            if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
        
    }
    **/
   
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
- (void)insertNewObject:(id)sender {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    Meet *meet = [NSEntityDescription insertNewObjectForEntityForName:@"Meet" inManagedObjectContext:context];
        
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
   
    [meet setValue: @"Mymeet" forKey:@"meetName"];
    [meet setValue: [NSDate date] forKey:@"meetDate"];
   
        
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
       // abort();
    }
}

*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (MeetTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MeetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MeetCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
     bool isOnlineMeet = [self.segmentedControl selectedSegmentIndex] == 0 ? FALSE : TRUE;
    
    if (isOnlineMeet) {        
        return YES;
        }
        else {
        return YES;
        }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        bool isOnlineMeet = [self.segmentedControl selectedSegmentIndex] == 0 ? FALSE : TRUE;
        Meet* meetObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if (isOnlineMeet&&([meetObject.isOwner boolValue]))
         {
          
          context = [self deleteOnlineMeet: meetObject InContext: context];
        }
        else
        {
        
        NSLog(@"here");
            [context deleteObject:meetObject];
        
        }
        
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
          //  abort();
        }
    }
}
- (NSManagedObjectContext*)deleteOnlineMeet:(Meet*)meetObject InContext: (NSManagedObjectContext*) context {

NSLog(@"deleteonlinemeet");

    CKRecordID *meetrecordID = [[CKRecordID alloc] initWithRecordName:meetObject.onlineID];
    
    
            //get the Container for the App
            CKContainer *defaultContainer = [CKContainer defaultContainer];
    
            //get the PublicDatabase inside the Container
            CKDatabase *publicDatabase = [defaultContainer publicCloudDatabase];
    
    
      [publicDatabase deleteRecordWithID:meetrecordID completionHandler:^(CKRecordID *recordID, NSError *error) {
        
          if(error) {
            
                NSLog(@"Uh oh, there was an error deleting ... %@", error);
              
              dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController * alert =   [UIAlertController
                                    alertControllerWithTitle:@"Removal From Database Failed"
                                    message:@"Failed to remove from online database, please check your internet connection, ensure you are signed in to iCloud and you have upgraded to iCloud Drive before trying again"
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

          
            //handle successful save
            } else {
            
            
                NSLog(@"deleted successfully");
                [context deleteObject:meetObject];
   
            }
  
        }];
    
        return context;
}
- (void)configureCell:(MeetTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  Meet *meetobject = (Meet*) object;
    
    
    cell.meetTitleLabel.text = [[object valueForKey:@"meetName"] description];

    NSDate *fulldate = [object valueForKey:@"meetDate"];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"dd MMM yyyy";
    

    if ([meetobject.onlineMeet boolValue]) {
   
        if ([meetobject.isOwner boolValue]) {
            NSLog(@"is owner");
             cell.hostLabel.hidden = NO;
            
        }
        else
        {
           cell.hostLabel.hidden = YES;
           
           // Fetch the record from the database
            
           

           
        }
    }
    else
    {
     cell.hostLabel.hidden = YES;
     
    }
   //     NSLog(@"in configurecell");
  //  NSLog(@"MEET NAME %@  owner value %hhd online %hhd", [[object valueForKey:@"meetName"] description],[[object valueForKey:@"isOwner"] boolValue],[[object valueForKey:@"onlineMeet"] boolValue]);

    
 //   [[object valueForKey:@"meetDate"] description];
    cell.meetDateLabel.text = [format stringFromDate:fulldate];
    cell.numberOfTeamsLabel.text = [NSString stringWithFormat:@"Teams: %@",  @([[object valueForKey:@"teams"] count] )];  
    //[[@"hello"] description];
    
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Meet" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    
    bool isOnlineMeet = [self.segmentedControl selectedSegmentIndex] == 0 ? FALSE : TRUE;
    
    if (!isOnlineMeet) {
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"onlineMeet == FALSE"];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"onlineMeet = nil"];
       
       
       NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *orPred = [NSCompoundPredicate orPredicateWithSubpredicates:preds];

       
       [fetchRequest setPredicate:orPred];
        }
    else
    {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(onlineMeet == TRUE)"];
    [fetchRequest setPredicate:predicate];

    }
    
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"meetDate" ascending:NO];
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

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */
#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 /*
 
    if ([[segue identifier] isEqualToString:@"addMeet"]) {
        
        
    }
  */
    if ([[segue identifier] isEqualToString:@"meetMenu"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    }
    
    if ([[segue identifier] isEqualToString:@"editMeet"]) {
        
       NSIndexPath *indexPath = self.indexPathForLongPressCell;
      //  NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
       
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        
        
        UINavigationController *navController = (UINavigationController*)[segue destinationViewController];
    MeetAddViewController* meetAddController = (MeetAddViewController*)[navController topViewController];
        
        
        [meetAddController setDetailItem:object];
       
        [meetAddController setManagedObjectContext:self.managedObjectContext];
       
    }

    
}
#pragma mark - MeetAddViewControllerUnwinds

- (IBAction)unwindToMainDone:(UIStoryboardSegue *)unwindSegue
{


    if ([unwindSegue.sourceViewController isKindOfClass:[MeetAddViewController class]])
    {
        // nslog(@"Coming from MeetAdd Done!");
        
        MeetAddViewController *sourceViewController = unwindSegue.sourceViewController;
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    Meet *meet;
    
      if (!sourceViewController.editing) {

    
        meet = [NSEntityDescription insertNewObjectForEntityForName:@"Meet" inManagedObjectContext:context];
        }
        else
        {
        
        meet = sourceViewController.detailItem;
        }
        
        
        ////////
        /////   set values
        ///////
        meet.appVersionUpdatedFor = self.latestAppVersion;
        
        if (sourceViewController.meetName) {
        [meet setValue: sourceViewController.meetName.text forKey:@"meetName"];
            
        }
        if (sourceViewController.meetDate) {
        [meet setValue: sourceViewController.meetDate.date forKey:@"meetDate"];
            
        }
        if (sourceViewController.ceventLimitStepper) {
        [meet setValue: [NSNumber numberWithInteger:sourceViewController.ceventLimitStepper.value ]forKey:@"cEventLimit"];
            
        }
        
        
        if (sourceViewController.maxCompPerTeamStepper) {
        [meet setValue: [NSNumber numberWithInteger: sourceViewController.maxCompPerTeamStepper.value] forKey:@"competitorPerTeam"];
    
        }

        
        if (sourceViewController.maxScoringCompPerTeamStepper) {
        [meet setValue: [NSNumber numberWithInteger: sourceViewController.maxScoringCompPerTeamStepper.value] forKey:@"maxScoringCompetitors"];
    
        }
        
        if (sourceViewController.firstPlaceScoreStepper) {
        [meet setValue: [NSNumber numberWithInteger: sourceViewController.firstPlaceScoreStepper.value] forKey:@"scoreForFirstPlace"];
    
        }
        
        if (sourceViewController.reductionPerPlaceStepper) {
        [meet setValue: [NSNumber numberWithInteger: sourceViewController.reductionPerPlaceStepper.value] forKey:@"decrementPerPlace"];
    
        }
        
        
         if (sourceViewController.scoreMultiplierStepper) {
        [meet setValue: [NSNumber numberWithInteger: sourceViewController.scoreMultiplierStepper.value] forKey:@"scoreMultiplier"];
    
        }
        
        
        
        
        
        ////////
        
        
        if (!sourceViewController.editing) {
        
        [meet setValue:[NSNumber numberWithBool:NO] forKey:@"divsDone"];

        [meet setValue:[NSNumber numberWithBool:NO] forKey:@"eventsDone"];

        [meet setValue:[NSNumber numberWithBool:NO] forKey:@"teamsDone"];
        
     //   [meet setValue:[NSNumber numberWithBool:YES] forKey:@"onlineMeet"];

        
        // Store meetID data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
     
     
     
     if (![defaults objectForKey:@"lastMeetID"]) {
     
     int idint = 0;
     NSNumber *idnumber = [NSNumber numberWithInt:idint];
     
     
     [defaults setObject:idnumber forKey:@"lastMeetID"];
     
     }
       
       NSNumber *oldnumber = [defaults objectForKey:@"lastMeetID"];
       
       
       int oldint = [oldnumber intValue];
       
       int newint = oldint + 1;
       
       NSNumber *newnumber = [NSNumber numberWithInt:newint];
       
       [meet setValue: newnumber forKey: @"meetID"];
    
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
    
    
    
      NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, newnumber,timestamp];
      [meet setValue: onlineID forKey: @"onlineID"];

        NSLog(@"timestamp %@  onlineID: %@",timestamp, onlineID);

    [defaults setObject: newnumber forKey:@"lastMeetID"];
     
    [defaults synchronize];
     
    ////
     }
    NSError *error = nil;

        // Save the context.
        
            if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
        
    }
   
   

}
- (IBAction)unwindToMainCancel:(UIStoryboardSegue *)unwindSegue
{

UIViewController* sourceViewController = unwindSegue.sourceViewController;

if ([sourceViewController isKindOfClass:[MeetAddViewController class]])
    {
        // nslog(@"Coming from MeetAdd Cancel!");
    }
}

/**
#pragma mark - MeetAddViewControllerDelegate

- (void)MeetAddViewControllerDidCancel:(MeetAddViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
 
- (void)MeetAddViewControllerDidSave:(MeetAddViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

**/

- (IBAction)longPressRecognizer:(UILongPressGestureRecognizer *)sender {
// nslog(@"long press fire");
// only when gesture was recognized, not when ended
	if (sender.state == UIGestureRecognizerStateBegan)
	{
		CGPoint location = [sender locationInView:self.tableView];
  self.indexPathForLongPressCell = [self.tableView indexPathForRowAtPoint:location];
        
        
        // get affected cell
	//	MeetMenuViewCell *cell = (MeetMenuViewCell *)[sender view];
 
		// get indexPath of cell
		//self.indexPathForLongPressCell = [self.tableView indexPathForCell:cell];
 
		// do something with this action
		// nslog(@"Long-pressed cell at row %@", self.indexPathForLongPressCell);
        
        [self performSegueWithIdentifier:@"editMeet" sender:self];
	}


}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {

self.fetchedResultsController = nil;
    NSLog(@"here 2");
    [self.tableView reloadData];
    bool isOnlineMeet = [self.segmentedControl selectedSegmentIndex] == 0 ? FALSE : TRUE;
    
    if (!isOnlineMeet) {
    
    
    //self.navigationItem.rightBarButtonItem = addButton;
    self.addButton.enabled = YES;
    
    }
    else
    {
    
      self.addButton.enabled = NO;
        
    }
    

}

/**
- (void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(yourCustomMethod:)
                                                 name:SELECT_INDEX_NOTIFICATION object:nil];
}


-(void)yourCustomMethod:(NSNotification*)_notification
{
    [[self navigationController] popToRootViewControllerAnimated:YES];
    NSString *selectedIndex=[[_notification userInfo] objectForKey:SELECTED_INDEX];
    NSLog(@"selectedIndex  : %@",selectedIndex);

}

- (void)setOnlineMeet:(NSString *)meetOnlineID {

    NSLog(@"in masteviewcontrooler with string %@", meetOnlineID);
   
     NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
        Meet *meet;
    
        meet = [NSEntityDescription insertNewObjectForEntityForName:@"Meet" inManagedObjectContext:context];
    
        [meet setValue: @"Online Meet Updating..." forKey:@"meetName"];
    
        [meet setValue: [NSNumber numberWithBool:YES] forKey:@"onlineMeet"];
    
        [meet setValue: [NSNumber numberWithBool:NO] forKey:@"isOwner"];

    
        [meet setValue: meetOnlineID forKey: @"onlineID"];

        NSLog(@"new meet set with onlineID onlineID: %@", meetOnlineID);
    
    
    
    NSError *error = nil;

        // Save the context.
        
            if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
    
            [self updateOnlineMeets];

    
}
**/


- (void)updateOnlineMeets {
    
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"Meet" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];

           NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(onlineMeet == TRUE)"];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(isOwner == FALSE)"];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];
    
    

                NSError *error;
                NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    
            CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
            CKRecordID *meetRecordID;
    
    for (Meet* meetobject in results) {
        
        
                NSLog(@"updating meet %@ %@", meetobject.meetName, meetobject.onlineID);
        
                 /**
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"onlineID = %@", meetobject.onlineID];
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"onlineID = %@", @"1"];
                //create query
                CKQuery *query = [[CKQuery alloc] initWithRecordType:@"Meet" predicate:predicate];
    
            //execute query
                [publicDatabase performQuery:query inZoneWithID:nil completionHandler:^(NSArray *results, NSError *error) {
        
                //handle query error
                if(error) {
            
                NSLog(@"Uh oh, there was an error querying ... %@", error);

                } else {
            
                    //handle query results
                    if([results count] > 0) {
                
                    //iterate query results
                        for(CKRecord *meetRecord in results) {
                    
                            meetobject.meetDate = meetRecord[@"meetDate"];
                            meetobject.meetName = meetRecord[@"meetName"];
                
                            NSError *error = nil;

                            // Save the context.
        
                            if (![self.managedObjectContext save:&error]) {
                           
                            }
                            NSLog(@"meet update succesfull %@", meetobject.meetName);

                            }
                
                    //handle no query results
                    } else {
                
                        NSLog(@"Query returned zero results");
                    }
                }
                }];
        
        
                **/
            
        
            
                NSLog(@"updating meet %@ %@", meetobject.meetName, meetobject.onlineID);
        

                meetRecordID = [[CKRecordID alloc] initWithRecordName:meetobject.onlineID];
                [publicDatabase fetchRecordWithID:meetRecordID completionHandler:^(CKRecord *meetRecord, NSError *error) {
                    if (error) {
                        // Error handling for failed fetch from public database
                
                        NSLog(@"Uh oh, there was an error getting meetname %@  %@ online ... %@",meetobject.meetName, meetobject.onlineID, error);
                    }
                    else {
                        // Modify the record and save it to the database
                        
                        meetobject.meetDate = meetRecord[@"meetDate"];
                        meetobject.meetName = meetRecord[@"meetName"];
                
                        NSError *error = nil;

                        // Save the context.
        
                        if (![self.managedObjectContext save:&error]) {
                           
                        }
                        NSLog(@"meet update succesfull %@", meetobject.meetName);
                
                
                    }
                }];
                
                
        }
}


- (IBAction)showAllTuts:(UIBarButtonItem *)sender {

NSUserDefaults *defaultstut = [NSUserDefaults standardUserDefaults];

NSString* mainTutString = @"Tutorials";

NSMutableDictionary* tutDict = [[NSMutableDictionary alloc] init];

[defaultstut setObject: tutDict forKey:mainTutString];
[defaultstut synchronize];
[self tutorialCode];

}

/////////
// Tutorial Code Start
////////


- (void) tutorialCode {

        // Edit these
    NSString* thisTutKeyString = @"tut2";
    NSString* tutTitleString = @"Tutorial";
    NSString* tutMessageString = @"Tutorial Text";
        // Rest Done

    NSString* mainTutString = @"Tutorials";
    NSUserDefaults *defaultstut = [NSUserDefaults standardUserDefaults];

  
   if (! [[[defaultstut objectForKey:mainTutString] objectForKey:thisTutKeyString] boolValue]) {
    NSLog(@"showing");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:tutTitleString
                                    message:tutMessageString
                                    preferredStyle:UIAlertControllerStyleAlert];
     
     
                UIAlertAction* dontshow = [UIAlertAction
                        actionWithTitle:@"Don't Show This Again"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            NSMutableDictionary* tutDict = [defaultstut objectForKey:mainTutString];
                            
                            
                            
                            if (!(tutDict)) {
                                tutDict = [[NSMutableDictionary alloc] init];
                            }
                            
                        
                            
                                [tutDict setObject:[NSNumber numberWithBool:YES] forKey:thisTutKeyString];
                                [defaultstut setObject: tutDict forKey:mainTutString];
                                [defaultstut synchronize];
                           
                            
                            
                            
                                [alert dismissViewControllerAnimated:YES completion:nil];
                            
                             
                        }];
                        UIAlertAction* done = [UIAlertAction
                        actionWithTitle:@"Close"
                        style:UIAlertActionStyleDefault
                        handler:^(UIAlertAction * action)
                        {
                            
                            [alert dismissViewControllerAnimated:YES completion:nil];
                            
                             
                        }];
    
                [alert addAction:done];
                [alert addAction:dontshow];
     
                [self presentViewController:alert animated:YES completion:nil];
        });
    
    }
    else
    {
        NSLog(@"not showing");
    
    }

}
-(void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
   //something here
   [self tutorialCode];
}
/////////
// Tutorial Code End
////////

@end
