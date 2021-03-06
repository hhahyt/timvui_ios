
#import "TVPagingScrollView.h"
#import "CaptureSessionManager.h"
#import "ECSlidingViewController.h"
#import "SSPhotoCropperViewController.h"
#import "LocationTableVC.h"
#import "PhotoBrowseVC.h"
@interface TVCameraVC : MyViewController <MHPagingScrollViewDelegate, UIScrollViewDelegate,  UIImagePickerControllerDelegate,UINavigationControllerDelegate,SSPhotoCropperDelegate,LocationTableVCDelegate,PhotoBrowseVCDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewNotify;

@property (nonatomic, unsafe_unretained) IBOutlet TVPagingScrollView *pagingScrollView;
@property (nonatomic, unsafe_unretained) IBOutlet UIPageControl *pageControl;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnStoreImage;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnAlbumPicker;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnLocationPicker;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnClose;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *imgImagePicked;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnCameraSkin;
@property (weak, nonatomic) IBOutlet UIView *viewSlidePickSkin;

@property (retain, nonatomic) UIImageView *imgStillCamera;
@property (nonatomic, retain) CaptureSessionManager *captureManager;
@property (nonatomic, retain) UITableView *tblBranches;
@property (nonatomic, retain) UITableView *tblSkinStyle;
@property(nonatomic, unsafe_unretained)ECSlidingViewController *slidingViewController;
@property (nonatomic, retain) NSMutableArray *arrImages;
@property (nonatomic, retain) UILabel *lblPhone;
@property (nonatomic,strong)   PhotoBrowseVC *photoBrowseTableVC;
@property (nonatomic, retain) TVBranch *branch;
@property (nonatomic, retain) NSString* strAlbum;
- (IBAction)skinPickerButtonClicked:(id)sender;
- (IBAction)photoBrowseButtonClicked:(id)sender;

- (IBAction)cameraButtonClicked:(id)sender;
- (IBAction)pageTurn;
- (IBAction)closeButtonClicked:(id)sender;
- (IBAction)albumPickerButtonClicked:(id)sender;
- (IBAction)locationPickerButtonClicked:(id)sender;

@end
