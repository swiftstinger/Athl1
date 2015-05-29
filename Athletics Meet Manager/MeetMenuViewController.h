//
//  MeetMenuViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 28/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeetMenuViewCell.h"
#import <CoreData/CoreData.h>


@interface MeetMenuViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *MeetMenuLabel;
@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (strong, nonatomic) id meetObject;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end
