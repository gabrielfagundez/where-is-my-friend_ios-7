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

@implementation LoginViewController

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

    
}

- (IBAction)butlogClick:(id)sender {
    
    if ([sender tag] == 1) {
        //sender.adjustsImageWhenHighlighted = YES;
        NSString * email = em.text;
        NSString * pswd = pass.text;	
        //build an info object and convert to json
        NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                              email,@"Email",
                              pswd, @"Password",
                              nil];
        
        
        
        // POST
        NSMutableURLRequest *request = [NSMutableURLRequest
                                        requestWithURL:[NSURL URLWithString:@"http://connectwp.azurewebsites.net/api/login/"]];
        
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
