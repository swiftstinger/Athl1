//
//  AppDelegate.m
//  Athletics Meet Manager
//
//  Created by Rudi Huysamen on 22/05/2015.
//  Copyright (c) 2015 rudi huysamen. All rights reserved.
//

#import "AppDelegate.h"
//#import "SetupDivViewController.h"
//#import "MeetMenuViewController.h"
#import "MasterViewController.h"
#import "Meet.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MasterViewController *controller = (MasterViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "swiftstinger.Athletics_Meet_Manager" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Athletics_Meet_Manager" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSDictionary *options = @{
NSMigratePersistentStoresAutomaticallyOption : @YES,
NSInferMappingModelAutomaticallyOption : @YES
};
   
    
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Athletics_Meet_Manager.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
       // abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            // nslog(@"Unresolved error %@, %@", error, [error userInfo]);
           // abort();
        }
        else
        {
            
      
     

        }
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (url){
        NSString *path = [url path];
        NSString *extension = [path pathExtension];
        NSLog(@"extention: %@",extension);
        if ([extension isEqualToString:@"ammp"]) {
    
              NSString *newStr = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
             // NSData *data = [NSData dataWithContentsOfURL:url];
             // NSLog(@" this data %@", data);
              
             // NSString* newStr = [NSString stringWithUTF8String:[data bytes]];
              
             NSLog(@"The file contained onlineID: %@",newStr);
                
               
            
                Meet *meet;
            
                meet = [NSEntityDescription insertNewObjectForEntityForName:@"Meet" inManagedObjectContext:self.managedObjectContext];
            
                [meet setValue: @"NewOnlineMeet" forKey:@"meetName"];
            
                [meet setValue: [NSNumber numberWithBool:YES] forKey:@"onlineMeet"];
            
                [meet setValue: [NSNumber numberWithBool:NO] forKey:@"isOwner"];

            
                [meet setValue: newStr forKey: @"onlineID"];

                NSLog(@"new meet set with onlineID onlineID: %@", meet.onlineID);
            
            
            
                [self saveContext];
              
              
                
                
                 NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                    [center postNotification:[NSNotification notificationWithName:@"importedMeet" object:nil]];
                      
                        UINavigationController *navigationController = (UINavigationController  *)self.window.rootViewController;
                    [navigationController popToRootViewControllerAnimated:YES];
                   
                   
                   

                   
                   
                   
                    NSLog(@"hello here tooo");
        } // is ammp
        else
        {
            NSLog(@"imported, is not ammp");
            if ([extension isEqualToString:@"csv"]) {
                 NSLog(@"imported, is csv");
                
                NSString *list = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
               NSLog(@"list1: %@", list);
               //  list = [list stringByReplacingOccurrencesOfString:@"\r" withString:@""];
               NSArray *csvItems = [list componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                //NSArray *csvItems = [list componentsSeparatedByString:@"\n"];
                self.csvDataArray = csvItems;
                
                NSMutableArray* mutableArrayOfStrings = [self.csvDataArray mutableCopy];
                
                [mutableArrayOfStrings removeObject:@""];
                
                self.csvDataArray = [mutableArrayOfStrings copy];
                
                NSLog(@"list2: %@", list);
               NSLog(@"csv: %@", csvItems);
                
                for (NSString* string in self.csvDataArray) {
                    NSLog(@"string: %@", string);
                    
                   
                }
               
                
                
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                    [center postNotification:[NSNotification notificationWithName:@"importedCsv" object:nil]];
                      
                UINavigationController *navigationController = (UINavigationController  *)self.window.rootViewController;
                [navigationController popToRootViewControllerAnimated:YES];
                
            }
            else
            {
                NSLog(@"imported, is not csv");
            }
        }
        
        
        
        
        
        
       // remove directory contents
                    ////
             
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSError *error = nil;
                NSString *newpath = [NSString stringWithFormat:@"%@/Inbox",  documentsPath];
                NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:newpath error:&error];
                if (error == nil) {
                    for (NSString *path in directoryContents)
                    {
                        NSString *fullPath = [newpath stringByAppendingPathComponent:path];
                        BOOL removeSuccess = [fileManager removeItemAtPath:fullPath error:&error];
                        if (!removeSuccess) {
                            // Error handling
                            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                        }
                        else
                        {
                         NSLog(@"deleted file in url");
                        }
                    }
                }
                else
                {
                    // Error handling not url
            
                }
    }
    
   return YES;
}




@end
