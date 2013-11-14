//
//  FirstViewController.m
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import "MapViewController.h"
#import "BackendProxy.h"
#import "AppDelegate.h"

@interface MapViewController ()

@end

@implementation MapViewController
{
    
    NSArray * jsonFriends;
    NSTimer * timer,*timer2;
    
}
@synthesize mapView,locationManager;

-(void)viewWillAppear:(BOOL)animated{
}

-(void) viewDidLoad{
    mapView.showsUserLocation = YES;
    //mapView.delegate = self;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
//    UITabBarItem *tbi = (UITabBarItem*)[[[self.tabBarController tabBar] items] objectAtIndex:2];
//    
//    [tbi setBadgeValue:@"1"];
    
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    [locationManager setDistanceFilter:50];
    [locationManager startUpdatingLocation];
    
    AppDelegate * ap = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    ap.habiaConexion=YES;

    timer = [NSTimer scheduledTimerWithTimeInterval:10
                                             target:self
                                           selector:@selector(targetMethod:)
                                           userInfo:nil
                                            repeats:YES];
    [self targetMethod:(NSTimer *) timer];
    
}


-(void) targetMethod: (NSTimer *) theTimer {
    NSLog(@"10 segundos!!!!");
    mapView.showsUserLocation = YES;
    AppDelegate * ap = (AppDelegate *) [[UIApplication sharedApplication] delegate];
   
    if ([BackendProxy internetConnection]){
        [mapView removeAnnotations:mapView.annotations];
        ap.habiaConexion=YES;
       
        [self performSelectorInBackground:@selector(actualizarMapaEnBack) withObject:nil];
        

        
    }else{ if (ap.habiaConexion){
            //si no hay conexion con el server
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", nil) message:NSLocalizedString(@"No Internet Connection App", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
            [alert show];
            ap.habiaConexion=NO;
            }
        }
    
}

-(void)actualizarMapaEnBack{
    jsonFriends = [BackendProxy GetLastFriendsLocationsById];
    
    [self performSelectorOnMainThread:@selector(finishUpdateMap) withObject:nil waitUntilDone:YES];
    
}

-(void)finishUpdateMap{
    NSDictionary * data;
    
    int cant= [jsonFriends count];
    
    CLLocationCoordinate2D  points[cant];
    
    for(int i=0; i<[jsonFriends count];i++)
    {
        data= [jsonFriends objectAtIndex:i];
        points[i].latitude = [[data objectForKey:@"Latitude"] floatValue];
        points[i].longitude = [[data objectForKey:@"Longitude"] floatValue];
        
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = points[i];
        annotationPoint.title = [data objectForKey:@"Name"];
        [mapView addAnnotation:annotationPoint];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//clocationmanagerdelegate
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

- (IBAction)centerMapOnUserButtonClicked:(id)sender {
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
}

-(IBAction)logoutClicked:(id)sender{
    // Create the action sheet
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                         destructiveButtonTitle:NSLocalizedString(@"Logout", nil)
                                              otherButtonTitles:nil];
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        
        if ([BackendProxy internetConnection]){
            [BackendProxy logout];
        }
        [self performSegueWithIdentifier:@"logoutSegue" sender:self];
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        
    }
}


@end
