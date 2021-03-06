//
//  TeamAddViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 29/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "TeamAddViewController.h"
#import "Team.h"


@interface TeamAddViewController ()
@property (nonatomic, assign) id currentResponder;
@end

@implementation TeamAddViewController

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
      self.teamName.text = [_detailItem valueForKey:@"teamName"];
      self.teamAbr.text = [_detailItem valueForKey:@"teamAbr"];
      
      
   }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.teamName becomeFirstResponder];
   
    
    [_teamName setDelegate:self];
    
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   
    
    if ([identifier isEqualToString:@"unwindToSetupTeamDoneSegue"]) {
        
        //checks
        
        if (FALSE) {
        
        // nslog(@"in shouldperformsegue no");
        return NO;
        }
   
    }
    
    return YES;              
}


@end
