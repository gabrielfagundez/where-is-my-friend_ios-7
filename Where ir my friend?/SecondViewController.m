//
//  SecondViewController.m
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import "SecondViewController.h"
#import "BackendProxy.h"
#import "ServerResponse.h"

@interface SecondViewController ()

@end

@implementation SecondViewController
{
    NSArray * jsonData;
    int ident;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSString *id = [[NSUserDefaults standardUserDefaults]stringForKey:@"IdUsuario"];
    
    NSString *aux = @"http://developmentpis.azurewebsites.net/api/Friends/GetAllFriends/";
    NSString *direc = [aux stringByAppendingString:id];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL
                                                          URLWithString:direc]];
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    jsonData = [NSJSONSerialization JSONObjectWithData:response
                                                              options:0 error:&jsonParsingError];
    
    UITabBarItem *tbi = (UITabBarItem*)[[[self.tabBarController tabBar] items] objectAtIndex:2];
    
    [tbi setBadgeValue:@"1"];
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [jsonData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary * data;
    data= [jsonData objectAtIndex:indexPath.row];
    cell.textLabel.text = [data objectForKey:@"Name"];
    cell.detailTextLabel.text=[data objectForKey:@"Mail"];
    
    NSString * tagid=[data objectForKey:@"Id"];
    cell.tag= [tagid intValue];
    
    cell.imageView.image = [UIImage imageNamed:@"face.jpg"];
    UISwitch *mySwitch = [[[UISwitch alloc] init] autorelease];
    cell.accessoryView = mySwitch;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *mensNoti = [NSString stringWithFormat: @"Send a notification to %@ ?", cell.textLabel.text];
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Row Selected" message:mensNoti delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
    
    ident= cell.tag;
    // Display Alert Message
    [messageAlert show];
  
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"entro");
    if (buttonIndex == 0)
    {
        NSLog(@"entro AL OK");
        
        if ([BackendProxy internetConnection]){
            //si hay conexion con el server
            
            //envio la solicitud        
            NSString * to=[NSString stringWithFormat:@"%d",ident ];
            
            //llamo a la funcion de backend
            ServerResponse * sr = [BackendProxy send :to];
            
            //comparo segun lo que me dio la funcion enterUser para ver como sigo
            if ([sr getCodigo] != 200){
                
                //hubo error, capaz hay que tirar mensaje
                
                //si es 200 (esta todo bien) creo que no se hace nada
            }
        }
        
        else{
            //si no hay conexion con el server
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", nil) message:NSLocalizedString(@"No Internet Connection Send", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
  
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
