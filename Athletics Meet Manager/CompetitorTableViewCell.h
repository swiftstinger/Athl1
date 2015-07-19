//
//  CompetitorTableViewCell.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 02/06/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompetitorTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *competitorTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfEventsLabel;

@end
