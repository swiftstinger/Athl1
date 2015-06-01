//
//  TeamAddViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 29/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TeamAddViewController : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *teamName;
@property (weak, nonatomic) IBOutlet UITextField *teamAbr;

@end
