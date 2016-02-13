//
//  TeamPlacesViewController.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 19/11/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "FinalResultsViewController.h"
#import "ResultsWebViewController.h"
#import "TeamPlacesViewController.h"


@interface TeamPlacesViewController ()

@end

@implementation TeamPlacesViewController

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
        
       // NSLog(@"teamplacing %d %@", placing, object.teamPlace);
        
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

[self saveContext];

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

//int fullspannumber = (int)self.meetObject.teams.count +1;

int fullspannumber = 3;
    
    
    // Bumf
[mutableHTML appendString:@"<html> <head>"];
//[mutableHTML appendString:@"<style> <!--table {} @page {margin:.75in .7in .75in .7in; }"];
[mutableHTML appendString:@"<style> <!--table {} @page {margin:.01in .01in .01in .01in; }"];
//[mutableHTML appendString:@"td { padding:0px; mso-ignore:padding; color:windowtext; font-size:10.0pt; font-weight:700; font-style:normal; text-decoration:none; white-space:nowrap; font-family:Garamond, serif; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext;; white-space:normal; width:136pt; height:19pt } --> </style>"];
//[mutableHTML appendString:@"td { padding:0px; mso-ignore:padding; color:windowtext; font-size:10.0pt; font-weight:700; font-style:normal; text-decoration:none; white-space:nowrap; font-family:Garamond, serif; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext;; white-space:normal; width:136pt; height:19pt } --> </style>"];
[mutableHTML appendString:@"td { padding:0px; mso-ignore:padding; color:windowtext; font-size:10.0pt; font-weight:700; font-style:normal; text-decoration:none; white-space:nowrap; font-family:\"Lucida Sans Unicode\", \"Lucida Grande\", sans-serif; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext;; white-space:normal; width:136pt; height:19pt } --> </style>"];

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
[mutableHTML appendString:@"</td> </tr><tr style=' height:28.25pt'> "];
[mutableHTML appendString:@"<td colspan="];
[mutableHTML appendFormat:@"%d",fullspannumber]; //columbs
[mutableHTML appendString:@" "];
[mutableHTML appendString:@"style='font-size:20pt'>"];
[mutableHTML appendString:@"RESULTS"];
[mutableHTML appendString:@"</td>"];
[mutableHTML appendString:@"</tr>"];

//int count = 0;

NSNumber* lastteamplace = [NSNumber numberWithInt: 1 ];

NSString* PlaceTeamName = @"";
NSNumber* LastPlaceScore = [NSNumber numberWithInt:0];
NSMutableArray* TeamPlaces = [[NSMutableArray alloc] init];
NSArray* NamePlaceScoreArray;
int placescounter = 0;

for (Team* team in [self.meetObject.teams sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"teamScore" ascending:NO]]]) {
    
    NSLog(@"1");
    NSLog(@"place %@ lastplace %@",team.teamPlace, lastteamplace );
    
    if ([team.teamPlace intValue] == [lastteamplace intValue]) {
    NSLog(@"2");
        PlaceTeamName = [NSString stringWithFormat:@"%@ %@",PlaceTeamName, team.teamName];
        LastPlaceScore = team.teamScore;
    }
    else
    {
        NSLog(@"3");
        NamePlaceScoreArray = @[PlaceTeamName,lastteamplace, LastPlaceScore];
        [TeamPlaces addObject:NamePlaceScoreArray];
        placescounter ++;
        PlaceTeamName = team.teamName;
        lastteamplace = team.teamPlace;
        LastPlaceScore = team.teamScore;
        
    }
    
}
NSLog(@"4");
        NamePlaceScoreArray = @[PlaceTeamName,lastteamplace, LastPlaceScore];
        [TeamPlaces addObject:NamePlaceScoreArray];
        placescounter ++;
/**

for (Team* team in [self.meetObject.teams sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"teamScore" ascending:NO]]]) {
count++;
**/

for (int i = 0; i < placescounter; i++) {


/**

if ([team.teamScore intValue] == [lastteamscore intValue]) {
    
     NSLog(@"same %d %d", [team.teamScore intValue], [lastteamscore intValue]);
    PlaceTeamName = [NSString stringWithFormat:@"%@ %@",PlaceTeamName, team.teamName];
    
}
else
{
   PlaceTeamName = team.teamName;
    NSLog(@"not same");
    NSLog(@"same %d %d", [team.teamScore intValue], [lastteamscore intValue]);
}
lastteamscore = team.teamScore;

**/

// teamplace score
NamePlaceScoreArray = TeamPlaces[i];

NSLog(@"team name %@ place %@ score %@", NamePlaceScoreArray[0],NamePlaceScoreArray[1],NamePlaceScoreArray[2]);


[mutableHTML appendString:@" <tr >"];
[mutableHTML appendString:@"<td style='width:136pt; height:40pt; font-size:20.0pt'>"];
[mutableHTML appendFormat:@"%@",NamePlaceScoreArray[1]];

if ([NamePlaceScoreArray[1] intValue] == 1) {
    [mutableHTML appendString:@"<sup>st</sup>"];
}
else if ([NamePlaceScoreArray[1] intValue] == 2){
[mutableHTML appendString:@"<sup>nd</sup>"];
}
else if ([NamePlaceScoreArray[1] intValue] == 3){

[mutableHTML appendString:@"<sup>rd</sup>"];
}
else
{
[mutableHTML appendString:@"<sup>th</sup>"];

}



[mutableHTML appendString:@"</td>"];
[mutableHTML appendString:@"<td style='color:blue; width:680pt; height:40pt; font-size:20.0pt; border-right:none'>"];
[mutableHTML appendFormat:@"%@",NamePlaceScoreArray[0]];
[mutableHTML appendString:@"</td>"];
[mutableHTML appendString:@"<td style='width:136pt; height:40pt; font-size:20.0pt; border-left:none'>"];
//[mutableHTML appendFormat:@"%@",team.teamName];
[mutableHTML appendString:@"</td>"];
[mutableHTML appendString:@"</tr>"];
 
}
 
 
/*
 
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
*/

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
        
        UIViewController *resultsViewController = [navController topViewController];
        
        
        
        if ([resultsViewController isKindOfClass:[FinalResultsViewController class]]) {
           FinalResultsViewController* resultsController = (FinalResultsViewController*)resultsViewController;
           [resultsController setDetailItem:self.meetObject];
        [resultsController setManagedObjectContext:self.managedObjectContext];
        }
        else
        {
            if ([resultsViewController isKindOfClass:[TeamPlacesViewController class]]) {
                
                TeamPlacesViewController* resultsController = (TeamPlacesViewController*)resultsViewController;
                [resultsController setDetailItem:self.meetObject];
                [resultsController setManagedObjectContext:self.managedObjectContext];

            }
            
            if ([resultsViewController isKindOfClass:[ResultsWebViewController class]]){
                ResultsWebViewController *resultsController = (ResultsWebViewController *) resultsViewController;
        
                [resultsController setDetailItem:self.meetObject];
                [resultsController setManagedObjectContext:self.managedObjectContext];
            }
            
            /*
            
            if ([resultsViewController isKindOfClass:[TeamPlacesViewController class]]) {
                
                NSLog(@"resultsViewControllerMaster");
                TeamPlacesViewController* resultsController = (TeamPlacesViewController*)resultsViewController;
                [resultsController setDetailItem:self.meetObject];
                [resultsController setManagedObjectContext:self.managedObjectContext];

            }
            if ([resultsViewController isKindOfClass:[TeamPlacesViewController class]]) {
                
                NSLog(@"resultsViewControllerMaster");
                TeamPlacesViewController* resultsController = (TeamPlacesViewController*)resultsViewController;
                [resultsController setDetailItem:self.meetObject];
                [resultsController setManagedObjectContext:self.managedObjectContext];

            }

            */
            
        }
        

    }
    
    
    return TRUE;
}
- (void) saveContext {


NSError *error = nil;

        // Save the context.
        
            if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
            //abort();
            }
    

}

@end
