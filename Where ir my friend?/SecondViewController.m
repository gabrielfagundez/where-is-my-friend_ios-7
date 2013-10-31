//
//  SecondViewController.m
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import "SecondViewController.h"

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
        
        //envio la solicitud
        
        //creo el JSON
        
        NSString * from=[[NSUserDefaults standardUserDefaults]stringForKey:@"IdUsuario"];
        NSString * to=[NSString stringWithFormat:@"%d",ident ];

        
        NSDictionary* info = [NSDictionary dictionaryWithObjectsAndKeys:
                               from,@"IdFrom",
                               to, @"IdTo",
                               nil];
        
        // POST
        NSMutableURLRequest *request = [NSMutableURLRequest
                                         requestWithURL:[NSURL URLWithString:@"http://developmentpis.azurewebsites.net/api/Solicitudes/Send/"]];
        
        NSError *error;
        NSData *postData2 = [NSJSONSerialization dataWithJSONObject:info options:0 error:&error];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData2];
        
        NSHTTPURLResponse* urlResponse = nil;
        error = [[NSError alloc] init];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
