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

#import "ExtraMenuCell.h"
#import "TVComment.h"
#import <QuartzCore/QuartzCore.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Utilities.h"
#import "TVAppDelegate.h"
#import "NSDate-Utilities.h"
@implementation ExtraMenuCell {
}

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
    _titleRow=[[UILabel alloc] initWithFrame:CGRectMake(15.0f, 4.0f, 222.0f, 15.0f)];
    self.titleRow.adjustsFontSizeToFitWidth = YES;
    self.titleRow.textColor = [UIColor blackColor];

    self.titleRow.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:_titleRow];
    self.detailTextLabel.backgroundColor=[UIColor clearColor];
    self.detailTextLabel.textColor=[UIColor whiteColor];
    self.detailTextLabel.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    self.titleRow.numberOfLines = 1;
//    self.titleRow.lineBreakMode = UILineBreakModeWordWrap;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.detailTextLabel.textAlignment = UITextAlignmentCenter;
    
    self.titleRow.font = [UIFont fontWithName:@"UVNTinTucHepThemBold" size:(15)];
    self.detailTextLabel.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    self.imageView.image=[Utilities imageFromColor:[UIColor grayColor]];
    [self.contentView insertSubview:self.detailTextLabel aboveSubview:self.imageView];
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    _dotLine=[[UILabel alloc] initWithFrame: CGRectMake(150.0f, 6.0f, 90, 15.0f)];
    _dotLine.font=[UIFont systemFontOfSize:12];
    _dotLine.text=@"................................................";
    _dotLine.textColor=[UIColor lightGrayColor];
    _dotLine.backgroundColor=[UIColor clearColor];
    [self.contentView insertSubview:_dotLine belowSubview:self.titleRow];
    return self;
}

#pragma mark - UIView
- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(254.0f, 8.0f, 56.0f, 17.0f);
    self.detailTextLabel.frame = CGRectMake(254.0f, 8.0f, 56.0f, 17.0f);
}

@end
