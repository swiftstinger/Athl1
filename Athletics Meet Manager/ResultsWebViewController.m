//
//  ResultsWebViewController.m
//  Athletics Meet Manager
//
//  Created by Ailsa Huysamen on 31/10/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "ResultsWebViewController.h"

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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableString *mutableHTML = [NSMutableString stringWithString:@""];
    
    
    // Bumf
    
    [mutableHTML appendString:@"<html><head> <meta name=Title content=""> <meta name=Keywords content=""> <meta http-equiv=Content-Type content=\"text/html; charset=macintosh\"> <meta name=ProgId content=Excel.Sheet> <meta name=Generator content=\"Microsoft Excel 14\"> <link rel=File-List href=\"Table_files/filelist.xml\"> <style> <!--table {mso-displayed-decimal-separator:\"\.\"; mso-displayed-thousand-separator:\"\,\";} @page {margin:.75in .7in .75in .7in; mso-header-margin:.3in; mso-footer-margin:.3in;} .font5 {color:windowtext; font-size:24.0pt; font-weight:400; font-style:normal; text-decoration:none; font-family:Impact, sans-serif; mso-font-charset:0;} .font6 {color:windowtext; font-size:24.0pt; font-weight:400; font-style:normal; text-decoration:none; font-family:Impact, sans-serif; mso-font-charset:0;} .style0 {mso-number-format:General; text-align:general; vertical-align:bottom; white-space:nowrap; mso-rotate:0; mso-background-source:auto; mso-pattern:auto; color:windowtext; font-size:10.0pt; font-weight:400; font-style:normal; text-decoration:none; font-family:Arial, sans-serif; mso-font-charset:0; border:none; mso-protection:locked visible; mso-style-name:Normal; mso-style-id:0;} td {mso-style-parent:style0; padding:0px; mso-ignore:padding; color:windowtext; font-size:10.0pt; font-weight:400; font-style:normal; text-decoration:none; font-family:Arial, sans-serif; mso-font-charset:0; mso-number-format:General; text-align:general; vertical-align:bottom; border:none; mso-background-source:auto; mso-pattern:auto; mso-protection:locked visible; white-space:nowrap; mso-rotate:0;} .xl66 {mso-style-parent:style0; font-size:24.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:none; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext; white-space:normal;} .xl67 {mso-style-parent:style0; font-size:24.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:none; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext; white-space:normal;} .xl68 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext; background:#00B0F0; mso-pattern:black none; white-space:normal;} .xl69 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; background:#00B0F0; mso-pattern:black none; white-space:normal;} .xl70 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext; background:#7030A0; mso-pattern:black none; white-space:normal;} .xl71 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; background:#7030A0; mso-pattern:black none; white-space:normal;} .xl72 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext; background:red; mso-pattern:black none; white-space:normal;} .xl73 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; white-space:normal;} .xl74 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; background:red; mso-pattern:black none; white-space:normal;} .xl75 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext; background:#92D050; mso-pattern:black none; white-space:normal;} .xl76 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; background:#92D050; mso-pattern:black none; white-space:normal;} .xl77 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext; background:yellow; mso-pattern:black none; white-space:normal;} .xl78 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; background:yellow; mso-pattern:black none; white-space:normal;} .xl79 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:none; white-space:normal;} .xl80 {mso-style-parent:style0; color:red; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:none; white-space:normal;} .xl81 {mso-style-parent:style0; color:fuchsia; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:none; white-space:normal;} .xl82 {mso-style-parent:style0; color:blue; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:none; white-space:normal;} .xl83 {mso-style-parent:style0; color:#FF6600; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:none; white-space:normal;} .xl84 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border:1.0pt solid windowtext; white-space:normal;} .xl85 {mso-style-parent:style0; font-size:18.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle;} .xl86 {mso-style-parent:style0; font-size:24.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; white-space:normal;} .xl87 {mso-style-parent:style0; font-size:24.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border:.5pt solid windowtext; white-space:normal;} .xl88 {mso-style-parent:style0; font-size:18.0pt; text-decoration:underline; text-underline-style:single; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle;} .xl89 {mso-style-parent:style0; color:red; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; white-space:normal;} .xl90 {mso-style-parent:style0; color:red; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; white-space:normal;} .xl91 {mso-style-parent:style0; color:red; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext; white-space:normal;} .xl92 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; white-space:normal;} .xl93 {mso-style-parent:style0; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext; white-space:normal;} .xl94 {mso-style-parent:style0; color:#FF6600; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; white-space:normal;} .xl95 {mso-style-parent:style0; color:#FF6600; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; white-space:normal;} .xl96 {mso-style-parent:style0; color:#FF6600; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext; white-space:normal;} .xl97 {mso-style-parent:style0; color:blue; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; white-space:normal;} .xl98 {mso-style-parent:style0; color:blue; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; white-space:normal;} .xl99 {mso-style-parent:style0; color:blue; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext; white-space:normal;} .xl100 {mso-style-parent:style0; color:fuchsia; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:1.0pt solid windowtext; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; white-space:normal;} .xl101 {mso-style-parent:style0; color:fuchsia; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:none; border-left:1.0pt solid windowtext; white-space:normal;} .xl102 {mso-style-parent:style0; color:fuchsia; font-size:14.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border-top:none; border-right:1.0pt solid windowtext; border-bottom:1.0pt solid windowtext; border-left:1.0pt solid windowtext; white-space:normal;} .xl103 {mso-style-parent:style0; font-size:24.0pt; font-family:Impact, sans-serif; mso-font-charset:0; text-align:center; vertical-align:middle; border:.5pt solid windowtext; background:#92D050; mso-pattern:black none; white-space:normal;} --> </style> </head><body link=blue vlink=purple>"];
    [mutableHTML appendString:@"<table border=0 cellpadding=0 cellspacing=0 width="];
    
   // NSString* maxwidth = @"879";
   // NSString* span = @"12";
    
    int divnumber = self.meetObject.divisions.count;
    
    int maxwidthint = ((divnumber*66)+200)*2;
    
    NSString* maxwidth = [NSString stringWithFormat:@"%d",maxwidthint];
    NSString* span = [NSString stringWithFormat:@"%d",divnumber];
    
    NSLog(@"width %@ span %@ divnumber %d maxint %d",maxwidth,span, divnumber, maxwidthint);
    
    [mutableHTML appendString:maxwidth];
    [mutableHTML appendString:@" style='border-collapse: collapse;table-layout:fixed;width:"];
    [mutableHTML appendString:maxwidth];
    [mutableHTML appendString:@"pt'> <col width=87 style='mso-width-source:userset;mso-width-alt:3712;width:87pt'> <col width=66 span="];
    
    [mutableHTML appendString:span];
    [mutableHTML appendString:@" style='mso-width-source:userset;mso-width-alt:2816; width:66pt'> "];
   // [mutableHTML appendString:@" "];
   // [mutableHTML appendString:@" "];
   // [mutableHTML appendString:@" "];
    
    
    
    
    [mutableHTML appendString:@"<tr height=23 style='height:23.0pt'> <td height=23 width=87 style='height:23.0pt;width:87pt'></td>"];
    /// meet info at top = heading
    
     NSString* temp1 = [NSString stringWithFormat: @"%@ %@",self.meetObject.meetName,self.meetObject.meetDate];
    
    NSString* temp2 = [NSString stringWithFormat: @"<td colspan=11 class=xl88 width=726 style='width:726pt'> %@ </td>",temp1];
    
    [mutableHTML appendString:temp2];
    
    /////
    /// DIVS


    [mutableHTML appendString:@"<td width=66 style='width:66pt'></td></tr><tr height=13 style='height:13.0pt'><td height=13 colspan=13 style='height:13.0pt;mso-ignore:colspan'></td></tr><tr height=19 style='height:19.0pt'><td height=19 class=xl84 width=87 style='height:19.0pt;width:87pt'>Team</td>"];
    
    /////
        //// div loop
           for (Division* div in self.meetObject.divisions) {
	
                temp1 = [NSString stringWithFormat:@"<td class=xl83 width=66 style='width:66pt'>%@</td>",div.divName];
                temp2 = [NSString stringWithFormat:@"<td class=xl83 width=66 style='width:66pt'>Position</td>"];
                [mutableHTML appendString:temp1];
                [mutableHTML appendString:temp2];
    
            }
    temp1 = [NSString stringWithFormat:@"<td class=xl79 width=66 style='width:66pt'>TOTAL</td>"];
    temp2 = [NSString stringWithFormat:@"<td class=xl79 width=66 style='width:66pt'>POSITION</td></tr>"];
    [mutableHTML appendString:temp1];
    [mutableHTML appendString:temp2];
  

    /// Divs headings Done
 
    
    /////TEAM RESULTS
    
    for (Team* team in self.meetObject.teams) {
    
        
        [mutableHTML appendString:@"<tr height=13 style='mso-height-source:userset;height:13.5pt'><td height=13 class=xl76 width=87 style='height:13.5pt;width:87pt'>&nbsp;</td>"];
      // temp1 = [NSString stringWithFormat:@"<tr height=13 style='mso-height-source:userset;height:13.5pt'> <td rowspan=3 class=xl89 width=66 style='border-bottom:1.0pt solid black;border-top:none;width:66pt'>%@</td>",team.teamName];
       
      // [mutableHTML appendString:temp1];
   
    
        for (Division* div in self.meetObject.divisions) {
    
            temp1 = [NSString stringWithFormat:@"<td rowspan=3 class=xl94 width=66 style='border-bottom:1.0pt solid black;border-top:none;width:66pt'>%d</td>", 99]; //teamDivScore
            
            temp2 = [NSString stringWithFormat:@"<td rowspan=3 class=xl94 width=66 style='border-bottom:1.0pt solid black;border-top:none;width:66pt'>%d</td>", 11]; //teamDivScore
            
            [mutableHTML appendString:temp1];
            [mutableHTML appendString:temp2];
        }
        temp1 = [NSString stringWithFormat:@"<td rowspan=3 class=xl92 width=66 style='border-bottom:1.0pt solid black;border-top:none;width:66pt'>%d</td>", 400]; //  Total score
            
        temp2 = [NSString stringWithFormat:@"<td rowspan=3 class=xl92 width=66 style='border-bottom:1.0pt solid black;border-top:none;width:66pt'>%d</td>",2]; // Total Pos
            
            [mutableHTML appendString:temp1];
            [mutableHTML appendString:temp2];
    
            [mutableHTML appendString:@"</tr>"];
        //[mutableHTML appendString:@""];
  
        temp1 = [NSString stringWithFormat:@"<tr height=13 style='mso-height-source:userset;height:13.5pt'><td height=13 class=xl76 width=87 style='height:13.5pt;width:87pt;font-size:14.0pt;color:windowtext;font-weight:400;text-decoration:none;text-underline-style:none;text-line-through:none;font-family:Impact;border-top:none;border-right:1.0pt solid windowtext;border-bottom:none;border-left:1.0pt solid windowtext;background:yellow;mso-pattern:black none'>%@</td></tr>",team.teamName];
     // temp2 = [NSString stringWithFormat:@"<tr height=13 style='mso-height-source:userset;height:13.5pt'><td height=13 class=xl76 width=87 style='height:13.5pt;width:87pt'>&nbsp;</td></tr>"];
        [mutableHTML appendString:temp1];
        
        
        
        [mutableHTML appendString:@"<tr height=13 style='mso-height-source:userset;height:13.5pt'><td height=13 class=xl75 width=87 style='height:13.5pt;width:87pt'>&nbsp;</td></tr>"];
        //[mutableHTML appendString:@""];
       
 
    }
 
    
    
    
    [mutableHTML appendString:@"<tr height=36 style='height:36.0pt;mso-xlrowspan:3'><td height=36 colspan=14 style='height:36.0pt;mso-ignore:colspan'></td></tr></table></body></html>"];
   // [mutableHTML appendString:@" "];
    
    
    NSString *myHTML = mutableHTML;
    
    [self.webWiew loadHTMLString:myHTML baseURL:nil];
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
