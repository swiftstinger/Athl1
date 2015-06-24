//
//  HighJumpScoreEnterViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 23/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEventScore.h"

@interface HighJumpScoreEnterViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate>

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property BOOL isEditing;
@property BOOL isOnTextField;



@property (strong, nonatomic) CEventScore* cEventScore;
@property  double result;
@property  double place;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (weak, nonatomic) IBOutlet UITextField *resultTextField;

@property (weak, nonatomic) IBOutlet UITextField *placingTextField;


@end
