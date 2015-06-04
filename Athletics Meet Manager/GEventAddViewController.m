//
//  GEventAddViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 29/05/2015.
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
    if (self.editing) {
      _gEventName.text = [self.detailItem valueForKey:@"gEventName"];
      
      self.maxCompStepper.value = [[self.detailItem valueForKey:@"competitorsPerTeam"] intValue];
      
     self.maxCompPerTeamLabel.text = [[self.detailItem valueForKey:@"competitorsPerTeam"]description];
      
      
     
      self.gEventTypeValue  = [self.detailItem valueForKey:@"gEventType"];

      if ([self.gEventTypeValue isEqualToString: [self.gEventType titleForSegmentAtIndex:0]])
      {
        self.gEventType.selectedSegmentIndex = 0;
        
        }
         if ([self.gEventTypeValue isEqualToString: [self.gEventType titleForSegmentAtIndex:1]])
      {
        self.gEventType.selectedSegmentIndex = 1;
        
        }
      
      
      
   }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
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

- (IBAction)maxCompStepperValueChanged:(UIStepper *)sender
{
  NSUInteger value = sender.value;
  self.maxCompPerTeamLabel.text = [NSString stringWithFormat:@"%@",@(value)];
 
}

- (IBAction)gEventTypeSelecterValueChanged:(id)sender {

self.gEventTypeValue= [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
// NSString * theTitle = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
 
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


@end
