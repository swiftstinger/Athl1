//
//  MeetMenuViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "MeetMenuViewController.h"
#import "MeetMenuViewCell.h"
#import "FinalResultsViewController.h"

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
    
            self.groupDivCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            self.groupDivCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if ([[self.meetObject valueForKey: @"eventsDone"] boolValue]) {
            self.gEventCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            self.gEventCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if ([[self.meetObject valueForKey: @"teamsDone"] boolValue]) {
            self.enterTeamCell.accessoryType = UITableViewCellAccessoryCheckmark;
            
        }
        else
        {
       
            self.enterTeamCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }



}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
     NSLog(@"Teams in configure view: %lu",  (unsigned long)[self.meetObject.teams count]);
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        NSEntityDescription *description = [NSEntityDescription entityForName:@"Team" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];


            NSPredicate *pred = [NSPredicate predicateWithFormat:@"(meet == %@)", self.meetObject];
           // NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(event == %@)", self.event];
           // NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
          //  NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:pred];


            NSError *err;
            NSUInteger teamcount = [self.managedObjectContext countForFetchRequest:fetchRequest error:&err];
        
        
            if(teamcount == NSNotFound) {
                //Handle error
            }
            int intvalue = (int)teamcount;

         NSLog(@"Teams in configure view from fetch : %d",  intvalue);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 

if (FALSE) {
    
}
else
{

    if ([[segue identifier] isEqualToString:@"finalResults"]) {
        NSLog(@"final results");
        
        
      
        UITabBarController *barController = (UITabBarController*)[segue destinationViewController];
        FinalResultsViewController* finalResultsController = (FinalResultsViewController*)[barController.viewControllers objectAtIndex:0];
       
        [finalResultsController setDetailItem:self.meetObject];
       
       [finalResultsController setManagedObjectContext:self.managedObjectContext];
     /*
        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    */
}

    else
    {

        [[segue destinationViewController] setDetailItem:self.meetObject];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];
    NSLog(@"in segue in meetmenu prepareforsegue");
    }
  /*
    if ([[segue identifier] isEqualToString:@"divSetup"]) {
        
        [[segue destinationViewController] setDetailItem:self.meetObject];
        [[segue destinationViewController] setManagedObjectContext:self.managedObjectContext];

    }
    */
}
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
            else if (!divsdone)
            {
              UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"No Divisions Set Up"
                                    message:@"Please set up at least one Division for this Meet"
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

    if ([identifier isEqualToString:@"enterResults"]) {
        
        //checks
        bool divsdone = [[self.meetObject valueForKey: @"divsDone"] boolValue];
        bool eventsdone = [[self.meetObject valueForKey: @"eventsDone"] boolValue];
        bool teamsdone = [[self.meetObject valueForKey: @"teamsDone"] boolValue];
        
        if (!divsdone && !eventsdone && !teamsdone) {
            
            UIAlertController * alert=   [UIAlertController
                                    alertControllerWithTitle:@"No Group Divisions, Events or Teams Set Up"
                                    message:@"Please set up at least one Group Division, Event and Team for this Meet"
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
            else if (!divsdone && !teamsdone) {
            
                UIAlertController * alert=   [UIAlertController
                                        alertControllerWithTitle:@"No Group Divisions or Teams Set Up"
                                        message:@"Please set up at least one Group Division and at least on Team for this Meet"
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
            else if (!eventsdone && !teamsdone) {
            
                UIAlertController * alert=   [UIAlertController
                                        alertControllerWithTitle:@"No Group Events or Teams Set Up"
                                        message:@"Please set up at least one Event and at least on Team for this Meet"
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
                else if (!divsdone)
                {
                UIAlertController * alert=   [UIAlertController
                                        alertControllerWithTitle:@"No Divisions Set Up"
                                        message:@"Please set up at least one Division for this Meet"
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
                else if (!teamsdone)
                {
                UIAlertController * alert=   [UIAlertController
                                        alertControllerWithTitle:@"No Teams Set Up"
                                        message:@"Please set up at least one Team for this Meet"
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


@end
