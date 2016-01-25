//
//  TutContentViewController.h
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 27/08/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *TutImageView;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *TutimageFile;

@end
