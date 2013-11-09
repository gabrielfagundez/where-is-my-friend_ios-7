//
//  FirstViewController.h
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//@  Copyright (c) 2013 MacDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate, UIActionSheetDelegate>{
    
    MKMapView * mapView;
    BOOL isFirstLaunch;
}

@property(nonatomic,retain) IBOutlet MKMapView *mapView;

-(IBAction)centerMapOnUserButtonClicked:(id)sender;
-(IBAction)logoutClicked:(id)sender;

@end

