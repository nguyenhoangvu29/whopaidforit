//
//  EntryDetailViewController.h
//  Test
//
//  Created by Tonny Dam on 10/10/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditEntryDetailViewController;

@interface EntryDetailViewController : UIViewController
{
    EditEntryDetailViewController * showPopUp;
}
@property(nonatomic)int paidForId;
@property(nonatomic,retain) NSMutableArray *arrayPerson;
@property(nonatomic,retain) NSString *selectPerson;
@property(nonatomic,retain) NSString *dateTextField;
@property(nonatomic,retain) NSString *desTextField;
@property(nonatomic,retain) NSString *priceTextField;
@property(nonatomic) BOOL accessEdit;

@property(nonatomic, retain) IBOutlet UIButton *buttonEdit;
@property(nonatomic, retain) IBOutlet UIButton *buttonDelete;
@property(nonatomic, retain) UILabel *priceLabel;
@property(nonatomic, retain) UILabel *desLabel;
@property(nonatomic, retain) UILabel *dateLabel;
@property(nonatomic, retain) UILabel *personPaid;
@property(nonatomic, retain) UIScrollView *scrollView;

-(IBAction)deleteEntry:(id)sender;

@end
