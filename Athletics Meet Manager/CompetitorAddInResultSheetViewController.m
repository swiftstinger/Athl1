//
//  CompetitorAddInResultSheetViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 13/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "CompetitorAddInResultSheetViewController.h"
#import "GEvent.h"

@interface CompetitorAddInResultSheetViewController ()
@property (nonatomic, assign) id currentResponder;
@end

@implementation CompetitorAddInResultSheetViewController

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
       self.event = (Event*)_detailItem;
       self.meet = self.event.meet;
    //   self.isEditing = TRUE;
      
      [self configureView];
    }
}

- (void)setTeamItem:(id)newTeamItem
{

   if (_teamItem != newTeamItem) {

       _teamItem = newTeamItem;
       
    //   self.isEditing = TRUE;
      
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
    //  _competitorName.text = [_detailItem valueForKey:@"compName"];
      
      
   }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self.competitorName becomeFirstResponder];
   
 
    [_competitorName setDelegate:self];
    
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




- (IBAction)doneButton:(UIBarButtonItem *)sender {

    if ([self.event.gEvent.gEventType isEqualToString:@"Relay"])
        {
            
        [self performSegueWithIdentifier:@"compAddInResultsRelayDone" sender:self];
           
            
        
        }
        else
        {
            [self performSegueWithIdentifier:@"compAddInResultsNormDone" sender:self];
        
        
        }

}
@end
