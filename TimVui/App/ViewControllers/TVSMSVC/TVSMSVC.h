//
//  TVSMSVC.h
//  Anuong
//
//  Created by Hoang The Hung on 10/8/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import <MessageUI/MessageUI.h>
@class TVCoupon;
@interface TVSMSVC : MFMessageComposeViewController

+(void)viewOptionSMSWithViewController:(UIViewController*)viewController andCoupon:(TVCoupon*)coupon;
@end