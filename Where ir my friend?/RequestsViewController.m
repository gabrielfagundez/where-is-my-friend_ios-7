//
//  RequestsViewController.m
//  Where is my friend?
//
//  Created by Felipe Puig on 10/30/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import "RequestsViewController.h"

@interface RequestsViewController ()

@end

@implementation RequestsViewController
{

    NSArray * jsonData;
    int ident;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *id = [[NSUserDefaults standardUserDefaults]stringForKey:@"id"];
    
    NSString *aux = @"http://developmentpis.azurewebsites.net/api/Solicitudes/GetAll/";
    NSString *direc = [aux stringByAppendingString:id];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL
                                                          URLWithString:direc]];
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    jsonData = [NSJSONSerialization JSONObjectWithData:response
                                               options:0 error:&jsonParsingError];
    
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
    UIButton *aceptar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    aceptar.frame = CGRectMake(200.0f, 5.0f, 75.0f, 30.0f);
    [aceptar setTitle:@"Yes" forState:UIControlStateNormal];
    [cell addSubview:aceptar];
    [aceptar addTarget:self
                        action:@selector(aceptar:)
              forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rechazar = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rechazar.frame = CGRectMake(250.0f, 5.0f, 75.0f, 30.0f);
    [rechazar setTitle:@"No" forState:UIControlStateNormal];
    [cell addSubview:rechazar];
    [rechazar addTarget:self
                action:@selector(rechazar:)
      forControlEvents:UIControlEventTouchUpInside];


    return cell;

}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}
- (IBAction)aceptar:(id)sender
{
    NSLog(@"Aceptooo.");
    //creo el JSON
    NSString * idUser =[[NSUserDefaults standardUserDefaults]stringForKey:@"id"];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString * idSol=[NSString stringWithFormat:@"%d", cell.tag];
    
    
      NSLog(@"El id de la solicitud es:%@",idSol);
    
    NSDictionary* info2 = [NSDictionary dictionaryWithObjectsAndKeys:
                           idUser,@"idUser",
                           idSol, @"idSolicitud",
                           nil];
    
    NSMutableURLRequest *request2 = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:@"http://developmentpis.azurewebsites.net/api/Solicitudes/Accept"]];
    
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
}
- (IBAction)rechazar:(id)sender
{
    NSLog(@"Rechazoooo.");
    //creo el JSON
    NSString * idUser =[[NSUserDefaults standardUserDefaults]stringForKey:@"id"];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString * idSol=[NSString stringWithFormat:@"%d", cell.tag];
    
    
    NSLog(@"El id de la solicitud es:%@",idSol);
    
    NSDictionary* info2 = [NSDictionary dictionaryWithObjectsAndKeys:
                           idUser,@"idUser",
                           idSol, @"idSolicitud",
                           nil];
    
    NSMutableURLRequest *request2 = [NSMutableURLRequest
                                     requestWithURL:[NSURL URLWithString:@"http://developmentpis.azurewebsites.net/api/Solicitudes/Reject"]];
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
