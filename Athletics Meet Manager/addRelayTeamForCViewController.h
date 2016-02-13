//
//  addRelayTeamForCViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 03/02/2016.
//  Copyright (c) 2016 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Event.h"
@interface addRelayTeamForCViewController : UITableViewController <UITextFieldDelegate>


@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Event* eventObject;
@property BOOL isOnTextField;

@property (weak, nonatomic) IBOutlet UITextField *relayDiscTextField;

@end
