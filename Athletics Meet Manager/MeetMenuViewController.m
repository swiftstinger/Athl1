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



@end