//
//  CheckoutDetailViewController.m
//  Test
//
//  Created by Tonny Dam on 10/16/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "CheckoutDetailViewController.h"
#import "CheckoutDetailCell.h"
#import "WidgetControl.h"
#import "Checkout.h"
#import "Event.h"
@interface CheckoutDetailViewController ()

@end

@implementation CheckoutDetailViewController

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
    // ======================== ||
    // // Back Bar Button
    // ======================== ||
    
    UIButton *backButton = [WidgetControl makePersonalBackBarButton];
    backButton.frame = CGRectMake(0, 0, 80, 30);
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"History" forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self loadData];
}
-(void) loadData
{
    listData = [[NSMutableArray alloc] init ];
    listItems = [[[NSMutableArray alloc] init ] retain];
    Checkout *checkout = [Checkout instance];
    NSMutableArray *datas = [checkout getDetailWS:checkout._id];
    int number=0;
    int user_id = 0;
    
    //get receive
    for(int i=0;i<[datas count]; i++)
    {
        NSString *value = [datas objectAtIndex:i];
        NSLog(value);
        NSArray *column = [value componentsSeparatedByString:@"#"];
        if(user_id != [[column objectAtIndex:0] intValue])
        {
            user_id = [[column objectAtIndex:0] intValue];
            NSString *item = [NSString stringWithFormat:@"%d#%@#%@#%@",[[column objectAtIndex:0] intValue], [column objectAtIndex:1], [column objectAtIndex:2],[column objectAtIndex:3] ];
            [listData addObject: item];
            number++;
        }
        NSMutableArray *obj = [[[NSMutableArray alloc] init ] retain];
        [listItems  addObject:obj];
        NSString *itemsub = [NSString stringWithFormat:@"%@#%@#%.02f#%d#0",[column objectAtIndex:7],[column objectAtIndex:6], [[column objectAtIndex:4] doubleValue], [[column objectAtIndex:5] intValue] ];
        [[listItems objectAtIndex:(number-1)] addObject:itemsub ];
    }
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
    //i is total items counted per cell
    int i = [[listItems objectAtIndex:[indexPath row]] count];
    return 52+(35*i);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CheckoutDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //if (cell == nil) {
        //NSArray *arrayItems = [NSArray arrayWithObjects:@"1#Marco#100#0#0", @"Kevin#50#1#1", @"Mark#50#1#0", nil];
        NSMutableArray *arrayItems = [listItems objectAtIndex:[indexPath row]];
        NSString *arrTitle = [listData objectAtIndex:[indexPath row]];
        cell = [[[CheckoutDetailCell alloc] initWithStyleArray:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andArray:arrayItems andTitle:arrTitle] autorelease];
        for (int i=0; i<[tableView numberOfRowsInSection:0]; i++) {
             [[cell viewWithTag:30+i] removeFromSuperview];
        }
        
    //}
    // Configure the cell...
    
    return cell;
}
@end
