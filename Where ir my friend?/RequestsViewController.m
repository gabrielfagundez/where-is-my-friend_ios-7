//
//  RequestsViewController.m
//  Where is my friend?
//
//  Created by Felipe Puig on 10/30/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import "RequestsViewController.h"
#import "BackendProxy.h"
#import "AppDelegate.h"

@interface RequestsViewController ()

@end

@implementation RequestsViewController
{

    NSArray * jsonData;
    int ident;
}

@synthesize spinner;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

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

    [[[[[self tabBarController] viewControllers]
       objectAtIndex: 2] tabBarItem] setBadgeValue:nil];

}

-(void)viewDidLoad{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"refreshRequests" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:@"updateSBadge" object:nil];

}

-(void)cargarDatosEnBackground{
    
    AppDelegate * ap = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
    
    if ([BackendProxy internetConnection]){
        
        jsonData = [BackendProxy GetAll];
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
    NSInteger num = [jsonData count];
    
    NSLog(@"la fila numero %ld", (long)indexPath.row);
    NSLog(@"elementos de jsonData %ld", (long)num);

    data= [jsonData objectAtIndex:indexPath.row];
    cell.textLabel.text = [data objectForKey:@"SolicitudFromNombre"];
    
    NSString * tagid=[data objectForKey:@"SolicitudId"];
    cell.tag= [tagid intValue];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // agrego los botones
    UIButton *aceptar = [UIButton buttonWithType:UIButtonTypeCustom];
    aceptar.frame = CGRectMake(210.0f, 10.0f, 40.0f, 40.0f);
    [aceptar setImage:[UIImage imageNamed:@"blue_tick.png"] forState:UIControlStateNormal];
    [cell addSubview:aceptar];
    [aceptar addTarget:self
                action:@selector(aceptar:)
              forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rechazar = [UIButton buttonWithType:UIButtonTypeCustom];
    rechazar.frame = CGRectMake(260.0f, 10.0f, 40.0f, 40.0f);
    [rechazar setImage:[UIImage imageNamed:@"bluecross.png"] forState:UIControlStateNormal];
    [cell addSubview:rechazar];
    [rechazar addTarget:self
                action:@selector(rechazar:)
      forControlEvents:UIControlEventTouchUpInside];

    [jsonData retain];
    return cell;

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
- (IBAction)aceptar:(id)sender
{
    if ([BackendProxy internetConnection]){
        
        NSLog(@"Aceptoooo.");
        UIButton *button= (UIButton*)sender;
        button.userInteractionEnabled=NO;
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString * idSol=[NSString stringWithFormat:@"%d", cell.tag];

        //borro la sol del jsonData
        NSMutableArray * copia =[jsonData mutableCopy];
        
        [copia removeObjectAtIndex:indexPath.row];
        
        jsonData= copia;
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView endUpdates];
        
        [self performSelectorInBackground:@selector(aceptarEnBackground:) withObject:idSol];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", nil) message:NSLocalizedString(@"No Internet Connection Action", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void)aceptarEnBackground:(NSString*)idSol{
    
        NSLog(@"El id de la solicitud es:%@",idSol);
        
        [BackendProxy Accept:idSol];
}

- (IBAction)rechazar:(id)sender
{
    if ([BackendProxy internetConnection]){

        NSLog(@"Rechazoooo.");
        UIButton *button= (UIButton*)sender;
        button.userInteractionEnabled=NO;
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString * idSol=[NSString stringWithFormat:@"%d", cell.tag];
        

        //borro la sol del jsonData
        NSMutableArray * copia =[jsonData mutableCopy];
        
        [copia removeObjectAtIndex:indexPath.row];
        
        jsonData= copia;
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]  withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView endUpdates];

        [self performSelectorInBackground:@selector(rechazarEnBackground:) withObject:idSol];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Connection Failed", nil) message:NSLocalizedString(@"No Internet Connection Action", nil) delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }

}

-(void)rechazarEnBackground:(NSString*)idSol{
    
    NSLog(@"El id de la solicitud es:%@",idSol);
    
    [BackendProxy Reject:idSol];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

-(void)viewDidDisappear:(BOOL)animated{
    NSMutableArray * copia =[jsonData mutableCopy];
    
    [copia removeAllObjects];
    
    jsonData= copia;
    [spinner removeFromSuperview];
    [self.tableView reloadData];
    
}

- (void) receiveNotification:(NSNotification *) notification{
    if ([[notification name] isEqualToString:@"refreshRequests"]){
        [spinner setHidden:NO];
        [spinner startAnimating];

        [self performSelectorInBackground:@selector(cargarDatosEnBackground) withObject:nil];
        [[[[[self tabBarController] viewControllers]
           objectAtIndex: 2] tabBarItem] setBadgeValue:nil];

    }
    if ([[notification name] isEqualToString:@"updateSBadge"]){
        AppDelegate * ap = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        
        [[[[[self tabBarController] viewControllers]
           objectAtIndex: 2] tabBarItem] setBadgeValue:ap.badgeRequest];
    }

}

@end
