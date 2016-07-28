//
//  ViewPagerController.m
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import "ViewPagerController.h"
#import "UIColor+Hex.h"
#import "Reachability.h"

#pragma mark - Constants and macros
#define kTabViewTag 38
#define kContentViewTag 34
#define IOS_VERSION_7 [[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define G_DefaultBGColor    [UIColor whiteColor]
#define G_DefaultTintColor  [UIColor greenColor]//[UIColor colorWithRed:35.0f/255.0f green:136.0f/255.0f blue:219.0f/255.0f alpha:1.0]
#define G_DefaultViewColor  [UIColor greenColor]//[UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0]
#define G_DefaultTitleColor [UIColor colorWithHexStr:@"ffc001"] //导航条文字颜色
#define G_UnselectedTitleColor [UIColor colorWithHexStr:@"444444"]//频道切换未选中时TitleColor
#define G_selectedTitleColor [UIColor colorWithHexStr:@"ff933d"]
#define navBarBackgroundColor RGBACOLOR(0, 0, 0, 0.3)

#define kTabHeight 33.0
#define kTabOffset 17.0
#define kTabWidth [UIScreen mainScreen].bounds.size.width
#define kTabLocation 1.0
#define kStartFromSecondTab 0.0
#define kCenterCurrentTab 0.0
#define kFixFormerTabsPositions 0.0
#define kFixLatterTabsPositions 0.0

#define kIndicatorColor [UIColor colorWithRed:178.0/255.0 green:203.0/255.0 blue:57.0/255.0 alpha:0.75]
#define kTabsViewBackgroundColor [UIColor greenColor]//[UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:0.75]
#define kContentViewBackgroundColor [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:0.75]
#define IOS_VERSION_7 [[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending

#pragma mark - UIColor+Equality
@interface UIColor (Equality)
- (BOOL)isEqualToColor:(UIColor *)otherColor;
@end

@implementation UIColor (Equality)
// This method checks if two UIColors are the same
// Thanks to @samvermette for this method: http://stackoverflow.com/a/8899384/1931781
- (BOOL)isEqualToColor:(UIColor *)otherColor {
    
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();
    
    UIColor *(^convertColorToRGBSpace)(UIColor *) = ^(UIColor *color) {
        if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            CGColorRef cgColor = CGColorCreate(colorSpaceRGB, components);
            color = [UIColor colorWithCGColor:cgColor];
            CGColorRelease(cgColor);
            return color;
        } else {
            return color;
        }
    };
    
    UIColor *selfColor = convertColorToRGBSpace(self);
    otherColor = convertColorToRGBSpace(otherColor);
    CGColorSpaceRelease(colorSpaceRGB);
    
    return [selfColor isEqual:otherColor];
}
@end

#pragma mark - TabView
@class TabView;

@interface TabView : UIView
@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic) UIColor *indicatorColor;
@end

@implementation TabView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    // Update view as state changed
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;
    // Draw an indicator line if tab is selected
    if (self.selected) {
        
        bezierPath = [UIBezierPath bezierPath];
        
        //        float height = CGRectGetHeight(rect);
        //        float width = CGRectGetWidth(rect);
        // Draw the indicator
        [bezierPath moveToPoint:CGPointMake(12, CGRectGetHeight(rect))];
        [bezierPath addLineToPoint:CGPointMake(CGRectGetWidth(rect)-12, CGRectGetHeight(rect))];
        [bezierPath setLineWidth:4.0];
        [self.indicatorColor setStroke];
        [bezierPath stroke];
    }
}
@end

#pragma mark - ViewPagerController
@interface ViewPagerController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    BOOL isChange;
}
// Tab and content stuff
@property UIView *backgroundView;
@property UIImageView *leftTabView;
@property UIImageView *rightTabView;
@property UIScrollView *tabsView;


@property (assign) id<UIScrollViewDelegate> actualDelegate;

// Tab and content cache
@property NSMutableArray *tabs;
@property NSMutableArray *contents;

// Options
@property (nonatomic) NSNumber *tabHeight;
@property (nonatomic) NSNumber *tabOffset;
@property (nonatomic) NSNumber *tabWidth;
@property (nonatomic) NSNumber *tabLocation;
@property (nonatomic) NSNumber *startFromSecondTab;
@property (nonatomic) NSNumber *centerCurrentTab;
@property (nonatomic) NSNumber *fixFormerTabsPositions;
@property (nonatomic) NSNumber *fixLatterTabsPositions;

@property (nonatomic) NSUInteger tabCount;

@property (nonatomic) NSUInteger activeContentIndex;

@property (getter = isAnimatingToTab, assign) BOOL animatingToTab;
@property (getter = isDefaultSetupDone, assign) BOOL defaultSetupDone;

// Colors
@property (nonatomic) UIColor *indicatorColor;
@property (nonatomic) UIColor *tabsViewBackgroundColor;
@property (nonatomic) UIColor *contentViewBackgroundColor;

@end

@implementation ViewPagerController

@synthesize tabHeight = _tabHeight;
@synthesize tabOffset = _tabOffset;
@synthesize tabWidth = _tabWidth;
@synthesize tabLocation = _tabLocation;
@synthesize startFromSecondTab = _startFromSecondTab;
@synthesize centerCurrentTab = _centerCurrentTab;
@synthesize fixFormerTabsPositions = _fixFormerTabsPositions;
@synthesize fixLatterTabsPositions = _fixLatterTabsPositions;

#pragma mark - Init
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSettings];
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self defaultSettings];
    }
    return self;
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //禁止手势返回
    self.fd_interactivePopDisabled = YES;
    //    self.navigationController.navigationBarHidden = NO;
    //    self.navigationController.navigationBar.translucent = NO;
    //    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithHexStr:@"f5f5f5"];
    //    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexStr:@"1f1f1f"];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // Do setup if it's not done yet
    if (![self isDefaultSetupDone]) {
        [self defaultSetup];
    }
}
- (void)viewWillLayoutSubviews {
    
    // Re-layout sub views
    [self layoutSubviews];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)layoutSubviews {
    
    CGFloat topLayoutGuide = 0.0;
    if (IOS_VERSION_7) {
        topLayoutGuide = 74.0;
        //        if (self.navigationController && !self.navigationController.navigationBarHidden) {
        //            topLayoutGuide += self.navigationController.navigationBar.frame.size.height;
        //        }
    }else{
         topLayoutGuide = 44.0;//因为是自定义的nav所以64
    }
   
    //    CGRect lframe = self.view.frame;//self.view.frame 会随着导航条出现和隐藏改变
    
    CGRect frame = self.tabsView.frame;
    frame.origin.x = 0.0;
    frame.origin.y = [self.tabLocation boolValue] ? topLayoutGuide : CGRectGetHeight(self.view.frame) - [self.tabHeight floatValue];
    
    CGFloat width = 0;
    //50 图标位置
    
    UIImage *image = [UIImage imageNamed:@"wxyAdd"];
    width = kScreenWidth-image.size.height-14;
    
    
    frame.size.width = width;
    frame.size.height = [self.tabHeight floatValue];
    self.tabsView.frame = frame;
    
    frame = self.contentView.frame;
    frame.origin.x = 0.0;
    if (isChange==YES) {
        frame.origin.y = 0;
        frame.size.height = kScreenHeight;
        isChange = NO;
    }else{
        frame.origin.y = [self.tabLocation boolValue] ? topLayoutGuide + CGRectGetHeight(self.tabsView.frame) : topLayoutGuide;
        frame.size.height = kScreenHeight - (topLayoutGuide + CGRectGetHeight(self.tabsView.frame));
    }
    
    frame.size.width = kScreenWidth;
    
    self.contentView.frame = frame;
    
    //    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth,1)];
    //    topView.backgroundColor = [UIColor colorWithHexStr:@"333333"];
    //    [self.tabsView addSubview:topView];
    //
    //    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,32,kScreenWidth,1)];
    //    bottomView.backgroundColor = [UIColor colorWithHexStr:@"333333"];
    //    [self.tabsView addSubview:bottomView];
}

#pragma mark - IBAction
- (IBAction)handleTapGesture:(id)sender {
    
    // Get the desired page's index
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *)sender;
    UIView *tabView = tapGestureRecognizer.view;
    __block NSUInteger index = [self.tabs indexOfObject:tabView];
    
    //if Tap is not selected Tab(new Tab)
    if (self.activeTabIndex != index) {
        // Select the tab
        [self selectTabAtIndex:index];
    }
}

#pragma mark - Interface rotation
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // Re-layout sub views
    [self layoutSubviews];
    
    // Re-align tabs if needed
    self.activeTabIndex = self.activeTabIndex;
}

#pragma mark - Setters
- (void)setTabHeight:(NSNumber *)tabHeight {
    
    if ([tabHeight floatValue] < 4.0)
        tabHeight = [NSNumber numberWithFloat:4.0];
    else if ([tabHeight floatValue] > CGRectGetHeight(self.view.frame))
        tabHeight = [NSNumber numberWithFloat:CGRectGetHeight(self.view.frame)];
    
    _tabHeight = tabHeight;
}
- (void)setTabOffset:(NSNumber *)tabOffset {
    
    if ([tabOffset floatValue] < 0.0)
        tabOffset = [NSNumber numberWithFloat:0.0];
    else if ([tabOffset floatValue] > CGRectGetWidth(self.view.frame) - [self.tabWidth floatValue])
        tabOffset = [NSNumber numberWithFloat:CGRectGetWidth(self.view.frame) - [self.tabWidth floatValue]];
    
    _tabOffset = tabOffset;
}
- (void)setTabWidth:(NSNumber *)tabWidth {
    
    if ([tabWidth floatValue] < 4.0)
        tabWidth = [NSNumber numberWithFloat:4.0];
    else if ([tabWidth floatValue] > CGRectGetWidth(self.view.frame))
        tabWidth = [NSNumber numberWithFloat:CGRectGetWidth(self.view.frame)];
    
    _tabWidth = tabWidth;
}
- (void)setTabLocation:(NSNumber *)tabLocation {
    
    if ([tabLocation floatValue] != 1.0 && [tabLocation floatValue] != 0.0)
        tabLocation = [tabLocation boolValue] ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
    
    _tabLocation = tabLocation;
}
- (void)setStartFromSecondTab:(NSNumber *)startFromSecondTab {
    
    if ([startFromSecondTab floatValue] != 1.0 && [startFromSecondTab floatValue] != 0.0)
        startFromSecondTab = [startFromSecondTab boolValue] ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
    
    _startFromSecondTab = startFromSecondTab;
}
- (void)setCenterCurrentTab:(NSNumber *)centerCurrentTab {
    
    if ([centerCurrentTab floatValue] != 1.0 && [centerCurrentTab floatValue] != 0.0)
        centerCurrentTab = [centerCurrentTab boolValue] ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
    
    _centerCurrentTab = centerCurrentTab;
}
- (void)setFixFormerTabsPositions:(NSNumber *)fixFormerTabsPositions {
    
    if ([fixFormerTabsPositions floatValue] != 1.0 && [fixFormerTabsPositions floatValue] != 0.0)
        fixFormerTabsPositions = [fixFormerTabsPositions boolValue] ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
    
    _fixFormerTabsPositions = fixFormerTabsPositions;
}
- (void)setFixLatterTabsPositions:(NSNumber *)fixLatterTabsPositions {
    
    if ([fixLatterTabsPositions floatValue] != 1.0 && [fixLatterTabsPositions floatValue] != 0.0)
        fixLatterTabsPositions = [fixLatterTabsPositions boolValue] ? [NSNumber numberWithBool:YES] : [NSNumber numberWithBool:NO];
    
    _fixLatterTabsPositions = fixLatterTabsPositions;
}

- (void)changeAllUnSelect{
    TabView *activeTabView;
    
    // Set to-be-inactive tab unselected
    activeTabView = [self tabViewAtIndex:self.activeTabIndex];
    activeTabView.selected = NO;
    
    //点击时改变字体颜色
    for (UIView *view in activeTabView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (id)view;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = G_UnselectedTitleColor;//未点击颜色
            UIFont *font = [UIFont systemFontOfSize:14.0];
            [label setFont:font];
        }
    }
    
    
    // Set to-be-active tab selected
    activeTabView = [self tabViewAtIndex:self.activeTabIndex];
    activeTabView.backgroundColor = [UIColor clearColor];
    activeTabView.selected = YES;
    
    //点击时改变字体颜色
    for (UIView *view in activeTabView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (id)view;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = G_selectedTitleColor;//点击时颜色
            UIFont *font = [UIFont boldSystemFontOfSize:16.0];
            [label setFont:font];
            [label setFrame:CGRectMake(0,0,activeTabView.frame.size.width,activeTabView.frame.size.height)];
        }
    }
    self.activeTabIndex = 100000;
}

- (void)setActiveTabIndex:(NSUInteger)activeTabIndex {
    
    TabView *activeTabView;
    
    // Set to-be-inactive tab unselected
    activeTabView = [self tabViewAtIndex:self.activeTabIndex];
    activeTabView.selected = NO;
    
    //点击时改变字体颜色
    for (UIView *view in activeTabView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (id)view;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = G_UnselectedTitleColor;//未点击颜色
            UIFont *font = [UIFont systemFontOfSize:14.0];
            [label setFont:font];
        }
    }
    
    // Set to-be-active tab selected
    activeTabView = [self tabViewAtIndex:activeTabIndex];
    activeTabView.backgroundColor = [UIColor clearColor];
    activeTabView.selected = YES;
    
    //点击时改变字体颜色
    for (UIView *view in activeTabView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (id)view;
            label.backgroundColor = [UIColor clearColor];
            label.textColor = G_selectedTitleColor;//点击时颜色
            UIFont *font = [UIFont boldSystemFontOfSize:16.0];
            [label setFont:font];
            [label setFrame:CGRectMake(0,0,activeTabView.frame.size.width,activeTabView.frame.size.height)];
        }
    }
    
    // Set current activeTabIndex
    _activeTabIndex = activeTabIndex;
    
    // Bring tab to active position
    // Position the tab in center if centerCurrentTab option is provided as YES
    UIView *tabView = [self tabViewAtIndex:self.activeTabIndex];
    CGRect frame = tabView.frame;
    
    if ([self.centerCurrentTab boolValue]) {
        
        frame.origin.x += (CGRectGetWidth(frame) / 2);
        frame.origin.x -= CGRectGetWidth(self.tabsView.frame) / 2;
        frame.size.width = CGRectGetWidth(self.tabsView.frame);
        
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
        }
        
        if ((frame.origin.x + CGRectGetWidth(frame)) > self.tabsView.contentSize.width) {
            frame.origin.x = (self.tabsView.contentSize.width - CGRectGetWidth(self.tabsView.frame));
        }
    } else {
        
        frame.origin.x -= [self.tabOffset floatValue];
        frame.size.width = CGRectGetWidth(self.tabsView.frame);
    }
    
    [self.tabsView scrollRectToVisible:frame animated:YES];
}
- (void)setActiveContentIndex:(NSUInteger)activeContentIndex {
    
    // Get the desired viewController
    UIViewController *viewController = [self viewControllerAtIndex:activeContentIndex];
    
    if (!viewController) {
        viewController = [[UIViewController alloc] init];
        viewController.view = [[UIView alloc] init];
        viewController.view.backgroundColor = [UIColor clearColor];
    }
    
    // __weak pageViewController to be used in blocks to prevent retaining strong reference to self
    __weak ViewPagerController *weakSelf = self;
    
    if (activeContentIndex == self.activeContentIndex) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.pageViewController setViewControllers:@[viewController]
                                                  direction:UIPageViewControllerNavigationDirectionForward
                                                   animated:NO
                                                 completion:^(BOOL completed) {
                                                     weakSelf.animatingToTab = NO;
                                                 }];
        });
    } else if (!(activeContentIndex + 1 == self.activeContentIndex || activeContentIndex - 1 == self.activeContentIndex)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.pageViewController setViewControllers:@[viewController]
                                                  direction:(activeContentIndex < weakSelf.activeContentIndex) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward
                                                   animated:NO
                                                 completion:^(BOOL completed) {
                                                     weakSelf.animatingToTab = NO;
                                                 }];
        });
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.pageViewController setViewControllers:@[viewController]
                                                  direction:(activeContentIndex < weakSelf.activeContentIndex) ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward
                                                   animated:NO
                                                 completion:^(BOOL completed) {
                                                     weakSelf.animatingToTab = NO;
                                                 }];
        });
    }
    
    // Clean out of sight contents
    NSInteger index;
    index = self.activeContentIndex - 1;
    if (index >= 0 &&
        index != activeContentIndex &&
        index != activeContentIndex - 1)
    {
        [self.contents replaceObjectAtIndex:index withObject:[NSNull null]];
    }
    index = self.activeContentIndex;
    if (index != activeContentIndex - 1 &&
        index != activeContentIndex &&
        index != activeContentIndex + 1)
    {
        [self.contents replaceObjectAtIndex:index withObject:[NSNull null]];
    }
    index = self.activeContentIndex + 1;
    if (index < self.contents.count &&
        index != activeContentIndex &&
        index != activeContentIndex + 1)
    {
        [self.contents replaceObjectAtIndex:index withObject:[NSNull null]];
    }
    
    _activeContentIndex = activeContentIndex;
}

#pragma mark - Getters
- (NSNumber *)tabHeight {
    
    if (!_tabHeight) {
        CGFloat value = kTabHeight;
        if ([self.delegate respondsToSelector:@selector(viewPager:valueForOption:withDefault:)])
            value = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabHeight withDefault:value];
        self.tabHeight = [NSNumber numberWithFloat:value];
    }
    return _tabHeight;
}
- (NSNumber *)tabOffset {
    
    if (!_tabOffset) {
        CGFloat value = kTabOffset;
        if ([self.delegate respondsToSelector:@selector(viewPager:valueForOption:withDefault:)])
            value = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabOffset withDefault:value];
        self.tabOffset = [NSNumber numberWithFloat:value];
    }
    return _tabOffset;
}
- (NSNumber *)tabWidth {
    
    if (!_tabWidth) {
        CGFloat value = kTabWidth;
        if ([self.delegate respondsToSelector:@selector(viewPager:valueForOption:withDefault:)])
            value = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabWidth withDefault:value];
        self.tabWidth = [NSNumber numberWithFloat:value];
    }
    return _tabWidth;
}
- (NSNumber *)tabLocation {
    
    if (!_tabLocation) {
        CGFloat value = kTabLocation;
        if ([self.delegate respondsToSelector:@selector(viewPager:valueForOption:withDefault:)])
            value = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabLocation withDefault:value];
        self.tabLocation = [NSNumber numberWithFloat:value];
    }
    return _tabLocation;
}
- (NSNumber *)startFromSecondTab {
    
    if (!_startFromSecondTab) {
        CGFloat value = kStartFromSecondTab;
        if ([self.delegate respondsToSelector:@selector(viewPager:valueForOption:withDefault:)])
            value = [self.delegate viewPager:self valueForOption:ViewPagerOptionStartFromSecondTab withDefault:value];
        self.startFromSecondTab = [NSNumber numberWithFloat:value];
    }
    return _startFromSecondTab;
}
- (NSNumber *)centerCurrentTab {
    
    if (!_centerCurrentTab) {
        CGFloat value = kCenterCurrentTab;
        if ([self.delegate respondsToSelector:@selector(viewPager:valueForOption:withDefault:)])
            value = [self.delegate viewPager:self valueForOption:ViewPagerOptionCenterCurrentTab withDefault:value];
        self.centerCurrentTab = [NSNumber numberWithFloat:value];
    }
    return _centerCurrentTab;
}
- (NSNumber *)fixFormerTabsPositions {
    
    if (!_fixFormerTabsPositions) {
        CGFloat value = kFixFormerTabsPositions;
        if ([self.delegate respondsToSelector:@selector(viewPager:valueForOption:withDefault:)])
            value = [self.delegate viewPager:self valueForOption:ViewPagerOptionFixFormerTabsPositions withDefault:value];
        self.fixFormerTabsPositions = [NSNumber numberWithFloat:value];
    }
    return _fixFormerTabsPositions;
}
- (NSNumber *)fixLatterTabsPositions {
    
    if (!_fixLatterTabsPositions) {
        CGFloat value = kFixLatterTabsPositions;
        if ([self.delegate respondsToSelector:@selector(viewPager:valueForOption:withDefault:)])
            value = [self.delegate viewPager:self valueForOption:ViewPagerOptionFixLatterTabsPositions withDefault:value];
        self.fixLatterTabsPositions = [NSNumber numberWithFloat:value];
    }
    return _fixLatterTabsPositions;
}

- (UIColor *)indicatorColor {
    
    if (!_indicatorColor) {
        UIColor *color = kIndicatorColor;
        if ([self.delegate respondsToSelector:@selector(viewPager:colorForComponent:withDefault:)]) {
            color = [self.delegate viewPager:self colorForComponent:ViewPagerIndicator withDefault:color];
        }
        self.indicatorColor = color;
    }
    return _indicatorColor;
}
- (UIColor *)tabsViewBackgroundColor {
    
    if (!_tabsViewBackgroundColor) {
        UIColor *color = kTabsViewBackgroundColor;
        if ([self.delegate respondsToSelector:@selector(viewPager:colorForComponent:withDefault:)]) {
            color = [self.delegate viewPager:self colorForComponent:ViewPagerTabsView withDefault:color];
        }
        self.tabsViewBackgroundColor = color;
    }
    return _tabsViewBackgroundColor;
}
- (UIColor *)contentViewBackgroundColor {
    
    if (!_contentViewBackgroundColor) {
        UIColor *color = kContentViewBackgroundColor;
        if ([self.delegate respondsToSelector:@selector(viewPager:colorForComponent:withDefault:)]) {
            color = [self.delegate viewPager:self colorForComponent:ViewPagerContent withDefault:color];
        }
        self.contentViewBackgroundColor = color;
    }
    return _contentViewBackgroundColor;
}

#pragma mark - Public methods
- (void)reloadData {
    
    // Empty all options and colors
    // So that, ViewPager will reflect the changes
    // Empty all options
    _tabHeight = nil;
    _tabOffset = nil;
    _tabWidth = nil;
    _tabLocation = nil;
    _startFromSecondTab = nil;
    _centerCurrentTab = nil;
    _fixFormerTabsPositions = nil;
    _fixLatterTabsPositions = nil;
    
    // Empty all colors
    _indicatorColor = nil;
    _tabsViewBackgroundColor = nil;
    _contentViewBackgroundColor = nil;
    // Index重置
    _activeTabIndex = 0;
    _activeContentIndex = 0;
    
    // Call to setup again with the updated data
    [self defaultSetup];
}
- (void)selectTabAtIndex:(NSUInteger)index {
    
    if (index >= self.tabCount) {
        return;
    }
    
    self.animatingToTab = NO;
    
    // Set activeTabIndex
    self.activeTabIndex = index;
    
    // Set activeContentIndex
    self.activeContentIndex = index;
    
    // Inform delegate about the change
    if ([self.delegate respondsToSelector:@selector(viewPager:didChangeTabToIndex:)]) {
        [self.delegate viewPager:self didChangeTabToIndex:self.activeTabIndex];
    }
}

- (void)setNeedsReloadOptions {
    
    // If our delegate doesn't respond to our options method, return
    // Otherwise reload options
    if (![self.delegate respondsToSelector:@selector(viewPager:valueForOption:withDefault:)]) {
        return;
    }
    
    // Update these options
    self.tabWidth = [NSNumber numberWithFloat:[self.delegate viewPager:self valueForOption:ViewPagerOptionTabWidth withDefault:kTabWidth]];
    self.tabOffset = [NSNumber numberWithFloat:[self.delegate viewPager:self valueForOption:ViewPagerOptionTabOffset withDefault:kTabOffset]];
    self.centerCurrentTab = [NSNumber numberWithFloat:[self.delegate viewPager:self valueForOption:ViewPagerOptionCenterCurrentTab withDefault:kCenterCurrentTab]];
    self.fixFormerTabsPositions = [NSNumber numberWithFloat:[self.delegate viewPager:self valueForOption:ViewPagerOptionFixFormerTabsPositions withDefault:kFixFormerTabsPositions]];
    self.fixLatterTabsPositions = [NSNumber numberWithFloat:[self.delegate viewPager:self valueForOption:ViewPagerOptionFixLatterTabsPositions withDefault:kFixLatterTabsPositions]];
    
    // We should update contentSize property of our tabsView, so we should recalculate it with the new values
    CGFloat contentSizeWidth = 0;
    
    // Give the standard offset if fixFormerTabsPositions is provided as YES
    if ([self.fixFormerTabsPositions boolValue]) {
        
        // And if the centerCurrentTab is provided as YES fine tune the offset according to it
        if ([self.centerCurrentTab boolValue]) {
            contentSizeWidth = (CGRectGetWidth(self.tabsView.frame) - [self.tabWidth floatValue]) / 2.0;
        } else {
            contentSizeWidth = [self.tabOffset floatValue];
        }
    }
    
    // Update every tab's frame
    for (NSUInteger i = 0; i < self.tabCount; i++) {
        
        UIView *tabView = [self tabViewAtIndex:i];
        
        CGRect frame = tabView.frame;
        frame.origin.x = contentSizeWidth;
        frame.size.width = [self.tabWidth floatValue];
        tabView.frame = frame;
        
        contentSizeWidth += CGRectGetWidth(tabView.frame);
    }
    
    // Extend contentSizeWidth if fixLatterTabsPositions is provided YES
    if ([self.fixLatterTabsPositions boolValue]) {
        
        // And if the centerCurrentTab is provided as YES fine tune the content size according to it
        if ([self.centerCurrentTab boolValue]) {
            contentSizeWidth += (CGRectGetWidth(self.tabsView.frame) - [self.tabWidth floatValue]) / 2.0;
        } else {
            contentSizeWidth += CGRectGetWidth(self.tabsView.frame) - [self.tabWidth floatValue] - [self.tabOffset floatValue];
        }
    }
    
    // Update tabsView's contentSize with the new width
    self.tabsView.contentSize = CGSizeMake(contentSizeWidth, [self.tabHeight floatValue]);
    
}
- (void)setNeedsReloadColors {
    
    // If our delegate doesn't respond to our colors method, return
    // Otherwise reload colors
    if (![self.delegate respondsToSelector:@selector(viewPager:colorForComponent:withDefault:)]) {
        return;
    }
    
    // These colors will be updated
    UIColor *indicatorColor;
    UIColor *tabsViewBackgroundColor;
    UIColor *contentViewBackgroundColor;
    
    // Get indicatorColor and check if it is different from the current one
    // If it is, update it
    indicatorColor = [self.delegate viewPager:self colorForComponent:ViewPagerIndicator withDefault:kIndicatorColor];
    
    if (![self.indicatorColor isEqualToColor:indicatorColor]) {
        
        // We will iterate through all of the tabs to update its indicatorColor
        [self.tabs enumerateObjectsUsingBlock:^(TabView *tabView, NSUInteger index, BOOL *stop) {
            tabView.indicatorColor = indicatorColor;
        }];
        
        // Update indicatorColor to check again later
        self.indicatorColor = indicatorColor;
    }
    
    // Get tabsViewBackgroundColor and check if it is different from the current one
    // If it is, update it
    tabsViewBackgroundColor = [self.delegate viewPager:self colorForComponent:ViewPagerTabsView withDefault:kTabsViewBackgroundColor];
    
    if (![self.tabsViewBackgroundColor isEqualToColor:tabsViewBackgroundColor]) {
        
        // Update it
        self.tabsView.backgroundColor = tabsViewBackgroundColor;
        
        // Update tabsViewBackgroundColor to check again later
        self.tabsViewBackgroundColor = tabsViewBackgroundColor;
    }
    
    // Get contentViewBackgroundColor and check if it is different from the current one
    // Yeah update it, too
    contentViewBackgroundColor = [self.delegate viewPager:self colorForComponent:ViewPagerContent withDefault:kContentViewBackgroundColor];
    
    if (![self.contentViewBackgroundColor isEqualToColor:contentViewBackgroundColor]) {
        
        // Yup, update
        self.contentView.backgroundColor = contentViewBackgroundColor;
        
        // Update this, too, to check again later
        self.contentViewBackgroundColor = contentViewBackgroundColor;
    }
    
}

- (CGFloat)valueForOption:(ViewPagerOption)option {
    
    switch (option) {
        case ViewPagerOptionTabHeight:
            return [[self tabHeight] floatValue];
        case ViewPagerOptionTabOffset:
            return [[self tabOffset] floatValue];
        case ViewPagerOptionTabWidth:
            return [[self tabWidth] floatValue];
        case ViewPagerOptionTabLocation:
            return [[self tabLocation] floatValue];
        case ViewPagerOptionStartFromSecondTab:
            return [[self startFromSecondTab] floatValue];
        case ViewPagerOptionCenterCurrentTab:
            return [[self centerCurrentTab] floatValue];
        default:
            return NAN;
    }
}
- (UIColor *)colorForComponent:(ViewPagerComponent)component {
    
    switch (component) {
        case ViewPagerIndicator:
            return [self indicatorColor];
        case ViewPagerTabsView:
            return [self tabsViewBackgroundColor];
        case ViewPagerContent:
            return [self contentViewBackgroundColor];
        default:
            return [UIColor clearColor];
    }
}

#pragma mark - Private methods
- (void)defaultSettings {
    
    // pageViewController
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    [self addChildViewController:self.pageViewController];
    
    // Setup some forwarding events to hijack the scrollView
    // Keep a reference to the actual delegate
    self.actualDelegate = ((UIScrollView *)[self.pageViewController.view.subviews objectAtIndex:0]).delegate;
    // Set self as new delegate
    ((UIScrollView *)[self.pageViewController.view.subviews objectAtIndex:0]).delegate = self;
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    self.animatingToTab = NO;
    self.defaultSetupDone = NO;
}

- (void)defaultSetup {
    
    //判断网络是否连接
    Reachability* reach = [Reachability reachabilityForInternetConnection];
    if( reach.isReachable==NO){
        return;
    }
    // Empty tabs and contents
    for (UIView *tabView in self.tabs) {
        [tabView removeFromSuperview];
    }
    self.tabsView.contentSize = CGSizeZero;
    
    [self.tabs removeAllObjects];
    [self.contents removeAllObjects];
    
    // Get tabCount from dataSource
    self.tabCount = [self.dataSource numberOfTabsForViewPager:self];
    
    // Populate arrays with [NSNull null];
    self.tabs = [NSMutableArray arrayWithCapacity:self.tabCount];
    for (NSUInteger i = 0; i < self.tabCount; i++) {
        [self.tabs addObject:[NSNull null]];
    }
    
    self.contents = [NSMutableArray arrayWithCapacity:self.tabCount];
    for (NSUInteger i = 0; i < self.tabCount; i++) {
        [self.contents addObject:[NSNull null]];
    }
    
    // Add BackgroundView
    if (!self.backgroundView) {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        //        if (!IOS7_OR_LATER) {
        //            self.backgroundView.frame = CGRectMake(0, 0, kScreenWidth, 44);
        //        }
        self.backgroundView.backgroundColor = navBarBackgroundColor;
        //        self.backgroundView.backgroundColor = [UIColor redColor];
    }
    
    
    // Add tabsView
    self.tabsView = (UIScrollView *)[self.view viewWithTag:kTabViewTag];
    if (!self.tabsView) {
        
        self.tabsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenWidth - 70, [self.tabHeight floatValue])];
        self.tabsView.delegate = self;
        self.tabsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.tabsView.backgroundColor = [UIColor colorWithHexStr:@"f4f5f6"];//self.tabsViewBackgroundColor
        self.tabsView.scrollsToTop = NO;
        self.tabsView.showsHorizontalScrollIndicator = NO;
        self.tabsView.showsVerticalScrollIndicator = NO;
        self.tabsView.tag = kTabViewTag;
        
        //背景图
        [self.view insertSubview:self.backgroundView atIndex:0];
        [self.view addSubview:self.tabsView];
        
        //左右半透明效果 home_navigation_mask_right
        self.rightTabView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_navigation_mask_right"]];
        //        self.rightTabView.hidden = YES;
        
        [self.view insertSubview:self.rightTabView aboveSubview:self.tabsView];
        
        self.leftTabView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_navigation_mask_right"]];
        self.leftTabView.hidden = YES;
        [self.view addSubview:self.rightTabView];
        UIImage *imageAdd = [UIImage imageNamed:@"wxyAdd"];
        UIImage *rightImage = [UIImage imageNamed:@"home_navigation_mask_right"];
        if(IOS_VERSION_7){
            self.rightTabView.frame = CGRectMake(kScreenWidth-imageAdd.size.width-rightImage.size.width-10, 64+(40-rightImage.size.height)/2.0,rightImage.size.width,rightImage.size.height);
        }else{
            self.rightTabView.frame = CGRectMake(kScreenWidth-imageAdd.size.width-rightImage.size.width-10, 44+(40-rightImage.size.height)/2.0,rightImage.size.width,rightImage.size.height);
        }

        self.leftTabView.frame = CGRectMake(0, 0, 35,33);
    }
    
    // Add tab views to _tabsView
    CGFloat contentSizeWidth = 0;
    
    // Give the standard offset if fixFormerTabsPositions is provided as YES
    if ([self.fixFormerTabsPositions boolValue]) {
        
        // And if the centerCurrentTab is provided as YES fine tune the offset according to it
        if ([self.centerCurrentTab boolValue]) {
            contentSizeWidth = (CGRectGetWidth(self.tabsView.frame) - [self.tabWidth floatValue]) / 2.0;
        } else {
            contentSizeWidth = [self.tabOffset floatValue];
        }
    }
    
    for (NSUInteger i = 0; i < self.tabCount; i++) {
        
        UIView *tabView = [self tabViewAtIndex:i];
        
        CGRect frame = tabView.frame;
        frame.origin.x = contentSizeWidth;
        frame.size.width = [self.tabWidth floatValue];
        tabView.frame = frame;
        
        [self.tabsView addSubview:tabView];
        
        contentSizeWidth += CGRectGetWidth(tabView.frame);
        
        // To capture tap events
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [tabView addGestureRecognizer:tapGestureRecognizer];
    }
    
    // Extend contentSizeWidth if fixLatterTabsPositions is provided YES
    if ([self.fixLatterTabsPositions boolValue]) {
        
        // And if the centerCurrentTab is provided as YES fine tune the content size according to it
        if ([self.centerCurrentTab boolValue]) {
            contentSizeWidth += (CGRectGetWidth(self.tabsView.frame) - [self.tabWidth floatValue]) / 2.0;
        } else {
            contentSizeWidth += CGRectGetWidth(self.tabsView.frame) - [self.tabWidth floatValue] - [self.tabOffset floatValue];
        }
    }
    
    self.tabsView.contentSize = CGSizeMake(contentSizeWidth, [self.tabHeight floatValue]);
    
    // Add contentView
    self.contentView = [self.view viewWithTag:kContentViewTag];
    
    if (!self.contentView) {
        
        self.contentView = self.pageViewController.view;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentView.backgroundColor = self.contentViewBackgroundColor;
        //        self.contentView.bounds = self.view.bounds;
        self.contentView.tag = kContentViewTag;
        
        //        [self.view insertSubview:self.contentView atIndex:0];//异常引起20像素跳动
        [self.view addSubview:self.contentView];
    }
    // Select starting tab
    NSUInteger index = [self.startFromSecondTab boolValue] ? 1 : 0;
    [self selectTabAtIndex:index];
    
    // Set setup done
    self.defaultSetupDone = YES;
    //禁止滑动
    //    ((UIScrollView *)[self.pageViewController.view.subviews objectAtIndex:0]).scrollEnabled = NO;
}

- (TabView *)tabViewAtIndex:(NSUInteger)index {
    //left right shadow show
    float x = self.tabsView.contentOffset.x;
    float startOffset = 29.5;
    float offsetX = 29.5 + 60 *(self.tabs.count - 4 - 1);
    //    NSLog(@"~~~~~~x~~~~%f",x);
    if (x < startOffset) {
        self.leftTabView.hidden = YES;
        if (self.tabCount == 4) {
            //4个频道不显示右边阴影
            self.rightTabView.hidden = YES;
        }
        else {
            self.rightTabView.hidden = NO;
        }
    }else if ((x >= startOffset) && x <= offsetX) {
        self.leftTabView.hidden = NO;
        self.rightTabView.hidden = NO;
    }else {
        self.leftTabView.hidden = YES;
        self.rightTabView.hidden = YES;
    }
    
    if (index >= self.tabCount) {
        return nil;
    }
    
    if ([[self.tabs objectAtIndex:index] isEqual:[NSNull null]]) {
        
        // Get view from dataSource
        UIView *tabViewContent = [self.dataSource viewPager:self viewForTabAtIndex:index];
        tabViewContent.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        // Create TabView and subview the content
        TabView *tabView = [[TabView alloc] initWithFrame:CGRectMake(0.0, 0.0, [self.tabWidth floatValue], [self.tabHeight floatValue])];
        [tabView addSubview:tabViewContent];
        [tabView setClipsToBounds:YES];
        [tabView setIndicatorColor:self.indicatorColor];
        
        tabViewContent.center = tabView.center;
        
        // Replace the null object with tabView
        [self.tabs replaceObjectAtIndex:index withObject:tabView];
    }
    
    return [self.tabs objectAtIndex:index];
}

- (NSUInteger)indexForTabView:(UIView *)tabView {
    
    return [self.tabs indexOfObject:tabView];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (index >= self.tabCount) {
        return nil;
    }
    
    if ([[self.contents objectAtIndex:index] isEqual:[NSNull null]]) {
        
        UIViewController *viewController;
        
        if ([self.dataSource respondsToSelector:@selector(viewPager:contentViewControllerForTabAtIndex:)]) {
            viewController = [self.dataSource viewPager:self contentViewControllerForTabAtIndex:index];
        } else if ([self.dataSource respondsToSelector:@selector(viewPager:contentViewForTabAtIndex:)]) {
            
            UIView *view = [self.dataSource viewPager:self contentViewForTabAtIndex:index];
            
            // Adjust view's bounds to match the pageView's bounds
            UIView *pageView = [self.view viewWithTag:kContentViewTag];
            view.frame = pageView.bounds;
            
            viewController = [UIViewController new];
            viewController.view = view;
        } else {
            viewController = [[UIViewController alloc] init];
            viewController.view = [[UIView alloc] init];
        }
        
        [self.contents replaceObjectAtIndex:index withObject:viewController];
    }
    
    return [self.contents objectAtIndex:index];
}

- (NSUInteger)indexForViewController:(UIViewController *)viewController {
    
    return [self.contents indexOfObject:viewController];
}

#pragma mark - UIPageViewControllerDataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexForViewController:viewController];
    index++;
    return [self viewControllerAtIndex:index];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexForViewController:viewController];
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    UIViewController *viewController = self.pageViewController.viewControllers[0];
    
    // Select tab
    NSUInteger index = [self indexForViewController:viewController];
    [self selectTabAtIndex:index];
}

#pragma mark - UIScrollViewDelegate, Responding to Scrolling and Dragging

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //left right shadow show
    if (scrollView.tag == kTabViewTag) {
        self.leftTabView.hidden = NO;
        self.rightTabView.hidden = NO;
        return;
    }
    
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.actualDelegate scrollViewDidScroll:scrollView];
    }
    
    if (![self isAnimatingToTab]) {
        UIView *tabView = [self tabViewAtIndex:self.activeTabIndex];
        
        // Get the related tab view position
        CGRect frame = tabView.frame;
        
        CGFloat movedRatio = (scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame)) - 1;
        frame.origin.x += movedRatio * CGRectGetWidth(frame);
        
        if ([self.centerCurrentTab boolValue]) {
            
            frame.origin.x += (frame.size.width / 2);
            frame.origin.x -= CGRectGetWidth(self.tabsView.frame) / 2;
            frame.size.width = CGRectGetWidth(self.tabsView.frame);
            
            if (frame.origin.x < 0) {
                frame.origin.x = 0;
            }
            
            if ((frame.origin.x + frame.size.width) > self.tabsView.contentSize.width) {
                frame.origin.x = (self.tabsView.contentSize.width - CGRectGetWidth(self.tabsView.frame));
            }
        } else {
            
            frame.origin.x -= [self.tabOffset floatValue];
            frame.size.width = CGRectGetWidth(self.tabsView.frame);
        }
        
        [self.tabsView scrollRectToVisible:frame animated:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //left right shadow show
    if (scrollView.tag == kTabViewTag) {
        float x = scrollView.contentOffset.x;
        if (x < 29.5) {
            self.leftTabView.hidden = YES;
            self.rightTabView.hidden = NO;
        }else if ((x >= 29.5) && x < 29.5 *(self.tabs.count - 3)) {
            self.leftTabView.hidden = NO;
            self.rightTabView.hidden = NO;
        }else {
            self.leftTabView.hidden = YES;
            self.rightTabView.hidden = YES;
        }
        
        return;
    }
    
    if ([self.actualDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.actualDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

@end

