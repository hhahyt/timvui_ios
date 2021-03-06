#import <Foundation/Foundation.h>


@class GHUser,TVBranch;

@interface TVCoupon : NSObject
@property(nonatomic,strong)NSString *couponID;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *used_number;
@property(nonatomic,strong)NSString *use_number;
@property(nonatomic,strong)NSString* view;
@property(nonatomic,strong)NSString *syntax;
@property(nonatomic,strong)NSDate *start;
@property(nonatomic,strong)NSDate *end;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)TVBranch *branch;
@property(nonatomic,strong) NSString *status;

@property(nonatomic,strong)NSString *special_content;
@property(nonatomic,strong)NSString *condition_content;

@property(nonatomic,strong) NSDictionary *sms_type;
@property(nonatomic,strong)NSString *image;

- (id)initWithDict:(NSDictionary *)dict;
- (void)setValues:(id)dict;
- (void)markAsRead;
@end