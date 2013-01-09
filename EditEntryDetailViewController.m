//
//  EditEntryDetailViewController.m
//  Test
//
//  Created by Tonny Dam on 10/11/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "EditEntryDetailViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "PopUpViewController.h"
#import "WidgetControl.h"
#import "TKDragView.h"
#import "CPPickerView.h"
#import "Entry.h"
#define FORMAT_DATE @"dd-MM-yyyy"
#define ROUND_NUM @"€ %.02f"

@interface EditEntryDetailViewController () <UITextFieldDelegate, TKDragViewDelegate, CPPickerViewDataSource, CPPickerViewDelegate>
@property(nonatomic,retain) UIToolbar *keyboardToolbar;
@property(nonatomic,retain) NSArray *textFields;
@property(nonatomic,retain) UIDatePicker *datePicker;
@property (nonatomic, retain) TKDragView *dragView;
@property (nonatomic, retain) NSMutableArray *dragViews;
@property BOOL dragFlag;

@end

@implementation EditEntryDetailViewController
@synthesize arrayPersons, selectPerson, selectPersonId, paidForId, keyboardToolbar, textFields, dragView, dragViews, dragFlag, dateTextField, desTextField, priceTextField, datePicker, scrollView, mailer;

- (void)reloadMoney {
    float a = [[[self.priceTextField.text stringByReplacingOccurrencesOfString:@"." withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@"."] floatValue];
    float totalPersons = 0;
    for (int i=0; i<self.arrayPersons.count; i++) {
        CPPickerView *itemCountPerson = (CPPickerView*)[self.view viewWithTag:3000+i];
        totalPersons = totalPersons + itemCountPerson.selectedItem;
    }
    float b = a/totalPersons;
    for (int i=0; i<self.arrayPersons.count; i++) {
        CPPickerView *itemCountPerson = (CPPickerView*)[self.view viewWithTag:3000+i];
        UILabel *itemPrice = (UILabel*)[self.view viewWithTag:2000+i];
        itemPrice.text = [WidgetControl formatCurrency:[NSString stringWithFormat:ROUND_NUM, b*(itemCountPerson.selectedItem)] addCurency:YES];
    }
    
}
-(void) receivedDataAddMember:(NSString *) name Email:(NSString *) email {
    NSMutableArray *listMember = [[NSMutableArray alloc] init ];
    Event *event = [Event instance];
    User *user = [User instance];
    listMember = [user getMemberByEventWS:event._id];
    NSMutableArray *arrPersons = [[NSMutableArray alloc] init ];
    for(int i=0;i<[listMember count];i++){
        NSString *value = [listMember objectAtIndex:i];
        NSArray *column = [value componentsSeparatedByString:@"#"];
        NSString *v= [NSString stringWithFormat:@"%@#%@#%@#%d",[column objectAtIndex:0],[column objectAtIndex:1],@"0.00",1];
        [arrPersons addObject:v];
    }
    self.arrayPersons = arrPersons;
    
    [self showGripUser];
    [self sendEmail:name Email:email];
}

- (void)showAddMember:(id)sender {
    User *user = [User instance];
    user.page = @"entryaddmember";
    showPopUp.arrayContent = [NSArray arrayWithObjects:@"Naam", @"Naam nieuw lid", @"", @"E-mail", @"E-mail adres nieuw lid", @"", @"Toevoegen", nil];
    [self presentSemiViewController:showPopUp andHeight:192];
}
- (void)setStyleForPrice:(UITextField *) textfield andActive:(BOOL) active {
    switch (active) {
        case NO:
            //edit style of Price
            textfield.textColor = [UIColor blackColor];
            textfield.userInteractionEnabled = NO;
            [[[textfield subviews] objectAtIndex:0] removeFromSuperview];
            break;
            
        default:
            //default style of Price
            textfield.userInteractionEnabled = YES;
            textfield.textColor = [UIColor colorWithPatternImage:[WidgetControl gradientImage:60 andTopColor:[UIColor colorWithRed:4/255.0f green:89/255.0f blue:162/255.0f alpha:1] andBottomColor:[UIColor colorWithRed:28/255.0f green:132/255.0f blue:222/255.0f alpha:1]]];
            
            CGSize priceLabelTextSize = [textfield.text sizeWithFont:textfield.font];
            CGFloat priceLabelWidth = priceLabelTextSize.width;
            CGFloat xeuroLabel = (textfield.frame.size.width - priceLabelWidth)/2 - 20;
            UILabel *euroLabel = [[UILabel alloc] initWithFrame:CGRectMake(xeuroLabel, 15, 30, 30)];
            [WidgetControl setLabelStyle:euroLabel andText:@"€" andTextAlignment:nil andFont:[UIFont fontWithName:@"Century Gothic" size:30] andTextColor:[UIColor colorWithRed:155/255.0f green:191/255.0f blue:227/255.0f alpha:1] andBackgroundColor:nil andShadowColor:[UIColor whiteColor] andShadowOffset:CGSizeMake(0, 0)];
            euroLabel.tag = 99;
            [textfield addSubview:euroLabel];
            [euroLabel release];
            break;
    }
}
- (void)closePopUp{
    UIViewController * parent = [self.view containingViewController];
    
    // ===========================
    // // Send to Parent's method
    // ============================
    //check input before submit
    if(self.paidForId == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Boekingen" 
                                                        message:@"Sleep gebruiker die deze rekening betaalt naar het 'Betaald door' vlak."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
            //ios5+
            //use this for entriesdetails
            Entry *entry = [Entry instance];
            for (int i=0; i<self.arrayPersons.count; i++) {
                NSString *value= [self.arrayPersons objectAtIndex:i];
                NSArray *column = [value componentsSeparatedByString:@"#"];
                int _id = [[column objectAtIndex:0] intValue];
                UILabel *textPerson = (UILabel*)[self.view viewWithTag:_id];
                UILabel *textPrice = (UILabel*)[self.view viewWithTag:2000+i];
                CPPickerView *currentPicker = (CPPickerView*)[self.view viewWithTag:3000+i];
                NSString *stringObj = [NSString stringWithFormat:@"%d#%@#%@#%d", _id, textPerson.text, [textPrice.text stringByReplacingOccurrencesOfString:@"€ " withString:@""], currentPicker.selectedItem];
                [self.arrayPersons removeObjectAtIndex:i];
                [self.arrayPersons insertObject:stringObj atIndex:i];
            };
            if (entry._id > 0 ) { // edit entry
                //NSLog([[parent.childViewControllers objectAtIndex:1] viewControllers] );
                [[[[[[parent.childViewControllers objectAtIndex:0] viewControllers] objectAtIndex:1] viewControllers] objectAtIndex:1]  performSelector:@selector(receivedDataEdit)];
            }else {
                [[[[[[parent.childViewControllers objectAtIndex:0] viewControllers] objectAtIndex:1] viewControllers] objectAtIndex:0] performSelector:@selector(receivedData)];
            }    
            
            
        } else {
            //ios4
            for (id obj in [parent.parentViewController childViewControllers]) {
                NSString *stringOfObj = NSStringFromClass([[[obj viewControllers] objectAtIndex:0] class]);
                
                if ([stringOfObj isEqualToString:@"EntriesViewController"]) {
                    for (int i=0; i<self.arrayPersons.count; i++) {
                        NSString *value= [self.arrayPersons objectAtIndex:i];
                        NSArray *column = [value componentsSeparatedByString:@"#"];
                        int _id = [[column objectAtIndex:0] intValue];
                        UILabel *textPerson = (UILabel*)[self.view viewWithTag:_id];
                        UILabel *textPrice = (UILabel*)[self.view viewWithTag:2000+i];
                        CPPickerView *currentPicker = (CPPickerView*)[self.view viewWithTag:3000+i];
                        NSString *stringObj = [NSString stringWithFormat:@"%d#%@#%@#%d", _id, textPerson.text, [textPrice.text stringByReplacingOccurrencesOfString:@"€ " withString:@""], currentPicker.selectedItem];
                        [self.arrayPersons removeObjectAtIndex:i];
                        [self.arrayPersons insertObject:stringObj atIndex:i];
                    };
                    Entry *entry = [Entry instance];
                    if (entry._id > 0 ) { // edit entry
                        [[[obj viewControllers] objectAtIndex:1] performSelector:@selector(receivedDataEdit)];
                        [[[obj viewControllers] objectAtIndex:0] performSelector:@selector(reloadData)];
                    }else{
                        [[[obj viewControllers] objectAtIndex:0] performSelector:@selector(receivedData)];
                    }
                }
                
            }
            
        }
        if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
            [parent dismissSemiModalView];
        }
    }
}

-(void) deleteEntry
{
    UIViewController * parent = [self.view containingViewController];
    [[[[[[parent.childViewControllers objectAtIndex:0] viewControllers] objectAtIndex:1] viewControllers] objectAtIndex:1]  performSelector:@selector(deleteEntry)];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalView];
    }
}

- (void)hideKeyBoardByButton {
    for (UITextField *t in self.textFields) {
        if ([t isEditing]) {
            [self textFieldShouldReturn:t];
        }
    }
    [self hideDatePicker];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    //hide for keyboard
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(resizeSemiView:)]) {
        [parent resizeSemiView:CGSizeMake(320, 390)];
    }
    [textField resignFirstResponder];   
    [self hideDatePicker];
    return YES;
}
-(void) datePickerValueChanged {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:FORMAT_DATE];
    self.dateTextField.text = [df stringFromDate:self.datePicker.date];
    [df release];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //show for keyboard
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(resizeSemiView:)]) {
        [parent resizeSemiView:CGSizeMake(320, 460)];
    }
    if (textField == [self.view viewWithTag:150]) {
        //act for Price
        [self setStyleForPrice:textField andActive:NO];
        //add toolbar
        [textField setInputAccessoryView:self.keyboardToolbar];
    }
    if (textField == self.dateTextField) {
        [self showDatePicker];
        return NO;
    }
    return YES;
}
-(void)hideDatePicker{
    [self.datePicker.superview setHidden:YES];
    //hide for keyboard
    
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(resizeSemiView:)]) {
        [parent resizeSemiView:CGSizeMake(320, 390)];
    }
    
}
-(void)showDatePicker{
    
    for (UITextField *t in self.textFields) {
        if ([t isEditing]) {
            [t resignFirstResponder];
        }
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:FORMAT_DATE];
    self.datePicker.date = [dateFormat dateFromString:self.dateTextField.text];
    [dateFormat release];
    
    [self.datePicker.superview setHidden:NO];
    [[[self.datePicker.superview subviews] objectAtIndex:1] setHidden:NO];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField == [self.view viewWithTag:150]) {
        //act for Price
        [self reloadMoney];
        [self setStyleForPrice:textField andActive:YES];
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 150) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"nl_NL"] autorelease];
        [formatter setLocale:locale];
        [formatter setCurrencySymbol:@""];
        [formatter setLenient:YES];
        [formatter setGeneratesDecimalNumbers:YES];
        NSString *replaced = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSDecimalNumber *amount = (NSDecimalNumber*) [formatter numberFromString:replaced];
        
        if (amount == nil) {
            // Something screwed up the parsing. Probably an alpha character.
            return NO;
        }
        
        // If the field is empty (the inital case) the number should be shifted to
        // start in the right most decimal place.
        short powerOf10 = 0;
        if ([textField.text isEqualToString:@""]) {
            powerOf10 = -formatter.maximumFractionDigits;
        }
        // If the edit point is to the right of the decimal point we need to do
        // some shifting.
        else if (range.location + formatter.maximumFractionDigits >= textField.text.length) {
            // If there's a range of text selected, it'll delete part of the number
            // so shift it back to the right.
            if (range.length) {
                powerOf10 = -range.length;
            }
            // Otherwise they're adding this many characters so shift left.
            else {
                powerOf10 = [string length];
            }
        }
        amount = [amount decimalNumberByMultiplyingByPowerOf10:powerOf10];
        
        // Replace the value and then cancel this change.
        textField.text = [[formatter stringFromNumber:amount] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [formatter release];
        return NO;
    } else {
        return YES;
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewDidAppear:(BOOL)animated{
    UILabel *currencyLabel = (UILabel*) [self.view viewWithTag:99];
    if (!currencyLabel.text) {
        [self setStyleForPrice:(UITextField*)[self.view viewWithTag:150] andActive:YES];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    showPopUp = [[PopUpViewController alloc] initWithNibName:@"PopUpViewController" bundle:nil];

 
    
    #pragma -mark define toolbar for keyboard
    self.keyboardToolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    self.keyboardToolbar.barStyle=UIBarStyleBlackTranslucent;
    [self.keyboardToolbar sizeToFit];
    
    NSArray *barItems = [NSArray arrayWithObjects:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease], [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyBoardByButton)] autorelease], nil];
    
    [self.keyboardToolbar setItems:barItems animated:YES];
    
    UIView *bgTopView = (UIView *) [self.view viewWithTag:100];
    bgTopView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgtb"]];
    
    UIImageView *bgRedLabel = (UIImageView *) [self.view viewWithTag:110];
    bgRedLabel.image = [UIImage imageNamed:@"redlabel"];
    
    // ===============
    // // Button Edit
    // ===============
    UIButton *buttonEdit = (UIButton *) [self.view viewWithTag:200];
    [buttonEdit addTarget:self action:@selector(closePopUp) forControlEvents:UIControlEventTouchUpInside];
    
    // ===============
    // // Button Delete
    // ===============
    UIButton *buttonDelete = (UIButton *) [self.view viewWithTag:250];
    [buttonDelete addTarget:self action:@selector(deleteEntry) forControlEvents:UIControlEventTouchUpInside];
    //if (!self.selectPerson) {
        [buttonDelete removeFromSuperview];
    //}
    
    #pragma -mark define Person, Price, Des, ...
    
    UILabel *personPaid = (UILabel *) [self.view viewWithTag:120];
    [WidgetControl setLabelStyle:personPaid andText:self.selectPerson andTextAlignment:nil andFont:nil andTextColor:nil andBackgroundColor:nil andShadowColor:[UIColor colorWithRed:71/255.0f green:0 blue:0 alpha:1] andShadowOffset:CGSizeMake(0, 1)];
    
    self.dateTextField = (UITextField *) [self.view viewWithTag:130];
    self.dateTextField.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    self.dateTextField.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.dateTextField.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.dateTextField.layer.shadowOpacity = 1.0;
    self.dateTextField.layer.shadowRadius = 0.0;
    
    self.desTextField = (UITextField *) [self.view viewWithTag:140];
    self.desTextField.textColor = [UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:1];
    self.desTextField.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.desTextField.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.desTextField.layer.shadowOpacity = 1.0;
    self.desTextField.layer.shadowRadius = 0.0;
    
    self.priceTextField = (UITextField *) [self.view viewWithTag:150];
    self.priceTextField.font = [UIFont fontWithName:@"Century Gothic" size:50];
    self.priceTextField.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.priceTextField.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.priceTextField.layer.shadowOpacity = 1.0;
    self.priceTextField.layer.shadowRadius = 0.0;
    self.priceTextField.selected = NO;
    self.priceTextField.highlighted = NO;
    
    //collect textfields for button action
    self.textFields = [NSArray arrayWithObjects:self.dateTextField, self.desTextField, self.priceTextField, nil];
    
    // ===============
    // // DatePicker
    // ===============
    UIView *datePickerView = [[UIView alloc] initWithFrame:CGRectMake(0, 250, 320, 360)];
    UIToolbar *datePickerToolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)] autorelease];
    datePickerToolbar.barStyle=UIBarStyleBlackTranslucent;
    [datePickerToolbar sizeToFit];
    
    NSArray *barPickerItems = [NSArray arrayWithObjects:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease], [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideDatePicker)] autorelease], nil];
    
    [datePickerToolbar setItems:barPickerItems animated:YES];
    
    self.datePicker = [[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 320, 216)] autorelease];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [datePickerView addSubview:self.datePicker];
    [datePickerView addSubview:datePickerToolbar];
    [self.view addSubview:datePickerView];
    datePickerView.hidden = YES;
    [datePickerView release];
    
    [self showGripUser];
    
#pragma -mark Drag Area
    CGRect endFrame =   CGRectMake(110, 0, 100, 100);
    self.dragView = [[[TKDragView alloc] initWithImage:[UIImage imageNamed:@"ico_touch"] startFrame:CGRectMake(0, 0, 100, 100) endFrame:endFrame andDelegate:self] autorelease];
    self.dragView.alpha = 0;
    self.dragView.canDragMultipleDragViewsAtOnce = NO;
    self.dragView.canUseSameEndFrameManyTimes = YES;

    [self.dragViews addObject:self.dragView];
    [self.view addSubview:self.dragView];
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taped:)];
    [g setNumberOfTapsRequired:2];
    [self.dragView addGestureRecognizer:g];
    [g release];
}

-(void)showGripUser
{
    //scroll view
    for(UIView *subview in [self.scrollView subviews]) {
        [subview removeFromSuperview];
        //NSLog(@"Subviews Count=%d",myScrollView.subviews.count);
    }
    self.scrollView = (UIScrollView *)[self.view viewWithTag:160];
    //number items per row
    int a=3;
    //number items per column
    int b=2;
    //total items + 1 for add item in last
    int c=[self.arrayPersons count]+1;
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
                UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(((p*d)+(n*e)), (m*f), e, f)];
                if (i == c-1) {
#pragma -mark define Last item
                    
                    UIButton *addMemberButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    addMemberButton.frame = CGRectMake(0, 0, e, f);
                    addMemberButton.backgroundColor = [UIColor colorWithRed:240/255.0f green:238/255.0f blue:238/255.0f alpha:1];
                    [addMemberButton setImage:[UIImage imageNamed:@"ico_plus"] forState:UIControlStateNormal];
                    addMemberButton.imageEdgeInsets = UIEdgeInsetsMake(-20, addMemberButton.frame.size.width/2-5, 0.0, 0.0);
                    addMemberButton.titleEdgeInsets = UIEdgeInsetsMake(10, -10, 0.0, 0.0);
                    addMemberButton.titleLabel.font = [UIFont fontWithName:@"Ubuntu Condensed" size:16];
                    [addMemberButton setTitleColor:[UIColor colorWithRed:158/255.0f green:158/255.0f blue:158/255.0f alpha:1] forState:UIControlStateNormal];
                    addMemberButton.titleLabel.shadowOffset = CGSizeMake(0, 2);
                    [addMemberButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    [addMemberButton setTitle:@"Lid toevoegen" forState:UIControlStateNormal];
                    [addMemberButton addTarget:self action:@selector(showAddMember:) forControlEvents:UIControlEventTouchUpInside];
                    [itemView addSubview:addMemberButton];
                    
                } else {
                    NSArray *arrayInEachPerson = [[self.arrayPersons objectAtIndex:i] componentsSeparatedByString:@"#"];
                    //define padding
                    int p = 15;
                    UITapGestureRecognizer *singleFingerTap =
                    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
                    //create rightline
                    UIView *lineGray = [[UIView alloc] initWithFrame:CGRectMake(e-2-p, p, 2, f-(p*2))];
                    lineGray.backgroundColor = [UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:224/255.0f];
                    [itemView addSubview:lineGray];
                    [lineGray release];
                    
                    //create itemprice
                    UILabel *itemPrice = [[UILabel alloc] initWithFrame:CGRectMake(0, p, e-10-p, 20)];
                    itemPrice.tag = 2000+i;
                    [WidgetControl setLabelStyle:itemPrice andText:[NSString stringWithFormat:@"€ %@", [arrayInEachPerson objectAtIndex:2]] andTextAlignment:@"right" andFont:[UIFont fontWithName:@"Century Gothic" size:19] andTextColor:[UIColor colorWithRed:15/255.0f green:131/255.0f blue:231/255.0f alpha:1] andBackgroundColor:nil andShadowColor:nil andShadowOffset:CGSizeMake(0, 0)];
                    itemPrice.minimumFontSize = 5;
                    itemPrice.adjustsFontSizeToFitWidth = YES;
                    [itemView addSubview:itemPrice];
                    [itemPrice release];
                    
                    //create itemperson
                    UILabel *itemPerson = [[UILabel alloc] initWithFrame:CGRectMake(0, p+20, e-10-p, 20)];
                    
                    [WidgetControl setLabelStyle:itemPerson andText:[arrayInEachPerson objectAtIndex:1] andTextAlignment:@"right" andFont:[UIFont boldSystemFontOfSize:15] andTextColor:[UIColor colorWithRed:79/255.0f green:79/255.0f blue:79/255.0f alpha:1] andBackgroundColor:nil andShadowColor:nil andShadowOffset:CGSizeMake(0, 0)];
                    
                    itemPerson.userInteractionEnabled = YES;
                    //itemPerson.tag = 1000+i;
                    itemPerson.tag = [[arrayInEachPerson objectAtIndex:0] intValue];
                    [itemPerson addGestureRecognizer:singleFingerTap];
                    
                    [itemView addSubview:itemPerson];
                    [itemPerson release];
                    
                    CPPickerView *itemCountPerson = [[CPPickerView alloc] initWithFrame:CGRectMake(0, p+42, e-p, 30)];
                    itemCountPerson.backgroundColor = [UIColor clearColor];
                    itemCountPerson.dataSource = self;
                    itemCountPerson.delegate = self;
                    itemCountPerson.tag = 3000+i;
                    itemCountPerson.itemFont = [UIFont systemFontOfSize:15];
                    itemCountPerson.itemColor = [UIColor grayColor];
                    itemCountPerson.peekInset = UIEdgeInsetsMake(-10, 0, 0, 0);
                    
                    itemCountPerson.selectedItem = [[arrayInEachPerson objectAtIndex:3] intValue];
                    //[itemCountPerson reloadData];
                    [itemView addSubview:itemCountPerson];
                    
                    //create smallavatar
                    UIImageView *smallAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(e-25-p, p+45, 16, 16)];
                    smallAvatarView.image = [UIImage imageNamed:@"icons1"];
                    [smallAvatarView setAlpha:0.5];
                    [itemView addSubview:smallAvatarView];
                    [smallAvatarView release];
                    
                    UIImageView *swipeAvatarView = [[UIImageView alloc] initWithFrame:CGRectMake(e-60-p, p+60, 50, 16)];
                    swipeAvatarView.image = [UIImage imageNamed:@"swipe"];
                    [swipeAvatarView setAlpha:0.5];
                    [itemView addSubview:swipeAvatarView];
                    [swipeAvatarView release];
                    
                    [singleFingerTap release];
                }
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
#pragma mark - CPPickerViewDataSource
- (NSInteger)numberOfItemsInPickerView:(CPPickerView *)pickerView
{
    return 11;
}
- (NSString *)pickerView:(CPPickerView *)pickerView titleForItem:(NSInteger)item
{
    return [NSString stringWithFormat:@"%i x", item];
}
- (void)pickerView:(CPPickerView *)pickerView didSelectItem:(NSInteger)item{
    [self reloadMoney];
}
#pragma mark - TKDragViewDelegate
- (void) handleSingleTap: (UITapGestureRecognizer *)sender {
    UILabel *currentLabel = (UILabel*) sender.view;
    self.selectPerson = currentLabel.text;
    self.selectPersonId = currentLabel.tag;
    //NSLog(@"select person %d",self.selectPersonId);
    UIView *scrollViewTouch = (UIView*) sender.view.superview.superview;
    UIView *itemViewTouch = (UIView*) sender.view.superview;
    CGFloat x = itemViewTouch.frame.origin.x + itemViewTouch.frame.size.width/2 - self.dragView.frame.size.width/2;
    CGFloat y = itemViewTouch.frame.origin.y + itemViewTouch.frame.size.height/2 - self.dragView.frame.size.height/2 + scrollViewTouch.frame.origin.y;
    if (x > 320) x = x-320;
    self.dragView.frame = CGRectMake(x, y, self.dragView.frame.size.width, self.dragView.frame.size.height);
    self.dragView.startFrame = CGRectMake(x, y, self.dragView.frame.size.width, self.dragView.frame.size.height);
    
    self.dragView.alpha = 1;
    
    [self performSelector:@selector(returnAlpha) withObject:nil afterDelay:1];
}
- (void) returnAlpha {
    if (!self.dragFlag) {
        self.dragView.alpha = 0;
    }
}
- (void)dragViewDidStartDragging:(TKDragView *)dragView{
    [UIView animateWithDuration:0.2 animations:^{
        //dragView.transform = CGAffineTransformMakeScale(1.2, 1.2);
        self.dragFlag = YES;
    }];
}

- (void)dragViewDidEndDragging:(TKDragView *)dragView{
    self.dragFlag = NO;
}


- (void)dragViewDidEnterStartFrame:(TKDragView *)dragView{
    
    [UIView animateWithDuration:0.2 animations:^{
        //dragView.alpha = 0;
    }];
}

- (void)dragViewDidLeaveStartFrame:(TKDragView *)dragView{
    
    [UIView animateWithDuration:0.2 animations:^{
        //dragView.alpha = 1.0;
    }];
}


- (void)dragViewDidEnterGoodFrame:(TKDragView *)dragView atIndex:(NSInteger)index{
    
    
    
    
}

- (void)dragViewDidLeaveGoodFrame:(TKDragView *)dragView atIndex:(NSInteger)index{

}


- (void)dragViewWillSwapToEndFrame:(TKDragView *)dragView atIndex:(NSInteger)index{
    
    
    
}

- (void)dragViewDidSwapToEndFrame:(TKDragView *)dragView atIndex:(NSInteger)index{
    self.dragView.alpha = 0;
    UILabel *label = (UILabel *) [self.view viewWithTag:120];
    label.text = self.selectPerson;
    paidForId = selectPersonId;
}


- (void)dragViewWillSwapToStartFrame:(TKDragView *)dragView{

}

- (void)dragViewDidSwapToStartFrame:(TKDragView *)dragView{
    [UIView animateWithDuration:0.2 animations:^{
        self.dragView.alpha = 0;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) sendEmail:(NSString *)name Email:(NSString *) email
{
    if ([MFMailComposeViewController canSendMail])
    {
        User *user =[User instance];
        Event *event = [Event instance];
        mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Uitnodiging om WhoPaidForIt te gebruiken"];
        NSArray *toRecipients = [NSArray arrayWithObjects:email, nil];
        [mailer setToRecipients:toRecipients];
        //UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
        //NSData *imageData = UIImagePNGRepresentation(myImage);
        //[mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
        NSString *emailBody = [NSString stringWithFormat:@"<p>Beste %@,</p><p>%@ nodigt u uit om de WhoPaidForIt app te downloaden en te participeren in het Event %@.</p><p>Met de WhoPaidForIt app administreert u snel en eenvoudig gezamenlijke uitgaven. De app verrekent vervolgens de gezamenlijke kosten naar kosten per deelnemer aan een event.</p><br/><p>[Logo Apple AppStore link to whopaidforit app]<br/>[Logo Google Play Store link to whopaidforit app]</p>",name,user._name, event._name ];
        [mailer setMessageBody:emailBody isHTML:YES];
        [self presentModalViewController:mailer animated:YES];
        [mailer release];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
