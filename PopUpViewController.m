//
//  PopUpViewController.m
//  Test
//
//  Created by Tonny Dam on 10/6/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "PopUpViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "GraphicDrawView.h"
#import "WidgetControl.h"

@interface PopUpViewController () <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet GraphicDrawView *viewSub;
@property (retain, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation PopUpViewController
@synthesize txtName, txtEmail, submitButton, viewSub, arrayContent;

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(resizeSemiView:)]) {
        [parent resizeSemiView:CGSizeMake(320, 410)];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(resizeSemiView:)]) {
        [parent resizeSemiView:CGSizeMake(320, 192)];
    }
    [textField resignFirstResponder];
    return YES;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //[WidgetControl setPersonalStyle:self];

    }
    return self;
}
- (void)closePopUp{
    UIViewController * parent = [self.view containingViewController];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        //ios5+
        NSString *name = txtName.text;
        NSString *email = txtEmail.text;
        Event *event = [Event instance];
        User *user = [User instance];
        if([user.page isEqualToString:@"addevent"]){
            //Call entries list
            [[[[[[parent.childViewControllers objectAtIndex:0] viewControllers] objectAtIndex:0] viewControllers] objectAtIndex:0] performSelector:@selector(receivedDataEventPopup)];
        }else if([user.page isEqualToString:@"eventadd"]){
            //Event List
            [[[[[[parent.childViewControllers objectAtIndex:0] viewControllers] objectAtIndex:0] viewControllers] objectAtIndex:0] performSelector:@selector(receivedData)];
        }else if([user.page isEqualToString:@"memberadd"]){
            // Memberview
            [[[[[[parent.childViewControllers objectAtIndex:0] viewControllers] objectAtIndex:3] viewControllers] objectAtIndex:0] performSelector:@selector(receivedData)];
        }else if([user.page isEqualToString:@"entryaddmember"]){
            // save member when add from editentry page
            [user addMemberWS:event._id Name:name Email:email];
            [parent receivedDataAddMember];
        }
    } else {
        //ios4
        NSString *name = txtName.text;
        NSString *email = txtEmail.text;
        Event *event = [Event instance];
        User *user = [User instance];
        Member *member = [Member instance];
        for (id obj in parent.childViewControllers) {
            NSString *stringOfObj = NSStringFromClass([obj class]);
            if ([stringOfObj isEqualToString:@"NEventsViewController"] || [stringOfObj isEqualToString:@"EntriesViewController"]) {
                NSLog(@"Add event");
                if(event.idEvent)
                    [event updateEvent:event.idEvent Name:name Description:email];
                else    
                    event._id = [event addEvent:user._id eventName:name eventDescription:email];
                event._name = name;
                user.page = @"addentry";
                if ([stringOfObj isEqualToString:@"NEventsViewController"]) {
                    [obj reloadData];
                }
            } else if ([stringOfObj isEqualToString:@"MemberViewController"]) {
                NSLog(@"action for Member");
                if(member._id)
                    [user updateMember:member._id Name:name Email:email];
                else    
                    [user addMember:event._id Name:name Email:email];
                [obj reloadData];
            }
        }
    }
    
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalView];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtb"]];
    
    self.viewSub.optionDraw = @"viewStyle1";
    
    self.txtEmail.delegate = self;
    self.txtEmail.borderStyle = UITextBorderStyleNone;
    self.txtName.delegate = self;
    self.txtName.borderStyle = UITextBorderStyleNone;
    
    //switch case
    //arrayContent = [text 1, placeholder 1, value 1, text 2, placehoder 2, value 2, text submit];
    
    UILabel *textLine1 = (UILabel*)[self.view viewWithTag:100];
    textLine1.text = [self.arrayContent objectAtIndex:0];
    self.txtName.placeholder = [self.arrayContent objectAtIndex:1];
    self.txtName.text = [self.arrayContent objectAtIndex:2];
    
    UILabel *textLine2 = (UILabel*)[self.view viewWithTag:200];
    textLine2.text = [self.arrayContent objectAtIndex:3];
    self.txtEmail.placeholder = [self.arrayContent objectAtIndex:4];
    self.txtEmail.text = [self.arrayContent objectAtIndex:5];

    
    //button
    UIImage *imageButton = [[UIImage imageNamed:@"btnblue"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    self.submitButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton setTitleShadowColor:[UIColor colorWithRed:36/255.0f green:75/255.0f blue:127/255.0f alpha:1] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:imageButton forState:UIControlStateNormal];
    [self.submitButton setTitle:[self.arrayContent objectAtIndex:6] forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(closePopUp) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [txtName release];
    [txtEmail release];
    [submitButton release];
    [viewSub release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtName:nil];
    [self setTxtEmail:nil];
    [self setSubmitButton:nil];
    [self setViewSub:nil];
    [super viewDidUnload];
}
@end
