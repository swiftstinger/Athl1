//
//  MeetAddViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 27/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "MeetAddViewController.h"
#import "Meet.h"

@interface MeetAddViewController ()
@property (nonatomic, assign) id currentResponder;
@end

@implementation MeetAddViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.editing = false;
    _isOnTextField = false;
    
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
NSLog(@"in detail item");
   if (_detailItem != newDetailItem) {
        
        NSLog(@"before edit set");
        _detailItem = newDetailItem;
        
        NSLog(@"is editing");
        self.isEditing = TRUE;
        // Update the view.
      [self configureView];
    }
}
#pragma mark - Managing the managedobjectcontext item

- (void)setManagedObjectContext:(NSManagedObjectContext *)newcontext
{
    if (_managedObjectContext != newcontext) {
        _managedObjectContext = newcontext;
        
    }
}

- (void)configureView
{

    // Update the user interface for the detail item.
    if (self.editing) {
      _meetName.text = [_detailItem valueForKey:@"meetName"];
      
      
      self.ceventLimitStepper.value = [[_detailItem valueForKey:@"cEventLimit"] intValue];
      
     self.cEventLimitLabel.text = [[_detailItem valueForKey:@"cEventLimit"]description];
      
      
      
      self.meetDate.date = [_detailItem valueForKey:@"meetDate"];
      
      
      // maxcomp
           
     self.maxCompPerTeamLabel.text = [[_detailItem valueForKey:@"competitorsPerTeam"]description];

 
      self.maxCompPerTeamStepper.value = [[_detailItem valueForKey:@"competitorPerTeam"] intValue];
      
      //maxScoringcomp
      
      self.maxScoringCompPerTeamLabel.text = [[_detailItem valueForKey:@"maxScoringCompetitors"]description];
      
      self.maxScoringCompPerTeamStepper.value = [[_detailItem valueForKey:@"maxScoringCompetitors"] intValue];
      
     
      
      
      //firstplacescore
      
      self.firstPlaceScoreLabel.text = [[_detailItem valueForKey:@"scoreForFirstPlace"]description];
      
      self.firstPlaceScoreStepper.value = [[_detailItem valueForKey:@"scoreForFirstPlace"] intValue];
      
      
      //reductionPerplace
      
      self.reductionPerPlaceLabel.text = [[_detailItem valueForKey:@"decrementPerPlace"]description];
      
      self.reductionPerPlaceStepper.value = [[_detailItem valueForKey:@"decrementPerPlace"] intValue];
      
      
      //ScoreMultiplier
      
      self.scoreMultiplierLabel.text = [[_detailItem valueForKey:@"scoreMultiplier"]description];
      
      self.scoreMultiplierStepper.value = [[_detailItem valueForKey:@"scoreMultiplier"] intValue];
      
      
   }
   else
   {
   
   NSLog(@"/////////////////////////////////");
   NSLog(@"/////////////////////////////////");
   NSLog(@"/////////////////////////////////");
   NSLog(@"/////////////////////////////////");
   NSLog(@"/////////////////////////////////");
   
   
        self.ceventLimitStepper.value = 0;
        self.cEventLimitLabel.text = @"0";
   
        // maxcomp
       
        self.maxCompPerTeamLabel.text = @"2";

 
        self.maxCompPerTeamStepper.value = 2;
      
        //maxScoringcomp
      
        self.maxScoringCompPerTeamLabel.text = @"2";
      
        self.maxScoringCompPerTeamStepper.value = 2;
      
     
      
      
        //firstplacescore
      
        self.firstPlaceScoreLabel.text = @"0";
      
        self.firstPlaceScoreStepper.value = 0;
      
      
        //reductionPerplace
      
        self.reductionPerPlaceLabel.text = @"1";
      
        self.reductionPerPlaceStepper.value = 1;
      
      
        //ScoreMultiplier
      
        self.scoreMultiplierLabel.text = @"1";
      
        self.scoreMultiplierStepper.value = 1;
   
   
   }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self.meetName becomeFirstResponder];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [_meetName setDelegate:self];
   
    [self configureView];
   
 
       UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    NSLog(@"close keyboard?");
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
   
   NSLog(@"beginedtiting");
    self.currentResponder = textField;
    self.isOnTextField = true;
}

- (void)resignOnTap:(id)iSender {
   
    NSLog(@"resign on tap");
    if (_isOnTextField) {
      self.isOnTextField = false;
      [self.currentResponder resignFirstResponder];
    }
    
}


 
    
 /*


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self.meetName becomeFirstResponder];
    }
    
    
}

*/

- (IBAction)cEventLimitStepperValueChanged:(UIStepper *)sender
{
  NSUInteger value = sender.value;
  self.cEventLimitLabel.text = [NSString stringWithFormat:@"%@",@(value)];
 
}

- (IBAction)maxCompPerTeamStepperValueChanged:(UIStepper *)sender {
  NSUInteger value = sender.value;
  self.maxCompPerTeamLabel.text = [NSString stringWithFormat:@"%@",@(value)];
 
}
- (IBAction)maxScoringCompPerTeamStepperValueChanged:(UIStepper *)sender {
  NSUInteger value = sender.value;
  self.maxScoringCompPerTeamLabel.text = [NSString stringWithFormat:@"%@",@(value)];
 

}
- (IBAction)firstPlaceScoreStepperValueChanged:(UIStepper *)sender {
  NSUInteger value = sender.value;
  self.firstPlaceScoreLabel.text = [NSString stringWithFormat:@"%@",@(value)];
 

}
- (IBAction)reductionPerPlaceStepperValueChanged:(UIStepper *)sender {
  NSUInteger value = sender.value;
  self.reductionPerPlaceLabel.text = [NSString stringWithFormat:@"%@",@(value)];
 

}
- (IBAction)scoreMultiplierStepperValueChanged:(UIStepper *)sender {
  NSUInteger value = sender.value;
  self.scoreMultiplierLabel.text = [NSString stringWithFormat:@"%@",@(value)];
 

}
@end
