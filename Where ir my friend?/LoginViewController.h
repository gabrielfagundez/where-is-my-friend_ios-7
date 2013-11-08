//
//  LoginViewController.h
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate,CLLocationManagerDelegate,UITableViewDataSource>
{

    IBOutlet UITextField * em;
    IBOutlet UITextField * pass;
    IBOutlet UIButton * butlog;
    IBOutlet UILabel *wrongTxt;
    IBOutlet UIActivityIndicatorView *spinner;
    IBOutlet UITableView *table;
    IBOutlet UIButton *btnWrong;
    IBOutlet UIView *wrongView;
}

@property(nonatomic,retain) UITextField * em;
@property(nonatomic,retain) UITextField * pass;
@property(nonatomic,retain) UIView *wrongTxt;
@property(nonatomic,retain) UIButton *butlog;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;
@property(nonatomic,retain) UITableView *table;
@property(nonatomic,retain) UIButton *btnWrong;
@property(nonatomic,retain) UIView *wrongView;

-(IBAction)butlogClick:(id)sender;



@end
