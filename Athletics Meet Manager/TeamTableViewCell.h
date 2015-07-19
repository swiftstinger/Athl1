//
//  TeamTableViewCell.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 29/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *teamTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfCompetitorsLabel;

@end
