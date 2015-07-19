//
//  GEventAddViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 29/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "GEventAddViewController.h"
#import "GEvent.h"


@interface GEventAddViewController ()
@property (nonatomic, assign) id currentResponder;
@end

@implementation GEventAddViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.editing = false;
    _isOnTextField = false;
    
    
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{

   if (_detailItem != newDetailItem) {

        _detailItem = newDetailItem;
       
        self.isEditing = TRUE;
      
      [self configureView];
    }
}


- (void)setMeetObject:(Meet *)meetObject
{

   if (_meetObject != meetObject) {

        _meetObject = meetObject;
       
       
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
    
    // nslog(@"comp per team: %@  max scoring competitors: %@ scorefor first place: %@ decrementperplace: %@ scoreMultiplier: %@", self.meetObject.competitorPerTeam,self.meetObject.maxScoringCompetitors,self.meetObject.scoreForFirstPlace,self.meetObject.decrementPerPlace,self.meetObject.scoreMultiplier);
    
    
    if (self.editing) {
      _gEventName.text = [_detailItem valueForKey:@"gEventName"];
      
      
      
      
     
      self.gEventTypeValue  = [_detailItem valueForKey:@"gEventType"];
      
      // nslog(@"geventtype in edit and is %@", self.gEventTypeValue);
      // nslog(@"geventtype segemnt in edit and is %@", self.gEventTypeValue);

      if ([self.gEventTypeValue isEqualToString: [self.gEventType titleForSegmentAtIndex:0]])
      {
        self.gEventType.selectedSegmentIndex = 0;
        
        }
         if ([self.gEventTypeValue isEqualToString: [self.gEventType titleForSegmentAtIndex:1]])
      {
        self.gEventType.selectedSegmentIndex = 1;
        
        }
        if ([self.gEventTypeValue isEqualToString: [self.gEventType titleForSegmentAtIndex:2]])
      {
        self.gEventType.selectedSegmentIndex = 2;
        
        }
      
      
       
      // maxcomp
           
     self.maxCompPerTeamLabel.text = [[_detailItem valueForKey:@"competitorsPerTeam"]description];

 
      self.maxCompPerTeamStepper.value = [[_detailItem valueForKey:@"competitorsPerTeam"] intValue];
      
      //maxScoringcomp
      
      self.maxScoringCompLabel.text = [[_detailItem valueForKey:@"maxScoringCompetitors"]description];
      
      self.maxScoringCompStepper.value = [[_detailItem valueForKey:@"maxScoringCompetitors"] intValue];
      
     
      
      
      //firstplacescore
      
      self.scoreForFirstLabel.text = [[_detailItem valueForKey:@"scoreForFirstPlace"]description];
      
      self.scoreForFirstStepper.value = [[_detailItem valueForKey:@"scoreForFirstPlace"] intValue];
      
      
      //reductionPerplace
      
      self.reductionPerPlaceLabel.text = [[_detailItem valueForKey:@"decrementPerPlace"]description];
      
      self.reductionPerPlaceStepper.value = [[_detailItem valueForKey:@"decrementPerPlace"] intValue];
      
      
      //ScoreMultiplier
      
      self.scoreMultiplierLabel.text = [[_detailItem valueForKey:@"scoreMultiplier"]description];
      
      self.scoreMultiplierStepper.value = [[_detailItem valueForKey:@"scoreMultiplier"] intValue];
      
      
      
   }
   else
   {
       
       // nslog(@"in else");
       
        // maxcomp
       
        Meet* meet =  self.meetObject;
           
     self.maxCompPerTeamLabel.text = [[meet valueForKey:@"competitorPerTeam"]description];

 
      self.maxCompPerTeamStepper.value = [[meet valueForKey:@"competitorPerTeam"] intValue];
      
      //maxScoringcomp
      
      self.maxScoringCompLabel.text = [[meet valueForKey:@"maxScoringCompetitors"]description];
      
      self.maxScoringCompStepper.value = [[meet valueForKey:@"maxScoringCompetitors"] intValue];
      
     
      
      
      //firstplacescore
      
      self.scoreForFirstLabel.text = [[meet valueForKey:@"scoreForFirstPlace"]description];
      
      self.scoreForFirstStepper.value = [[meet valueForKey:@"scoreForFirstPlace"] intValue];
      
      
      //reductionPerplace
      
      self.reductionPerPlaceLabel.text = [[meet valueForKey:@"decrementPerPlace"]description];
      
      self.reductionPerPlaceStepper.value = [[meet valueForKey:@"decrementPerPlace"] intValue];
      
      
      //ScoreMultiplier
      
      self.scoreMultiplierLabel.text = [[meet valueForKey:@"scoreMultiplier"]description];
      
      self.scoreMultiplierStepper.value = [[meet valueForKey:@"scoreMultiplier"] intValue];
   
   }
   
   
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   [self.gEventName becomeFirstResponder];
    
    [_gEventName setDelegate:self];
    
UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)gEventTypeSelecterValueChanged:(id)sender {

self.gEventTypeValue= [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
// NSString * theTitle = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
 
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


- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   
    
    if ([identifier isEqualToString:@"unwindToSetupGEventDoneSegue"]) {
        
        self.gEventTypeValue = [self.gEventType titleForSegmentAtIndex:[self.gEventType selectedSegmentIndex]];
        //checks
        // nslog(@"GEventType: %@",self.gEventTypeValue);
        
        if (FALSE) {
        
        // nslog(@"in shouldperformsegue no");
        return NO;
        }
   
    }
    
    return YES;              
}


- (IBAction)maxCompStepperValueChanged:(UIStepper *)sender
{
  NSUInteger value = sender.value;
  self.maxCompPerTeamLabel.text = [NSString stringWithFormat:@"%@",@(value)];
 
}
- (IBAction)maxScoringCompStepperValueChanged:(UIStepper *)sender {
  NSUInteger value = sender.value;
  self.maxScoringCompLabel.text = [NSString stringWithFormat:@"%@",@(value)];
 

}
- (IBAction)scoreForFirstStepperValueChanged:(UIStepper *)sender {
  NSUInteger value = sender.value;
  self.scoreForFirstLabel.text = [NSString stringWithFormat:@"%@",@(value)];
 

}
- (IBAction)scoreMultiplierStepperValueChanged:(UIStepper *)sender {
  NSUInteger value = sender.value;
  self.scoreMultiplierLabel.text = [NSString stringWithFormat:@"%@",@(value)];
 

}
- (IBAction)reductionPerPlaceStepperValueChanged:(UIStepper *)sender {
  NSUInteger value = sender.value;
  self.reductionPerPlaceLabel.text = [NSString stringWithFormat:@"%@",@(value)];
 

}
@end
