//
//  LoginViewController.h
//  Where ir my friend?
//
//  Created by MacDev on 9/28/13.
//  Copyright (c) 2013 MacDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate>{

    IBOutlet UITextField * em;
    IBOutlet UITextField * pass;
    IBOutlet UIButton * butlog;
    IBOutlet UILabel *wrongView;
}

@property(nonatomic,retain) UITextField * em;
@property(nonatomic,retain) UITextField * pass;
@property(nonatomic,retain) UIView *wrongView;
@property(nonatomic,retain) UIButton * butlog;

-(IBAction)butlogClick:(id)sender;



@end
