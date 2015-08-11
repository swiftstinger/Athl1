//
//  MeetMenuViewController.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetMenuViewCell.h"
#import <CoreData/CoreData.h>
#import "Meet.h"
#import <MessageUI/MessageUI.h>
#import <CloudKit/CloudKit.h>


@interface MeetMenuViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *MeetMenuLabel;
@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (strong, nonatomic) Meet* meetObject;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet MeetMenuViewCell *groupDivCell;
@property (weak, nonatomic) IBOutlet UILabel *groupDivLabel;
@property (weak, nonatomic) IBOutlet MeetMenuViewCell *gEventCell;
@property (weak, nonatomic) IBOutlet UILabel *gEventLabel;
@property (weak, nonatomic) IBOutlet MeetMenuViewCell *enterTeamCell;
@property (weak, nonatomic) IBOutlet UILabel *enterTeamLabel;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateOnlineButton;
- (IBAction)updateOnlineButtonPressed:(UIBarButtonItem *)sender;


- (IBAction)ExportResultsButton:(UIBarButtonItem *)sender;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendPermissionButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareOnlineButton;
@property (weak, nonatomic) IBOutlet MeetMenuViewCell *finalResultCell;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *exportResultsButton;

@property (strong, nonatomic) UIActivityIndicatorView *activityindicator;

@property (strong, nonatomic) UIView *activityview;

@property (strong, nonatomic) IBOutlet UITableView *tableview;



@end
