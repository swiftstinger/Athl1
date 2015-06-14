//
//  CompetitorScoreEnterViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 03/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "CompetitorScoreEnterViewController.h"
#import "GEvent.h"
#import "Event.h"

@interface CompetitorScoreEnterViewController ()
@property (nonatomic, assign) id currentResponder;

@end

@implementation CompetitorScoreEnterViewController

//_navBar.title = [self.competitorObject valueForKey:@"compName"];

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
      
      
   }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.resultTextField setKeyboardType:UIKeyboardTypeDecimalPad];
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
    
    NSLog(@"close keyboard?");
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
NSLog(@"event id %@",event.eventID);

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
                else
                {
                    NSLog(@"whooooops geventtyp not either %@", event.gEvent.gEventType);
                    }
    
    
                NSArray *sortDescriptors = @[sorter];
    
                [fetchRequest setSortDescriptors:sortDescriptors];


            NSError *error;
                NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
 
    int competitorPointsMultiplier = [event.gEvent.competitorsPerTeam intValue];
    
    int numberOfTeams = [self getTeamNumberWithEventObject: event];
    
    int topresult = competitorPointsMultiplier * numberOfTeams;
    
    int count = 0;
    int score;
    for(CEventScore *object in results) {
        
        
        score = topresult - count;
        count++;
        object.placing = [NSNumber numberWithInt:count];
        
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

    
    if ([[segue identifier] isEqualToString:@"unwindToEventScoreSheetDoneSegue"]) {
       [self resultsCalculate: self.cEventScore];
        
    }
    
}


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   NSLog(@"here");
    
    if ([identifier isEqualToString:@"unwindToEventScoreSheetDoneSegue"]) {
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *resultNumber = [f numberFromString:self.resultTextField.text];
        self.result =[resultNumber doubleValue];
        
        
        
        
        if (FALSE) {
        
        NSLog(@"in shouldperformsegue no");
        return NO;
        }
   
    }
    
    return YES;              
}

@end
