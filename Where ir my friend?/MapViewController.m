//
//  FirstViewController.m
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import "MapViewController.h"
#import "BackendProxy.h"

@interface MapViewController ()

@end

@implementation MapViewController
{
    
    NSArray * jsonFriends;
    NSTimer * timer,*timer2;
    
}
@synthesize mapView;

-(void)viewWillAppear:(BOOL)animated{
    timer = [NSTimer scheduledTimerWithTimeInterval:200
                                             target:self
                                           selector:@selector(targetMethod:)
                                           userInfo:nil
                                            repeats:YES];
    [self targetMethod:(NSTimer *) timer2];
    isFirstLaunch=YES;
    
    
    
}

-(void) viewDidLoad{
    mapView.showsUserLocation = YES;
    mapView.delegate = self;
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
    UITabBarItem *tbi = (UITabBarItem*)[[[self.tabBarController tabBar] items] objectAtIndex:2];
    
    [tbi setBadgeValue:@"1"];
}


-(void) targetMethod: (NSTimer *) theTimer {
    NSLog(@"tiempooooooooooooo");
    [mapView removeAnnotations:mapView.annotations];
    mapView.showsUserLocation = YES;
    
    jsonFriends = [BackendProxy GetLastFriendsLocationsById];
    
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
        annotationPoint.title = [data objectForKey:@"Mail"];
        [mapView addAnnotation:annotationPoint];
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//mkmapviewdelegates
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    if (isFirstLaunch) {
//        MKCoordinateRegion region;
//        MKCoordinateSpan span;
//        span.latitudeDelta = 0.005;
//        span.longitudeDelta = 0.005;
//        CLLocationCoordinate2D location;
//        location.latitude = userLocation.coordinate.latitude;
//        location.longitude = userLocation.coordinate.longitude;
//        region.span = span;
//        region.center = location;
//        [mapView setRegion:region animated:YES];
//        isFirstLaunch=NO;
//    }
//}

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
