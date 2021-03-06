//
//  DropDownExample.m
//  VPPLibraries
//
//  Created by Víctor on 13/12/11.
//  Copyright (c) 2011 Víctor Pena Placer. All rights reserved.
//

#import "LeftMenuVC.h"
#import "GHMenuCell.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalDataUser.h"
#import "LoginVC.h"
#import "TVAppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ECSlidingViewController.h"
#import "MapTableViewController.h"
#import "MyNavigationController.h"
#import "TVCameraVC.h"
#import "CommentVC.h"
#import "SIAlertView.h"
#import "RecentlyBranchListVC.h"
#import "ManualVC.h"
#import <SVProgressHUD.h>
#import "TVMenuUserCell.h"
#import "NearbyCouponVC.h"
#import "EventVC.h"
#import "UserSettingVC.h"
#import "ReceivedCouponVC.h"
#import "FavoriteBranchListVC.h"
#import "TVNotification.h"
#import "TVWebVC.h"
#import "SearchWithContactsVC.h"

#define kNumberOfSections 3

enum {
    kSection1UserAccount = 0,
    kSection2Services,
    kSection3Setting
};


// including the dropdown cell !!
/* set to 3 if you want to see how it behaves 
 when having more cells in the same section 
 */
#define kNumberOfRowsInSection1 7-2


enum {
    kS1AccountInfoUser=0,
    kS1AccountRecentlyView,
    kS1AccountReceivedCoupon,
    kS1AccountSetting
};
enum {
    kS1InfoUser=0,
    kS1RecentlyView,
    kS1ReceivedCoupon,
    kS1Interesting,
    kS1Setting,
//    kS1History,
//    kS1UpdateAccount
    
};

/* set to 2 if you want to see how it behaves 
 when having more cells in the same section 
 */

#define kNumberOfRowsInSection2 4
enum {
    kS2Home = 0,
    kS2Coupon,
    kS2GoingEven,
    kS2Handbook
};

#define kNumberOfRowsInSection3 6
enum {
    kS3Introduction = 0,
    kS3TermOfUse,
    kS3RFacebookPage,
    kS3Feedback,
    kS3InviteFriends,
    kS3Logout
};
@implementation LeftMenuVC

- (void)checkAndRefreshTableviewWhenUserLoginOrLogout
{
    if (_lastStatusLogin==[GlobalDataUser sharedAccountClient].isLogin) {
        return;
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self checkAndRefreshTableviewWhenUserLoginOrLogout];
        _headers=[[NSArray alloc] initWithObjects:@"Tài khoản",@"Từ ĂnUống.net",@"Sản phẩm", nil];
        CGRect frame=self.view.bounds;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            frame.origin.y+=20;
            frame.size.height-=20;
        }
        self.tableView=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        _tableView.userInteractionEnabled = YES;
        _tableView.bounces = YES;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [self.view addSubview:self.tableView];
        [self.view setBackgroundColor:[UIColor blackColor]];
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshTableViewDropdown];
    if ([SVProgressHUD isVisible])
        [SVProgressHUD dismiss];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)showLoginScreenWhenUserNotLogin:(UINavigationController*)nav{
    LoginVC* loginVC=nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
    } else {
        loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
    }
    loginVC.isPushNaviYES=YES;
    [nav pushViewController:loginVC animated:YES];
    [loginVC goWithDidLogin:^{
        
    } thenLoginFail:^{
        
    }];
}

-(void)showPushViewController:(UIViewController*)yourViewController with:(UINavigationController*)nav{

    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [nav pushViewController: yourViewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:nav.view cache:NO];
    [UIView commitAnimations];
}

#pragma mark - Camera Comment Action
- (void)showCameraActionWithLocation:(TVBranches*)branches with:(UINavigationController*)nav
{
    TVCameraVC* tvCameraVC=[[TVCameraVC alloc] initWithNibName:@"TVCameraVC" bundle:nil];
    LocationTableVC* tableVC=[[LocationTableVC   alloc] initWithStyle:UITableViewStylePlain];
    tableVC.branches=branches;
    [tableVC setDelegate:tvCameraVC];
//    SkinPickerTableVC* skinVC=[[SkinPickerTableVC   alloc] initWithStyle:UITableViewStylePlain];
//    [skinVC setDelegate:tvCameraVC];
    
    ECSlidingViewController *_slidingViewController=[[ECSlidingViewController alloc] init];
    _slidingViewController.topViewController=tvCameraVC;
    _slidingViewController.underLeftViewController = tableVC;
    _slidingViewController.anchorRightRevealAmount = 320-44;
    [tvCameraVC.view addGestureRecognizer:_slidingViewController.panGesture];
//    [nav presentModalViewController:_slidingViewController animated:YES];

    nav.navigationBarHidden=YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    CGRect windowBounds = [[UIScreen mainScreen] bounds];
    NSLog(@"WINDOW :%@",NSStringFromCGRect(windowBounds));
    nav.view.frame = windowBounds;
    
    [nav pushViewController:_slidingViewController animated:YES];
    tvCameraVC.slidingViewController=_slidingViewController;
}

- (void)showCameraActionWithBranch:(TVBranch*)branch with:(UINavigationController*)nav
{
    TVCameraVC* tvCameraVC=[[TVCameraVC alloc] initWithNibName:@"TVCameraVC" bundle:nil];
//    SkinPickerTableVC* skinVC=[[SkinPickerTableVC   alloc] initWithStyle:UITableViewStylePlain];
//    [skinVC setDelegate:tvCameraVC];
    UINavigationController* navController =navController = [[MyNavigationController alloc] initWithRootViewController:tvCameraVC];
    tvCameraVC.branch=branch;
    ECSlidingViewController *_slidingViewController=[[ECSlidingViewController alloc] init];
    _slidingViewController.topViewController=navController;
//    _slidingViewController.underRightViewController = skinVC;
//    _slidingViewController.anchorLeftRevealAmount = 320-44;
    
    [navController.view addGestureRecognizer:_slidingViewController.panGesture];

    [self presentModalViewController:_slidingViewController animated:YES];
    tvCameraVC.slidingViewController=_slidingViewController;
}

- (void)showCommentActionWithBranch:(TVBranch*)branch
{
    CommentVC* commentVC=[[CommentVC alloc] initWithNibName:@"CommentVC" bundle:nil];
    UINavigationController* navController =navController = [[MyNavigationController alloc] initWithRootViewController:commentVC];
    commentVC.branch=branch;
    ECSlidingViewController *_slidingViewController=[[ECSlidingViewController alloc] init];
    _slidingViewController.topViewController=navController;
    
    [navController.view addGestureRecognizer:_slidingViewController.panGesture];
    [self presentModalViewController:_slidingViewController animated:YES];
    commentVC.slidingViewController=_slidingViewController;
}

- (void)showCommentActionWithBranches:(TVBranches*)branches
{
    CommentVC* commentVC=[[CommentVC alloc] initWithNibName:@"CommentVC" bundle:nil];
    LocationTableVC* tableVC=[[LocationTableVC   alloc] initWithStyle:UITableViewStylePlain];
    [tableVC setDelegate:commentVC];
    tableVC.branches=branches;
    UINavigationController* navController =navController = [[MyNavigationController alloc] initWithRootViewController:commentVC];
    
    ECSlidingViewController *_slidingViewController=[[ECSlidingViewController alloc] init];
    _slidingViewController.topViewController=navController;
    _slidingViewController.underLeftViewController = tableVC;
    _slidingViewController.anchorRightRevealAmount = 320-44;
    
    [navController.view addGestureRecognizer:_slidingViewController.panGesture];
    [self presentModalViewController:_slidingViewController animated:YES];
    commentVC.slidingViewController=_slidingViewController;
}

- (void)cameraButtonClickedWithNav:(UINavigationController*)nav andWithBranch:(TVBranch*)branch{
    if ([GlobalDataUser sharedAccountClient].isLogin)
        [self showCameraActionWithBranch:branch with:nav];
    else{
        LoginVC* loginVC=nil;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
        } else {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
        }
        UINavigationController* navController = [[MyNavigationController alloc] initWithRootViewController:loginVC];
        [self presentModalViewController:navController animated:YES];
        
        [loginVC goWithDidLogin:^{
            [self showCameraActionWithBranch:branch with:nav];
        } thenLoginFail:^{
            
        }];
    }
}

- (void)cameraButtonClickedWithNav:(UINavigationController*)nav andWithBranches:(TVBranches*)branches
{
    if ([GlobalDataUser sharedAccountClient].isLogin)
        [self showCameraActionWithLocation:branches with:nav];
    else{
        LoginVC* loginVC=nil;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
        } else {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
        }
        loginVC.isPushNaviYES=YES;
        [nav pushViewController:loginVC animated:YES];
        [loginVC goWithDidLogin:^{
            [self showCameraActionWithLocation:branches with:nav];
        } thenLoginFail:^{
            
        }];
    }
}

- (void)commentButtonClickedWithNav:(UINavigationController*)nav andWithBranches:(TVBranches*)branches{
    if ([GlobalDataUser sharedAccountClient].isLogin)
        [self showCommentActionWithBranches:branches];
    else{
        LoginVC* loginVC=nil;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
        } else {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
        }
        loginVC.isPushNaviYES=YES;
        [nav pushViewController:loginVC animated:YES];
        [loginVC goWithDidLogin:^{
            [self showCommentActionWithBranches:branches];
        } thenLoginFail:^{
            
        }];
    }
}
- (void)commentButtonClickedWithNav:(UINavigationController*)nav andWithBranch:(TVBranch*)branch
{
    if ([GlobalDataUser sharedAccountClient].isLogin)
        [self showCommentActionWithBranch:branch];
    else{
        LoginVC* loginVC=nil;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
        } else {
            loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
        }
        
        UINavigationController* navController = [[MyNavigationController alloc] initWithRootViewController:loginVC];
        [self presentModalViewController:navController animated:YES];
        [loginVC goWithDidLogin:^{
            [self performSelector:@selector(showCommentActionWithBranch:) withObject:branch afterDelay:1];
        } thenLoginFail:^{
            
        }];
    }
}

#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Helper

- (void)toggleTopView {
    //    self.slidingViewController.underLeftWidthLayout = ECFixedRevealWidth;
    if (self.slidingViewController.underLeftShowing) {
        // actually this does not get called when the top view screenshot is enabled
        // because the screenshot intercepts the touches on the toggle button
        [self.slidingViewController resetTopView];
    } else {
        [self.slidingViewController anchorTopViewTo:ECRight];
    }
}



- (UIBarButtonItem *)toggleBarButtonItem {
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 31)];
    [backButton setImage:[UIImage imageNamed:@"img_button-menu-off"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_button-menu-on"] forState:UIControlStateHighlighted];
    //    [backButton addTarget:self.viewDeckController action:@selector(toggleDownLeftView) forControlEvents:UIControlEventTouchDown];
    [backButton addTarget:self action:@selector(toggleTopView) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 31)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, 16, -0);
    }else{
        backButtonView.bounds = CGRectOffset(backButtonView.bounds, 0, -0);
    }
    [backButtonView addSubview:backButton];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    item.accessibilityLabel = NSLocalizedString(@"Menu", nil);
    item.accessibilityHint = NSLocalizedString(@"Double-tap to reveal menu on the left. If you need to close the menu without choosing its item, find the menu button in top-right corner (slightly to the left) and double-tap it again.", nil);
    return item;
}


// clean up the old state and push the given controller wrapped in a navigation controller.
// in case the given view controller is already a navigation controller it used it directly.
- (void)openViewController:(UIViewController *)viewController {
    // unset the current navigation controller
	UINavigationController *currentController = (UINavigationController *)self.slidingViewController.topViewController;
    if ([currentController isKindOfClass:UINavigationController.class])
        [currentController popToRootViewControllerAnimated:NO];
	// prepare the new navigation controller
    UINavigationController *navController = nil;
    if ([viewController isKindOfClass:UINavigationController.class]) {
        navController = (UINavigationController *)viewController;
    } else {
        navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
    }
	navController.view.layer.shadowOpacity = 0.8f;
	navController.view.layer.shadowRadius = 5;
	navController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
	// give the root view controller the toggle bar button item
    [(UIViewController *)navController.viewControllers[0] navigationItem].leftBarButtonItem = self.toggleBarButtonItem;
	// set the navigation controller as the new top view and bring it on
    [self.slidingViewController setTopViewController:navController];
	//self.slidingViewController.underLeftWidthLayout = ECFixedRevealWidth;
    self.slidingViewController.anchorRightPeekAmount=40.0f;
    self.slidingViewController.shouldAddPanGestureRecognizerToTopViewSnapshot=YES;
    [[(UIViewController *)navController.viewControllers[0] view] addGestureRecognizer:self.slidingViewController.panGesture];
    [navController.navigationBar dropShadow];
    [self.slidingViewController resetTopViewWithAnimations:nil onComplete:nil];
}


- (void)refreshTableViewDropdown
{
    [self checkAndRefreshTableviewWhenUserLoginOrLogout];
}

- (void)showLoginViewController
{
    LoginVC* loginVC=nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPhone" bundle:nil];
    } else {
        loginVC = [[LoginVC alloc] initWithNibName:@"LoginVC_iPad" bundle:nil];
    }
    
    UINavigationController* navController = [[MyNavigationController alloc] initWithRootViewController:loginVC];
    [self presentModalViewController:navController animated:YES];
    [loginVC goWithDidLogin:^{
        [self refreshTableViewDropdown];
        [self.tableView reloadData];
    } thenLoginFail:^{
        
    }];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0)return 2;
	return (_headers[section] == [NSNull null]) ? 0.0f : 34.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSObject *headerText = _headers[section];

	UIView *headerView = nil;
    if (section==0) {
        headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 3)];
        [headerView setBackgroundColor:kDeepOrangeColor];
        return  headerView;
    }
	if (headerText != [NSNull null]) {
		headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 34.0f)];
		headerView.backgroundColor = [UIColor colorWithRed:(0/255.0f) green:(204/255.0f) blue:(255/255.0f) alpha:1.0f];
		UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 3.0f, 5.0f)];
		textLabel.text = (NSString *) headerText;
		textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(17)];
		textLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		textLabel.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		textLabel.textColor = [UIColor colorWithRed:(236.0f/255.0f) green:(234.0f/255.0f) blue:(235.0f/255.0f) alpha:1.0f];
		textLabel.backgroundColor = [UIColor clearColor];
        UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine.backgroundColor = [UIColor colorWithRed:(219.0f/255.0f) green:(219.0f/255.0f) blue:(219.0f/255.0f) alpha:1.0f];
		[textLabel.superview addSubview:topLine];
		
		UIView *topLine2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 1.0f, [UIScreen mainScreen].bounds.size.height, 1.0f)];
		topLine2.backgroundColor = [UIColor whiteColor];
		[textLabel.superview addSubview:topLine2];
		[headerView addSubview:textLabel];
	}
	return headerView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (SharedAppDelegate.isLoadWhenConnectedYES==NO) {
        if ([SharedAppDelegate isConnected]){
            [SharedAppDelegate loadWhenInternetConnected];
        }else{
            if (indexPath.section!=kSection1UserAccount)return;
        }
    }
    
    if (isNotTheFirstTimeOpenHomeYES==NO) {
        isNotTheFirstTimeOpenHomeYES=YES;
        if (indexPath.section==kSection2Services&&indexPath.row==kS2Home) {
            [self toggleTopView];
            lastIndexPath=indexPath;
            return;
        }
    }
    if (indexPath.section!=kSection3Setting){

        
        if (lastIndexPath.section==indexPath.section&&lastIndexPath.row==indexPath.row) {
            if (lastIndexPath.section!=kSection1UserAccount) {
                [self toggleTopView];
                lastIndexPath=indexPath;
                return;
            }
        }
    }
    lastIndexPath=indexPath;
	
    UIViewController *viewController = nil;
    int row = indexPath.row;
    switch (indexPath.section) {
        case kSection1UserAccount:
            if ([GlobalDataUser sharedAccountClient].isLogin){
                switch (row) {
                        
                    case kS1RecentlyView:
                        viewController = [[RecentlyBranchListVC alloc] initWithNibName:@"RecentlyBranchListVC" bundle:nil];
                        
                        break;
                    case kS1ReceivedCoupon:
                        viewController = [[ReceivedCouponVC alloc] initWithNibName:@"ReceivedCouponVC" bundle:nil];
                        break;
                        
                    case kS1Interesting:
                        viewController = [[FavoriteBranchListVC   alloc] initWithNibName:@"FavoriteBranchListVC" bundle:nil];
                        break;
                        
                    case kS1Setting:
                        viewController = [[UserSettingVC alloc] initWithNibName:@"UserSettingVC" bundle:nil];
                        break;
//                    case kS1History:
//
//                        break;
//                    case kS1UpdateAccount:
//
//                        break;
                        
                }
            }else
            {
                switch (row) {
                    case kS1AccountInfoUser:
                        [self showLoginViewController];
                        break;
                    case kS1AccountRecentlyView:
                        viewController = [[RecentlyBranchListVC alloc] initWithNibName:@"RecentlyBranchListVC" bundle:nil];
                        break;
                    case kS1AccountReceivedCoupon:
                        viewController = [[ReceivedCouponVC alloc] initWithNibName:@"ReceivedCouponVC" bundle:nil];
                        break;
                    case kS1AccountSetting:
                        viewController = [[UserSettingVC alloc] initWithNibName:@"UserSettingVC" bundle:nil];
                        break;
                }
                break;
            case kSection2Services:
                switch (row) {
                    case kS2Home:
                        viewController = [[MapTableViewController alloc] initWithNibName:@"MapTableViewController" bundle:nil];
                        break;
                    case kS2Handbook:
                        viewController = [[ManualVC alloc] initWithNibName:@"ManualVC" bundle:nil];
                        break;
                    case kS2GoingEven:
                        viewController = [[EventVC alloc] initWithNibName:@"EventVC" bundle:nil];
                        break;
                    case kS2Coupon:
                        viewController = [[NearbyCouponVC alloc] initWithNibName:@"NearbyCouponVC" bundle:nil];
                        break;
                }
                break;
            case kSection3Setting:
                switch (row) {
                    case kS3Introduction:{
                        viewController=[[TVWebVC alloc] initWithNibName:@"TVWebVC" bundle:nil withRequest:@"view/about"];
                        
                        break;
                    }
                    case kS3TermOfUse:{
                        viewController=[[TVWebVC alloc] initWithNibName:@"TVWebVC" bundle:nil withRequest:@"view/termOfUse"];
                        
                        break;
                    }

                    case kS3RFacebookPage:
                        if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/349578341842722"]])
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/anuongfan"]];
                        break;
                    case kS3Feedback:
                    {
                        MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
                        controller.mailComposeDelegate = self;
                        [controller setToRecipients:[[NSArray alloc] initWithObjects:@"homthu@ ĂnUống.net", nil]];
                        [controller setSubject:@"My Subject"];
                        [controller setMessageBody:@"" isHTML:NO];
                        if (controller) [self presentModalViewController:controller animated:YES];
                    
                    }
                        break;
                    case kS3InviteFriends:
                        viewController = [[SearchWithContactsVC alloc] initWithSectionIndexes:YES isInviting:YES];
                        break;
                    case kS3Logout:
                    {
                        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:nil andMessage:@"Bạn muốn đăng xuất ?"];
                        
                        [alertView addButtonWithTitle:@"Bỏ qua"
                                                 type:SIAlertViewButtonTypeCancel
                                              handler:^(SIAlertView *alert) {
                                                  NSLog(@"Cancel Clicked");
                                              }];
                        [alertView addButtonWithTitle:@"Đồng ý"
                                                 type:SIAlertViewButtonTypeDestructive
                                              handler:^(SIAlertView *alert) {
                                                  if ([GlobalDataUser sharedAccountClient].isLogin) {
                                                      [[FBSession activeSession] closeAndClearTokenInformation];
                                                      [[GlobalDataUser sharedAccountClient] userLogout];
                                                      [tableView reloadData];
                                                  }
                                                  NSLog(@"Logout! Clicked");
                                              }];
                        [alertView show];
                    }
                        break;
                }
                break;
            }
    }
        // Maybe push a controller
    if (viewController) {
            [self openViewController:viewController];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row==0) {
        return 70;
    }
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int rows =0;
    switch (section) {
            
        case kSection1UserAccount:
            if ([GlobalDataUser sharedAccountClient].isLogin)
                rows += kNumberOfRowsInSection1;
            else
                rows += 4;
                break;
        case kSection2Services:
            rows += kNumberOfRowsInSection2;
            break;
        case kSection3Setting:
            if ([GlobalDataUser sharedAccountClient].isLogin)
                rows += kNumberOfRowsInSection3;
            else
                rows += kNumberOfRowsInSection3 -1;
            
            break;
            
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (indexPath.section==kSection1UserAccount&&indexPath.row==kS1InfoUser) {
         CellIdentifier = @"GlobalCustomDropDownCell";
        TVMenuUserCell *cellUser = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cellUser) {
            cellUser = [[TVMenuUserCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] ;
        }
        
        if ([GlobalDataUser sharedAccountClient].isLogin){
            
            cellUser.textLabel.text = [NSString stringWithFormat:@"%@ %@",[GlobalDataUser sharedAccountClient].user.last_name,[GlobalDataUser sharedAccountClient].user.first_name];
            [cellUser.imgAvatar setImageWithURL:[[NSURL alloc] initWithString:[GlobalDataUser sharedAccountClient].user.avatar]  placeholderImage:[UIImage imageNamed:@"user"]];
        }else{
            cellUser.textLabel.text = @"Đăng nhập";
            [cellUser.imgAvatar setImage:[UIImage imageNamed:@"user"]];
        }
        
        return cellUser;
    }
    
    CellIdentifier = @"Cell";
    
    GHMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[GHMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    
    // Configure the cell...
    cell.textLabel.text = nil;
    
    // first check if any dropdown contains the requested cell
    int row = indexPath.row;
    switch (indexPath.section) {
        case kSection1UserAccount:
            if ([GlobalDataUser sharedAccountClient].isLogin){
                switch (row) {

                    case kS1RecentlyView:
                            cell.imageView.image=[UIImage imageNamed:@"img_menu_user_option"];
                            cell.textLabel.text = @"Xem gần đây";
                            

                        break;
                    case kS1ReceivedCoupon:
                        cell.imageView.image=[UIImage imageNamed:@"img_menu_coupon_received"];
                        cell.textLabel.text = @"Coupon đã nhận";
                        break;
                    case kS1Interesting:
                        cell.imageView.image=[UIImage imageNamed:@"img_menu_interestedIn"];
                        cell.textLabel.text = @"Đang quan tâm";
                        break;
                        
                    case kS1Setting:
                            cell.imageView.image=[UIImage imageNamed:@"img_menu_user_option"];
                            cell.textLabel.text = @"Tuỳ chọn Gợi ý";

                        break;
//                    case kS1History:
//                        cell.imageView.image=[UIImage imageNamed:@"img_menu_coupon_received"];
//                        cell.textLabel.text = @"Lịch sử hoạt động";
//                        break;
//                    case kS1UpdateAccount:
//                        cell.imageView.image=[UIImage imageNamed:@"img_menu_interestedIn"];
//                        cell.textLabel.text = @"Cập nhật tài khoản";
//                        break;

                }
            }else
            {
                switch (row) {
                        
                    case kS1AccountRecentlyView:

                            cell.imageView.image=[UIImage imageNamed:@"img_menu_recently_views"];
                            cell.textLabel.text = @"Xem gần đây";
                        break;
                    case kS1AccountReceivedCoupon:
                        cell.imageView.image=[UIImage imageNamed:@"img_menu_coupon_received"];
                        cell.textLabel.text = @"Coupon đã nhận";
                        break;
                    case kS1AccountSetting:
                        cell.imageView.image=[UIImage imageNamed:@"img_menu_interestedIn"];
                        cell.textLabel.text = @"Tuỳ chọn Gợi ý";
                        break;
                }
            break;
        case kSection2Services:
            switch (row) {
                case kS2Home:
                    cell.textLabel.text = @"Trang chủ";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_home"];
                    break;
                case kS2Handbook:
                    cell.textLabel.text = @"Cẩm nang";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_handbook"];
                    break;
                case kS2GoingEven:
                    cell.textLabel.text = @"Sự kiện";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_event"];
                    break;
                case kS2Coupon:
                    cell.textLabel.text = @"Coupon";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_coupon"];
                    break;
            }
            break;
        case kSection3Setting:
            switch (row) {
                case kS3Introduction:
                    cell.textLabel.text = @"Giới thiệu";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_intro"];
                    break;
                case kS3TermOfUse:
                    cell.textLabel.text = @"Điều khoản sử dụng";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_termOfUse"];
                    break;
                case kS3RFacebookPage:
                    cell.textLabel.text = @"Facebook Page";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_fanPage"];
                    break;
                case kS3Feedback:
                    cell.textLabel.text = @"Góp ý - Báo lỗi";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_reportError"];
                    break;
                case kS3InviteFriends:
                    cell.textLabel.text = @"Mời bạn bè";
                    cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_inviteFriends"];
                    break;
                case kS3Logout:
                    if ([GlobalDataUser sharedAccountClient].isLogin) {
                        cell.textLabel.text = @"Đăng suất";
                        cell.imageView.image=[UIImage imageNamed:@"img_menu_icon_signOut"];
                    }
                    break;
            }
            break;
        }
    }
    return cell;
}

@end
