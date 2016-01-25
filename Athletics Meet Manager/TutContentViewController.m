//
//  TutContentViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 27/08/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "TutContentViewController.h"

@interface TutContentViewController ()

@end

@implementation TutContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.TutImageView.image = [UIImage imageNamed:self.TutimageFile];
   // self.titleLabel.text = self.titleText;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
