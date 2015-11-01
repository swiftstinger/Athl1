//
//  ResultsWebViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 31/10/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Meet.h"
#import "Team.h"
#import "Division.h"
#import "GEvent.h"

@interface ResultsWebViewController : UIViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Meet* meetObject;

@property (weak, nonatomic) IBOutlet UIWebView *webWiew;



@end
