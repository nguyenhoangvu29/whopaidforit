//
//  AccountViewController.m
//  Test
//
//  Created by Imac on 10/24/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "AccountViewController.h"
#import "WidgetControl.h"
#import "GraphicDrawView.h"
#import "User.h"

@interface AccountViewController () <UITextFieldDelegate>

@end

@implementation AccountViewController
@synthesize textFieldName, textFieldEmail, textFieldPassword, textFieldCPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self buildForm];
    [self loadData];
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = @"Account";
    [label sizeToFit];
}
-(void) buildForm
{
    // Custom initialization
    [WidgetControl setPersonalStyle:self];
    GraphicDrawView *drawView = [[GraphicDrawView alloc] initWithFrame:CGRectMake(10, 10, 300, 195)];
    drawView.optionDraw = @"viewStyle2";
    [self.view insertSubview:drawView atIndex:0];
    [drawView release];
    
    // =============
    // // Save button
    // =============
    UIButton *saveButton = [WidgetControl makeButton:nil andFont:nil andColor:nil andImage:[UIImage imageNamed:@"icon-save-green"] andBackground:nil andHightlightBackground:nil];
    //UIButton *saveButton = [WidgetControl makePersonalBarButton];
    //[saveButton setTitle:@"Opslaan" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAccount) forControlEvents:UIControlEventTouchUpInside];
    saveButton.frame = CGRectMake(0, 0, 35, 35);
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:saveButton] autorelease];
    
    // =============
    // // Textfields
    // =============
    textFieldName = (UITextField*)[self.view viewWithTag:100];
    textFieldName.delegate = self;
    
    [WidgetControl setPersonalTextfieldStyle:textFieldName];
    
    textFieldEmail = (UITextField*)[self.view viewWithTag:200];
    textFieldEmail.delegate = self;
    [WidgetControl setPersonalTextfieldStyle:textFieldEmail];
    
    textFieldPassword = (UITextField*)[self.view viewWithTag:300];
    textFieldPassword.delegate = self;
    textFieldPassword.secureTextEntry = YES;
    [WidgetControl setPersonalTextfieldStyle:textFieldPassword];
    
    textFieldCPassword = (UITextField*)[self.view viewWithTag:400];
    textFieldCPassword.delegate = self;
    textFieldCPassword.secureTextEntry = YES;
    [WidgetControl setPersonalTextfieldStyle:textFieldCPassword];
    
    textFieldName.returnKeyType = UIReturnKeyDone;
    textFieldEmail.returnKeyType = UIReturnKeyDone;
    textFieldPassword.returnKeyType = UIReturnKeyDone;
    textFieldCPassword.returnKeyType = UIReturnKeyDone;
}
-(void) loadData{
    User *user = [User instance];
    NSString *value = [user getAccountWS:user._id];
    NSArray *column = [value componentsSeparatedByString:@"#"];
    textFieldName.text = [column objectAtIndex:0];
    textFieldEmail.text = [column objectAtIndex:1];
}
-(void) saveAccount
{
    User *user = [User instance];
    if (![self.textFieldPassword.text isEqualToString:self.textFieldCPassword.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account" 
                                                        message:@"Gelieve voer het wachtwoord in en bevestig het paswoord."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        [user updateAccount:user._id Name:self.textFieldName.text Email:self.textFieldEmail.text Password:self.textFieldPassword.text];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Account" 
                                                        message:@"Account informative update succesvol."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
