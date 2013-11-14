//
//  LoginViewController.m
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "BackendProxy.h"
#import "BackendProxy.h"
#import "ServerResponse.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize pass,em, butlog, wrongView, spinner, table, btnWrong, wrongTxt;

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];

    butlog.clipsToBounds = YES;
    butlog.layer.cornerRadius = 15.0f;
    [wrongView setHidden:YES];
    //[butlog setEnabled:NO];
    pass.secureTextEntry = YES;
    //[em setDelegate:self];
    pass.delegate = self;
    em.delegate = self;
    table.dataSource=self;
    btnWrong.transform = CGAffineTransformMakeRotation(45.0*M_PI/180.0);
    
    //locationManager = [[CLLocationManager alloc] init];
    
    [spinner setHidden:YES];
    
    [btnWrong setTintColor:[UIColor colorWithRed:190.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1]];
    [wrongTxt setTextColor:[UIColor colorWithRed:190.0/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1]];
}

-(void)dismissKeyboard{
    [em resignFirstResponder];
    [pass resignFirstResponder];
    
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//  return @"Login";
//}

-(void)viewDidAppear:(BOOL)animated{
    [wrongView setHidden:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.table cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init ];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(IBAction)butlogClick:(id)sender{
    //[txtPassword resignFirstResponder];
    [spinner setHidden:NO];
    [spinner startAnimating];
    [em resignFirstResponder];
    [pass resignFirstResponder];

    [self performSelectorInBackground:@selector(processLogin) withObject:self];
    
}

-(void)processLogin{
    NSString * email = em.text;
    NSString * pswd = pass.text;
    if (email!=nil && pswd!= nil && ![email isEqualToString:@""] && ![pswd isEqualToString:@""]){//no hay cosas vacias
        
        if ([BackendProxy internetConnection]){
            //si hay conexion con el server
            
            NSString * plat= @"ios";
            NSString * idiom=[[NSLocale preferredLanguages] objectAtIndex:0];
            if ([idiom isEqualToString:@"es"])
                idiom=@"esp";
            //NSString * device= [[UAPush shared] deviceToken];
            NSString * device=@"123";

            //llamo a la funcion de backend
            ServerResponse * sr = [BackendProxy login :email :pswd :plat :device :idiom];
            
            //comparo segun lo que me dio la funcion enterUser para ver como sigo
            if ([sr getCodigo] == 200){
                
                //BUSCO LA UBICACION DEL USUARIO
                //locationManager.delegate = self;
//                locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//                locationManager.distanceFilter = 50; // metros
                
                //[locationManager startUpdatingLocation];
                [self performSelectorOnMainThread:@selector(finishedLoading) withObject:nil waitUntilDone:NO];
                
            }else{
                pass.text=@"";
                pswd=nil;
                wrongTxt.text=NSLocalizedString(@"Invalid Mail and/or Password", nil);
                [wrongView setHidden:NO];
            }
        }
        else{
            //si no hay conexion con el server
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", nil) message:NSLocalizedString(@"No Internet Connection Login", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
            [alert show];
        }
    }
    else{
        //txtWrong.text=NSLocalizedString(@"Complete all the fields to login", nil);
        //[butlog setBackgroundColor:[UIColor colorWithRed:0.0/255.0f green:175.0/255.0f blue:240.0/255.0f alpha:0.5]];
        //[butlog setEnabled:NO];
        wrongTxt.text=NSLocalizedString(@"Complete all the fields to login", nil);
        [wrongView setHidden:NO];
    }
    
    [spinner stopAnimating];
    [spinner setHidden:YES];
    
    
}

-(void)finishedLoading{
    [self performSegueWithIdentifier:@"logsegue" sender:self];
}

//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    NSLog(@"didFailWithError: %@", error);
//    UIAlertView *errorAlert = [[UIAlertView alloc]
//                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [errorAlert show];
//}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
//{
//    NSLog(@"didUpdateToLocation: %@", newLocation);
//    CLLocation *currentLocation = newLocation;
//    
//    if (currentLocation != nil) {
//        NSLog(@"Response: %8F", currentLocation.coordinate.longitude);
//        NSLog(@"Response: %8F", currentLocation.coordinate.latitude);
//        //ACA MANDO AL SERVIDOR
//        
//        //creo el JSON
//        NSString * email = em.text;
//        NSString *longit=[NSString stringWithFormat:@"%1.6f",currentLocation.coordinate.longitude ];
//        NSString *latit=[NSString stringWithFormat:@"%1.6f",currentLocation.coordinate.latitude ];
//        
//        NSDictionary* info2 = [NSDictionary dictionaryWithObjectsAndKeys:
//                               email,@"Mail",
//                               latit, @"Latitude",
//                               longit, @"Longitude",
//                               nil];
//        
//        // POST
//        NSMutableURLRequest *request2 = [NSMutableURLRequest
//                                         requestWithURL:[NSURL URLWithString:@"http://serverdevelopmentpis.azurewebsites.net/api/Geolocation/SetLocation/"]];
//        
//        NSError *error;
//        NSData *postData2 = [NSJSONSerialization dataWithJSONObject:info2 options:0 error:&error];
//        [request2 setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [request2 setHTTPMethod:@"POST"];
//        [request2 setHTTPBody:postData2];
//        //NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//        
//        // imprimo lo que mando para verificar
//        NSLog(@"%@", [[NSString alloc] initWithData:postData2 encoding:NSUTF8StringEncoding]);
//        
//        NSHTTPURLResponse* urlResponse = nil;
//        error = [[NSError alloc] init];
//        NSData *responseData = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&urlResponse error:&error];
//        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//        
//        // imprimo el resultado del post para verificar
//        NSLog(@"Response: %@", result);
//        NSLog(@"Response: %ld", (long)urlResponse.statusCode);
//        
//        //comparo segun lo que me dio el status code para ver como sigo
//        if ((long)urlResponse.statusCode == 200){
//            // paso la info del json obtenido
//            
//        }else{
//            
//        }
//        
//    }
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [wrongView setHidden:YES];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [wrongView setHidden:YES];
    //if (![em.text isEqualToString:@""] && ![pass.text isEqualToString:@""]){
    //[butlog setEnabled:YES];
    // }else {
    //[butlog setEnabled:NO];
    //}
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
