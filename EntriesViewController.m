//
//  EntriesViewController.m
//  Test
//
//  Created by Tonny Dam on 10/8/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "EntriesViewController.h"
#import "EntriesCell.h"
#import "EntryDetailViewController.h"
#import "EditEntryDetailViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "WidgetControl.h"
#import "User.h"
#import "Event.h"
#import "Entry.h"
#import "Participate.h"
#import "PopUpViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "Helper.h"

@interface EntriesViewController ()

@end

@implementation EntriesViewController
@synthesize arrayReceive;

-(void) receivedDataEventPopup
{
    NSString *name = showPopUpEvent.txtName.text;
    NSString *email = showPopUpEvent.txtEmail.text;
    Event *event = [Event instance];
    User *user = [User instance];
    event._id = [event addEventWS:user._id eventName:name eventDescription:email];
    event._name = name;
    user.page = @"addentry";
}
-(void) receivedData {
    User *user = [User instance];
    Event *event = [Event instance];
    Entry *entry = [Entry instance];
    NSString *dateString= showPopUp.dateTextField.text;
    //add to webservice
    int first = 1;
    NSMutableString * result = [[NSMutableString alloc] init];
    for(int i=0;i<[showPopUp.arrayPersons count];i++){
        NSString *value = [showPopUp.arrayPersons objectAtIndex:i];
        NSArray *column = [value componentsSeparatedByString:@"#"];
        if([[column objectAtIndex:3] intValue]){ // have quantity
            if(first){
                [result appendString:[NSString stringWithFormat:@"%d,%d",[[column objectAtIndex:0] intValue], [[column objectAtIndex:3] intValue] ] ];  
                first = 0;
            }else {
                [result appendString:[NSString stringWithFormat:@"-%d,%d",[[column objectAtIndex:0] intValue], [[column objectAtIndex:3] intValue] ] ]; 
            }
        } 
    }
    entry._id = [entry addEntryWS:user._id Amount:showPopUp.priceTextField.text Description:showPopUp.desTextField.text DateExpenses:dateString eventId:event._id paidFor:showPopUp.paidForId ParticipantStr:result];
    
    
    [self reloadData];
}

-(void) didTapAdd {
    showPopUp = [[EditEntryDetailViewController alloc] init];
    // ============
    // // Today
    // ============
    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat: @"dd-MM-yyyy"];
    NSString *formattedDate = [formatter stringFromDate: today];
    listMember = [[NSMutableArray alloc] init ];
    Event *event = [Event instance];
    User *user = [User instance];
    Entry *entry = [Entry instance];
    entry._id = 0;
    listMember = [user getMemberByEventWS:event._id];
    NSMutableArray *arrPersons = [[NSMutableArray alloc] init ];
    for(int i=0;i<[listMember count];i++){
        NSString *value = [listMember objectAtIndex:i];
        NSArray *column = [value componentsSeparatedByString:@"#"];
        NSString *v= [NSString stringWithFormat:@"%@#%@#%@#%d",[column objectAtIndex:0],[column objectAtIndex:1],@"0.00",1];
        //NSLog(@"member %@",v);
        [arrPersons addObject:v];
    }
    showPopUp.arrayPersons = arrPersons;
    [self presentSemiViewController:showPopUp andHeight:390];
    showPopUp.dateTextField.text = formattedDate;
    [showPopUp viewDidAppear:YES];
    
}
- (id)initWithStyle:(UITableViewStyle)style
{
    style = UITableViewStyleGrouped;
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [WidgetControl setPersonalStyle:self];
        
        // ====================
        // // Right Bar Button
        // ====================
        UIButton *addButton = [WidgetControl makeButton:nil andFont:nil andColor:nil andImage:[UIImage imageNamed:@"ico_plus"] andBackground:nil andHightlightBackground:nil];
        addButton.frame = CGRectMake(0, 0, 30, 30);
        [addButton addTarget:self action:@selector(didTapAdd) forControlEvents:UIControlEventTouchUpInside];
        
        /*UIButton *addButton = [WidgetControl makePersonalBarButton];
        [addButton setTitle:@"Toevoegen" forState:UIControlStateNormal];
        addButton.frame = CGRectMake(0, 0, 60, 30);
        [addButton addTarget:self action:@selector(didTapAdd) forControlEvents:UIControlEventTouchUpInside];*/
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:addButton] autorelease];
        
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    User *user = [User instance];
    Event *event = [Event instance];
    if([user.page isEqualToString:@"addevent"]){
        [self presentSemiViewController:showPopUpEvent andHeight:192];
    }   
    [self reloadData];
    self.title = event._name;
}
-(void)loadData
{
    Event *event = [Event instance];
    Entry *entry = [Entry instance];
    listData = [[NSMutableArray alloc ] init ];
    listData = [entry getDatasWS:event._id];
}
-(void) reloadData
{
    Event *event = [Event instance];
    self.title = event._name;
    [self loadData];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    showPopUpEvent = [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];
    User *user = [User instance];
    if([user.page isEqualToString:@"addevent"]){
        showPopUpEvent.arrayContent = [NSArray arrayWithObjects:@"Evenement", @"Naam evenement", @"", @"Omschrijving", @"Omschrijving evenement", @"", @"Toevoegen", nil];
        //[showPopUp.submitButton setTitle:@"Save Event" forState:UIControlStateNormal];
        //user.page = @"addentry";
    } 
    //[self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
    EntriesCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[EntriesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSString *value = [listData objectAtIndex:[indexPath row]];
    NSLog(@" string entry %@", value);
    NSArray *column = [value componentsSeparatedByString:@"#"];
    
    NSString *date = [column objectAtIndex:1];
    NSLog( @"date %@",date);
    cell.labelDate.text = date;
    cell.labelTitle.text = [column objectAtIndex:3];
    cell.labelPrice.text = [NSString stringWithFormat:@"€ %@",[column objectAtIndex:2]];
    cell.labelPerson.text = [NSString stringWithFormat:@"%@ x",[column objectAtIndex:5]];
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entry *entry = [Entry instance];
    Event *event = [Event instance];
    NSString *value = [listData objectAtIndex:[indexPath row]];
    NSArray *column = [value componentsSeparatedByString:@"#"];
    entry._id = [[column objectAtIndex:0] intValue];
    
    EntryDetailViewController *detailViewController = [[EntryDetailViewController alloc] init];
    detailViewController.title = event._name;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

@end
