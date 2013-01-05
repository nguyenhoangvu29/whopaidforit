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
        self.navigationItem.leftBarButtonItem = self.buttonAdd;
        [super setEditing:YES animated:YES];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
        [super setEditing:NO animated:YES];
    }
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
}
- (UIBarButtonItem *)rightBarButtonItem
{
    if (self.tableView.editing) {
        UIButton *doneButton = [WidgetControl makePersonalBarButton];
        [doneButton setTitle:@"Opslaan" forState:UIControlStateNormal];
        [doneButton addTarget:self action:@selector(didTapEdit) forControlEvents:UIControlEventTouchUpInside];
        doneButton.frame = CGRectMake(0, 0, 60, 30);
        UIBarButtonItem *doneBarButton = [[[UIBarButtonItem alloc] initWithCustomView:doneButton] autorelease];
        return doneBarButton;
    } else {
        UIButton *editButton = [WidgetControl makePersonalBarButton];
        [editButton setTitle:@"Bewerken" forState:UIControlStateNormal];
        [editButton addTarget:self action:@selector(didTapEdit) forControlEvents:UIControlEventTouchUpInside];
        editButton.frame = CGRectMake(0, 0, 60, 30);
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
    
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    
    //add button Add
    UIButton *buttonAddView = [WidgetControl makePersonalBarButton];
    [buttonAddView setTitle:@"Toevoegen" forState:UIControlStateNormal];
    [buttonAddView addTarget:self action:@selector(buttonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    buttonAddView.frame = CGRectMake(0, 0, 60, 30);
    self.buttonAdd = [[[UIBarButtonItem alloc] initWithCustomView:buttonAddView] autorelease];
    [self loadData];
}
-(void)loadData
{
    User *user = [User instance];
    Event *event = [Event instance];
    listData = [[NSMutableArray alloc ] init ];
    listData = [user getMemberByEventWS:event._id];
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
    if (cell == nil) {
        cell = [[[MemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    //cell.labelPrice.text = @"€ 50,00";
    //cell.labelPerson.text = @"Marcel";
    //cell.labelEmail.text = @"marcel@gmail.com";
    NSString *value = [listData objectAtIndex:[indexPath row]];
    NSArray *column = [value componentsSeparatedByString:@"#"];
    cell.labelPrice.text = @"";
    cell.labelPerson.text = [column objectAtIndex:1];
    cell.labelEmail.text = [column objectAtIndex:2];
    cell.editButton.tag = [indexPath row];
    [cell.editButton addTarget:self action:@selector(buttonDidEditTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

@end
