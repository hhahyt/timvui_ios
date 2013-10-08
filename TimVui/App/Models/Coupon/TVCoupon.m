#import "TVCoupon.h"
#import "GHUser.h"
#import "TVComment.h"
#import "NSString+Extensions.h"
#import "NSDictionary+Extensions.h"


@interface TVCoupon ()
@property(nonatomic,readwrite)BOOL read;
@end


@implementation TVCoupon

- (id)initWithDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		self.read = NO;
		[self setValues:dict];
	}
	return self;
}



- (void)markAsRead {
	self.read = YES;
}

- (void)setValues:(id)dict {
    NSLog(@"%@",dict);
	self.couponID = [dict safeStringForKey:@"id"];
	self.name = [dict safeStringForKey:@"name"];
	self.view = [dict safeStringForKey:@"view"];
	self.used = [dict safeStringForKey:@"used"];
    self.syntax  =[dict safeStringForKey:@"syntax"];
    self.start = [dict safeDateForKey:@"start"];
	self.end = [dict safeDateForKey:@"end"];
    self.content = [dict safeStringForKey:@"content"];
    self.status = [dict safeStringForKey:@"status"];
    self.sms_type = [dict safeStringForKey:@"sms_type"];
}

@end
