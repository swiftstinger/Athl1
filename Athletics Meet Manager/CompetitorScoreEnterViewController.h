//
//  CompetitorScoreEnterViewController.h
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 03/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CEventScore.h"

@interface CompetitorScoreEnterViewController : UITableViewController

@property (strong, nonatomic) CEventScore* cEventScore;
@property  double result;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;

@end
