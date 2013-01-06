//
//  NEventsViewController.m
//  Test
//
//  Created by Tonny Dam on 10/10/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "NEventsViewController.h"
#import "EventsCell.h"
#import "PopUpViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "PPRevealSideViewController.h"
#import "WidgetControl.h"

@interface NEventsViewController ()
@property (nonatomic,retain) UIBarButtonItem *buttonAdd;
@end

@implementation NEventsViewController
@synthesize buttonAdd;

- (void)buttonDidTouch:(id)sender {
    User *user = [User instance];
    Event *event = [Event instance];
    event.idEvent = 0;
    user.page = @"eventadd";
    showPopUp.arrayContent = [NSArray arrayWithObjects:@"Evenement", @"Naam evenement", @"", @"Omschrijving", @"Omschrijving evenement", @"", @"Toevoegen", nil];
    showPopUp.txtName.text = @"";
    showPopUp.txtEmail.text = @"";
    [self presentSemiViewController:showPopUp andHeight:192];
}
-(void) buttonDidEditTouch:(UIButton *)sender
{
    User *user = [User instance];
    Event *event = [Event instance];
    user.page = @"eventadd";
    showPopUp.arrayContent = [NSArray arrayWithObjects:@"Evenement", @"Naam evenement", @"", @"Omschrijving", @"Omschrijving evenement", @"", @"Toevoegen", nil];
        NSString *value = [listData objectAtIndex:sender.tag];
        NSArray *column = [value componentsSeparatedByString:@"#"];
        showPopUp.txtName.text = [column objectAtIndex:1];
        showPopUp.txtEmail.text = [column objectAtIndex:2];
        event.idEvent = [[column objectAtIndex:0] intValue];
        [self presentSemiViewController:showPopUp andHeight:192];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [WidgetControl setPersonalStyle:self];
        
        // ====================
        // // Right Bar Button
        // ====================
        UIButton *addButton = [WidgetControl makeButton:nil andFont:nil andColor:nil andImage:[UIImage imageNamed:@"ico_plus"] andBackground:nil andHightlightBackground:nil];
        addButton.frame = CGRectMake(0, 0, 30, 30);
        [addButton addTarget:self action:@selector(buttonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:addButton] autorelease];
    }
    return self;
}
-(void) receivedData {
    NSString *name = showPopUp.txtName.text;
    NSString *email = showPopUp.txtEmail.text;
    Event *event = [Event instance];
    User *user = [User instance];
    if(event.idEvent)
        [event updateEventWS:event.idEvent userId:user._id Name:name Description:email];
    else{    
        event._id = [event addEventWS:user._id eventName:name eventDescription:email];
    }    
    event._name = name;
    [self reloadData];
}
/*- (void)semiModalDismissed:(NSNotification *) notification {
    [UIView animateWithDuration:0.5 animations:^{
        [self.revealSideViewController replaceAfterOpenedCompletelyAnimated:YES];
    }];
}*/
-(void)didTapEdit{
    if (!self.tableView.isEditing) {
        //self.navigationItem.rightBarButtonItem = self.buttonAdd;
        [super setEditing:YES animated:YES];
    } else {
        //self.navigationItem.rightBarButtonItem = nil;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    // ======================== ||
    // // Other Calls
    // ======================== ||
    
    showPopUp = [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
    
    // ======================== ||
    // // Setting styles
    // ======================== ||
    
    [WidgetControl setBackgroundImageNavigationBar:self.navigationController.navigationBar andImage:[UIImage imageNamed:@"navblack"]];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtbb"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // ======================== ||
    // // Navigation Label
    // ======================== ||
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    //label.shadowColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
    //label.shadowOffset = CGSizeMake(0, -1);
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = @"Event lijst";
    [label sizeToFit];
    //self.title = @"Event lijst";
    
    // ======================== ||
    // // BarButton Edit
    // ======================== ||
    
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    
    // ======================== ||
    // // BarButton Add
    // ======================== ||
    
    UIButton *buttonAddView = [WidgetControl makeButton:nil andFont:nil andColor:nil andImage:[UIImage imageNamed:@"ico_plus"] andBackground:nil andHightlightBackground:nil];
    buttonAddView.frame = CGRectMake(0, 0, 30, 30);
    [buttonAddView addTarget:self action:@selector(buttonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonAdd = [[[UIBarButtonItem alloc] initWithCustomView:buttonAddView] autorelease];
    [self loadData];
}
-(void)loadData
{
    User *user = [User instance];
    Event *event = [Event instance];
    listData = [[NSMutableArray alloc ] init ];
    listData = [event getDatasWS:user._id];
}
-(void) reloadData
{
    [self loadData];
    [self.tableView reloadData];
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
        return 89;
    }
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = [User instance];
    static NSString *CellIdentifier = @"Cell";
    NSString *value = [listData objectAtIndex:[indexPath row]];
    NSArray *column = [value componentsSeparatedByString:@"#"];
    
    //custom cell
    EventsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
    NSInteger active = [[column objectAtIndex:5] intValue];
    cell = [[[EventsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier Active:active] autorelease];
    //}
    
    // Configure the cell..
    //cell.textLabel.text = [column objectAtIndex:1];
    cell.labelDate.text = [column objectAtIndex:3];
    cell.labelTitle.text = [column objectAtIndex:1];
    cell.labelPrice.text = @"";
    //cell.active = [[column objectAtIndex:5] intValue];
    if([[column objectAtIndex:5] intValue] == 1){
        Helper *helper = [Helper instance];
        NSString *price = [helper stringToMoney:([[column objectAtIndex:4] doubleValue])];
        cell.labelPrice.text = [NSString stringWithFormat:@"€ %@",price];
    }
    if([[column objectAtIndex:6] intValue] == user._id){
        cell.editButton.tag = [indexPath row];
        [cell.editButton addTarget:self action:@selector(buttonDidEditTouch:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell.editButton setHidden:YES];
    }
    
    
    return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Event *event = [Event instance];
    NSString *value = [listData objectAtIndex:[indexPath row]];
    NSArray *column = [value componentsSeparatedByString:@"#"];
    event._id = [[column objectAtIndex:0] intValue];
    event._name = [column objectAtIndex:1];
    
    self.tabBarController.selectedIndex = 1;
    /*
    EntriesViewController *entries = [[EntriesViewController alloc] init];
    entries.title = event._name;
    [self.navigationController pushViewController:entries animated:YES];
    [entries release];
     */
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *user = [User instance];
    NSString *value = [listData objectAtIndex:[indexPath row]];
    NSArray *column = [value componentsSeparatedByString:@"#"];
    if([[column objectAtIndex:6] intValue] == user._id){
        //delete event
        Event *event = [Event instance];
        [event deleteEventWS:[[column objectAtIndex:0] intValue] userId:user._id];
        [listData removeObjectAtIndex:[indexPath row]];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Events"
                                                        message:@"Don't have permission delete that event"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    
    [self.tableView reloadData];
}

- (void) dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
