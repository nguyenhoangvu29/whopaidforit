//
//  LoginViewController.m
//  Test
//
//  Created by Tonny Dam on 10/9/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarViewController.h"
#define kOFFSET_FOR_KEYBOARD 210.0

@interface LoginViewController () <UITextFieldDelegate>
@property(nonatomic,retain) IBOutlet UITextField *usernameField;
@property(nonatomic,retain) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController
@synthesize revealSideViewController = _revealSideViewController;
@synthesize usernameField, passwordField;
-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender isEqual:usernameField] || [sender isEqual:passwordField])
    {
        //move the main view, so that the keyboard does not hide it.
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}



- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Dismiss the keyboard when the view outside the text field is touched.
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    // Revert the text field to the previous value.
    [self keyboardWillHide];
    [super touchesBegan:touches withEvent:event];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self keyboardWillShow];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self keyboardWillHide];
    [textField resignFirstResponder];
    return YES;
}
-(IBAction)clickButtonLogin {
    User *user = [User instance];
    user._tab = 0;
    NSString *name = [usernameField text];
    //name = [name stringByReplacingOccurrencesOfString:@" "
    //                                       withString:@"%20"];
    NSString *pass = [passwordField text];
    if([name length] == 0 ){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Inloggen" 
                                                        message:@"Gelieve ingang e-mail"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else if ([pass length] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Inloggen" 
                                                        message:@"Voer de vergeten"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else {
        NSString *response = [user loginWS:name passwd:pass];
        user.page = response;
        //NSLog(@"page login %@",response);
        TabBarViewController *main = [[TabBarViewController alloc] init];
        self.revealSideViewController = [[[PPRevealSideViewController alloc] initWithRootViewController:main] autorelease];
        
        [self presentModalViewController:self.revealSideViewController animated:YES];
        [main release];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtbb"]];

    
    UIView *paddingView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)] autorelease];
    usernameField.leftView = paddingView;
    usernameField.leftViewMode = UITextFieldViewModeAlways;
    usernameField.frame = CGRectMake(40, 267, 241, 37);
    usernameField.backgroundColor = [UIColor clearColor];
    usernameField.textColor = [UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
    
    UIView *paddingView2 = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)] autorelease];
    passwordField.leftView = paddingView2;
    passwordField.leftViewMode = UITextFieldViewModeAlways;
    passwordField.frame = CGRectMake(40, 314, 241, 37);
    usernameField.backgroundColor = [UIColor clearColor];
    passwordField.textColor = [UIColor colorWithRed:164/255.0f green:164/255.0f blue:164/255.0f alpha:1];
    
    UILabel *label = (UILabel *) [self.view viewWithTag:200];
    label.font = [UIFont fontWithName:@"Ubuntu Condensed" size:16];
    label.textColor = [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1];
    label.shadowColor = [UIColor colorWithRed:47/255.0f green:0 blue:0 alpha:1];
    label.shadowOffset = CGSizeMake(0, 1);
    
    usernameField.text =@"vu@yahoo.com";
    passwordField.text = @"123";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
