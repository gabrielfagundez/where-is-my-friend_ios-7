//
//  LoginViewController.m
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()

@end

@implementation LoginViewController{
    
    CLLocationManager * locationManager;
}

@synthesize pass,em, butlog, wrongView;;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    butlog.clipsToBounds = YES;
    butlog.layer.cornerRadius = 15.0f;
    [wrongView setHidden:YES];
    [butlog setEnabled:NO];
    
    pass.secureTextEntry = YES;
    //[em setDelegate:self];
    pass.delegate = self;
    em.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];

    
}

- (IBAction)butlogClick:(id)sender {
    
  	  if ([sender tag] == 1) {
        //sender.adjustsImageWhenHighlighted = YES;
        NSString * email = em.text;
        NSString * pswd = pass.text;	
        //build an info object and convert to json
         NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                              email,@"Mail",
                              pswd, @"Password",
                              nil];
        
        
        
        // POST
        NSMutableURLRequest *request = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:@"http://developmentpis.azurewebsites.net/api/Users/login/"]];
        
        NSError *error;
        NSData *postData = [NSJSONSerialization dataWithJSONObject:info options:0 error:&error];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
        //NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        // imprimo lo que mando para verificar
        NSLog(@"%@", [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]);
        
        NSHTTPURLResponse* urlResponse = nil;
        error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        // imprimo el resultado del post para verificar
        NSLog(@"Response: %@", result);
        NSLog(@"Response: %ld", (long)urlResponse.statusCode);
        
        //comparo segun lo que me dio el status code para ver como sigo
        if ((long)urlResponse.statusCode == 200){
            // paso la info del json obtenido
            [self performSegueWithIdentifier:@"logsegue" sender:self];
            
            //BUSCO LA UBICACION DEL USUARIO
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
            
            locationManager.distanceFilter = 50; // metros
            
            [locationManager startUpdatingLocation];
            
            
        }else{
            pass.text=@"";
            [butlog setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:0.5]];
            [butlog setEnabled:NO];
            if ((long)urlResponse.statusCode == 404){
                wrongView.text = @"User not found";
                [wrongView setHidden:NO];
            }else{
                wrongView.text = @"Wrong Password";
                [wrongView setHidden:NO];
            }
        }

    }
    
    

    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        NSLog(@"Response: %8F", currentLocation.coordinate.longitude);
        NSLog(@"Response: %8F", currentLocation.coordinate.latitude);
        //ACA MANDO AL SERVIDOR
        
        //creo el JSON
        NSString * email = em.text;
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (![em.text isEqualToString:@""] && ![pass.text isEqualToString:@""]){
        [butlog setEnabled:YES];
    }else {
         [butlog setEnabled:NO];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
