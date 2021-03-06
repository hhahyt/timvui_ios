
#import "TVPagingScrollView.h"

@implementation TVPagingScrollView
{
	NSMutableSet *_recycledPages;
	NSMutableSet *_visiblePages;
	NSUInteger _firstVisiblePageIndexBeforeRotation;  // for autorotation
	CGFloat _percentScrolledIntoFirstVisiblePage;
}

- (void)commonInit
{
	_recycledPages = [[NSMutableSet alloc] init];
	_visiblePages  = [[NSMutableSet alloc] init];

	self.pagingEnabled = YES;
	self.showsVerticalScrollIndicator = NO;
	self.showsHorizontalScrollIndicator = NO;
	self.contentOffset = CGPointZero;
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self commonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self commonInit];
	}
	return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	// This allows for touch handling outside of the scroll view's bounds.

	CGPoint parentLocation = [self convertPoint:point toView:self.superview];

	CGRect responseRect = self.frame;
	responseRect.origin.x -= _previewInsets.left;
	responseRect.origin.y -= _previewInsets.top;
	responseRect.size.width += (_previewInsets.left + _previewInsets.right);
	responseRect.size.height += (_previewInsets.top + _previewInsets.bottom);

	return CGRectContainsPoint(responseRect, parentLocation);
}

- (void)selectPageAtIndex:(NSUInteger)index animated:(BOOL)animated
{
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3f];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	}

	self.contentOffset = CGPointMake(self.bounds.size.width * index, 0);

	if (animated)
		[UIView commitAnimations];
}

- (NSUInteger)indexOfSelectedPage
{
	CGFloat width = self.bounds.size.width;
	int currentPage = (self.contentOffset.x + width/2.0f) / width;
	return currentPage;
}

- (NSUInteger)numberOfPages
{
	return [_pagingDelegate numberOfPagesInPagingScrollView:self];
}

- (CGSize)contentSizeForPagingScrollView
{
	CGRect rect = self.bounds;
	return CGSizeMake(rect.size.width * [self numberOfPages], rect.size.height);
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
	for (PageView *page in _visiblePages)
	{
		if (page.index == index)
			return YES;
	}
	return NO;
}

- (PageView*)getPageForIndex:(NSUInteger)index
{
	for (PageView *page in _visiblePages)
	{
		if (page.index == index)
			return (PageView*)page;
	}
	return nil;
}

-(void)setNameBranchForPageViewName:(NSString*)name andAddress:(NSString*)address{
    for (PageView *page in _visiblePages)
	{
		[page setName:name andAddress:address];
	}
    for (PageView *page in _recycledPages)
	{
		[page setName:name andAddress:address];
	}
}

- (UIView *)dequeueReusablePageAtIndex:(int)index
{
    for (PageView *page in [_recycledPages allObjects]) {
        if (index==page.index) {
            UIView *view = page;
            [_recycledPages removeObject:page];
            return view;
        }
    }
	return nil;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
	CGRect rect = self.bounds;
	rect.origin.x = rect.size.width * index;
	return rect;
}

- (void)tilePages 
{
	CGRect visibleBounds = self.bounds;
	CGFloat pageWidth = CGRectGetWidth(visibleBounds);
	visibleBounds.origin.x -= _previewInsets.left;
	visibleBounds.size.width += (_previewInsets.left + _previewInsets.right);

	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / pageWidth);
	int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds) - 1.0f) / pageWidth);
	firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
	lastNeededPageIndex = MIN(lastNeededPageIndex, (int)[self numberOfPages] - 1);

	for (PageView *page in _visiblePages)
	{
		if ((int)page.index < firstNeededPageIndex || (int)page.index > lastNeededPageIndex)
		{
			[_recycledPages addObject:page];
			[page removeFromSuperview];
		}
	}

	[_visiblePages minusSet:_recycledPages];

	for (int i = firstNeededPageIndex; i <= lastNeededPageIndex; ++i)
	{
		if (![self isDisplayingPageForIndex:i])
		{
			PageView *pageView = [_pagingDelegate pagingScrollView:self pageForIndex:i];
			pageView.frame = [self frameForPageAtIndex:i];
			pageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			[self addSubview:pageView];
            pageView.index = i;
			[_visiblePages addObject:pageView];
		}
	}
}

- (void)reloadPages
{
	self.contentSize = [self contentSizeForPagingScrollView];
	[self tilePages];
}

- (void)scrollViewDidScroll
{
	[self tilePages];
}

- (void)beforeRotation
{
	CGFloat offset = self.contentOffset.x;
	CGFloat pageWidth = self.bounds.size.width;

	if (offset >= 0)
		_firstVisiblePageIndexBeforeRotation = floorf(offset / pageWidth);
	else
		_firstVisiblePageIndexBeforeRotation = 0;

	_percentScrolledIntoFirstVisiblePage = offset / pageWidth - _firstVisiblePageIndexBeforeRotation;
}

- (void)afterRotation
{
	self.contentSize = [self contentSizeForPagingScrollView];

	for (PageView *page in _visiblePages)
		page.frame = [self frameForPageAtIndex:page.index];

	CGFloat pageWidth = self.bounds.size.width;
	CGFloat newOffset = (_firstVisiblePageIndexBeforeRotation + _percentScrolledIntoFirstVisiblePage) * pageWidth;
	self.contentOffset = CGPointMake(newOffset, 0);
}

- (void)didReceiveMemoryWarning
{
	[_recycledPages removeAllObjects];
}

@end
