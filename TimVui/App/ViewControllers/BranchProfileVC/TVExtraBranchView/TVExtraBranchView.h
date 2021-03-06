//
//  TVExtraBranchView.h
//  TimVui
//
//  Created by Hoang The Hung on 6/24/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TVComments.h"
#import "TVBranches.h"
#import "TVBranch.h"
#import "SearchCuisines.h"
typedef enum {
    kTVComment =0,
    kTVMenu,
    kTVSimilar,
    kTVKaraoke,
    kTVEvent
} kTVTable;

@interface TVExtraBranchView : UIView <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SearchCuisinesDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (assign, nonatomic) kTVTable currentTableType;
@property (strong, nonatomic) TVComments* comments;
@property (strong, nonatomic) NSArray* arrMenu;
@property (strong, nonatomic) TVBranches* similarBranches;
@property(nonatomic,strong)TVBranch *branch;
@property (assign, nonatomic) BOOL isHiddenYES;
@property (assign, nonatomic) BOOL isAnimating;
@property (assign, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIScrollView *viewScroll;
@property (strong, nonatomic) UIButton* btnBackground;
@property (strong, nonatomic) UILabel*lblReview;
@property (strong, nonatomic) UILabel*lblMenu;
@property (assign, nonatomic) BOOL isWantToShowEvents;
@property (strong, nonatomic) UILabel* lblKaraoke;

@property (strong, nonatomic) UIScrollView *scrollEvent;
@property (strong, nonatomic) UIScrollView *scrollKaraoke;
@property (assign, nonatomic) BOOL isShowFullExtraYES;
@property (assign, nonatomic) UIViewController *viewController;

-(void)showExtraView:(BOOL)isYES;

-(void)eventButtonClicked:(UIButton*)sender;

- (id)initWithBranch:(TVBranch*)branch withViewController:(UIViewController*)viewController;

-(id)initShowEventWithFrame:(CGRect)frame andBranch:(TVBranch*)branch withViewController:(UIViewController*)viewController;

@end
