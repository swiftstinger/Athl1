//
//  MeetAddViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 27/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeetAddViewController;
 
@protocol MeetAddViewControllerDelegate <NSObject>
- (void)MeetAddViewControllerDidCancel:(MeetAddViewController *)controller;
- (void)MeetAddViewControllerDidSave:(MeetAddViewController *)controller;
@end

@interface MeetAddViewController : UITableViewController

@property (nonatomic, weak) id <MeetAddViewControllerDelegate> delegate;
 
- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
