//
//  CompetitorScoreEnterViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 03/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "CompetitorScoreEnterViewController.h"

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
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   
    
    if ([identifier isEqualToString:@"unwindToEventScoreSheetDoneSegue"]) {
        
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *resultNumber = [f numberFromString:self.resultTextField.text];
        self.result =[resultNumber doubleValue];
        
        
        //checks
        
        if (FALSE) {
        
        NSLog(@"in shouldperformsegue no");
        return NO;
        }
   
    }
    
    return YES;              
}

@end
