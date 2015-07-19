//
//  TeamFinalResultsTableViewCell.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 28/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamFinalResultsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teamLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;

@end
