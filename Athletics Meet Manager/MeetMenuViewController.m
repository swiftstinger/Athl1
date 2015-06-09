//
//  MeetMenuViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "MeetMenuViewController.h"
#import "MeetMenuViewCell.h"

@interface MeetMenuViewController ()

@end

@implementation MeetMenuViewController


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        _meetObject = _detailItem;
        // Update the view.
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
    if (_detailItem) {
      _navBar.title = [self.meetObject valueForKey:@"meetName"];
      
      NSLog(@"meet item %@", [self.meetObject valueForKey:@"meetName"]);
             /*
          self.titleField.text = [_detailItem valueForKey:@"title"];
        self.episodeIDField.text = [NSString stringWithFormat:@"%d", [[_detailItem valueForKey:@"episodeID"] integerValue]];
        self.descriptionView.text = [_detailItem valueForKey:@"desc"];
        self.firstRunSegmentedControl.selectedSegmentIndex = [[_detailItem valueForKey:@"firstRun"] boolValue];
        self.showTimeLabel.text = [[_detailItem valueForKey:@"showTime"] description];
        
        */
      
        
        
    }
}
- (void)viewWillAppear:(BOOL)animated
{

if ([[self.meetObject valueForKey: @"divsDone"] boolValue]) {
            NSLog(@"meet divs done");
            self.groupDivCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            self.groupDivCell.accessoryType = UITableViewCellAccessoryNone;
        }
        if ([[self.meetObject valueForKey: @"eventsDone"] boolValue]) {
            self.gEventCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            self.gEventCell.accessoryType = UITableViewCellAccessoryDetailButton;
        }
        if ([[self.meetObject valueForKey: @"teamsDone"] boolValue]) {
            self.enterTeamCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        else
        {
        NSLog(@"meet team not done done");
            self.enterTeamCell.accessoryType = UITableViewCellAccessoryNone;
        }



}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
 /*
 
    if ([[segue identifier] isEqualToString:@"addMeet"]) {
        
        
    }
  */
  if (FALSE) {
    
}
else
{

[[segue destinationViewController] setDetailItem:self.meetObject];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
}
  /*
    if ([[segue identifier] isEqualToString:@"divSetup"]) {
        
        [[segue destinationViewController] setDetailItem:self.meetObject];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];

    }
    */
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
   
    
    if ([identifier isEqualToString:@"gEventsSetup"]) {
        
        //checks
        bool divsdone = [[self.meetObject valueForKey: @"divsDone"] boolValue];
        
        if (!divsdone) {
            
                UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"No Group Divisions Set Up"
                                    message:@"Please set up at least one Group Division for this Meet"
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
    if ([identifier isEqualToString:@"teamsSetup"]) {
        
        //checks
        bool divsdone = [[self.meetObject valueForKey: @"divsDone"] boolValue];
        bool eventsdone = [[self.meetObject valueForKey: @"eventsDone"] boolValue];
        
        if (!divsdone && !eventsdone) {
            
            UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"No Group Divisions or Events Set Up"
                                    message:@"Please set up at least one Group Division and at least on Event for this Meet"
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
        else
        {
        
        
            if (!eventsdone) {
            
                UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"No Events Set Up"
                                    message:@"Please set up at least one Event for this Meet"
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

        
   
    
    return YES;              
}


@end
