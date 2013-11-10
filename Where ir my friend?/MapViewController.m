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
@synthesize mapView,locationManager;

-(void)viewWillAppear:(BOOL)animated{
    timer = [NSTimer scheduledTimerWithTimeInterval:10
                                             target:self
                                           selector:@selector(targetMethod:)
                                           userInfo:nil
                                            repeats:YES];
    [self targetMethod:(NSTimer *) timer2];
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
    [locationManager setDistanceFilter:100];
    [locationManager startUpdatingLocation];

}


-(void) targetMethod: (NSTimer *) theTimer {
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


//clocationmanagerdelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSLog(@"Response: %8F", currentLocation.coordinate.longitude);
        NSLog(@"Response: %8F", currentLocation.coordinate.latitude);
        //ACA MANDO AL SERVIDOR
        
        //creo el JSON
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        

        NSString *email = [defaults stringForKey:@"mail"];;
        NSString *longit=[NSString stringWithFormat:@"%1.6f",currentLocation.coordinate.longitude ];
        NSString *latit=[NSString stringWithFormat:@"%1.6f",currentLocation.coordinate.latitude ];
        
        NSDictionary* info2 = [NSDictionary dictionaryWithObjectsAndKeys:
                               email,@"Mail",
                               latit, @"Latitude",
                               longit, @"Longitude",
                               nil];
        
        // POST
        NSMutableURLRequest *request2 = [NSMutableURLRequest
                                         requestWithURL:[NSURL URLWithString:@"http://developmentpis.azurewebsites.net/api/Geolocation/SetLocation/"]];
        
        NSError *error;
        NSData *postData2 = [NSJSONSerialization dataWithJSONObject:info2 options:0 error:&error];
        [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request2 setHTTPMethod:@"POST"];
        [request2 setHTTPBody:postData2];
        //NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        // imprimo lo que mando para verificar
        NSLog(@"%@", [[NSString alloc] initWithData:postData2 encoding:NSUTF8StringEncoding]);
        
        NSHTTPURLResponse* urlResponse = nil;
        error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&urlResponse error:&error];
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        // imprimo el resultado del post para verificar
        NSLog(@"Response: %@", result);
        NSLog(@"Response: %ld", (long)urlResponse.statusCode);
        
        //comparo segun lo que me dio el status code para ver como sigo
        if ((long)urlResponse.statusCode == 200){
            // paso la info del json obtenido
            
        }else{
            
        }
        
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
