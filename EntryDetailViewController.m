//
//  EntryDetailViewController.m
//  Test
//
//  Created by Tonny Dam on 10/10/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "EntryDetailViewController.h"
#import "WidgetControl.h"
#import "EditEntryDetailViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "WidgetControl.h"
#import "User.h"
#import "Event.h"
#import "Entry.h"
#import "Participate.h"

@interface EntryDetailViewController ()

@end

@implementation EntryDetailViewController

@synthesize arrayPerson, selectPerson, dateTextField, desTextField, priceTextField, paidForId;
@synthesize priceLabel, desLabel, dateLabel, personPaid, scrollView;
- (void) clickButtonEdit {
    showPopUp.arrayPersons = self.arrayPerson;
    showPopUp.selectPerson = self.selectPerson;
    [self presentSemiViewController:showPopUp andHeight:390];
    showPopUp.dateTextField.text = self.dateTextField;
    showPopUp.desTextField.text = self.desTextField;
    showPopUp.priceTextField.text = self.priceTextField;
    showPopUp.paidForId = self.paidForId;
    [showPopUp viewDidAppear:YES];
}
-(void) receivedDataEdit {
    User *user = [User instance];
    Event *event = [Event instance];
    Entry *entry = [Entry instance];
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
    [entry updateEntryWS:entry._id UserId:user._id Amount:showPopUp.priceTextField.text Description:showPopUp.desTextField.text DateExpenses:showPopUp.dateTextField.text eventId:event._id paidFor:showPopUp.paidForId ParticipantStr:result];
    
    [self loadData];
    [self reloadData];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(semiModalDismissed:) name:kSemiModalDidHideNotification object:nil];
        
        // ================
        // // Init Data
        // ================
        [self loadData];
    }
    return self;
}
-(void) loadData
{
    Helper *helper = [Helper instance];
    User *user = [User instance];
    Event *event = [Event instance];
    Entry *entry = [Entry instance];
    Participate *participate = [Participate instance];
    NSString *data = [entry getDetailWS:entry._id];
    NSMutableArray *listParticipate = [participate getDatasWS:entry._id];
    NSArray *detail = [data componentsSeparatedByString:@"#"];
    double amountPerOne = [[detail objectAtIndex:2] doubleValue] / [[detail objectAtIndex:5] doubleValue];
    NSMutableArray *listMember = [user getMemberByEventWS:event._id];
    NSMutableArray *arrPersons = [[NSMutableArray alloc] init ];
    NSString *price = @"";
    for(int i=0;i<[listMember count];i++){
        int num = 0;
        NSString *value = [listMember objectAtIndex:i];
        NSArray *column = [value componentsSeparatedByString:@"#"];
        for(int j=0;j<[listParticipate count];j++){
            
            NSString *valuePar = [listParticipate objectAtIndex:j];
            NSArray *columnPar = [valuePar componentsSeparatedByString:@"#"];
            if([[column objectAtIndex:0] intValue] == [[columnPar objectAtIndex:0] intValue])
            {
                num = [[columnPar objectAtIndex:2] intValue];
            }
        }
        price = [helper stringToMoney:(amountPerOne * num)];
        NSString *v= [NSString stringWithFormat:@"%@#%@#%@#%d",[column objectAtIndex:0],[column objectAtIndex:1],price,num];
        [arrPersons addObject:v];
    }
    self.arrayPerson = arrPersons;
    self.dateTextField = [detail objectAtIndex:1];
    self.desTextField = [detail objectAtIndex:3];
    NSString *money = [helper stringToMoney:[[detail objectAtIndex:2] doubleValue]];
    self.priceTextField = money;
    self.selectPerson = [detail objectAtIndex:4];
    self.paidForId = [[detail objectAtIndex:6] intValue];
}
-(void) reloadData
{
    self.dateLabel.text = self.dateTextField;
    self.priceLabel.text = self.priceTextField;
    self.personPaid.text = self.selectPerson;
    self.desLabel.text = self.desTextField;
    [self updateMemberList];
}
- (void)semiModalDismissed:(NSNotification *) notification {
    if ([[notification object] isKindOfClass:[self class]]) {
        if (showPopUp.view.subviews.count>3) {
            [showPopUp dismissSemiModalView];
        }
    }
}
-(void) goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    showPopUp = [[EditEntryDetailViewController alloc] initWithNibName:@"EditEntryDetailViewController" bundle:nil];
    
    // ======================== ||
    // // Back Bar Button
    // ======================== ||
    UIButton *backButton = [WidgetControl makeButton:nil andFont:nil andColor:nil andImage:[UIImage imageNamed:@"icon-list"] andBackground:nil andHightlightBackground:nil];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    /*UIButton *backButton = [WidgetControl makePersonalBackBarButton];
    backButton.frame = CGRectMake(0, 0, 60, 30);
    [backButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:self.parentViewController.title forState:UIControlStateNormal];*/
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    
    // ======================== ||
    // // View Controller
    // ======================== ||
    
    UIView *bgTopView = (UIView *) [self.view viewWithTag:100];
    bgTopView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtb"]];
    
    UIImageView *bgRedLabel = (UIImageView *) [self.view viewWithTag:110];
    bgRedLabel.image = [UIImage imageNamed:@"redlabel"];
    
    UIButton *buttonEdit = (UIButton *) [self.view viewWithTag:200];
    [buttonEdit addTarget:self action:@selector(clickButtonEdit) forControlEvents:UIControlEventTouchUpInside];
    
    personPaid = (UILabel *) [self.view viewWithTag:120];
    [WidgetControl setLabelStyle:personPaid andText:self.selectPerson andTextAlignment:nil andFont:nil andTextColor:nil andBackgroundColor:nil andShadowColor:[UIColor colorWithRed:71/255.0f green:0 blue:0 alpha:1] andShadowOffset:CGSizeMake(0, 1)];
    
    dateLabel = (UILabel *) [self.view viewWithTag:130];
    [WidgetControl setLabelStyle:dateLabel andText:self.dateTextField andTextAlignment:nil andFont:nil andTextColor:[UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1] andBackgroundColor:nil andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(0, 1)];
    
    desLabel = (UILabel *) [self.view viewWithTag:140];
    [WidgetControl setLabelStyle:desLabel andText:self.desTextField andTextAlignment:nil andFont:nil andTextColor:[UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:1] andBackgroundColor:nil andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(0, 1)];
    
    priceLabel = (UILabel *) [self.view viewWithTag:150];
    [WidgetControl setLabelStyle:priceLabel andText:self.priceTextField andTextAlignment:nil andFont:[UIFont fontWithName:@"Century Gothic" size:50] andTextColor:[UIColor colorWithPatternImage:[WidgetControl gradientImage:50 andTopColor:[UIColor colorWithRed:4/255.0f green:89/255.0f blue:162/255.0f alpha:1] andBottomColor:[UIColor colorWithRed:28/255.0f green:132/255.0f blue:222/255.0f alpha:1]]] andBackgroundColor:nil andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(1, 1)];
    
    CGSize priceLabelTextSize = [priceLabel.text sizeWithFont:priceLabel.font];
    CGFloat priceLabelWidth = priceLabelTextSize.width;
    CGFloat xeuroLabel = (priceLabel.frame.size.width - priceLabelWidth)/2 - 20;
    UILabel *euroLabel = [[UILabel alloc] initWithFrame:CGRectMake(xeuroLabel, 15, 30, 30)];
    [WidgetControl setLabelStyle:euroLabel andText:@"€" andTextAlignment:nil andFont:[UIFont fontWithName:@"Century Gothic" size:30] andTextColor:[UIColor colorWithRed:155/255.0f green:191/255.0f blue:227/255.0f alpha:1] andBackgroundColor:nil andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(0, 1)];
    [priceLabel addSubview:euroLabel];
    [euroLabel release];
    
    // ======================== ||
    // // Scroll View
    // ======================== ||
    [self updateMemberList];
    
}
-(void) updateMemberList
{
    scrollView = (UIScrollView *)[self.view viewWithTag:160];
    for (id obj in scrollView.subviews) {
        [obj removeFromSuperview];
    }
    //number items per row
    int a=3;
    //number items per column
    int b=2;
    //total items
    int c=self.arrayPerson.count;
    //width of scrollView
    int d=scrollView.frame.size.width;
    //height of scrollView
    int d2=scrollView.frame.size.height;
    //width of an item
    int e=d/a;
    //height of an item
    int f=d2/b;
    int i=0;
    int numPages = ceil(1.0f*c/(a*b));
    for (int p=0; p<numPages; p++) {
        for (int m=0; m<b; m++) {
            for (int n=0; n<a && i<c; n++) {
                NSArray *arrayObj = [[self.arrayPerson objectAtIndex:i] componentsSeparatedByString:@"#"];
                UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(((p*d)+(n*e)), (m*f), e, f)];
                //define padding
                int p = 15;
                //create rightline
                UIView *lineGray = [[UIView alloc] initWithFrame:CGRectMake(e-2-p, p, 2, f-(p*2))];
                lineGray.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:224/255.0f];
                [itemView addSubview:lineGray];
                [lineGray release];
                
                //create smallavatar
                UIImageView *smallAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(e-25-p, p+45, 16, 16)];
                smallAvatarView.image = [UIImage imageNamed:@"icons1"];
                [smallAvatarView setAlpha:0.5];
                [itemView addSubview:smallAvatarView];
                [smallAvatarView release];
                
                //create itemprice
                UILabel *itemPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, p, e-10-p, 20)];
                //NSString *price
                [WidgetControl setLabelStyle:itemPrice andText:[NSString stringWithFormat:@"€ %@",[arrayObj objectAtIndex:2]] andTextAlignment:@"right" andFont:[UIFont fontWithName:@"Century Gothic" size:19] andTextColor:[UIColor colorWithRed:15/255.0f green:131/255.0f blue:231/255.0f alpha:1] andBackgroundColor:nil andShadowColor:nil andShadowOffset:CGSizeMake(0, 0)];
                [itemView addSubview:itemPrice];
                [itemPrice release];
                
                //create itemperson
                UILabel *itemPerson = [[UILabel alloc] initWithFrame:CGRectMake(0, p+20, e-10-p, 20)];
                [WidgetControl setLabelStyle:itemPerson andText:[arrayObj objectAtIndex:1] andTextAlignment:@"right" andFont:[UIFont boldSystemFontOfSize:15] andTextColor:[UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:1] andBackgroundColor:nil andShadowColor:nil andShadowOffset:CGSizeMake(0, 0)];
                [itemView addSubview:itemPerson];
                [itemPerson release];
                
                //create countperson
                UILabel *itemCountPerson = [[UILabel alloc] initWithFrame:CGRectMake(0, p+42, e-30-p, 20)];
                [WidgetControl setLabelStyle:itemCountPerson andText:[NSString stringWithFormat:@"%@ x", [arrayObj objectAtIndex:3]] andTextAlignment:@"right" andFont:[UIFont systemFontOfSize:15] andTextColor:[UIColor grayColor] andBackgroundColor:nil andShadowColor:nil andShadowOffset:CGSizeMake(0, 0)];
                [itemView addSubview:itemCountPerson];
                [itemCountPerson release];
                
                [scrollView addSubview:itemView];
                [itemView release];
                i++;
            }
        }
    }
    scrollView.contentSize = CGSizeMake(d*(numPages), d2);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) dealloc {
    [super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
