//
//  CEventResultTableViewCell.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 25/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CEventResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *competitorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *competitorTeamLabel;
@property (weak, nonatomic) IBOutlet UILabel *competitorScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *competitorResultLabel;
@property (weak, nonatomic) IBOutlet UILabel *competitorPlaceLabel;

@end
