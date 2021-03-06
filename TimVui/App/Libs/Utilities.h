//
//  Uitilities.h
//  CityOffers
//
//  Created by hunght on 8/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>
typedef enum
{
    kThumbnailSizeType = 0,//50*50
    kNormalSizeType,//300*300
    kOriginalSizeType,//1024*1024
} ImageSizeType;
@interface Utilities : NSObject
+(void) logMemoryUsage;
+(BOOL)isRetinaYES;
+(void)iPhoneRetina;
+ (void)roundCornerUIImageView:(UIImageView *)img;
+(void)showAlertWithMessage:(NSString*)strMessage;
+ (BOOL)validateString:(NSString*)string;
+(BOOL)validateEmail:(NSString*)email;
+ (BOOL)validatePhone:(NSString *)aString;
+ (BOOL)validatePassword:(NSString*)pass;
+ (BOOL)validatePassword:(NSString*)pass withConfirmPass:(NSString*)confirmPass;
+(BOOL)checkPhoneNumber:(NSString *)aString;
+(BOOL)validateInputString:(NSString*)string withMessage:(NSString*)strMess;
+ (void)setBorderForLayer:(CALayer *)l radius:(float)radius;

+ (NSURL *)getThumbImageOfCoverBranch:(NSDictionary *)arrURLs;
+ (NSURL *)getLargeImageOfCoverBranch:(NSDictionary *)arrURLs;
+(void) writeToTextFile:(NSString*)name withContent:(NSString*)content;
+(NSDictionary*) displayContentOfFile:(NSString*)name;

+ (NSURL *)getLargeAlbumPhoto:(NSDictionary *)arrURLs;
+ (NSURL *)getOriginalAlbumPhoto:(NSDictionary *)arrURLs;

+ (UIImage *) imageFromColor:(UIColor *)color;
+ (UIImage *) imageFromColor:(UIColor *)color withSize:(CGSize)size;


@end
