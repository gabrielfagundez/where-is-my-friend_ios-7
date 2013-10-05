//
//  FirstViewController.h
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//@  Copyright (c) 2013 MacDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FirstViewController : UIViewController{
    
    MKMapView * mapView;
    
}

@property(nonatomic,retain) IBOutlet MKMapView *mapView;

@end
