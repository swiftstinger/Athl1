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

@interface MeetMenuViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *MeetMenuLabel;
@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (strong, nonatomic) Meet* meetObject;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet MeetMenuViewCell *groupDivCell;
@property (weak, nonatomic) IBOutlet MeetMenuViewCell *gEventCell;
@property (weak, nonatomic) IBOutlet MeetMenuViewCell *enterTeamCell;

- (IBAction)ExportResultsButton:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *exportbutton;

@end
