//
//  MemberViewController.m
//  Test
//
//  Created by Tonny Dam on 10/5/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "MemberViewController.h"
#import "MemberCell.h"
#import "PopUpViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "WidgetControl.h"

@interface MemberViewController ()
@property (nonatomic, retain) UIBarButtonItem *buttonAdd;
@end

@implementation MemberViewController
@synthesize buttonAdd;

- (void)buttonDidTouch:(id)sender {
    User *user = [User instance];
    Member *member = [Member instance];
    user.page = @"memberadd";
    member._id = 0;
    showPopUp.arrayContent = [NSArray arrayWithObjects:@"Naam", @"Naam nieuw lid", @"", @"E-mail", @"E-mail adres nieuw lid", @"", @"Toevoegen", nil];
    showPopUp.txtName.text = @"";
    showPopUp.txtEmail.text = @"";
    [self presentSemiViewController:showPopUp andHeight:192];
}
- (void)buttonDidEditTouch:(UIButton *)sender
{
    Member *member = [Member instance];
    User *user = [User instance];
    user.page = @"memberadd";
    showPopUp.arrayContent = [NSArray arrayWithObjects:@"Naam", @"Naam nieuw lid", @"", @"E-mail", @"E-mail adres nieuw lid", @"", @"Toevoegen", nil];
    
    NSString *value = [listData objectAtIndex:sender.tag];
    NSArray *column = [value componentsSeparatedByString:@"#"];
    member._id = [[column objectAtIndex:0] intValue];
    showPopUp.txtName.text = [column objectAtIndex:1];
    showPopUp.txtEmail.text = [column objectAtIndex:2];
    [self presentSemiViewController:showPopUp andHeight:192];
}
-(void)didTapEdit{
    if (!self.tableView.isEditing) {
        [super setEditing:YES animated:YES];
    } else {
        [super setEditing:NO animated:YES];
    }
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
}
- (UIBarButtonItem *)leftBarButtonItem
{
    if (self.tableView.editing) {
        UIButton *doneButton = [WidgetControl makeButton:nil andFont:nil andColor:nil andImage:[UIImage imageNamed:@"icon-save-green"] andBackground:[UIImage imageNamed:@"empty"] andHightlightBackground:nil];
        [doneButton addTarget:self action:@selector(didTapEdit) forControlEvents:UIControlEventTouchUpInside];
        doneButton.frame = CGRectMake(0, 0, 30, 30);
        UIBarButtonItem *doneBarButton = [[[UIBarButtonItem alloc] initWithCustomView:doneButton] autorelease];
        return doneBarButton;
    } else {
        UIButton *editButton = [WidgetControl makeButton:nil andFont:nil andColor:nil andImage:[UIImage imageNamed:@"icon-edit"] andBackground:[UIImage imageNamed:@"empty"] andHightlightBackground:nil];
        [editButton addTarget:self action:@selector(didTapEdit) forControlEvents:UIControlEventTouchUpInside];
        editButton.frame = CGRectMake(0, 0, 30, 30);
        UIBarButtonItem *editBarButton = [[[UIBarButtonItem alloc] initWithCustomView:editButton] autorelease];
        return editBarButton;
    }
}
- (id)initWithStyle:(UITableViewStyle)style
{
    style = UITableViewStyleGrouped;
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [WidgetControl setPersonalStyle:self];
        showPopUp = [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    
    UIButton *addButton = [WidgetControl makeButton:nil andFont:nil andColor:nil andImage:[UIImage imageNamed:@"ico_plus"] andBackground:nil andHightlightBackground:nil];
    addButton.frame = CGRectMake(0, 0, 30, 30);
    [addButton addTarget:self action:@selector(buttonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:addButton] autorelease];
    /*//add button Add
    UIButton *buttonAddView = [WidgetControl makePersonalBarButton];
    [buttonAddView setTitle:@"Toevoegen" forState:UIControlStateNormal];
    [buttonAddView addTarget:self action:@selector(buttonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    buttonAddView.frame = CGRectMake(0, 0, 60, 30);
    self.buttonAdd = [[[UIBarButtonItem alloc] initWithCustomView:buttonAddView] autorelease];
     */
    //[self loadData];
}

-(void)loadData
{
    User *user = [User instance];
    Event *event = [Event instance];
    if(event._id){
        listData = [[NSMutableArray alloc ] init ];
        listData = [user getMemberByEventWS:event._id];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor]; // change this color
        self.navigationItem.titleView = label;
        label.text = event._name;
        [label sizeToFit];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Leden"
                                                        message:@"Please choose item before see members"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [self reloadData];
}

-(void) reloadData
{
    [self loadData];
    [self.tableView reloadData];
}
-(void) receivedData
{
    User *user =[User instance];
    Event *event = [Event instance];
    Member *member = [Member instance];
    NSString *name = showPopUp.txtName.text;
    NSString *email = showPopUp.txtEmail.text;
    if(member._id)
        [user updateMemberWS:member._id Name:name Email:email];
    else    
        [user addMemberWS:event._id Name:name Email:email];
    [self reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [listData count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        return 69;
    }
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MemberCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSString *value = [listData objectAtIndex:[indexPath row]];
    NSArray *column = [value componentsSeparatedByString:@"#"];
    int active = [[column objectAtIndex:3] intValue];
    cell = [[[MemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier Active:active] autorelease];
    
    // Configure the cell...
    //cell.labelPrice.text = @"€ 50,00";
    //cell.labelPerson.text = @"Marcel";
    //cell.labelEmail.text = @"marcel@gmail.com";
    
    //cell.labelPrice.text = @"123";
    cell.labelPerson.text = [column objectAtIndex:1];
    cell.labelEmail.text = [column objectAtIndex:2];
    cell.editButton.tag = [indexPath row];
    [cell.editButton addTarget:self action:@selector(buttonDidEditTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.tabBarController.selectedIndex = 0;
}
@end
