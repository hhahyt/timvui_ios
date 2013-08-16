#import "TVEvents.h"
#import "TVEvent.h"


@implementation TVEvents



- (void)setValues:(id)values {
	self.items = [NSMutableArray array];

    
	for (NSDictionary *dict in values) {
        
		TVEvent *branch = [[TVEvent alloc] initWithDict:dict];
        
		[self.items addObject:branch];
	}
}

@end