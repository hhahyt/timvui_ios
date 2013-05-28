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
@interface TVAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (retain, nonatomic) LeftMenuVC *menuVC;
@property (nonatomic, strong)id<GAITracker> tracker;

@end