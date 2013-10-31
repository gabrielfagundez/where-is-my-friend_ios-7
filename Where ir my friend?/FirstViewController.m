//
//  FirstViewController.m
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
{

    NSArray * jsonFriends;
    NSTimer * timer,*timer2;

}
@synthesize mapView;

-(void)viewWillAppear:(BOOL)animated
{
    
    timer = [NSTimer scheduledTimerWithTimeInterval:45
                                                    target:self
                                                    selector:@selector(targetMethod:)
                                                    userInfo:nil
                                                     repeats:YES];
    [self targetMethod:(NSTimer *) timer2];
    
}


-(void) targetMethod: (NSTimer *) theTimer {
    NSLog(@"tiempooooooooooooo");
    [mapView removeAnnotations:mapView.annotations];
    mapView.showsUserLocation = YES;
    
    NSString *id = [[NSUserDefaults standardUserDefaults]stringForKey:@"IdUsuario"];
    
    NSString *aux = @"http://developmentpis.azurewebsites.net/api/Geolocation/GetLastFriendsLocationsById/";
    NSString *direc = [aux stringByAppendingString:id];
    

    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL
                                                          URLWithString:direc]];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    jsonFriends = [NSJSONSerialization JSONObjectWithData:response
                                                  options:0 error:&jsonParsingError];
    
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

@end
