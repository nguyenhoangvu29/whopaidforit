//
//  TabBarViewController.m
//  Test
//
//  Created by Tonny Dam on 10/9/12.
//  Copyright (c) 2012 Tonny Dam. All rights reserved.
//

#import "TabBarViewController.h"
#import "MainViewController.h"
#import "EntriesViewController.h"
#import "MemberViewController.h"
#import "CheckoutController.h"
#import "AccountViewController.h"
#import "NEventsViewController.h"
#import "PPRevealSideViewController.h"
#import "WidgetControl.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)pushOldLeft:(id)sender {
    NEventsViewController *left = [[[NEventsViewController alloc] init] autorelease];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:left];
    
    [self.revealSideViewController setOption:PPRevealSideOptionsResizeSideView];
    
    [self.revealSideViewController setDirectionsToShowBounce:PPRevealSideDirectionNone];
    [self.revealSideViewController setPanInteractionsWhenClosed:PPRevealSideInteractionNone];
    [self.revealSideViewController setTapInteractionsWhenOpened:(PPRevealSideInteractionNavigationBar | PPRevealSideInteractionContentView)];
    
    [self.revealSideViewController pushViewController:nav onDirection:PPRevealSideDirectionLeft withOffset:80 animated:YES];
    [nav release];
    //[self.revealSideViewController pushOldViewControllerOnDirection:PPRevealSideDirectionLeft withOffset:80 animated:YES];
}

- (id) init
{
    self = [super init];
    if (self)
    {
        self.delegate = self;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //pick up personal style
        [WidgetControl setPersonalStyle:self];
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // ======================== ||
    // // Tabbar controller
    // ======================== ||
    NEventsViewController * main0 = [[NEventsViewController alloc] init];
    UINavigationController *navMain0 = [[UINavigationController alloc] initWithRootViewController:main0];
    main0.title = @"EVENTS";
    main0.tabBarItem.image = [UIImage imageNamed:@"icon1"];
    [main0 release];
    
    EntriesViewController * main1 = [[EntriesViewController alloc] init];
    UINavigationController *navMain1 = [[UINavigationController alloc] initWithRootViewController:main1];
    
    // ======================== ||
    // // Left BarButton for main1
    // ======================== ||
    
    UIButton *leftButton = [WidgetControl makePersonalBackBarButton];
    //[leftButton setTitle:@"Items" forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 60, 30);
    [leftButton addTarget:self action:@selector(pushOldLeft:) forControlEvents:UIControlEventTouchUpInside];
    //main1.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:leftButton] autorelease];
    
    // ===

    main1.title = @"REKENING";
    main1.tabBarItem.image = [UIImage imageNamed:@"icon-booking.png"];
    [main1 release];
    
    CheckoutController * main3 = [[CheckoutController alloc] init];
    UINavigationController *navMain3 = [[UINavigationController alloc] initWithRootViewController:main3];
    main3.title = @"CHECKOUT";
    main3.tabBarItem.image = [UIImage imageNamed:@"icon4"];
    [main3 release];
    
    MemberViewController * main2 = [[MemberViewController alloc] init];
    UINavigationController *navMain2 = [[UINavigationController alloc] initWithRootViewController:main2];
    main2.title = @"MEMBERS";
    main2.tabBarItem.image = [UIImage imageNamed:@"icon-members.png"];
    [main2 release];
        
    AccountViewController * main4 = [[AccountViewController alloc] init];
    UINavigationController *navMain4 = [[UINavigationController alloc] initWithRootViewController:main4];
    main4.title = @"ACCOUNT";
    main4.tabBarItem.image = [UIImage imageNamed:@"icon-account.png"];
    [main4 release];
    
    self.viewControllers = [NSArray arrayWithObjects:navMain0, navMain1, navMain3, navMain2, navMain4, nil];
    //self.viewControllers = [NSArray arrayWithObjects:navMain0, navMain1, navMain3, nil];
    [WidgetControl setPersonalStyle:navMain0];
    [WidgetControl setPersonalStyle:navMain1];
    [WidgetControl setPersonalStyle:navMain2];
    [WidgetControl setPersonalStyle:navMain3];
    [WidgetControl setPersonalStyle:navMain4];
    [navMain0 release];
    [navMain1 release];
    [navMain2 release];
    [navMain3 release];
    [navMain4 release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
