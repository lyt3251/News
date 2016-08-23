//
//  KDCycleBannerView.m
//  KDCycleBannerViewDemo
//
//  Created by Kingiol on 14-4-11.
//  Copyright (c) 2014年 Kingiol. All rights reserved.
//

#import "KDCycleBannerView.h"
#import "UIImageView+AFNetworking.h"

@interface KDCycleBannerView () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) BOOL scrollViewBounces;

@property (strong, nonatomic) UIView *curveView;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) NSArray *datasourceImages;
@property (assign, nonatomic) NSUInteger currentSelectedPage;

@property (strong, nonatomic) CompleteBlock completeBlock;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation KDCycleBannerView

static void *kContentImageViewObservationContext = &kContentImageViewObservationContext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _scrollViewBounces = YES;
        _curveDistance = 2.f;
        _backgroundCurveColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        _maskCurveColor = [UIColor whiteColor];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _scrollViewBounces = YES;
        _curveDistance = 2.f;
        _backgroundCurveColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
        _maskCurveColor = [UIColor whiteColor];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    NSArray *subViews = self.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self initialize];
    
    if (self.completeBlock) {
        self.completeBlock();
    }
}

- (void)initialize {
    self.clipsToBounds = YES;
    
    [self initializeScrollView];
    if (_addCurveLine) {
        [self initializeCurveView];
    }
//    [self initializePageControl];
    [self initBottomView];
  
    [self loadData];
    
    // progress autoPlayTimeInterval
    if (self.autoPlayTimeInterval > 0) {
        if ((self.isContinuous && _datasourceImages.count > 3) || (!self.isContinuous &&_datasourceImages.count > 1)) {
            [self performSelector:@selector(autoSwitchBannerView) withObject:nil afterDelay:self.autoPlayTimeInterval];
        }
    }
}

- (void)initializeScrollView {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.autoresizingMask = self.autoresizingMask;
    [self addSubview:_scrollView];
}
//创建半弧形的效果
- (void)initializeCurveView {
    _curveView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _curveView.backgroundColor = [UIColor clearColor];
    _curveView.clipsToBounds = YES;
    _curveView.userInteractionEnabled = NO;
    [self addSubview:_curveView];
    
    CGFloat distance = 15.f;
    CGFloat layerDistance = _curveDistance;
    CGFloat halfWidth = CGRectGetWidth(self.frame) / 2;
    CGFloat radius = (halfWidth * halfWidth + distance * distance) / (2 * distance);
    CGFloat offsetH = radius - distance;
    //    CGFloat degress = asin(offsetH / radius);
    //第一层layer
    UIBezierPath *bgPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height + offsetH - layerDistance) radius:radius startAngle:M_PI endAngle:M_PI * 2 clockwise:YES];
    CAShapeLayer *bgLayer = [CAShapeLayer layer];
    bgLayer.fillColor = _backgroundCurveColor.CGColor;
    bgLayer.strokeEnd = 1.f;
    bgLayer.path = bgPath.CGPath;
    bgLayer.strokeColor = [UIColor clearColor].CGColor;
    [_curveView.layer addSublayer:bgLayer];
    //第二层layer
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height + offsetH) radius:radius startAngle:M_PI endAngle:M_PI * 2 clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = _maskCurveColor.CGColor;
    shapeLayer.strokeEnd = 1.f;
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor clearColor].CGColor;
    [_curveView.layer addSublayer:shapeLayer];
}

-(void)initBottomView
{
    _bottomView = [[UIView alloc] init];
    CGRect bottomControlFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 35);
    CGPoint center = CGPointMake(CGRectGetWidth(_scrollView.frame)*0.5, CGRectGetHeight(_scrollView.frame) - 17.f);
    if (_addCurveLine) {
        bottomControlFrame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 20);
        center = CGPointMake(CGRectGetWidth(_scrollView.frame)*0.5, CGRectGetHeight(_scrollView.frame) - 12.f);
    }
    _bottomView.backgroundColor = RGBACOLOR(0, 0, 0, 0.3f);
    _bottomView.frame = bottomControlFrame;
    _bottomView.center = center;
    [self addSubview:_bottomView];
    [self initializePageControl];
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textColor = kColorWhite;
    textLabel.font = kFontLarge;
    [_bottomView addSubview:textLabel];
    textLabel.text = @"  ";
    self.titleLabel = textLabel;
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(_bottomView);
        make.right.mas_equalTo(_pageControl.mas_left);
    }];
    
    
}


- (void)initializePageControl {
    CGRect pageControlFrame = CGRectMake(_bottomView.width_ - 100, 0, 100, 35);
//    CGPoint center = CGPointMake(CGRectGetWidth(_scrollView.frame)*0.5, CGRectGetHeight(_scrollView.frame) - 12.f);
    if (_addCurveLine) {
        pageControlFrame = CGRectMake(_bottomView.width_ - 100, 0, 100, 20);
//        center = CGPointMake(CGRectGetWidth(_scrollView.frame)*0.5, CGRectGetHeight(_scrollView.frame) - 5.f);
    }
    _pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
//    _pageControl.center = center;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.userInteractionEnabled = NO;
    if (_pageIndicatorTintColor) {
        _pageControl.pageIndicatorTintColor = _pageIndicatorTintColor;
    }
    if (_currentPageIndicatorTintColor) {
        _pageControl.currentPageIndicatorTintColor = _currentPageIndicatorTintColor;
    }
    [_bottomView addSubview:_pageControl];
}

- (void)loadData {
    NSAssert(_datasource != nil, @"datasource must not nil");
    _datasourceImages = [_datasource numberOfKDCycleBannerView:self];
    
    if (_datasourceImages.count == 0) {
        //显示默认页，无数据页面
        if ([self.datasource respondsToSelector:@selector(placeHolderImageOfZeroBannerView)]) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_scrollView.frame), CGRectGetHeight(_scrollView.frame))];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.backgroundColor = [UIColor clearColor];
            imageView.image = [self.datasource placeHolderImageOfZeroBannerView];
            [_scrollView addSubview:imageView];
        }
        return;
    }
    
    _pageControl.numberOfPages = _datasourceImages.count;
    _pageControl.currentPage = 0;
    self.titleLabel.text = [_datasource titleAtIndex:0];
    
    if (self.isContinuous) {
        NSMutableArray *cycleDatasource = [_datasourceImages mutableCopy];
        [cycleDatasource insertObject:[_datasourceImages lastObject] atIndex:0];
        [cycleDatasource addObject:[_datasourceImages firstObject]];
        _datasourceImages = [cycleDatasource copy];
    }
    
    CGFloat contentWidth = CGRectGetWidth(_scrollView.frame);
    CGFloat contentHeight = CGRectGetHeight(_scrollView.frame);
    
    _scrollView.contentSize = CGSizeMake(contentWidth * _datasourceImages.count, contentHeight);
    
    for (NSInteger i = 0; i < _datasourceImages.count; i++) {
        CGRect imgRect = CGRectMake(contentWidth * i, 0, contentWidth, contentHeight);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imgRect];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.clipsToBounds = YES;
        imageView.contentMode = [_datasource contentModeForImageIndex:i];
        
        id sourceData = [_datasourceImages objectAtIndex:i];
        id imageSource = [_datasource imageSourceForContent:sourceData];

        if ([imageSource isKindOfClass:[UIImage class]]) {
            imageView.image = imageSource;
        }else if ([imageSource isKindOfClass:[NSString class]] || [imageSource isKindOfClass:[NSURL class]]) {
            UIActivityIndicatorView *activityIndicatorView = [UIActivityIndicatorView new];
            activityIndicatorView.center = CGPointMake(CGRectGetWidth(_scrollView.frame) * 0.5, CGRectGetHeight(_scrollView.frame) * 0.5);
            activityIndicatorView.tag = 100;
            activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            [activityIndicatorView startAnimating];
            [imageView addSubview:activityIndicatorView];
            [imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:kContentImageViewObservationContext];
            
            if ([self.datasource respondsToSelector:@selector(placeHolderImageOfBannerView:atIndex:)]) {
                UIImage *placeHolderImage = [self.datasource placeHolderImageOfBannerView:self atIndex:i];
                if ([[[UIDevice currentDevice] systemVersion] compare:@"7"] != NSOrderedAscending) {
                    //NSAssert(placeHolderImage != nil, @"placeHolderImage must not be nil");
                }
                [imageView setImageWithURL:[imageSource isKindOfClass:[NSString class]] ? [NSURL URLWithString:imageSource] : imageSource placeholderImage:placeHolderImage];
            }else {
                [imageView setImageWithURL:[imageSource isKindOfClass:[NSString class]] ? [NSURL URLWithString:imageSource] : imageSource];
            }
            
        }
        [_scrollView addSubview:imageView];
    }
    
    if (self.isContinuous && _datasourceImages.count > 1) {
        _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
    }
    
    // single tap gesture recognizer
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    
}

- (void)reloadDataWithCompleteBlock:(CompleteBlock)competeBlock {
    self.completeBlock = competeBlock;
    [self setNeedsLayout];
}

- (void)moveToTargetPosition:(CGFloat)targetX withAnimated:(BOOL)animated {
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}

- (void)setCurrentPage:(NSInteger)currentPage animated:(BOOL)animated {
    NSInteger page = MIN(_datasourceImages.count - 1, MAX(0, currentPage));
    
    [self setSwitchPage:page animated:animated withUserInterface:YES];
}

- (void)setSwitchPage:(NSInteger)switchPage animated:(BOOL)animated withUserInterface:(BOOL)userInterface {
    
    NSInteger page = -1;
    
    if (userInterface) {
        page = switchPage;
    }else {
        _currentSelectedPage++;
        page = _currentSelectedPage % (self.isContinuous ? (_datasourceImages.count - 1) : _datasourceImages.count);
    }
    
    if (self.isContinuous) {
        if (_datasourceImages.count > 1) {
            if (page >= (_datasourceImages.count -2)) {
                page = _datasourceImages.count - 3;
                _currentSelectedPage = 0;
                [self moveToTargetPosition:CGRectGetWidth(_scrollView.frame) * (page + 2) withAnimated:animated];
            }else {
                [self moveToTargetPosition:CGRectGetWidth(_scrollView.frame) * (page + 1) withAnimated:animated];
            }
        }else {
            [self moveToTargetPosition:0 withAnimated:animated];
        }
    }else {
        [self moveToTargetPosition:CGRectGetWidth(_scrollView.frame) * page withAnimated:animated];
    }

    if([_datasource respondsToSelector:@selector(titleAtIndex:)])
    {
        self.titleLabel.text = [_datasource titleAtIndex:page];
        [self.titleLabel layoutIfNeeded];
    }
    
    
    [self scrollViewDidScroll:_scrollView];
}

- (void)autoSwitchBannerView {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoSwitchBannerView) object:nil];
    
    [self setSwitchPage:-1 animated:YES withUserInterface:NO];
    
    [self performSelector:_cmd withObject:nil afterDelay:self.autoPlayTimeInterval];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == kContentImageViewObservationContext) {
        UIImageView *imageView = (UIImageView *)object;
        UIActivityIndicatorView *activityIndicatorView = (UIActivityIndicatorView *)[imageView viewWithTag:100];
        [activityIndicatorView removeFromSuperview];
        [imageView removeObserver:self forKeyPath:@"image"];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat targetX = scrollView.contentOffset.x;
    
    CGFloat item_width = CGRectGetWidth(scrollView.frame);
    
    if (self.isContinuous && _datasourceImages.count >= 3) {
        if (targetX >= item_width * (_datasourceImages.count - 1)) {
            targetX = item_width;
            _scrollView.contentOffset = CGPointMake(targetX, 0);
        }else if (targetX <= 0) {
            targetX = item_width * (_datasourceImages.count - 2);
            _scrollView.contentOffset = CGPointMake(targetX, 0);
        }
    }
    if ([self.delegate respondsToSelector:@selector(cycleBannerView:didScrollToOffset:)]) {
        [self.delegate cycleBannerView:self didScrollToOffset:_scrollView.contentOffset];
    }
    
    NSInteger page = (scrollView.contentOffset.x + item_width * 0.5) / item_width;
    
    if (self.isContinuous && _datasourceImages.count > 1) {
        page--;
        if (page >= _pageControl.numberOfPages) {
            page = 0;
        }else if (page < 0) {
            page = _pageControl.numberOfPages - 1;
        }
    }
    
    _currentSelectedPage = page;
    
    if (page != _pageControl.currentPage) {
        if ([self.delegate respondsToSelector:@selector(cycleBannerView:didScrollToIndex:)]) {
            [self.delegate cycleBannerView:self didScrollToIndex:page];
        }
    }
    
    _pageControl.currentPage = page;
}

#pragma mark - UIGestureRecognizerDelegate

#pragma mark - UITapGestureRecognizerSelector

- (void)singleTapGestureRecognizer:(UITapGestureRecognizer *)tapGesture {
    
    NSInteger page = (NSInteger)(_scrollView.contentOffset.x / CGRectGetWidth(_scrollView.frame));
    
    if ([self.delegate respondsToSelector:@selector(cycleBannerView:didSelectedAtIndex:)]) {
        [self.delegate cycleBannerView:self didSelectedAtIndex:self.isContinuous ? --page : page];
    }
}

@end
