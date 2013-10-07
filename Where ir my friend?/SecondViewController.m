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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL
                                                          URLWithString:@"http://developmentpis.azurewebsites.net/api/Friends/GetAllFriends/2"]];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil error:nil];
    NSError *jsonParsingError = nil;
    jsonData = [NSJSONSerialization JSONObjectWithData:response
                                                              options:0 error:&jsonParsingError];
    
  //  NSDictionary * data;
    
   // for(int i=0; i<[jsonData count];i++)
    //{
      //  data= [jsonData objectAtIndex:i];
       // NSLog(@"Statuses:%@",[data objectForKey:@"Name"]);
   // }
    
    
    
   // tableData = [NSArray arrayWithObjects:@"Felipe", @"Facundo", @"Esteban", @"Ismael", @"Diego", @"Jose Juan",nil];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary * data;
    data= [jsonData objectAtIndex:indexPath.row];
    cell.textLabel.text = [data objectForKey:@"Name"];
    
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
                                 initWithTitle:@"Row Selected" message:mensNoti delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];

    
    // Display Alert Message
    [messageAlert show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
