//
//  BranchProfileVC.m
//  TimVui
//
//  Created by Hoang The Hung on 6/5/13.
//  Copyright (c) 2013 Hoang The Hung. All rights reserved.
//

#import "BranchProfileVC.h"
#import "TVAppDelegate.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "GlobalDataUser.h"
#import <QuartzCore/QuartzCore.h>
#import "TVCoupons.h"
#import "TVCoupon.h"
#import "TVExtraBranchView.h"
#import "MHFacebookImageViewer.h"
#import "SpecBranchProfileVC.h"
#import "TVPhotoBrowserVC.h"

@interface BranchProfileVC ()
{
    @private
        double lastDragOffset;
}
@end

@implementation BranchProfileVC

#pragma mark - UIViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (UIView *)addGenerationInfoView
{
    UIView *genarateInfoView=[[UIView alloc] initWithFrame:CGRectMake(7, 186, 310, 90)];
    [genarateInfoView setBackgroundColor:[UIColor whiteColor]];
    CALayer* l=genarateInfoView.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    // You can even add a border
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    
    UILabel *lblBranchName = [[UILabel alloc] initWithFrame:CGRectMake(9, 9, 230, 20)];
    lblBranchName.backgroundColor = [UIColor clearColor];
    lblBranchName.textColor = [UIColor redColor];
    lblBranchName.font = [UIFont fontWithName:@"UVNVanBold" size:(15)];
    lblBranchName.text=_branch.name;
    [genarateInfoView addSubview:lblBranchName];
    
    UIImage *imageDirection=[UIImage imageNamed:@"img_direction_icon"];
    UIImageView* imgDirectionView=[[UIImageView alloc] initWithFrame:CGRectMake(257,9+8 , 9, 9)];
    [imgDirectionView setImage:imageDirection];
    [genarateInfoView addSubview:imgDirectionView];
    
    UILabel *lblDistance = [[UILabel alloc] initWithFrame:CGRectMake(270,9+4, 60, 15)];
    lblDistance.backgroundColor = [UIColor clearColor];
    lblDistance.textColor = [UIColor redColor];
    lblDistance.font = [UIFont fontWithName:@"ArialMT" size:(15)];
    double distance=[[GlobalDataUser sharedAccountClient] distanceFromAddress:_branch.latlng];
    if (distance>1000.0) {
//        NSLog(@"%f",distance/1000.0);
        lblDistance.text=[NSString stringWithFormat:@"%.2f km",distance/1000];
    }
    else
        lblDistance.text=[NSString stringWithFormat:@"%f m",distance];
    
    [genarateInfoView addSubview:lblDistance];
    
    UILabel *lblAddress = [[UILabel alloc] initWithFrame:CGRectMake(8.0+15, 35.0, 210, 12)];
    lblAddress.backgroundColor = [UIColor clearColor];  
    lblAddress.textColor = [UIColor grayColor];
    lblAddress.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    lblAddress.text=_branch.address_full;
    [genarateInfoView addSubview:lblAddress];
    
    UILabel *lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(8.0+15, 53.0, 210, 12)];
    lblPrice.backgroundColor = [UIColor clearColor];
    lblPrice.textColor = [UIColor grayColor];
    lblPrice.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    lblPrice.text=_branch.price_avg;
    [genarateInfoView addSubview:lblPrice];
    
    UIImageView* homeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 35.0, 11, 12)];
    homeIcon.image=[UIImage imageNamed:@"img_address_branch_icon"];
    [genarateInfoView addSubview:homeIcon];
    
    UIImageView* price_avgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 53.0, 8, 11)];
    price_avgIcon.image=[UIImage imageNamed:@"img_price_range_branch_icon"];
    [genarateInfoView addSubview:price_avgIcon];
    
    UIImageView*phone_Icon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 71.0, 11, 12)];
    phone_Icon.image=[UIImage imageNamed:@"img_profile_branch_phone"];
    [genarateInfoView addSubview:phone_Icon];
    
    UILabel *lblPhone = [[UILabel alloc] initWithFrame:CGRectMake(10.0+15, 71.0, 210, 12)];
    lblPhone.backgroundColor = [UIColor clearColor];
    lblPhone.textColor = [UIColor grayColor];
    lblPhone.font = [UIFont fontWithName:@"ArialMT" size:(13)];
    lblPhone.text=_branch.phone;
    [genarateInfoView addSubview:lblPhone];
    return genarateInfoView;
}

- (void)showInfoView
{
    
    // Do any additional setup after loading the view from its nib.
    [_imgBranchCover setImageWithURL:[Ultilities getLargeImageOfCoverBranch:_branch.arrURLImages]placeholderImage:nil];
    
    //Show Ablum images
    int i=0;
    for (NSDictionary* images in _branch.images) {
        UIImageView* imageButton = [[UIImageView alloc] initWithFrame:CGRectMake(6+52*i, 140, 50, 35)];
        [imageButton setImageWithURL:[Ultilities getThumbImageOfCoverBranch:images]];
        imageButton.tag=i;
        [_scrollView addSubview:imageButton];
        [imageButton setupImageViewerWithImageURL:[Ultilities getLargeImageOfCoverBranch:images] onOpen:^{
            NSLog(@"OPEN!");
        } onClose:^{
            NSLog(@"CLOSE!");
        }];
        
        i++;
    }
    
    if (_branch.image_count>=4) {
        UIButton* imageButton = [[UIButton alloc] initWithFrame:CGRectMake(6+52*i, 140, 50, 35)];
        [imageButton setTitle:[NSString stringWithFormat:@"+%d",_branch.image_count-3] forState:UIControlStateNormal];
        [imageButton addTarget:self action:@selector(albumButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:imageButton];
    }
    
    //Show mapView button
    NSString* latlng=[NSString stringWithFormat:@"%f,%f",_branch.latlng.latitude,_branch.latlng.longitude];
    NSString* strURL=[NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?center=%@&zoom=15&size=160x160&markers=size:mid%@color:red%@%@&sensor=false",latlng,@"%7C",@"%7C",latlng];
    NSLog(@"strURL = %@",strURL);
    NSURL* url=[NSURL URLWithString:strURL];
    UIButton* mapViewButton = [[UIButton alloc] initWithFrame:CGRectMake(218, 106, 97, 72)];
    [mapViewButton setImageWithURL:url];
    [mapViewButton addTarget:self action:@selector(mapViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:mapViewButton];
    
    // Generate Infomation Of Branch
    UIView *genarateInfoView = [self addGenerationInfoView];
    [_scrollView addSubview:genarateInfoView];
    CALayer *l;
    
    //Button Camera, Comment, Follow
    UIButton* cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(7, genarateInfoView.frame.origin.y+genarateInfoView.frame.size.height+ 15, 101, 38)];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_camera"] forState:UIControlStateNormal];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_camera_on"] forState:UIControlStateHighlighted];
    [cameraButton setTitle:@"             CHỤP ẢNH" forState:UIControlStateNormal];
    [cameraButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cameraButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(10)];
    [cameraButton addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:cameraButton];
    
    UIButton* commentButton = [[UIButton alloc] initWithFrame:CGRectMake(7+101+5, genarateInfoView.frame.origin.y+genarateInfoView.frame.size.height+ 15, 101, 38)];
    [commentButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment"] forState:UIControlStateNormal];
    [commentButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_coment_on"] forState:UIControlStateHighlighted];
    [commentButton setTitle:@"             BÌNH LUẬN" forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    commentButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(10)];
    
    [commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:commentButton];
    
    UIButton* likeButton = [[UIButton alloc] initWithFrame:CGRectMake(7+101*2+5*2, genarateInfoView.frame.origin.y+genarateInfoView.frame.size.height+ 15, 101, 38)];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_like"] forState:UIControlStateNormal];
    [likeButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_like_on"] forState:UIControlStateHighlighted];
    [likeButton setTitle:@"             QUAN TÂM" forState:UIControlStateNormal];
    [likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    likeButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(10)];
    
    [likeButton addTarget:self action:@selector(likeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:likeButton];
    
    int height= likeButton.frame.origin.y+likeButton.frame.size.height+10;
    //COUPON
    for (TVCoupon* coupon in _branch.coupons.items) {
        
    }
    
    //Detail Info
    UIView* detailInfoBranch=[[UIView alloc] initWithFrame:CGRectMake(6, height, 320-6*2, 45)];
    [detailInfoBranch setBackgroundColor:[UIColor whiteColor]];
    l=detailInfoBranch.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    [_scrollView addSubview:detailInfoBranch];
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 19, 210, 23)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor redColor];
    lblTitle.font = [UIFont fontWithName:@"UVNVanBold" size:(20)];
    lblTitle.text=@"THÔNG TIN";
    [detailInfoBranch addSubview:lblTitle];
    
    int heightDetailInfo=lblTitle.frame.origin.y+lblTitle.frame.size.height +12;
    //Style foody
    
    NSString* strDetail=[_branch.cats valueForKey:@"name"];
    NSString* strTiltle=@"Thể loại";
    
    
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=[_branch.district valueForKey:@"name"];
    strTiltle=@"Khu vực";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=[_branch.public_locations valueForKey:@"name"];
    strTiltle=@"Ở gần";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=_branch.direction;
    strTiltle=@"Chỉ đường";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=_branch.space;
    strTiltle=@"Sức chứa";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=[self getDetailStringFrom:_branch.decoration];
    strTiltle=@"Không gian";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=[NSString stringWithFormat:@"%@- %@",_branch.time_open,_branch.time_open];
    strTiltle=@"Thời gian hoạt động";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    
    strDetail=[NSString stringWithFormat:@"Khoảng %@- %@ phút",_branch.waiting_start,_branch.waiting_end];;
    strTiltle=@"Thời gian chuẩn bị";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=_branch.holiday;
    strTiltle=@"Nghỉ lễ";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=_branch.year;
    strTiltle=@"Năm thành lập";
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    
    strTiltle=@"Thích hợp";
    strDetail=[self getDetailStringFrom:_branch.adaptive];
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strDetail=nil;
    strTiltle=@"Phong cách ẩm thực";
    if ([[_branch.styleFoody allValues] count]>0) {
        NSString* strStyleFoody=@"";
        BOOL isFistTime=YES;
        
        for (NSDictionary* dicStyle in [_branch.styleFoody allValues]) {
            NSLog(@"dicStyle = %@",dicStyle);
            NSString* strStyleFoodyRow=@"";
            if ([[dicStyle valueForKey:@"params"] count]>0) {
                for (NSDictionary* dicStyleDeeper in [[dicStyle valueForKey:@"params"] allValues]){
                    NSLog(@"dicStyleDeeper = %@",dicStyleDeeper);
                    strStyleFoodyRow=[strStyleFoodyRow stringByAppendingFormat:@"%@-%@",[dicStyle valueForKey:@"name"],[dicStyleDeeper valueForKey:@"name"]];
                }
            }else
                strStyleFoodyRow=[dicStyle valueForKey:@"name"];
            
            if (isFistTime) {
                isFistTime=NO;
                strStyleFoody=[strStyleFoody stringByAppendingFormat:@"%@",strStyleFoodyRow];
            }else
                strStyleFoody=[strStyleFoody stringByAppendingFormat:@", %@",strStyleFoodyRow];
        }
        strDetail=strStyleFoody;
    }
    
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strTiltle=@"Phù hợp mục đích";
    strDetail=[self getDetailStringFrom:_branch.purpose];
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    strTiltle=@"Phù hợp các món";
    strDetail=[self getDetailStringFrom:_branch.cuisine];
    [self setRowWithHeight:&heightDetailInfo detailInfoBranch:detailInfoBranch strDetail:strDetail strTiltle:strTiltle];
    
    CGRect frame=detailInfoBranch.frame;
    frame.size.height=heightDetailInfo + 0;
    [detailInfoBranch setFrame:frame];
    
    // Utilities
    UIView* utilitiesView=[[UIView alloc] initWithFrame:CGRectMake(6, detailInfoBranch.frame.origin.y+detailInfoBranch.frame.size.height+10, 320-6*2, 45)];
    [utilitiesView setBackgroundColor:[UIColor whiteColor]];
    l=utilitiesView.layer;
    [l setMasksToBounds:YES];
    [l setCornerRadius:5.0];
    [l setBorderWidth:1.0];
    [l setBorderColor:[UIColor colorWithRed:(214/255.0f) green:(214/255.0f) blue:(214/255.0f) alpha:1.0f].CGColor];
    [_scrollView addSubview:utilitiesView];
    
    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 19, 210, 23)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor redColor];
    lblTitle.font = [UIFont fontWithName:@"UVNVanBold" size:(20)];
    lblTitle.text=@"TIỆN ÍCH";
    [utilitiesView addSubview:lblTitle];
    int heightUtilities=lblTitle.frame.origin.y+lblTitle.frame.size.height +27;
    int rowCount=0;
    
    NSDictionary* params=[SharedAppDelegate getParamData];
    NSDictionary* dicUtilities=[[[params valueForKey:@"data"] valueForKey:@"tien-ich"] valueForKey:@"params"];
    //    NSDictionary*dicUtilities=_branch.services;
    int heightPreRow=0;
    for (NSDictionary* dic in [dicUtilities allValues]) {
        UIImageView *iconIView = [[UIImageView alloc] initWithFrame:CGRectMake((rowCount%2) ?165:8,heightUtilities, 18, 18)];
        BOOL isServiceOnYES=NO;
        for (NSDictionary *dicOn in [_branch.services allValues]) {
            NSString* strOne=[dicOn valueForKey:@"id"];
            NSString* strTwo=[dic valueForKey:@"id"];
            if ([strOne isEqualToString:strTwo]){
                isServiceOnYES=YES;
                break;
            }
        }

        [utilitiesView addSubview:iconIView];
        UILabel *lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(iconIView.frame.origin.x+iconIView.frame.size.width+3, heightUtilities+3, 130, 23)];
        
        lblDetailRow.backgroundColor = [UIColor clearColor];
        lblDetailRow.textColor = [UIColor blackColor];
        lblDetailRow.numberOfLines = 0;
        lblDetailRow.lineBreakMode = UILineBreakModeWordWrap;
        lblDetailRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblDetailRow.text =[dic valueForKey:@"name"];
        [lblDetailRow sizeToFit];
        [utilitiesView addSubview:lblDetailRow];
        
        NSString * strImageName;
        if (isServiceOnYES){
            strImageName=[NSString stringWithFormat:@"%@_on",[dic valueForKey:@"id"]];
            lblDetailRow.textColor = [UIColor colorWithRed:(0/255.0f) green:(180/255.0f) blue:(220/255.0f) alpha:1.0f];
        }else{
            lblDetailRow.textColor = [UIColor grayColor];
            strImageName=[dic valueForKey:@"id"];
        }
        
        [iconIView setImage:[UIImage imageNamed:strImageName]];
        
        rowCount++;
        if (rowCount>1&& !(rowCount%2)) {
            int padRow=(lblDetailRow.frame.size.height>heightPreRow)?lblDetailRow.frame.size.height:heightPreRow;
            heightUtilities+=padRow+ 10;
            heightPreRow=0;
        }else
            heightPreRow=lblDetailRow.frame.size.height;
    }
    frame=utilitiesView.frame;
    if (rowCount%2)
        frame.size.height=heightUtilities +26+ 10;
    else
        frame.size.height=heightUtilities + 10;
    
    [utilitiesView setFrame:frame];
    height =utilitiesView.frame.origin.y +utilitiesView.frame.size.height+40;
    if(_branch.special_content)
    {
        UIButton* specialContentButton = [[UIButton alloc] initWithFrame:CGRectMake(10, utilitiesView.frame.origin.y+utilitiesView.frame.size.height+10, 301, 45)];
        [specialContentButton addTarget:self action:@selector(specialContentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        specialContentButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [specialContentButton setTitle:@"    Điểm nổi bật" forState:UIControlStateNormal];
        specialContentButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:(15)];
        [specialContentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [specialContentButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_button_addition"] forState:UIControlStateNormal];
        [specialContentButton setBackgroundImage:[UIImage imageNamed:@"img_profile_branch_button_addition_on"] forState:UIControlStateHighlighted];
        [_scrollView addSubview:specialContentButton];
        height+=45;
    }
    [_scrollView setContentSize:CGSizeMake(320, height)];
}

- (void)viewDidLoad
{
    UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(7, 7, 57, 33)];
    [backButton setImage:[UIImage imageNamed:@"img_back-on"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"img_back-off"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    self.branch=[[TVBranch alloc] initWithPath:@"branch/getById"];
     NSDictionary *params = @{@"id": _branchID};
//    NSDictionary *params = @{@"id": @"1"};
    [self.branch loadWithParams:params start:nil success:^(GHResource *instance, id data) {
        dispatch_async( dispatch_get_main_queue(),^ {
            [self showInfoView];
            TVExtraBranchView *_extraBranchView=[[TVExtraBranchView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 46)];
            _extraBranchView.scrollView=_scrollView;
            _extraBranchView.branchID=@"1";
            [self.view addSubview:_extraBranchView];
            [self.view setBackgroundColor:[UIColor colorWithRed:(239/255.0f) green:(239/255.0f) blue:(239/255.0f) alpha:1.0f]];
            
        });
    } failure:^(GHResource *instance, NSError *error) {
        dispatch_async( dispatch_get_main_queue(),^ {
            
        });
    }];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper

- (void)setRowWithHeight:(int *)heightDetailInfo_p detailInfoBranch:(UIView *)detailInfoBranch strDetail:(NSString *)strDetail strTiltle:(NSString *)strTiltle
{
    if (strDetail) {
        UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0.0f, *heightDetailInfo_p, detailInfoBranch.frame.size.width, 1.0f)];
        grayLine.backgroundColor = [UIColor colorWithRed:(243/255.0f) green:(243/255.0f) blue:(243/255.0f) alpha:1.0f];
        [detailInfoBranch addSubview:grayLine];
        
        UILabel *lblTitleRow = [[UILabel alloc] initWithFrame:CGRectMake(8, grayLine.frame.origin.y+grayLine.frame.size.height+5.0, 150, 23)];
        lblTitleRow.backgroundColor = [UIColor clearColor];
        lblTitleRow.textColor = [UIColor grayColor];
        lblTitleRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblTitleRow.text =strTiltle;
        [detailInfoBranch addSubview:lblTitleRow];
        
        UILabel *lblDetailRow = [[UILabel alloc] initWithFrame:CGRectMake(138, grayLine.frame.origin.y+grayLine.frame.size.height+ 5.0, 165, 23)];
        
        lblDetailRow.backgroundColor = [UIColor clearColor];
        lblDetailRow.textColor = [UIColor blackColor];
        lblDetailRow.font = [UIFont fontWithName:@"ArialMT" size:(12)];
        lblDetailRow.text = strDetail;
        lblDetailRow.numberOfLines = 0;
        lblDetailRow.lineBreakMode = UILineBreakModeWordWrap;
        [lblDetailRow sizeToFit];
        [detailInfoBranch addSubview:lblDetailRow];
        *heightDetailInfo_p+=14+lblDetailRow.frame.size.height;
    }
}

- (NSString*)getDetailStringFrom:(NSDictionary *)dic
{
    NSString* strStyleFoody;
    if ([[dic allValues] count]>0) {
        strStyleFoody=@"";
        BOOL isFistTime=YES;
        for (NSDictionary* dicStyle in [dic allValues]) {
            NSString* strStyleFoodyRow=@"";
            strStyleFoodyRow=[dicStyle valueForKey:@"name"];
            if (isFistTime) {
                isFistTime=NO;
                strStyleFoody=[strStyleFoody stringByAppendingFormat:@"%@",strStyleFoodyRow];
            }else
                strStyleFoody=[strStyleFoody stringByAppendingFormat:@", %@",strStyleFoodyRow];
        }
    }
    return strStyleFoody;
}

#pragma mark - IBAction
-(void)likeButtonClicked:(id)sender{
    
}

-(void)commentButtonClicked:(id)sender{
    [SharedAppDelegate.menuVC commentButtonClickedWithNav:self.navigationController];
}

-(void)cameraButtonClicked:(id)sender{
    [SharedAppDelegate.menuVC cameraButtonClickedWithNav:self.navigationController];
}

-(void)mapViewButtonClicked:(id)sender{
    
}

-(void)albumButtonClicked:(id)sender{
    TVPhotoBrowserVC* mbImagesVC;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        mbImagesVC = [[TVPhotoBrowserVC alloc] initWithNibName:@"TMViewController_iPhone" bundle:nil] ;
    } else {
        mbImagesVC = [[TVPhotoBrowserVC alloc] initWithNibName:@"TMViewController_iPad" bundle:nil] ;
    }
    mbImagesVC.brandID=_branch.branchID;
    [self.navigationController pushViewController:mbImagesVC animated:YES];
}

-(void)specialContentButtonClicked:(id)sender{
    SpecBranchProfileVC* specBranchVC=[[SpecBranchProfileVC alloc] initWithNibName:@"SpecBranchProfileVC" bundle:nil];
    specBranchVC.branch=_branch;
    [self.navigationController pushViewController:specBranchVC animated:YES];
}

-(void)backButtonClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setImgBranchCover:nil];
    [super viewDidUnload];
}

@end
