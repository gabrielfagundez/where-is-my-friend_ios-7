//
//  SecondViewController.m
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import "FriendsViewController.h"
#import "BackendProxy.h"
#import "ServerResponse.h"
#import "AppDelegate.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController
{
    NSArray * jsonData;
    int ident;
}

@synthesize spinner;

- (void)viewWillAppear:(BOOL)animated
{
    //empeza a correr el spinner
    spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.color=[UIColor grayColor];
    spinner.center = self.view.center;
    [self.view addSubview: spinner];

    [spinner setHidden:NO];
    [spinner startAnimating];
    
    [self performSelectorInBackground:@selector(cargarDatosEnBackground) withObject:nil];

    
}

-(void)cargarDatosEnBackground{
    
    AppDelegate * ap = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    
    if ([BackendProxy internetConnection]){
        
            jsonData = [BackendProxy GetAllFriends];
            [jsonData retain];
            ap.habiaConexion = YES;
    }else{
            if (ap.habiaConexion){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", nil) message:NSLocalizedString(@"No Internet Connection App", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil];
                [alert show];
                ap.habiaConexion = NO;
            }
        }
        
    [self performSelectorOnMainThread:@selector(finishLoading) withObject:nil waitUntilDone:YES];
}

-(void)finishLoading{
    
    //termino de correr el spinner
    [spinner stopAnimating];
    [spinner setHidden:YES];
    
    [self.tableView reloadData];
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
    
    [jsonData retain];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *mensNoti = [NSString stringWithFormat: NSLocalizedString(@"Send a notification to", nil), cell.textLabel.text];
    UIAlertView *messageAlert = [[UIAlertView alloc]
                                 initWithTitle:NSLocalizedString(@"Send", nil) message:mensNoti delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:NSLocalizedString(@"Cancel", nil),nil];
    
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
            
            if ([sr getCodigo] == 400){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Can not send", nil) message:NSLocalizedString(@"Can not send why", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                [alert show];
            }
        }
        
        else{
            //si no hay conexion con el server
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", nil) message:NSLocalizedString(@"No Internet Connection Action", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert show];
        }
        
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    NSMutableArray * copia =[jsonData mutableCopy];
    
    [copia removeAllObjects];
    
    jsonData= copia;
    
    [self.tableView reloadData];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
