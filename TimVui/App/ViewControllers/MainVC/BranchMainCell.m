// TweetTableViewCell.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "BranchMainCell.h"
#import "TVBranch.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utilities.h"
#import "TVAppDelegate.h"
#import "TVCoupon.h"
#import "TVCoupons.h"

@implementation BranchMainCell {
@private
    __strong TVBranch *_branch;
}

@synthesize branch = _branch;

- (void)setBorderForLayer:(CALayer *)l radius:(float)radius {
    [l setMasksToBounds:YES];
    [l setCornerRadius:radius];
    // You can even add a border
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.textLabel.textColor = [UIColor blackColor];
    self.textLabel.numberOfLines = 1;
    self.detailTextLabel.numberOfLines = 1;
    self.textLabel.backgroundColor=[UIColor clearColor];
    self.detailTextLabel.backgroundColor=[UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    self.price_avg = [[UILabel alloc] initWithFrame:CGRectZero];
    self.price_avg.backgroundColor = [UIColor clearColor];
    
    self.price_avg.textColor = [UIColor grayColor];
    self.price_avg.highlightedTextColor = [UIColor whiteColor];
    
    
    self.textLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(13)];
    self.price_avg.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    self.detailTextLabel.font = [UIFont fontWithName:@"ArialMT" size:(12)];
    
    
    UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(80+ 8.0, 35.0+7, 11, 12)];
    homeIcon.image=[UIImage imageNamed:@"img_address_branch_icon"];
    
    UIImageView* price_avgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(80+ 10.0, 53.0+7, 8, 11)];
    price_avgIcon.image=[UIImage imageNamed:@"img_price_range_branch_icon"];
    
    CALayer* l = [self.imageView layer];
    [self setBorderForLayer:l radius:1];
    
    [self.contentView addSubview:_price_avg];
    [self.contentView addSubview:homeIcon];
    [self.contentView addSubview:price_avgIcon];
    
    _utility=[[UIView alloc] initWithFrame:CGRectMake(88,70+7, 320-88, 18)];
    [self.contentView addSubview:_utility];
    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_main_cell_pattern"]]];

    _lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(270,7+7, 60, 15)];
    _lblDistance.backgroundColor = [UIColor clearColor];
    _lblDistance.textColor = [UIColor grayColor];
    _lblDistance.font = [UIFont fontWithName:@"Arial-ItalicMT" size:(10)];
    
    [self.contentView addSubview:_lblDistance];
    return self;
}

- (void)setBranch:(TVBranch *)branch withDistance:(double)distance {
    _branch = branch;
    self.textLabel.text=_branch.name;
    self.detailTextLabel.text=_branch.address_full;
    self.price_avg.text=_branch.price_avg;
    
    if (distance>1000.0)
        _lblDistance.text=[NSString stringWithFormat:@"%.01f km",distance/1000];
    else
        _lblDistance.text=[NSString stringWithFormat:@"%.01f m",distance];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:[_branch.arrURLImages valueForKey:@"80"]]placeholderImage:[UIImage imageNamed:@"branch_placeholder"]];
    
    int lineHeight=0;
    
    for (TVCoupon* coupon in branch.coupons.items) {
        UILabel *lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(0+18, lineHeight, 210, 17)];
        lblAddress.backgroundColor = [UIColor clearColor];
        lblAddress.textColor = [UIColor redColor];
        lblAddress.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblAddress.numberOfLines = 1;
        lblAddress.text=coupon.name;
        [self.utility addSubview:lblAddress];
        
        UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, lineHeight, 15, 15)];
        homeIcon.image=[UIImage imageNamed:@"img_main_coupon_icon"];
        [self.utility addSubview:homeIcon];
        lineHeight+=lblAddress.frame.size.height+5;
    }
    
    CGRect frame=self.utility.frame;
    frame.size.height+=branch.coupons.items.count*30;
    [self.utility setFrame:frame];
    
    [self setNeedsLayout];
}

+ (CGFloat)heightForCellWithPost:(TVBranch *)branch {
    return (8+ 70+ 8+15+ branch.coupon_count* 18);
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(5.0f, 8.0f+7, 70.0f, 70.0f);
    self.textLabel.frame = CGRectMake(80+10.0f, 8.0f+7, 180.0f, 20.0f);
    self.detailTextLabel.frame = CGRectMake(80+25.0f, 30.0f+7, 210.0f, 20.0f);
    self.price_avg.frame = CGRectMake(80 +25.0f, 48.0f+7, 210.0f, 20.0f);
    
}

@end
