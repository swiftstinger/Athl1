//
//  EventForCAddViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 02/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "EventForCAddViewController.h"
#import "CEventScore.h"

@interface EventForCAddViewController ()
//@property (nonatomic, assign) id currentResponder;
@end

@implementation EventForCAddViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.editing = false;
  //  self.isOnTextField = false;
    
    
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
    if (self.managedObjectContext != newcontext) {
        _managedObjectContext = newcontext;
        
    }
}
- (void)setCompetitorItem:(Competitor*)newCompetitorItem
{

   if (_competitorItem != newCompetitorItem) {

        _competitorItem = newCompetitorItem;
       
      
      
    }
}


- (void)configureView
{

    // Update the user interface for the detail item.
    if (self.editing) {
      //_competitorName.text = [_detailItem valueForKey:@"competitorName"];
      
      
   }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
 //   [_competitorName setDelegate:self];
/*
UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
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
*/
/*

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   
    
    if ([identifier isEqualToString:@"unwindToSetupEventsForCDoneSegue"]) {
        
        //checks
        if (!self.isEditing) {
            self.meet = self.competitorItem.meet;
            int competitorEventLimit = [self.meet.cEventLimit intValue];
    
        int currentEventNumber = (int)[[self.competitorItem valueForKey:@"cEventScores"] count] ;
            if (competitorEventLimit != 0) {
            
                    if (!(competitorEventLimit>currentEventNumber)) {
    
                NSLog(@"in shouldperformsegue no");
                
                UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"Too many Events For Competitor"
                                    message:@"Please delete an event or change the number of events allowed per competitor"
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
*/

@end
