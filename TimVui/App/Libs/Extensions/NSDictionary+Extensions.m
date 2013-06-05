#import "NSDictionary+Extensions.h"
#import "NSURL+Extensions.h"


@implementation NSDictionary (Extensions)

- (id)valueForKey:(NSString *)key defaultsTo:(id)defaultValue {
	id value = [self valueForKey:key];
	return (value != nil && value != NSNull.null) ? value : defaultValue;
}

- (id)valueForKeyPath:(NSString *)keyPath defaultsTo:(id)defaultValue {
	id value = [self valueForKeyPath:keyPath];
	return (value != nil && value != NSNull.null) ? value : defaultValue;
}

- (BOOL)safeBoolForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:nil];
	return (!value || value == NSNull.null) ? (BOOL)nil : [value boolValue];
}

- (BOOL)safeBoolForKeyPath:(NSString *)keyPath {
	id value = [self valueForKeyPath:keyPath defaultsTo:nil];
	return (!value || value == NSNull.null) ? (BOOL)nil : [value boolValue];
}

- (NSInteger)safeIntegerForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:nil];
	return (!value || value == NSNull.null) ? (int)nil : [value integerValue];
}

- (NSDictionary *)safeDictForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:nil];
	return ([value isKindOfClass:NSDictionary.class]) ? value : nil;
}

- (NSDictionary *)safeDictForKeyPath:(NSString *)keyPath {
	id value = [self valueForKeyPath:keyPath defaultsTo:nil];
	return ([value isKindOfClass:NSDictionary.class]) ? value : nil;
}

- (NSString *)safeStringForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:@""];
	return ([value isKindOfClass:NSString.class]) ? value : @"";
}
- (CLLocationCoordinate2D )safeLocaitonForKey:(NSString *)key {
    CLLocationCoordinate2D location;
	id value = [self valueForKey:key defaultsTo:@""];
	NSString*latlng= ([value isKindOfClass:NSString.class]) ? value : @"";
    if ([value isKindOfClass:NSString.class]) {
        NSArray *listItems = [latlng componentsSeparatedByString:@","];
        if (listItems.count==2) {
            NSString* lat= listItems[0];
            NSString*lng= listItems[1];
            
            location.latitude=lat.doubleValue;
            location.longitude=lng.doubleValue;
            
        }
    }
    return location;
}

- (NSString *)safeStringForKeyPath:(NSString *)keyPath {
	id value = [self valueForKeyPath:keyPath defaultsTo:@""];
	return ([value isKindOfClass:NSString.class]) ? value : @"";
}

- (NSString *)safeStringOrNilForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:nil];
	return ([value isKindOfClass:NSString.class]) ? value : nil;
}

- (NSString *)safeStringOrNilForKeyPath:(NSString *)keyPath {
	id value = [self valueForKeyPath:keyPath defaultsTo:nil];
	return ([value isKindOfClass:NSString.class]) ? value : nil;
}

- (NSArray *)safeArrayForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:nil];
	return ([value isKindOfClass:NSArray.class]) ? value : nil;
}

- (NSArray *)safeArrayForKeyPath:(NSString *)keyPath {
	id value = [self valueForKeyPath:keyPath defaultsTo:nil];
	return ([value isKindOfClass:NSArray.class]) ? value : nil;
}

- (NSDate *)safeDateForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:nil];
	return ([value isKindOfClass:NSDate.class]) ? value : [self.class _parseDate:value];
}

- (NSDate *)safeDateForKeyPath:(NSString *)keyPath {
	id value = [self valueForKeyPath:keyPath defaultsTo:nil];
	return ([value isKindOfClass:NSDate.class]) ? value : [self.class _parseDate:value];
}

- (NSURL *)safeURLForKey:(NSString *)key {
	id value = [self valueForKey:key defaultsTo:@""];
	return (!value || value == NSNull.null) ? nil : [NSURL smartURLFromString:value];
}

- (NSURL *)safeURLForKeyPath:(NSString *)keyPath {
	id value = [self valueForKeyPath:keyPath defaultsTo:@""];
	return (!value || value == NSNull.null) ? nil : [NSURL smartURLFromString:value];
}

+ (NSDate *)_parseDate:(NSString *)string {
	if ([string isKindOfClass:NSNull.class] || string == nil || [string isEqualToString:@""]) return nil;
	static NSDateFormatter *dateFormatter;
	if (dateFormatter == nil) dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssz";
	// Fix for timezone format
	if ([string hasSuffix:@"Z"]) {
		string = [[string substringToIndex:[string length]-1] stringByAppendingString:@"+0000"];
	} else if ([string length] >= 24) {
		string = [string stringByReplacingOccurrencesOfString:@":" withString:@"" options:0 range:NSMakeRange(21,4)];
	}
	NSDate *date = [dateFormatter dateFromString:string];
	return date;
}

@end