//
//  TMQuiltView
//
//  Created by Bruno Virlet on 7/20/12.
//
//  Copyright (c) 2012 1000memories

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//


#import "TVPhotoBrowserVC.h"
#import "TMPhotoQuiltViewCell.h"
#import "TMQuiltView.h"
#import "TVNetworkingClient.h"
#import "Ultilities.h"
@interface TVPhotoBrowserVC ()

@property (nonatomic, retain) NSDictionary *imagesDic;
@property (nonatomic, retain) NSArray *albumArr;
@end

@implementation TVPhotoBrowserVC




#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.quiltView.backgroundColor = [UIColor blackColor];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _brandID,@"branch_id" ,
                            nil];
    
    [[TVNetworkingClient sharedClient] postPath:@"branch/getImages" parameters:params success:^(AFHTTPRequestOperation *operation, id JSON) {
        _imagesDic=[JSON valueForKey:@"data"];
        NSLog(@"%@",_imagesDic);
        _albumArr=[[_imagesDic allValues] lastObject] ;
        
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - QuiltViewControllerDataSource

- (NSInteger)quiltViewNumberOfCells:(TMQuiltView *)TMQuiltView {
    return [self.albumArr count];
}

- (TMQuiltViewCell *)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath {
    TMPhotoQuiltViewCell *cell = (TMPhotoQuiltViewCell *)[quiltView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"];
    if (!cell) {
        cell = [[TMPhotoQuiltViewCell alloc] initWithReuseIdentifier:@"PhotoCell"] ;
    }
    NSDictionary* dic=[[[_albumArr objectAtIndex:indexPath.row] allValues] lastObject];
    [cell.photoView setImageWithURL:[Ultilities getLargeAlbumPhoto:dic]placeholderImage:nil];
    cell.titleLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    return cell;
}

#pragma mark - TMQuiltViewDelegate
- (void)quiltView:(TMQuiltView *)quiltView didSelectCellAtIndexPath:(NSIndexPath *)indexPath{
	MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.wantsFullScreenLayout = YES;
    
    if (!_photos) {
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        for (NSDictionary* dic in _albumArr) {
            NSDictionary* dicPhoto=[[dic allValues] lastObject];
            [photos addObject:[MWPhoto photoWithURL:[Ultilities getOriginalAlbumPhoto:dicPhoto]]];
        }
        _photos=photos;
    }
    
    [browser setInitialPageIndex:indexPath.row];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentModalViewController:nc animated:YES];
}

- (NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft 
        || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        return 3;
    } else {
        return 2;
    }
}

- (CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath {
    return 300 / [self quiltViewNumberOfColumns:quiltView];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

@end