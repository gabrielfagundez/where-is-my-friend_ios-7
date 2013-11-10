//
//  RequestsViewController.h
//  Where is my friend?
//
//  Created by Felipe Puig on 10/30/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RequestsViewController : UITableViewController
{
    UIActivityIndicatorView *spinner;
}


@property(nonatomic,retain) UIActivityIndicatorView *spinner;

@end



