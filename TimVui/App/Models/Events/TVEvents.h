#import <Foundation/Foundation.h>
#import "GHCollection.h"



@interface TVEvents : NSObject
@property(nonatomic,strong)NSMutableArray *items;
- (void)setValues:(id)values;
@end