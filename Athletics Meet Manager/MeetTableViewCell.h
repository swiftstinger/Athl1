//
//  MeetTableViewCell.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 25/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *meetTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *meetDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *numberOfTeamsLabel;

@end
