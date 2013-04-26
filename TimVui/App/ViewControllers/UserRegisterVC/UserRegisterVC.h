//
//  RegisterViewController.h
//  CityOffers
//
//  Created by Nguyen Mau Dat on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "MacroApp.h"
#import "Ultilities.h"

#import "GAITrackedViewController.h"

@interface UserRegisterVC : GAITrackedViewController<UITextFieldDelegate,UIAlertViewDelegate>{
	CGPoint _svos;
    NSString*   user_email;
    NSString*  user_firstName;
    NSString*  user_lastName;
    NSString*  user_password;
    NSString*  user_confirm_password;
    NSString*  user_phone;
    BOOL _isTakenPhotoYES;
    NSURL* urlImage;
}

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnRegister;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgViewAvatar;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollview;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txfName;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txfPassword;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txfPhone;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *txfConfirmPassword;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelFirstName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelReentrePassword;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *labelPhoneNumber;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnBackground;

@property (strong, nonatomic) UIImage* imageAvatar;
@property (assign, nonatomic) BOOL isUpdateProfileYES;

//IBAction
- (IBAction)userRegisterClicked:(id)sender;
- (IBAction)backgroundButtonClicked:(id)sender;

@end
