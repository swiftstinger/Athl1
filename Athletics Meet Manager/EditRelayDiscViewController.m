//
//  EditRelayDiscViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 18/01/2016.
//  Copyright (c) 2016 rudi huysamen. All rights reserved.
//

#import "EditRelayDiscViewController.h"
#import "CEventScore.h"

@interface EditRelayDiscViewController ()
@property (nonatomic, assign) id currentResponder;
@property (strong, nonatomic) CEventScore* cscore;
@end

@implementation EditRelayDiscViewController

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.isOnTextField = false;
    
    
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{

   if (_detailItem != newDetailItem) {

       _detailItem = newDetailItem;
       self.cscore = (CEventScore*)_detailItem;
       
      
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

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
   [self.textfield becomeFirstResponder];
   
 
    [_textfield setDelegate:self];
    
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


@end
