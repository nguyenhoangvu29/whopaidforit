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
    [self presentSemiViewController:showPopUp andHeight:192];
    //[self presentSemiViewController:showPopUp andHeight:390];
    //showPopUp.dateTextField.text = formattedDate;
    //[showPopUp viewDidAppear:YES];

    /*[UIView animateWithDuration:0.5 animations:^{
        [self.revealSideViewController openCompletelyAnimated:YES];
    }completion:^(BOOL finished) {
        showPopUp.txtName.text = @"";
        showPopUp.txtEmail.text = @"";
        [self presentSemiViewController:showPopUp andHeight:192];
    }];*/
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
        // Custom initialization
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(semiModalDismissed:) name:kSemiModalDidHideNotification object:nil];
        [WidgetControl setPersonalStyle:self];
        
        // ====================
        // // Right Bar Button
        // ====================
        UIButton *addButton = [WidgetControl makeButton:nil andFont:nil andColor:nil andImage:[UIImage imageNamed:@"ico_plus"] andBackground:nil andHightlightBackground:nil];
        addButton.frame = CGRectMake(0, 0, 30, 30);
        [addButton addTarget:self action:@selector(buttonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        /*UIButton *addButton = [WidgetControl makePersonalBarButton];
         [addButton setTitle:@"Toevoegen" forState:UIControlStateNormal];
         addButton.frame = CGRectMake(0, 0, 60, 30);
         [addButton addTarget:self action:@selector(didTapAdd) forControlEvents:UIControlEventTouchUpInside];*/
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
- (void)semiModalDismissed:(NSNotification *) notification {
    [UIView animateWithDuration:0.5 animations:^{
        [self.revealSideViewController replaceAfterOpenedCompletelyAnimated:YES];
    }];
}
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
        UIButton *doneButton = [WidgetControl makeButton:nil andFont:nil andColor:nil andImage:[UIImage imageNamed:@"ico_done"] andBackground:[UIImage imageNamed:@"empty"] andHightlightBackground:nil];
        [doneButton addTarget:self action:@selector(didTapEdit) forControlEvents:UIControlEventTouchUpInside];
        doneButton.frame = CGRectMake(0, 0, 30, 30);
        UIBarButtonItem *doneBarButton = [[[UIBarButtonItem alloc] initWithCustomView:doneButton] autorelease];
        return doneBarButton;
    } else {
        UIButton *editButton = [WidgetControl makeButton:nil andFont:nil andColor:nil andImage:[UIImage imageNamed:@"iconeditblank"] andBackground:[UIImage imageNamed:@"empty"] andHightlightBackground:nil];
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
    static NSString *CellIdentifier = @"Cell";
    
    //custom cell
    EventsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[EventsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.labelDate.text = @"15-02-12";
    cell.labelTitle.text = @"SMD's Events";
    cell.labelPrice.text = @"€ 1.250,00";
    //cell.labelPerson.text = @"3 x";
    
    //[cell.editButton addTarget:self action:@selector(buttonDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
    /*static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
        cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbbline"]];
        cell.textLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tbbline"]];
        [cell.contentView setOpaque:NO];
        
        UIButton *editButton = [WidgetControl makeButton:nil andFont:nil andColor:nil andImage:[UIImage imageNamed:@"iconeditblank"] andBackground:nil andHightlightBackground:nil];
        editButton.tag = [indexPath row];
        [editButton addTarget:self action:@selector(buttonDidEditTouch:) forControlEvents:UIControlEventTouchUpInside];
        cell.editingAccessoryView = editButton;
    }*/
    // Configure the cell...
    //NSString *value = [listData objectAtIndex:[indexPath row]];
    //NSArray *column = [value componentsSeparatedByString:@"#"];
    //cell.textLabel.text = [column objectAtIndex:1];

    //return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select item");
    Event *event = [Event instance];
    NSString *value = [listData objectAtIndex:[indexPath row]];
    NSArray *column = [value componentsSeparatedByString:@"#"];
    event._id = [[column objectAtIndex:0] intValue];
    event._name = [column objectAtIndex:1];
    //ios5 but don't need
    /*for (id obj in self.revealSideViewController.rootViewController.childViewControllers) {
        NSString *stringOfObj = NSStringFromClass([[[obj viewControllers] objectAtIndex:0] class]);
        if ([stringOfObj isEqualToString:@"EntriesViewController"]) {
            
            [[[obj viewControllers] objectAtIndex:0] performSelector:@selector(reloadData)];
        }
    }
    [self.revealSideViewController popViewControllerAnimated:YES];
     */
}
- (void) dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
