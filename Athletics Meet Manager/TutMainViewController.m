//
//  TutMainViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 27/08/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "TutMainViewController.h"
#import "TutContentViewController.h"

@interface TutMainViewController ()

@end

@implementation TutMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    _pageImages = @[@"0.png",@"1.png", @"2.png", @"3.png", @"4.png", @"5.png", @"6.png", @"7.png", @"8.png", @"9.png",@"10.png",@"11.png", @"12.png", @"13.png", @"14.png", @"15.png", @"16.png", @"17.png", @"18.png", @"19.png", @"20.png",@"21.png", @"22.png", @"23.png", @"24.png", @"25.png", @"26.png", @"27.png", @"28.png", @"29.png",@"30.png",@"31.png", @"32.png", @"33.png", @"34.png", @"35.png", @"36.png", @"37.png", @"38.png", @"39.png",@"40.png",@"41.png", @"42.png", @"43.png", @"44.png", @"45.png", @"46.png", @"47.png", @"48.png", @"49.png"];
    _pageTitles = _pageImages;
 //   _pageTitles = @[@"Over 200 Tips and Tricks", @"Discover Hidden Features", @"Bookmark Favorite Tip", @"Free Regular Update"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutPageViewController"];
    self.pageViewController.dataSource = self;
    
    TutContentViewController *startingViewController = [self viewControllerAtIndex:0];
    
    //change index here?
    
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
   // self.navigationController.navigationBar.frame.size.height
   // self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
 //  double height = self.view.frame.size.height - ( self.navigationController.navigationBar.frame.size.height + 20 + self.navigationController.toolbar.frame.size.height);
   
  // double width = (height/1536) * 1152;
   
   
   self.pageViewController.view.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + 20 , self.view.frame.size.width, self.view.frame.size.height - ( self.navigationController.navigationBar.frame.size.height + 20 + self.navigationController.toolbar.frame.size.height));
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((TutContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
- (TutContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    TutContentViewController *tutContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutContentViewController"];
    tutContentViewController.TutimageFile = self.pageImages[index];
    tutContentViewController.titleText = self.pageTitles[index];
    tutContentViewController.pageIndex = index;
    
    return tutContentViewController;
}
- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}


/** set viewcontroller to start
- (IBAction)startWalkthrough:(id)sender {
    TutContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

**/

@end
