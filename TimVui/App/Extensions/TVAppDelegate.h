//
//  AppDelegate.h
//  TimVui
//
//  Created by Hoang The Hung on 3/22/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "MacroApp.h"
#import "LeftMenuVC.h"
#import "TVBranch.h"
#import "Utilities.h"
#import <SDWebImage/UIImageView+WebCache.h>
//
@class TVBranch;
@interface TVAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (retain, nonatomic) LeftMenuVC *menuVC;
@property (nonatomic, strong)id<GAITracker> tracker;
@property (retain, nonatomic) NSDictionary *getParamData;
@property (retain, nonatomic) NSDictionary *getCityDistrictData;
@property (retain, nonatomic) NSDictionary *getDistrictHasPublicLocationData;
@property (retain, nonatomic) NSDictionary *getPublicLocationData;
@property (retain, nonatomic) NSDictionary *getPriceAvgData;
@property (retain, nonatomic) NSDictionary *getCatData;

@property (retain, nonatomic) TVBranch *nearlyBranch;
@property (retain, nonatomic) TVBranch *hasCouponBranch;
@property (retain, nonatomic) NSMutableDictionary *notifBranches;
@property (retain, nonatomic) NSMutableDictionary *notifCoupons;
@property(nonatomic,assign)BOOL isLoadWhenConnectedYES;
@property(nonatomic,assign)BOOL isHasInternetYES;
-(void)showNotificationAboutNearlessBranch:(TVBranch*)branch;
- (BOOL)isConnected;
-(void)loadWhenInternetConnected;
-(void)showNotificationWithBranch:(TVBranch*)branch;
@end
