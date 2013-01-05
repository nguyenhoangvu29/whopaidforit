//
//  CheckoutViewController.m
//  Test
//
//  Created by Tonny Dam on 10/16/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "CheckoutViewController.h"
#import "CheckoutDetailViewController.h"
#import "CheckoutCell.h"
#import "WidgetControl.h"
#import "Checkout.h"
#import "User.h"
#import "Event.h"
#import "Helper.h"
@interface CheckoutViewController ()

@end

@implementation CheckoutViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    style = UITableViewStyleGrouped;
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [WidgetControl setPersonalStyle:self];
    }
    return self;
}
-(void) goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *backButton = [WidgetControl makePersonalBackBarButton];
    backButton.frame = CGRectMake(0, 0, 80, 30);
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Afrekenen" forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    [self loadData];
}
-(void)loadData
{
    Checkout *checkout = [Checkout instance];
    Event *event = [Event instance];
    listData = [checkout getDatasWS:event._id];
    
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
    
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CheckoutCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CheckoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell...
    NSString *value = [listData objectAtIndex:[indexPath row]];
    NSArray *column = [value componentsSeparatedByString:@"#"];
  
    //cell.stringDate.text = [helper convertDatetoString:[column objectAtIndex:1]];
    cell.stringDate.text = [column objectAtIndex:1];
    cell.stringPerson.text = [column objectAtIndex:2];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Checkout *checkout = [Checkout instance];
    
    NSString *value = [listData objectAtIndex:[indexPath row]];
    NSArray *column = [value componentsSeparatedByString:@"#"];
    checkout._id = [[column objectAtIndex:0] intValue];
    
    CheckoutDetailViewController *detailViewController = [[CheckoutDetailViewController alloc] init];
    detailViewController.title = [column objectAtIndex:1];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
     
}

@end
