//
//  AppDelegate.m
//  PitchTracker
//
//  Created by Tanner Young-Schultz on 2016-04-28.
//  Copyright © 2016 UofTBaseball. All rights reserved.
//

#import "AppDelegate.h"
#import "LocalPitcherDatabase.h"
#import "Globals.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
#ifndef RESET_DEFAULT_PITCHER
    [ self startLoadDatabaseThread ];
#endif
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [ self startWriteDatabaseThread ];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [ self startWriteDatabaseThread ];
}

//-----Writing and loading from disk (threaded)-----//
-(void) startWriteDatabaseThread
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ self writeDatabaseThread ];
    });
}

-(void) startLoadDatabaseThread
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [ self loadDatabaseThread ];
    });
}

-(void)writeDatabaseThread
{
    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
    [ database writeDatabaseToDisk ];
}

-(void)loadDatabaseThread
{
    LocalPitcherDatabase *database = [ LocalPitcherDatabase sharedDatabase ];
    [ database loadDatabaseFromDisk ];
}
//--------------------------------------------------//

@end
