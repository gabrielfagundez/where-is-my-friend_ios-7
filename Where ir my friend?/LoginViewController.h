//
//  LoginViewController.h
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate,CLLocationManagerDelegate>
{

    IBOutlet UITextField * em;
    IBOutlet UITextField * pass;
    IBOutlet UIButton * butlog;
    IBOutlet UILabel *wrongView;
    IBOutlet UIActivityIndicatorView *spinner;
}

@property(nonatomic,retain) UITextField * em;
@property(nonatomic,retain) UITextField * pass;
@property(nonatomic,retain) UIView *wrongView;
@property(nonatomic,retain) UIButton * butlog;
@property(nonatomic,retain) UIActivityIndicatorView *spinner;

-(IBAction)butlogClick:(id)sender;



@end
