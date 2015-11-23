//
//  ResultsWebViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 31/10/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "Meet.h"
#import "Team.h"
#import "Division.h"
#import "GEvent.h"
#import "CEventScore.h"
#import "BNHtmlPdfKit.h"
@interface ResultsWebViewController : UIViewController <UITabBarControllerDelegate, BNHtmlPdfKitDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) Meet* meetObject;
@property (strong, nonatomic) NSString* htmlString;
@property (strong, nonatomic) IBOutlet UIWebView *webWiew;
@property (strong, nonatomic) UIPrintInfo* printInfo;
@property (strong, nonatomic) UIViewPrintFormatter* formatter;
@property (strong, nonatomic) BNHtmlPdfKit *htmlPdfKit;

- (IBAction)ActionButtonPressed:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ActionButton;



@end
