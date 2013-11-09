//
//  FirstViewController.h
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//@  Copyright (c) 2013 MacDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate,CLLocationManagerDelegate>{
    
    MKMapView * mapView;
    BOOL isFirstLaunch;
    CLLocationManager *locationManager;
}

@property(nonatomic,retain) IBOutlet MKMapView *mapView;
@property(nonatomic,retain) CLLocationManager *locationManager;

-(IBAction)centerMapOnUserButtonClicked:(id)sender;
-(IBAction)logoutClicked:(id)sender;

@end

