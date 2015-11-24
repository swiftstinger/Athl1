//
//  HighJumpScoreEnterViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 23/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "HighJumpScoreEnterViewController.h"
#import "GEvent.h"
#import "Event.h"

@interface HighJumpScoreEnterViewController ()
@property (nonatomic, assign) id currentResponder;
@end

@implementation HighJumpScoreEnterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.editing = false;
    self.isOnTextField = false;
    
    
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{

   if (_detailItem != newDetailItem) {

        _detailItem = newDetailItem;
       self.cEventScore = _detailItem;
       if (self.cEventScore.result) {
            self.isEditing = TRUE;
            // nslog(@"self.editing = true");
        }
       
      
      [self configureView];
    }
}
#pragma mark - Managing the managedobjectcontext item

- (void)setManagedObjectContext:(NSManagedObjectContext *)newcontext
{
    if (self.managedObjectContext != newcontext) {
        _managedObjectContext = newcontext;
        
    }
}

- (void)configureView
{

    // Update the user interface for the detail item.
    if (self.editing) {
      _resultTextField.text = [[self.cEventScore valueForKey:@"result"] description];
      _placingTextField.text = [[self.cEventScore valueForKey:@"placing"] description];
    
      
        
   }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.resultTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.placingTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [self.resultTextField becomeFirstResponder];
    
    [_resultTextField setDelegate:self];
    
UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    // nslog(@"close keyboard?");
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
    self.isOnTextField = true;
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
    if (_isOnTextField) {
      self.isOnTextField = false;
      [self.currentResponder resignFirstResponder];
    }
}
- (void) resultsCalculate: (CEventScore*)thisscore {

Event * event = thisscore.event;
// nslog(@"event id %@",event.eventID);

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
    
                if ([event.gEvent.gEventType isEqualToString:@"Track"] || [event.gEvent.gEventType isEqualToString:@"Relay"] ) {
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
                    // nslog(@"whooooops geventtyp not either %@", event.gEvent.gEventType);
                    }
    
    
                NSArray *sortDescriptors = @[sorter];
    
                [fetchRequest setSortDescriptors:sortDescriptors];


            NSError *error;
                NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    int competitorPointsMultiplier = [event.gEvent.competitorsPerTeam intValue];
    int topresult;
    
    
    if (competitorPointsMultiplier == 0) {
    
        topresult = [results count];
    }
    else
    {
        int numberOfTeams = [self getTeamNumberWithEventObject: event];
    
        topresult = competitorPointsMultiplier * numberOfTeams;

    }
    
   
    int count = 0;
    int score;
    double placing;
    int lastplacegiven = 0;
    int lastscoregiven = 0;
    NSNumber *lastResult = 0;
    NSNumber *currentResult;
    bool lastplacemanual = NO;
    
    for(CEventScore *object in results) {
       
         currentResult = object.result;
       // [number1 doubleValue] < [number2 doubleValue]
       if (![object.highJumpPlacingManual boolValue]) {
        
            if ([currentResult doubleValue] == [lastResult doubleValue]) {
                // nslog(@"same lastResult %@ currentResult %@", lastResult,currentResult);
               
                if (lastplacemanual){
                    placing = lastplacegiven + 1;
                    score = topresult - (placing -1);
                    // nslog(@" manual and last place given %d", lastplacegiven);
                                    }
                else
                {
                score = lastscoregiven;
                placing = lastplacegiven;
                // nslog(@"not manual and last place given %d", lastplacegiven);

                }
            }
            else
            {
                // nslog(@"not same lastResult %@ currentResult %@", lastResult,currentResult);
                score = topresult - count;
                placing = count + 1;
                // nslog(@"not manual and last place given %d", lastplacegiven);
            }
            lastplacegiven = placing;
            lastscoregiven = score;
            lastResult = currentResult;
           lastplacemanual = NO;
           
        }
        else
        {
        
        // nslog(@"manual");
            placing = [object.placing intValue];
            score = topresult - (placing -1);
            lastResult = currentResult;
           lastplacemanual = YES;
        }
        
        count++;
        
        
        
        object.placing = [NSNumber numberWithInt:placing];
        
        object.score = [NSNumber numberWithInt:score];

        // nslog(@" score ranking =  %@  and Points =  %@",object.placing,object.score);
    }
    
    
    //resultworkout
 
   
    


    

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

    
    if ([[segue identifier] isEqualToString:@"unwindToEventScoreSheetDoneSegue"]) {
      // [self resultsCalculate: self.cEventScore];
        
    }
    
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   // nslog(@"here");
    
    if ([identifier isEqualToString:@"unwindToEventScoreSheetDoneSegue"]) {
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *resultNumber = [f numberFromString:self.resultTextField.text];
        NSNumber *placeNumber = [f numberFromString:self.placingTextField.text];
        self.result =[resultNumber doubleValue];
        self.place =[placeNumber doubleValue];
        self.cEventScore.result = [NSNumber numberWithDouble:self.result];
        double oldplace = [self.cEventScore.placing doubleValue];
        
        if (oldplace != self.place) {
            self.cEventScore.placing = [NSNumber numberWithDouble:self.place];
            self.cEventScore.highJumpPlacingManual = [NSNumber numberWithBool:YES];
        }
        
        
        
        
        if (FALSE) {
        
        // nslog(@"in shouldperformsegue no");
        return NO;
        }
   
    }
    
    return YES;              
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // If the showAllSections is NO, then we want only two sections.
    // Otherwise, we want our table to have four sections.
    if (!self.editing) {
        return 1;
    }
    else{
        return 2;
    }
}


@end
