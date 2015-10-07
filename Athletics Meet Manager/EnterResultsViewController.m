//
//  EnterResultsViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "EnterResultsViewController.h"
#import "EventScoreSheetViewController.h"
#import "EventScoreCopySheetViewController.h"
#import "GEvent.h"
#import "Division.h"
#import "CEventScore.h"
#import "BackupCEventScore.h"
#import "Event.h"
#import "BackupEvent.h"
#import "Competitor.h"
#import "BackupCompetitor.h"
#import "Team.h"
#import "Meet.h"

@interface EnterResultsViewController ()
@property BOOL updateOnlineSuccess;
@property BOOL showingBackups;
@property CKRecord* fetchedMeetRecord;
@property BOOL objectNotOnServer;
@property (strong, nonatomic) UIActivityIndicatorView *activityindicator;

@property (strong, nonatomic) UIView *activityview;

@end

@implementation EnterResultsViewController

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
        _meetObject = _detailItem;
        // Update the view.
        [self configureView];
        
       
        
    }
}



- (void)configureView
{


    // Update the user interface for the detail item.
    if (_detailItem) {
      //// nslog(@"meet item %@", [self.meetObject valueForKey:@"meetName"]);
      
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.objectNotOnServer = NO;
    
    [self configureView];
    self.updateOnlineButton.enabled = NO;
    self.showingBackups = NO;
    
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

- (EventResultTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EventResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultEventCell" forIndexPath:indexPath];
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
  
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
   
     NSEntityDescription *entity;
    
if (self.showingBackups) {
  NSLog(@"showing backups in fetchedResultsController");
  entity = [NSEntityDescription entityForName:@"BackupEvent" inManagedObjectContext:self.managedObjectContext];
}
else
{
    NSLog(@"not showing backups in fetchedResultsController");
    entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];

 }
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
     // limit to those entities that belong to the particular item
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(meet == %@)", self.meetObject];
    [fetchRequest setPredicate:predicate];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    
        ////////
        ///////
    
                // Edit for segmented control
    NSString *sortKey = [self.segmentedControl selectedSegmentIndex] == 0 ? @"division.divName" : @"gEvent.gEventID";
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
    
    sortKey = [self.segmentedControl selectedSegmentIndex] == 0 ? @"gEvent.gEventID" : @"division.divName";
    
        ////////
        ////////
    
    
   NSSortDescriptor *sortDescriptor2 = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES];
 NSArray *sortDescriptors;
    
if (self.showingBackups) {
  sortKey = @"backupDate";
  NSSortDescriptor *sortDescriptor3 = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:NO];
  sortDescriptors = @[sortDescriptor1,sortDescriptor2,sortDescriptor3];
}
else
{
    //NSLog(@"not showing backups in fetchedResultsController");
    sortDescriptors = @[sortDescriptor1,sortDescriptor2];

 }
    
    
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

- (void)configureCell:(EventResultTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    Event *event = (Event*)object;
  
     GEvent* gevent  = (GEvent*)event.gEvent;
   NSString *geventname = gevent.gEventName;
   Division* division  = (Division*)event.division;
   NSString *divisionname = division.divName;
   
 //  NSString *eventname = [NSString stringWithFormat:@"%@ - %@", geventname, divisionname];

   
  cell.eventNameLabel.text = geventname;
  cell.divisionNameLabel.text = divisionname;
    if ([event.eventDone boolValue]){
    
    
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
      if (![self.meetObject.isOwner boolValue]) {
        
            if ([event.edited boolValue]) {
              
              cell.accessoryType = UITableViewCellAccessoryDetailButton;
                if ([event.editDone boolValue]) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
        }

  
    }
    else
    {
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
        NSLog(@"event %@ %@ edited value: %hhd editDone value: %hhd eventdone value: %hhd", event.gEvent.gEventName, event.division.divName, [event.edited boolValue], [event.editDone boolValue], [event.eventDone boolValue]);
    
}
#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

    if ([[segue identifier] isEqualToString:@"showEventScoreSheet"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        self.lastpathselected = indexPath;
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
        
      
    }
    
}




- (IBAction)segmentedControlValueChanged:(id)sender {

self.fetchedResultsController = nil;
    
    [self.tableView reloadData];
}


- (IBAction)unwindToEnterResultsDone:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.sourceViewController isKindOfClass:[EventScoreSheetViewController class]])
        {
        
            if ([self.meetObject.onlineMeet boolValue]) {
                NSLog(@"online meet in results done");
                if (![self.meetObject.isOwner boolValue ]) {
                   
                        NSLog(@"not owner so update event online");
                            [self pauseMethod];
                        
                            EventScoreSheetViewController* eventscoresheetviewcontroller = unwindSegue.sourceViewController;
                            
                            self.savedEventObject = eventscoresheetviewcontroller.eventObject;
                            // nslog(@"Coming from Eventscoresheetviewcontroller Done!");
                        
                              NSMutableArray *localChangesMute = [[NSMutableArray alloc] init];;
                            NSMutableArray *localDeletionsMute = [[NSMutableArray alloc] init];
                   
                                //get meetrecord by query
                            CKDatabase *publicDatabase = [[CKContainer defaultContainer] publicCloudDatabase];
                            NSPredicate *predicatemeet = [NSPredicate predicateWithFormat:@"onlineID = %@", self.meetObject.onlineID];
                    
                                NSArray *preds1 = [NSArray arrayWithObjects: predicatemeet, nil];
                             NSPredicate *predicateM = [NSCompoundPredicate andPredicateWithSubpredicates:preds1];
                           ////////////
                           
                            CKQuery *queryMeet = [[CKQuery alloc] initWithRecordType:@"Meet" predicate:predicateM];
                            CKQueryOperation *queryOpMeet = [[CKQueryOperation alloc] initWithQuery:queryMeet];
                
                           queryOpMeet.database = publicDatabase;
                
                        //execute query
    
                    
    
    
    
                            queryOpMeet.recordFetchedBlock = ^(CKRecord *meetRecord)
                            {
                                NSLog(@"in meet record check");
                                self.fetchedMeetRecord = meetRecord;
                            
                                
                            };

                            queryOpMeet.queryCompletionBlock = ^(CKQueryCursor *cursor, NSError *error)
                            {
                            
                                if (error) {
                                NSLog(@"CKQueryCursor  meet query error %@", error);
                               self.updateOnlineSuccess = NO;
                               [self modifyOnlineDone];
                                }
                                else
                                {
                                 NSLog(@"query meet succesful");
                                 
                                 
                               ///////////////
                                  if (self.fetchedMeetRecord != Nil) {
                                    CKReference* meetref = [[CKReference alloc] initWithRecord:self.fetchedMeetRecord action:CKReferenceActionDeleteSelf];
                                    NSString*   user = self.fetchedMeetRecord.creatorUserRecordID.recordName;
                                    NSLog(@"createuserrecordID %@",  user);
                                                user = [user stringByReplacingOccurrencesOfString:@"_" withString:@""];
                                    
                                     NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
                                                timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];
                                    
                                    
                                    NSString* newrecordname = [NSString stringWithFormat:@"updatedEvent%@%@%@",self.savedEventObject.onlineID, user,timestamp];
                                    
                                    CKRecordID *eventrecordID = [[CKRecordID alloc] initWithRecordName:newrecordname];
                                        
                                        CKRecord *eventrecord = [self addEventOnline:self.savedEventObject AndEventRecordID:eventrecordID];
                                    
                                        CKReference* ref = [[CKReference alloc] initWithRecord:eventrecord action:CKReferenceActionDeleteSelf];
                                        [eventrecord setObject:meetref forKey:@"owningMeet"];
                                        
                                        [localChangesMute addObject:eventrecord];
                                      
                                      /// add div
                                      
                                      CKRecord *divrecord = [self addDivisionOnline: self.savedEventObject.division AndEventRecordID:eventrecordID];
                                      
                                            [divrecord setObject:ref forKey:@"owningEvent"];
                                      
                                            [localChangesMute addObject:divrecord];
                                      
                                      
                                      
                                      //// end ad div
                                      
                                      /// add div
                                      
                                      CKRecord *geventrecord = [self addGEventOnline: self.savedEventObject.gEvent AndEventRecordID:eventrecordID];
                                      
                                            [geventrecord setObject:ref forKey:@"owningEvent"];
                                      
                                            [localChangesMute addObject:geventrecord];
                                      
 
                                      //// end ad div
                                      
                                      
                                        for (CEventScore* cscore in self.savedEventObject.cEventScores) {
                                            
                                            
                                            if (cscore.onlineID) {
                                                NSLog(@"onlineid is there %@",cscore.onlineID);
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
                                    
                                            NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, cscore.cEventScoreID,timestamp];
                                            [cscore setValue: onlineID forKey: @"onlineID"];
                                            NSLog(@"onlineid not found %@",cscore.onlineID);
                                            }
                                            
                                            

                                            Competitor* comp = cscore.competitor;
                                            
                                            
                                            if (comp.onlineID) {
                                                NSLog(@"onlineid is there %@",comp.onlineID);
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
                                    
                                                NSString* onlineID = [NSString stringWithFormat:@"%@%@%@",devID, comp.compID,timestamp];
                                                [comp setValue: onlineID forKey: @"onlineID"];
                                                NSLog(@"onlineid not found %@",comp.onlineID);
                                            }
                                    
                                            
                                            
                                            
                                            
                                            CKRecord *cscorerecord = [self addCScoreOnline:cscore AndEventRecordID:eventrecordID];
                                           
                                            [cscorerecord setObject:ref forKey:@"owningEvent"];
                                            
                                            [localChangesMute addObject:cscorerecord];
                                           
                                            
                                           
                                            CKRecord *comprecord = [self addCompOnline:comp AndEventRecordID:eventrecordID];
                                            
                                            [comprecord setObject:ref forKey:@"owningEvent"];
                                           
                                            [localChangesMute addObject:comprecord];
                                            ///// add team
                                            
                                            CKRecord *teamrecord = [self addTeamOnline: comp.team AndEventRecordID:eventrecordID];
                                            
                                            [teamrecord setObject:ref forKey:@"owningEvent"];
                                           
                                            [localChangesMute addObject:teamrecord];
                                            
                                            
                                            //// add team end
                                            
                                            
                                    }
                            
                  

                                    [self modifyOnlineWithChanges:localChangesMute AndDeletions:localDeletionsMute];
                          

                                    }
                                    else
                                    {
                                        NSLog(@"meet not found");
                                        
                                                        self.updateOnlineSuccess = NO;
                                                        self.objectNotOnServer = YES;
                                                        [self modifyOnlineDone];
                                    }
                                   
                                    
                                 }
                            };
                           
                           self.fetchedMeetRecord = nil;
                           NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                            [queue addOperation: queryOpMeet];
               

                     
                }
                
            }
        }

}
- (IBAction)unwindToEnterResultsReset:(UIStoryboardSegue *)unwindSegue {

}

- (CKRecord*)addEventOnline:(Event*)eventObject AndEventRecordID: (CKRecordID*) eventrecordID{
    //create a new RecordType
    
   
    CKRecord *event = [[CKRecord alloc] initWithRecordType:@"Event" recordID:eventrecordID];
    
    NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
    if (numberrange.location != NSNotFound) {
        newdevID = [devID substringFromIndex:numberrange.location + 2];
    } else {
     newdevID = devID;
    }

    devID = newdevID;
    devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //create and set record instance properties
event[@"editDone"] = [NSNumber numberWithBool:YES];
event[@"edited"] = [NSNumber numberWithBool:NO];
event[@"eventDone"] = eventObject.eventDone;
event[@"eventEdited"] = eventObject.eventEdited;
event[@"eventID"] = eventObject.eventID;
event[@"onlineID"] = eventObject.onlineID;
event[@"startTime"] = eventObject.startTime;
event[@"updateByUser"] = devID;
event[@"updateDateAndTime"] = [NSDate date];


    
    event[@"division"] = eventObject.division.onlineID;
    event[@"gEvent"] = eventObject.gEvent.onlineID;
    event[@"meetOnlineID"] = eventObject.meet.onlineID;
    
 
 
return event;

}

- (CKRecord*)addCompOnline:(Competitor*)compObject AndEventRecordID: (CKRecordID*) eventrecordID {
    //create a new RecordType
    NSString*   user = self.fetchedMeetRecord.creatorUserRecordID.recordName;
    
    user = [user stringByReplacingOccurrencesOfString:@"_" withString:@""];
     NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
                                                timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];

    NSString* newrecordname = [NSString stringWithFormat:@"updatedEvent%@%@%@",compObject.onlineID, user,timestamp];
    CKRecordID *comprecordID = [[CKRecordID alloc] initWithRecordName:newrecordname];
    CKRecord *comp = [[CKRecord alloc] initWithRecordType:@"Competitor" recordID:comprecordID];
    
    NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
    if (numberrange.location != NSNotFound) {
        newdevID = [devID substringFromIndex:numberrange.location + 2];
    } else {
     newdevID = devID;
    }

    devID = newdevID;
    devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //create and set record instance properties
comp[@"editDone"] = [NSNumber numberWithBool:YES];
comp[@"edited"] = [NSNumber numberWithBool:NO];
comp[@"compID"] = compObject.compID;
comp[@"compName"] = compObject.compName;
comp[@"onlineID"] = compObject.onlineID;
comp[@"teamName"] = compObject.teamName;
comp[@"updateByUser"] = devID;
comp[@"updateDateAndTime"] = [NSDate date];


    comp[@"team"] = compObject.team.onlineID;
    comp[@"meetOnlineID"] = compObject.meet.onlineID;
    
    comp[@"eventRecordID"] = eventrecordID.recordName;
 
 
return comp;

}

- (CKRecord*)addCScoreOnline:(CEventScore*)cscoreObject AndEventRecordID: (CKRecordID*) eventrecordID {
    //create a new RecordType
    
    NSString*   user = self.fetchedMeetRecord.creatorUserRecordID.recordName;
    
    user = [user stringByReplacingOccurrencesOfString:@"_" withString:@""];
     NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
                                                timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];

    NSString* newrecordname = [NSString stringWithFormat:@"updatedEvent%@%@%@",cscoreObject.onlineID, user, timestamp];
    CKRecordID *cscorerecordID = [[CKRecordID alloc] initWithRecordName:newrecordname];
    CKRecord *cscore = [[CKRecord alloc] initWithRecordType:@"CEventScore" recordID:cscorerecordID];
    
    
     NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
    if (numberrange.location != NSNotFound) {
        newdevID = [devID substringFromIndex:numberrange.location + 2];
    } else {
     newdevID = devID;
    }

    devID = newdevID;
    devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //create and set record instance properties
cscore[@"editDone"] = [NSNumber numberWithBool:YES];
cscore[@"edited"] = [NSNumber numberWithBool:NO];
cscore[@"cEventScoreID"] = cscoreObject.cEventScoreID;
cscore[@"highJumpPlacingManual"] = cscoreObject.highJumpPlacingManual;
cscore[@"onlineID"] = cscoreObject.onlineID;
cscore[@"personalBest"] = cscoreObject.personalBest;
cscore[@"placing"] = cscoreObject.placing;
cscore[@"result"] = cscoreObject.result;
cscore[@"resultEntered"] = cscoreObject.resultEntered;
cscore[@"score"] = cscoreObject.score;
cscore[@"updateByUser"] = devID;
cscore[@"updateDateAndTime"] = [NSDate date];



    cscore[@"competitor"] = cscoreObject.competitor.onlineID;
    cscore[@"event"] = cscoreObject.event.onlineID;
    cscore[@"team"] = cscoreObject.team.onlineID;
    cscore[@"meetOnlineID"] = cscoreObject.meet.onlineID;
    
    cscore[@"eventRecordID"] = eventrecordID.recordName;
    
 
 
return cscore;

}

- (CKRecord*)addDivisionOnline:(Division*)divObject AndEventRecordID: (CKRecordID*) eventrecordID{
    //create a new RecordType
        NSString*   user = self.fetchedMeetRecord.creatorUserRecordID.recordName;
    
    user = [user stringByReplacingOccurrencesOfString:@"_" withString:@""];
     NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
                                                timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];

    NSString* newrecordname = [NSString stringWithFormat:@"updatedEvent%@%@%@",divObject.onlineID, user, timestamp];
    CKRecordID *divrecordID = [[CKRecordID alloc] initWithRecordName:newrecordname];
    
    CKRecord *div = [[CKRecord alloc] initWithRecordType:@"Division" recordID:divrecordID];
    
      NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
    if (numberrange.location != NSNotFound) {
        newdevID = [devID substringFromIndex:numberrange.location + 2];
    } else {
     newdevID = devID;
    }

    devID = newdevID;
    devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //create and set record instance properties
    
div[@"editDone"] = [NSNumber numberWithBool:YES];
div[@"edited"] = [NSNumber numberWithBool:NO];
div[@"divID"] = divObject.divID;
div[@"divName"] = divObject.divName;
div[@"onlineID"] = divObject.onlineID;
div[@"updateByUser"] = devID;
div[@"updateDateAndTime"] = [NSDate date];


div[@"meetOnlineID"] = divObject.meet.onlineID;
    
div[@"eventRecordID"] = eventrecordID.recordName;
 
 
return div;

}

- (CKRecord*)addGEventOnline:(GEvent*)gEventObject AndEventRecordID: (CKRecordID*) eventrecordID{
    //create a new RecordType
        NSString*   user = self.fetchedMeetRecord.creatorUserRecordID.recordName;
    
    user = [user stringByReplacingOccurrencesOfString:@"_" withString:@""];
     NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
                                                timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];

    NSString* newrecordname = [NSString stringWithFormat:@"updatedEvent%@%@%@",gEventObject.onlineID, user, timestamp];
    CKRecordID *geventrecordID = [[CKRecordID alloc] initWithRecordName:newrecordname];
   
    CKRecord *gevent = [[CKRecord alloc] initWithRecordType:@"GEvent" recordID: geventrecordID];
    
      NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
    if (numberrange.location != NSNotFound) {
        newdevID = [devID substringFromIndex:numberrange.location + 2];
    } else {
     newdevID = devID;
    }

    devID = newdevID;
    devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
            //create and set record instance properties
gevent[@"editDone"] = [NSNumber numberWithBool:YES];
gevent[@"edited"] = [NSNumber numberWithBool:NO];
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
gevent[@"updateByUser"] = devID;
gevent[@"updateDateAndTime"] = [NSDate date];





gevent[@"meetOnlineID"] = gEventObject.meet.onlineID;

gevent[@"eventRecordID"] = eventrecordID.recordName;
    
    
 
 
return gevent;

}

- (CKRecord*)addTeamOnline:(Team*)teamObject AndEventRecordID: (CKRecordID*) eventrecordID{
    //create a new RecordType
        NSString*   user = self.fetchedMeetRecord.creatorUserRecordID.recordName;
    
    user = [user stringByReplacingOccurrencesOfString:@"_" withString:@""];
     NSString*   timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]];
                                                timestamp = [timestamp stringByReplacingOccurrencesOfString:@"." withString:@""];

    NSString* newrecordname = [NSString stringWithFormat:@"updatedEvent%@%@%@",teamObject.onlineID, user, timestamp];
    CKRecordID *teamrecordID = [[CKRecordID alloc] initWithRecordName:newrecordname];
    
    CKRecord *team = [[CKRecord alloc] initWithRecordType:@"Team" recordID:teamrecordID];
    
    
      NSString *devID = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] identifierForVendor]];
        
        NSString* newdevID;

    NSRange numberrange = [devID rangeOfString:@">" ];
    if (numberrange.location != NSNotFound) {
        newdevID = [devID substringFromIndex:numberrange.location + 2];
    } else {
     newdevID = devID;
    }

    devID = newdevID;
    devID = [newdevID stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    //create and set record instance properties
team[@"editDone"] = [NSNumber numberWithBool:YES];
team[@"edited"] = [NSNumber numberWithBool:NO];
team[@"onlineID"] = teamObject.onlineID;
team[@"teamAbr"] = teamObject.teamAbr;
team[@"teamID"] = teamObject.teamID;
team[@"teamName"] = teamObject.teamName;
team[@"teamPlace"] = teamObject.teamPlace;
team[@"teamScore"] = teamObject.teamScore;
team[@"updateByUser"] = devID;
team[@"updateDateAndTime"] = [NSDate date];


  team[@"meetOnlineID"] = teamObject.meet.onlineID;
    
 team[@"eventRecordID"] = eventrecordID.recordName;
 
return team;

}


- (void) modifyOnlineWithChanges: (NSMutableArray*) changesMute AndDeletions: (NSMutableArray*) deletionsMute {


  
  
  
    NSArray *localChanges = [changesMute copy];
    NSArray *localDeletions = [deletionsMute copy];
  
    
   // Initialize the database and modify records operation
 
   CKDatabase *database = [[CKContainer defaultContainer] publicCloudDatabase];
 
 
   CKModifyRecordsOperation *modifyRecordsOperation = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:localChanges recordIDsToDelete:localDeletions];
   modifyRecordsOperation.savePolicy = CKRecordSaveAllKeys;

   NSLog(@"CLOUDKIT Changes Uploading: %lu", (unsigned long)localChanges.count);

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
   


}

- (void) modifyOnlineDone {

    if (self.updateOnlineSuccess) {
        NSLog(@"update online success event %@ %@", self.savedEventObject.gEvent.gEventName, self.savedEventObject.division.divName);
        
        [self setAllNotEditedAndDoneForEvent:self.savedEventObject];
         [self endSendMethod];
    }
    else
    {
    
        if (self.objectNotOnServer) {
             dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertController * alert=   [UIAlertController
                                                                alertControllerWithTitle:@"Meet Not Found"
                                                                message:@"No record of this Athletics Meet was found on the server, the Meet may have been removed by the owner. \n \n If this is temporary, please wait until the Meet has been re-added and then submit results again"
                                                                preferredStyle:UIAlertControllerStyleAlert];
                                 
                                 
                                            UIAlertAction* ok = [UIAlertAction
                                                    actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                                                    {
                                                       
                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                         [self endSendMethod];
                                                    }];
                                                    
                                            [alert addAction:ok];
                                 
                                            [self presentViewController:alert animated:YES completion:nil];
                                            });
        }
        else
        {
                NSLog(@"update online failed event %@ %@", self.savedEventObject.gEvent.gEventName, self.savedEventObject.division.divName);
            
                [self setAllEditedAndNotDoneForEvent:self.savedEventObject];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertController * alert=   [UIAlertController
                                            alertControllerWithTitle:@"Update To Server Failed"
                                            message:@"Failed to update to online database, please check your internet connection, ensure you are signed in to iCloud and you have upgraded to iCloud Drive before trying again\n \n You may continue to enter results and send them when you re-establish a working connection. \n \n "
                                            preferredStyle:UIAlertControllerStyleAlert];
             
             
                        UIAlertAction* ok = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                    
                                    
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    [self endSendMethod];
                                    
                                     
                                }];
                                
                        [alert addAction:ok];
                        [self presentViewController:alert animated:YES completion:nil];
                        });
            
        }
    
    }

}
- (void) setAllEditedAndNotDoneForEvent: (Event*) event {

//NSLog(@"set all edited and not done for event %@ %@", event.division.divName, event.gEvent.gEventName);

    event.eventEdited = [NSNumber numberWithBool:YES];
    event.eventDone = [NSNumber numberWithBool:YES];
    event.edited = [NSNumber numberWithBool:YES];
    event.editDone = [NSNumber numberWithBool:NO];


    event.gEvent.edited = [NSNumber numberWithBool:YES];
    event.gEvent.editDone = [NSNumber numberWithBool:NO];
    
    event.division.edited = [NSNumber numberWithBool:YES];
    event.division.editDone = [NSNumber numberWithBool:NO];
    
    for (CEventScore* cscore in event.cEventScores) {
    
        cscore.edited = [NSNumber numberWithBool:YES];
        cscore.editDone = [NSNumber numberWithBool:NO];
        
        cscore.competitor.edited = [NSNumber numberWithBool:YES];
        cscore.competitor.editDone = [NSNumber numberWithBool:NO];
    
        cscore.competitor.team.edited = [NSNumber numberWithBool:YES];
        cscore.competitor.team.editDone = [NSNumber numberWithBool:NO];
    }
    
    
    
    
    NSError *error = nil;

    if (![self.managedObjectContext save:&error]) {
        
             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
    }
    
}
- (void) setAllNotEditedAndDoneForEvent: (Event*) event {

NSLog(@"set all not edited and done for event %@ %@", event.division.divName, event.gEvent.gEventName);

    event.eventEdited = [NSNumber numberWithBool:NO];
    event.eventDone = [NSNumber numberWithBool:YES];
    event.edited = [NSNumber numberWithBool:NO];
    event.editDone = [NSNumber numberWithBool:YES];


    event.gEvent.edited = [NSNumber numberWithBool:NO];
    event.gEvent.editDone = [NSNumber numberWithBool:YES];
    
    event.division.edited = [NSNumber numberWithBool:NO];
    event.division.editDone = [NSNumber numberWithBool:YES];
    
    for (CEventScore* cscore in event.cEventScores) {
    
        cscore.edited = [NSNumber numberWithBool:NO];
        cscore.editDone = [NSNumber numberWithBool:YES];
        
        cscore.competitor.edited = [NSNumber numberWithBool:NO];
        cscore.competitor.editDone = [NSNumber numberWithBool:YES];
    
        cscore.competitor.team.edited = [NSNumber numberWithBool:NO];
        cscore.competitor.team.editDone = [NSNumber numberWithBool:YES];
    }
    
    
    
    
    NSError *error = nil;

    if (![self.managedObjectContext save:&error]) {
        
             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
    }
   
    
}
- (void) endSendMethod {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self resumeMethod];
    });
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




[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

}


- (void) resumeMethod {


self.navigationController.view.userInteractionEnabled = YES;
  
    [self.activityindicator stopAnimating];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.tableView.tableHeaderView = nil;
    
    
}

- (IBAction)updateOnlineButtonPressed:(UIBarButtonItem *)sender {
    
}
- (IBAction)showBackupPressed:(UIBarButtonItem *)sender {
    if (self.showingBackups) {
        self.showingBackups = NO;
        self.showBackupButton.title = @"Show Backups";
        
    }
    else
    {
        self.showingBackups = YES;
        self.showBackupButton.title = @"Hide Backups";
        
    }
    self.fetchedResultsController = nil;
    [self.tableView reloadData];
}
@end
