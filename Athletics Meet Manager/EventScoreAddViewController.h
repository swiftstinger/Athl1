//
//  EventScoreAddViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 03/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Competitor.h"

@interface EventScoreAddViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *compNameField;
@property (weak, nonatomic) IBOutlet UITextField *teamAbrField;
@property (weak, nonatomic) IBOutlet UITextField *resultField;
@property (strong, nonatomic) Competitor* competitorObject;
@property  double result;

@end
