//
//  CheckoutController.m
//  Test
//
//  Created by user on 11/1/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "CheckoutController.h"
#import "CheckoutDetailCell.h"
#import "CheckoutViewController.h"
#import "WidgetControl.h"
#import "Checkout.h"
#import "Event.h"
#import "User.h"
#import "NEventsViewController.h"

@implementation CheckoutController

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
-(void) addCheckout {
    Checkout *checkout = [Checkout instance];
    Event *event = [Event instance];
    User *user = [User instance];
    [checkout addCheckoutWS:user._id EventId:event._id ArrayExpenses:listData ArrayParticipate:listItems]; 
    [self goHistory];
}
-(void) goHistory{
    CheckoutViewController *detailViewController = [[CheckoutViewController alloc] init];
    detailViewController.title = @"Geschiedenis";
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // ======================== ||
    // // Back Bar Button
    // ======================== ||
    // ======================== ||
    // // Back Bar Button
    // ======================== ||
    UIButton *backButton = [WidgetControl makeButton:nil andFont:nil andColor:nil andImage:[UIImage imageNamed:@"icon-list"] andBackground:nil andHightlightBackground:nil];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    /*UIButton *backButton = [WidgetControl makePersonalBackBarButton];
    backButton.frame = CGRectMake(0, 0, 80, 30);
    [backButton addTarget:self action:@selector(addCheckout) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"Checkout" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    UIButton *historyButton = [WidgetControl makePersonalBackBarButton];
    historyButton.frame = CGRectMake(0, 0, 80, 30);
    [historyButton addTarget:self action:@selector(goHistory) forControlEvents:UIControlEventTouchUpInside];
    [historyButton setTitle:@"Geschiedenis" forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:historyButton] autorelease];
    */
}

- (void)viewDidAppear:(BOOL)animated
{
    [self reloadData];
}

-(void) reloadData
{
    Event *event = [Event instance];
    if(event._id){
        [self loadData];
        [self.tableView reloadData];
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor whiteColor]; // change this color
        self.navigationItem.titleView = label;
        label.text = event._name;
        [label sizeToFit];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Afrekenen"
                                                        message:@"Please choose item before see checkout"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

-(void) loadData
{
    listData = [[NSMutableArray alloc] init ];
    listItems = [[[NSMutableArray alloc] init ] retain];
    Checkout *checkout = [Checkout instance];
    Event *event = [Event instance];
    NSMutableArray *datas = [checkout getCheckoutWS:event._id];
    int number = 0;
    int user_id = 0;
    
    //get receive
    for(int i=0;i<[datas count]; i++)
    {
        NSString *value = [datas objectAtIndex:i];
        NSArray *column = [value componentsSeparatedByString:@"#"];
        if(user_id != [[column objectAtIndex:1] intValue])
        {
            user_id = [[column objectAtIndex:1] intValue];
            [listData addObject:[NSString stringWithFormat:@"%d#%@#%@#%d",[[column objectAtIndex:1] intValue], [column objectAtIndex:2], [column objectAtIndex:4],1] ];
            number++;
        }else 
        {
            NSString *value = [listData objectAtIndex:(number-1)];
            NSArray *columnValue = [value componentsSeparatedByString:@"#"];
            double amount = [[columnValue objectAtIndex:2] doubleValue];
            amount +=  [[column objectAtIndex:4] doubleValue];
            value = [NSString stringWithFormat:@"%d#%@#%.02f#%d",[[column objectAtIndex:1] intValue], [column objectAtIndex:2], amount,1];
            [listData replaceObjectAtIndex:(number-1) withObject:value];
        }
        NSMutableArray *obj = [[[NSMutableArray alloc] init ] retain];
        [listItems  addObject:obj];
        [[listItems objectAtIndex:(number-1)] addObject:[NSString stringWithFormat:@"%d#%@#%@#1#0",[[column objectAtIndex:6] intValue],[column objectAtIndex:3], [column objectAtIndex:4] ] ];
    }
    
    //get paid
    for(int i=0;i<[datas count]; i++)
    {
        NSString *value = [datas objectAtIndex:i];
        NSArray *column = [value componentsSeparatedByString:@"#"];
        user_id = [[column objectAtIndex:6] intValue];
        BOOL flag = TRUE;
        for(int t =0;t<[listData count];t++)
        {
            NSString *valueItem = [listData objectAtIndex:t];
            NSArray *columnItem = [valueItem componentsSeparatedByString:@"#"];
            if(user_id == [[columnItem objectAtIndex:0] intValue])
            {
                flag = FALSE;
                double amount = [[columnItem objectAtIndex:2] doubleValue];
                amount -=  [[column objectAtIndex:4] doubleValue];
                if(amount > 0)
                {
                    value = [NSString stringWithFormat:@"%d#%@#%.02f#%d",[[columnItem objectAtIndex:0] intValue], [columnItem objectAtIndex:1], amount,1];
                }else {
                    value = [NSString stringWithFormat:@"%d#%@#%.02f#%d",[[columnItem objectAtIndex:0] intValue], [columnItem objectAtIndex:1], amount,0];
                }
                [listData replaceObjectAtIndex:t withObject:value];
                [[listItems objectAtIndex:t] addObject:[NSString stringWithFormat:@"%d#%@#%@#0#0",[[column objectAtIndex:1] intValue],[column objectAtIndex:2], [column objectAtIndex:4] ] ];
            }
        }
        if(flag == TRUE)
        {
            double amount = [[column objectAtIndex:4] doubleValue];
            amount = -amount;
            [listData addObject:[NSString stringWithFormat:@"%d#%@#%.02f#%d",[[column objectAtIndex:6] intValue], [column objectAtIndex:3], amount,0] ];
            NSMutableArray *obj = [[[NSMutableArray alloc] init ] retain];
            [listItems  addObject:obj];
            [[listItems objectAtIndex:number] addObject:[NSString stringWithFormat:@"%d#%@#%@#0#0",[[column objectAtIndex:1] intValue],[column objectAtIndex:2], [column objectAtIndex:4] ] ];
            number++;
        }
    }
    // group by listItems
    for(int i=0;i<[listItems count];i++)
    {
        NSMutableArray *items = [listItems objectAtIndex:i];
        for(int t = 0;t <[items count]; t++)
        {
            NSString *value = [items objectAtIndex:t];
            NSArray *column = [value componentsSeparatedByString:@"#"];
            for(int n = t+1;n<[items count]; n++)
            {
                NSString *valueNext = [items objectAtIndex:n];
                NSArray *columnNext = [valueNext componentsSeparatedByString:@"#"];
                if( [[column objectAtIndex:0] intValue] == [[columnNext objectAtIndex:0] intValue] )
                {
                    double amount = 0;
                    int num = 1; 
                    if([[column objectAtIndex:3] intValue] == [[columnNext objectAtIndex:3] intValue])
                    {
                        amount = [[column objectAtIndex:2] doubleValue] + [[columnNext objectAtIndex:2] doubleValue];
                    }else{
                        amount = [[column objectAtIndex:2] doubleValue] - [[columnNext objectAtIndex:2] doubleValue];
                    }
                    if(amount < 0 ){
                        amount = -amount;
                        num = 0;
                    }
                    NSString *newValue = [NSString stringWithFormat:@"%d#%@#%.02f#%d#0",[[column objectAtIndex:0] intValue], [column objectAtIndex:1], amount, num];
                    [[listItems objectAtIndex:i] replaceObjectAtIndex:t withObject:newValue];
                    [[listItems objectAtIndex:i] removeObjectAtIndex:n];
                }
            }
        }
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
        NSMutableArray *arrayItems = [listItems objectAtIndex:[indexPath row]];
        NSString *arrTitle = [listData objectAtIndex:[indexPath row]];
        cell = [[[CheckoutDetailCell alloc] initWithStyleArray:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier andArray:arrayItems andTitle:arrTitle] autorelease];
        for (int i=0; i<[tableView numberOfRowsInSection:0]; i++) {
            [[cell viewWithTag:30+i] removeFromSuperview];
        }
        
    //}
    return cell;
}

-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
   self.tabBarController.selectedIndex = 0;
}
-(void) goBack {
    self.tabBarController.selectedIndex = 1;
}
@end
