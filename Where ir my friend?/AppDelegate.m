//
//  AppDelegate.m
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


@synthesize locationManager;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:10.0/256.0 green:145.0/10.0 blue:35.0/256.0 alpha:1.0]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults stringForKey:@"id"];
    if (user){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"tabbar"];
        self.window.rootViewController= viewController;
    }
    
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    // or set runtime properties here.
    UAConfig *config = [UAConfig defaultConfig];
    
    // You can also programmatically override the plist values:
    // config.developmentAppKey = @"YourKey";
    // etc.
    
    // Call takeOff (which creates the UAirship singleton)
    [UAirship takeOff:config];

    // Request a custom set of notification types
    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert |
                                         UIRemoteNotificationTypeNewsstandContentAvailability);

//    [UAPush shared].autobadgeEnabled = YES;
    
    //[UAPush shared].autobadgeEnabled=YES;
    if (launchOptions)
    {
        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
            NSLog(@"Launched from push notification: %@", dictionary);
            
            [self clearNotifications];
        }
    }
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    locationManager.pausesLocationUpdatesAutomatically= NO;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [locationManager setDistanceFilter:10];
    

    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults stringForKey:@"id"];
    if (user){
        [locationManager startUpdatingLocation];
        NSLog(@"entre al background");
    }

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *user = [defaults stringForKey:@"id"];
////    if (user){
////        [locationManager stopUpdatingLocation];
////        NSLog(@"sali del background");
////    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        
        
        NSLog(@"Response: %8F", currentLocation.coordinate.longitude);
        NSLog(@"Response: %8F", currentLocation.coordinate.latitude);
        //ACA MANDO AL SERVIDOR
        [self performSelectorInBackground:@selector(locationInBackground:) withObject:currentLocation];
        //creo el JSON
    }
    
}

-(void)locationInBackground:(CLLocation*)currentLocation{
    
    if ([BackendProxy internetConnection]){
        
        NSString *longit=[NSString stringWithFormat:@"%1.6f",currentLocation.coordinate.longitude ];
        NSString *latit=[NSString stringWithFormat:@"%1.6f",currentLocation.coordinate.latitude ];
        
        [BackendProxy setLocation:longit :latit];
    }
}

- (void) clearNotifications {
    [[UAPush shared] resetBadge];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if ([BackendProxy internetConnection]){
        [BackendProxy resetBadgeCount];
    }

}


- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
//    if ([string rangeOfString:@"bla"].location == NSNotFound) {

    NSLog(@"Received notification: %@", userInfo);
//    [userInfo objectForKey:@"aps"] objectForKey:@""
    [self clearNotifications];
    
    
    //[UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badge"] intValue];

    
}



@end
