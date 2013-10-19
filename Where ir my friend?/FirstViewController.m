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

}
@synthesize mapView;

-(void)viewWillAppear:(BOOL)animated
{
    [mapView removeAnnotations:mapView.annotations];
    mapView.showsUserLocation = YES;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL
                                                          URLWithString:@"http://developmentpis.azurewebsites.net/api/Geolocation/GetLastFriendsLocations/1"]];
    
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
/*
- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView.showsUserLocation = YES;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL
                                                          URLWithString:@"http://developmentpis.azurewebsites.net/api/Geolocation/GetLastFriendsLocations/1"]];
    
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
	// Do any additional setup after loading the view, typically from a nib.
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
