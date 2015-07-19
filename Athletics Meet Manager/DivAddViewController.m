//
//  DivAddViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "DivAddViewController.h"
#import "Division.h"

@interface DivAddViewController ()
@property (nonatomic, assign) id currentResponder;
@end




@implementation DivAddViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.editing = false;
    self.isOnTextField = false;
    
    
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{

   if (_detailItem != newDetailItem) {
// nslog(@"setdetailitem");
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

- (void)configureView
{
// nslog(@"configureview");
    // Update the user interface for the detail item.
    if (self.editing) {
    // nslog(@"configureview is editing");
      _divName.text = [_detailItem valueForKey:@"divName"];
      
      
   }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.divName becomeFirstResponder];
   
    
    [_divName setDelegate:self];
    
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
   
    
    if ([identifier isEqualToString:@"unwindToSetupDivDoneSegue"]) {
        
        //checks
        
        if (FALSE) {
        
        // nslog(@"in shouldperformsegue no");
        return NO;
        }
   
    }
    
    return YES;              
}

@end
