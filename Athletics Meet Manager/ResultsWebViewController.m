//
//  ResultsWebViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 31/10/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "ResultsWebViewController.h"
#import "FinalResultsViewController.h"
#import "TeamPlacesViewController.h"


@interface ResultsWebViewController ()

@end

@implementation ResultsWebViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)newcontext
{
    if (_managedObjectContext != newcontext) {
        _managedObjectContext = newcontext;
        
    }
}

#pragma mark - Managing the detail item

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        _meetObject = _detailItem;
        // Update the view.
       
      
        
    }
}

- (void) setPlaceForTeamsInMeet: (Meet*) meet {

            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"Team" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];

           NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(teamScore != NULL)", nil];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(meet == %@)", _meetObject];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];
    
    
               NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"teamScore" ascending:NO];

    
                NSArray *sortDescriptors = @[highestToLowest];
    
                [fetchRequest setSortDescriptors:sortDescriptors];


                NSError *error;
                NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    
    int count = 0;
   
    int placing;
    int lastplacegiven = 0;
    
    NSNumber *lastScore = 0;
    NSNumber *currentScore;
    for(Team *object in results) {
       
         currentScore = object.teamScore;
      //  score = score + [currentScore intValue];
        
        if ([currentScore intValue] == [lastScore intValue]) {
            // nslog(@"same lastScore %@ currentScore %@", lastScore,currentScore);
            
            placing = lastplacegiven;
        }
        else
        {
        // nslog(@"not same lastScore %@ currentScore %@", lastScore,currentScore);
        
        placing = count + 1;
        }
        
        count++;
        
        lastplacegiven = placing;
        lastScore = currentScore;
        
        object.teamPlace = [NSNumber numberWithInt:placing];
        
        // nslog(@" team : %@  ranking =  %@  and Points =  %@",object.teamName, object.teamPlace,object.teamScore);
        
       
    }



}

- (void) sumResultsForTeam: (Team*) teamobject
{

  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];

           NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(score != NULL)", nil];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(team == %@)", teamobject];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];
    
    
               NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
                       NSArray *sortDescriptors = @[highestToLowest];
    
                [fetchRequest setSortDescriptors:sortDescriptors];


                NSError *error;
                NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
 
    
    
    int score = 0;

    NSNumber *currentScore;
    for(CEventScore *object in results) {
       
         currentScore = object.score;
        score = score + [currentScore intValue];
        
       }

teamobject.teamScore = [NSNumber numberWithInt:score];
// nslog(@" team : %@ score set at %@", teamobject.teamName,teamobject.teamScore);

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.delegate = self;
    
    
    for (Team *object in _meetObject.teams) {
        
        [self sumResultsForTeam:object];
    
    
    }
    
    for (Team *object in _meetObject.teams) {
        
        [self sumResultsForTeam:object];
    
    
    }
    
    [self setPlaceForTeamsInMeet:_meetObject];
    
    NSMutableString *mutableHTML = [NSMutableString stringWithString:@""];
   

    
//// Calculations //////

int fullspannumber = self.meetObject.teams.count +1;


    
    
    // Bumf
[mutableHTML appendString:@"<html> <head>"];
//[mutableHTML appendString:@"<style> <!--table {} @page {margin:.75in .7in .75in .7in; }"];
[mutableHTML appendString:@"<style> <!--table {} @page {margin:.01in .01in .01in .01in; }"];
[mutableHTML appendString:@"td { padding:0px; mso-ignore:padding; color:windowtext; font-size:10.0pt; font-weight:700; font-style:normal; text-decoration:none; white-space:nowrap; font-family:Garamond, serif; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext;; white-space:normal; width:136pt; height:19pt } --> </style>"];

[mutableHTML appendString:@"</head><body>"];

[mutableHTML appendString:@"<table border=0 cellpadding=0 cellspacing=0  style='border-collapse: collapse;'><tr  style='height:59.25pt'> "];
//[mutableHTML appendString:@"<table border=0 cellpadding=0 cellspacing=0  style='border-collapse: collapse;'><tr  style='height:30pt'> "];

[mutableHTML appendString:@"<td colspan="];
[mutableHTML appendFormat:@"%d",fullspannumber]; //columbs
 [mutableHTML appendString:@" style='font-size:28.0pt;'>"];
 
 // Meet Name and Date
 
 /*
NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
[dateFormat setDateFormat:@"yyyy-MM-dd"];

NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
[timeFormat setDateFormat:@"HH:mm:ss"];

//NSDate *date = [[NSDate alloc] init];
NSDate *date = self.meetObject.meetDate;

NSString *theDate = [dateFormat stringFromDate:date];
//NSString *theTime = [timeFormat stringFromDate:date];




 
 [mutableHTML appendFormat:@"%@  %@",self.meetObject.meetName,theDate];
 */
 
 [mutableHTML appendFormat:@"%@",self.meetObject.meetName];
 
 //
 [mutableHTML appendString:@"</td> </tr><tr style='height:26.25pt'> "];
 [mutableHTML appendString:@"<td colspan="];
  [mutableHTML appendFormat:@"%d",fullspannumber]; //columbs
  [mutableHTML appendString:@" "];
[mutableHTML appendString:@"style='font-size:20.0pt'>"];
[mutableHTML appendString:@"OVERALL TOTALS"];
[mutableHTML appendString:@"</td>"];
[mutableHTML appendString:@"</tr> <tr > <td style='font-size:16.0pt'>"];
[mutableHTML appendString:@"DIVISION"];
[mutableHTML appendString:@"</td>"];

for (Team* team in [self.meetObject.teams sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"teamID" ascending:YES]]]) {


 [mutableHTML appendString:@"<td style='font-size:20.0pt'>"];
 [mutableHTML appendFormat:@"%@",team.teamName];
 [mutableHTML appendString:@"</td>"];
 
 
 }
 [mutableHTML appendString:@"</tr>"];
 
 
 
 for (Division* div in [self.meetObject.divisions sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"divID" ascending:YES]]]) {
	
    [mutableHTML appendString:@"<tr > <td style='font-size:16.0pt' >"];
    [mutableHTML appendFormat:@"%@",div.divName];
    [mutableHTML appendString:@"</td>"];
     
     NSMutableArray* scoreArray = [[NSMutableArray alloc]init];
     NSMutableDictionary* nameDict = [[NSMutableDictionary alloc] init];
        for (Team* team in [self.meetObject.teams sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"teamID" ascending:YES]]]) {


            [mutableHTML appendString:@"<td style='color:blue;font-size:16.0pt'>"];
            NSNumber* numberInt = [NSNumber numberWithInt: [self sumResultsForTeam:team AndDiv:div]];
            [mutableHTML appendFormat:@"%@",numberInt];
            [mutableHTML appendString:@"</td>"];
            
            [scoreArray addObject:numberInt];
            [nameDict setObject:numberInt forKey:team.teamName];
            
 
        }
     
        [mutableHTML appendString:@" </tr>"];
     /**
     
            spare outfits 2
     vest long top leggings cardy
     
     slippers
     
     outfit for tomorrow
     
     sleepingbag
     
     light on
     
     book
     
     
     **/
     
 /// Place
 [mutableHTML appendString:@"<tr> <td style='font-size:16.0pt' >"];
// [mutableHTML appendString:@"<tr style='height:10pt'> <td style='font-size:12.0pt; height:16pt' >"];
 [mutableHTML appendString:@"Rank"];
 [mutableHTML appendString:@"</td>"];
     
     
        int counter;
     
     
        for (Team* team in [self.meetObject.teams sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"teamID" ascending:YES]]]) {
            
            NSNumber* tempnumber = [nameDict objectForKey:team.teamName];
            NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
            NSArray*sortArray = [NSArray arrayWithObject:highestToLowest];
            [scoreArray sortUsingDescriptors:sortArray];
            counter = 0;
            NSNumber* scorenumber = scoreArray[counter];
            
            
            while (tempnumber != scorenumber) {
                counter++;
                scorenumber = scoreArray[counter];
            }
            
            [mutableHTML appendString:@"<td style='color:blue;font-size:16.0pt'>"];
          //  [mutableHTML appendString:@"<td style='color:blue;font-size:12.0pt; height:16pt'>"];
            NSNumber* numberInt = [NSNumber numberWithInt: counter+1];
            [mutableHTML appendFormat:@"%@",numberInt];
            [mutableHTML appendString:@"</td>"];
 
        }
        [mutableHTML appendString:@" </tr>"];
     
     
     

  
     

}
 
 // Event
 

  
  /// Final Total
  
  [mutableHTML appendString:@"<tr style='height:24pt'> <td style='font-size:20.0pt'>"];
  [mutableHTML appendString:@"TOTAL"];
  [mutableHTML appendString:@"</td>"];
  
 for (Team* team in [self.meetObject.teams sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"teamID" ascending:YES]]])
    {
        

            [mutableHTML appendString:@"<td style='color:blue;font-size:16.0pt'>"];
            NSNumber* numberInt = team.teamScore;
            [mutableHTML appendFormat:@"%@",numberInt];
            [mutableHTML appendString:@"</td>"];
 
 
        }
        [mutableHTML appendString:@" </tr>"];
//26.25
  
 
 [mutableHTML appendString:@"<tr style='height:24pt'> <td style='font-size:20.0pt'>"];
   [mutableHTML appendString:@"POSITION"];
  [mutableHTML appendString:@"</td>"];
  
  
 for (Team* team in [self.meetObject.teams sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"teamID" ascending:YES]]]) {


            [mutableHTML appendString:@"<td style='color:blue;font-size:16.0pt'>"];
            NSNumber* numberInt = team.teamPlace;
            [mutableHTML appendFormat:@"%@",numberInt];
            [mutableHTML appendString:@"</td>"];
 
 
        }
        [mutableHTML appendString:@" </tr>"];


  [mutableHTML appendString:@"</table></body></html>"];


    NSString *myHTML = mutableHTML;
  //  NSLog(@"%@",myHTML);
  
  self.htmlString = myHTML;
    [self.webWiew loadHTMLString:myHTML baseURL:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (int) sumResultsForTeam: (Team*) teamobject AndDiv: (Division*) divobject
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];

           NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(score != NULL)", nil];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(team == %@)", teamobject];
            NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"(event.division == %@)", divobject];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2,pred3, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];
    
    
               NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
                       NSArray *sortDescriptors = @[highestToLowest];
    
                [fetchRequest setSortDescriptors:sortDescriptors];


                NSError *error;
                NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
 
    
    
    int score = 0;

    NSNumber *currentScore;
    for(CEventScore *object in results) {
       
         currentScore = object.score;
        score = score + [currentScore intValue];
        
       }


 return score;



}
- (int) getPlaceForTeam: (Team*) teamobject AndDiv: (Division*) divobject
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
            NSEntityDescription *description = [NSEntityDescription entityForName:@"CEventScore" inManagedObjectContext: self.managedObjectContext];

            [fetchRequest setEntity:description];

           NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"(score != NULL)", nil];
            NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"(team == %@)", teamobject];
            NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"(event.division == %@)", divobject];
            NSArray *preds = [NSArray arrayWithObjects: pred1,pred2,pred3, nil];
            NSPredicate *andPred = [NSCompoundPredicate andPredicateWithSubpredicates:preds];

            [fetchRequest setPredicate:andPred];
    
    
               NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"score" ascending:NO];
                       NSArray *sortDescriptors = @[highestToLowest];
    
                [fetchRequest setSortDescriptors:sortDescriptors];


                NSError *error;
                NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
 
    
    
    int score = 0;

    NSNumber *currentScore;
    for(CEventScore *object in results) {
       
         currentScore = object.score;
        score = score + [currentScore intValue];
        
       }


 return score;



}




- (IBAction)ActionButtonPressed:(UIBarButtonItem *)sender {


    
         UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"MeetResults";
        printInfo.orientation = UIPrintInfoOrientationLandscape;
    
        UIViewPrintFormatter *formatter = [self.webWiew viewPrintFormatter];
    
            self.formatter = formatter;
            self.printInfo = printInfo;
   
                NSLog(@"started");
            self.htmlPdfKit = [[BNHtmlPdfKit alloc] init];
            self.htmlPdfKit.delegate = self;
            [self.htmlPdfKit saveHtmlAsPdf:self.htmlString];
    

}
- (void)htmlPdfKit:(BNHtmlPdfKit *)htmlPdfKit didSavePdfData:(NSData *)data {

        NSLog(@"in delegate");
    
    
        NSArray *activityItems = @[self.printInfo, self.formatter, data];
    
    
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    
        


        if ( [activityController respondsToSelector:@selector(popoverPresentationController)] ) {
            // iOS8
            activityController.popoverPresentationController.barButtonItem = self.ActionButton;
        }


         [self presentViewController:activityController animated:YES completion:nil];
         
    
}
- (void)htmlPdfKit:(BNHtmlPdfKit *)htmlPdfKit didFailWithError:(NSError *)error {
  NSLog(@"PDF Error");
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UINavigationController *)viewController{
    if ([viewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navController = (UINavigationController *) viewController;
        NSLog(@"helloooooooooo");
        
        UIViewController *resultsViewController = [navController topViewController];
        
        
        
        if ([resultsViewController isKindOfClass:[FinalResultsViewController class]]) {
           FinalResultsViewController* resultsController = (FinalResultsViewController*)resultsViewController;
           [resultsController setDetailItem:self.meetObject];
        [resultsController setManagedObjectContext:self.managedObjectContext];
        }
        else
        {
            if ([resultsViewController isKindOfClass:[TeamPlacesViewController class]]) {
                
                NSLog(@"resultsViewControllerMaster");
                TeamPlacesViewController* resultsController = (TeamPlacesViewController*)resultsViewController;
                [resultsController setDetailItem:self.meetObject];
                [resultsController setManagedObjectContext:self.managedObjectContext];

            }
            
        }
        
        
        /*
        FinalResultsViewController* resultsController = (FinalResultsViewController*)[navController topViewController];
        */
        
        
        
   
    
    }
    
    
    return TRUE;
}

@end
