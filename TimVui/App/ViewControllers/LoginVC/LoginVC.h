/*
 * Copyright 2012 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>
@protocol LoginVCDelegate

@optional

/**
 * Sent to the delegate when sign up has completed successfully. Immediately
 * followed by an invocation of userDidLogin:
 */
- (void)userFacebookDidLogin;
- (void)userFacebookDidLogout;

@end
@interface LoginVC : UIViewController<UITextFieldDelegate>{
    CGPoint _svos;
}

@property (nonatomic, retain) NSObject<LoginVCDelegate>* delegate;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *tfdUsername;
@property (unsafe_unretained, nonatomic) IBOutlet UITextField *tfdPassword;

@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnBackground;

//Action
- (IBAction)facebookLoginButtonClicked:(id)sender;
- (IBAction)googleLoginButtonClicked:(id)sender;
- (IBAction)userLoginButtonClicked:(id)sender;
- (IBAction)signupButtonClicked:(id)sender;
- (IBAction)backgroundButtonClicked:(id)sender;

@end

