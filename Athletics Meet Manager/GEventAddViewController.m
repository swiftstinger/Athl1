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
}

- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}


@end
