//
//  GXImpMsgPagerView.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXImpMsgPagerView.h"
#import "GXImpMsgBaseView.h"
#import "GXImgMsgParameter.h"
#import "UIView+GXVIewController.h"
#define MaxNums  10
static NSString *const kObserverPage = @"currentPage";

@interface GXImpMsgPagerView ()<NSCacheDelegate>
@property (nonatomic, strong)NSCache *limitControllerCache;
@end

@implementation GXImpMsgPagerView
{
    NSArray *myArray;
    NSArray *classArray;
    NSArray *colorArray;
    NSInteger pagerStyle;
    NSMutableArray *viewNumArray;
    NSMutableArray *vcsTagArray;
    NSMutableArray *vcsArray;
    BOOL viewAlloc[MaxNums];
    UIViewController *firstVC;
    NSInteger ninaDefaultIndex;
    NSInteger titleFontSize;
    
}
- (instancetype)initWithNinaPagerStyle:(NinaPagerStyle)ninaPagerStyle WithTitles:(NSArray *)titles WithVCs:(NSArray *)childVCs WithColorArrays:(NSArray *)colors  WithDefaultIndex:(NSInteger)defaultIndex{
    if (self = [super init]) {
        //Need You Edit,title for the toptabbar
        self.frame = CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT);
        myArray = titles;
        classArray = childVCs;
        colorArray = colors;
        pagerStyle = ninaPagerStyle;
        ninaDefaultIndex = defaultIndex;
        [self createPagerView:myArray WithVCs:classArray WithColors:colorArray];
        
    }
    return self;
}
- (instancetype)initWithNinaPagerStyle:(NinaPagerStyle)ninaPagerStyle WithTitles:(NSArray *)titles WithVCs:(NSArray *)childVCs WithColorArrays:(NSArray *)colors  WithDefaultIndex:(NSInteger)defaultIndex WithTitleFontSize:(NSInteger)fontSize{
    if (self = [super init]) {
        //Need You Edit,title for the toptabbar
        self.frame = CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT);
        myArray = titles;
        classArray = childVCs;
        colorArray = colors;
        pagerStyle = ninaPagerStyle;
        ninaDefaultIndex = defaultIndex;
        if (fontSize > 0) {
            titleFontSize = fontSize;
        }else{
            titleFontSize = 14;
        }
        [self createPagerView:myArray WithVCs:classArray WithColors:colorArray];
        
    }
    return self;
}



#pragma mark - SetMethod
- (void)setPushEnabled:(BOOL )pushEnabled {
    if (LoadWholePage && pushEnabled == YES) {
        for (NSInteger i = 0; i < vcsArray.count; i++) {
            [self.viewController addChildViewController:vcsArray[i]];
        }
    }else {
        if (pushEnabled == YES && firstVC != nil) {
            [self.viewController addChildViewController:firstVC];
        }
    }
}

- (void)setTitleScale:(CGFloat)titleScale {
    _titleScale = titleScale;
    _pagerView.titleScale = _titleScale;
}
-(void)setCustomBottomLinePer:(CGFloat)customBottomLinePer{
    _customBottomLinePer = customBottomLinePer;
    _pagerView.customBottomLinePer = _customBottomLinePer;
}

- (void)setNina_navigationBarHidden:(BOOL)nina_navigationBarHidden {
    if (nina_navigationBarHidden == YES) {
        self.viewController.automaticallyAdjustsScrollViewInsets = NO;
        _pagerView.topTab.frame = CGRectMake(0, 20, FUll_VIEW_WIDTH, PageBtn);
        _pagerView.scrollView.frame = CGRectMake(0, PageBtn + 20, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT - PageBtn);
    }
}

#pragma mark - NSCache
- (NSCache *)limitControllerCache {
    if (!_limitControllerCache) {
        _limitControllerCache = [NSCache new];
        _limitControllerCache.delegate = self;
    }
    /**< Set max of controller's number   **/
    _limitControllerCache.countLimit = 5;
    return _limitControllerCache;
}

#pragma mark - CreateView
- (void)createPagerView:(NSArray *)titles WithVCs:(NSArray *)childVCs WithColors:(NSArray *)colors {
    viewNumArray = [NSMutableArray array];
    vcsArray = [NSMutableArray array];
    vcsTagArray = [NSMutableArray array];
    //No Need to edit
    if (colors.count > 0) {
        for (NSInteger i = 0; i < colors.count; i++) {
            switch (i) {
                case 0:
                    _selectColor = colors[0];
                    break;
                case 1:
                    _unselectColor = colors[1];
                    break;
                case 2:
                    _underlineColor = colors[2];
                    break;
                case 3:
                    _topTabColor = colors[3];
                    break;
                default:
                    break;
            }
        }
    }
    if (titles.count > 0 && childVCs.count > 0 && titleFontSize <= 0) {
        _pagerView = [[GXImpMsgBaseView alloc] initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT) WithSelectColor:_selectColor WithUnselectorColor:_unselectColor WithUnderLineColor:_underlineColor WithtopTabColor:_topTabColor WithTopTabType:pagerStyle WithNinaDefaultPageIndex: ninaDefaultIndex];
        _pagerView.titleArray = myArray;
        [_pagerView addObserver:self forKeyPath:@"currentPage" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        
        
        _pagerView.scrollView.contentOffset = CGPointMake(FUll_VIEW_WIDTH * ninaDefaultIndex, 0);
        
        [self addSubview:_pagerView];
        //First ViewController present to the screen
        if (classArray.count > 0 && myArray.count > 0) {
            if (LoadWholePage) {
                for (NSInteger i = 0; i< classArray.count; i++) {
                    [self loadWholeOrNotWithTag:i WithMode:1];
                }
            }else {
                if (ninaDefaultIndex) {
                    [self loadWholeOrNotWithTag:ninaDefaultIndex WithMode:0];
                }else{
                    [self loadWholeOrNotWithTag:0 WithMode:0];
                }
                
            }
        }
    }else if (titles.count > 0 && childVCs.count > 0 && titleFontSize > 0){
        _pagerView = [[GXImpMsgBaseView alloc]initWithFrame:CGRectMake(0, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT) WithSelectColor:_selectColor WithUnselectorColor:_unselectColor WithUnderLineColor:_underlineColor WithtopTabColor:_topTabColor WithTopTabType:pagerStyle WithNinaDefaultPageIndex:ninaDefaultIndex WithNinaTitleFontSize:titleFontSize];
        _pagerView.titleArray = myArray;
        [_pagerView addObserver:self forKeyPath:@"currentPage" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        
        
        _pagerView.scrollView.contentOffset = CGPointMake(FUll_VIEW_WIDTH * ninaDefaultIndex, 0);
        
        [self addSubview:_pagerView];
        //First ViewController present to the screen
        if (classArray.count > 0 && myArray.count > 0) {
            if (LoadWholePage) {
                for (NSInteger i = 0; i< classArray.count; i++) {
                    [self loadWholeOrNotWithTag:i WithMode:1];
                }
            }else {
                if (ninaDefaultIndex) {
                    [self loadWholeOrNotWithTag:ninaDefaultIndex WithMode:0];
                }else{
                    [self loadWholeOrNotWithTag:0 WithMode:0];
                }
            }
        }
        
    }else {
        NSLog(@"You should correct titlesArray or childVCs count!");
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kObserverPage]) {
        NSInteger page = [change[@"new"] integerValue];
        if (isDebug) {
            NSLog(@"It's controller %li",(long)page + 1);
        }
        self.PageIndex = @(page).stringValue;
        if ([self.delegate respondsToSelector:@selector(ninaCurrentPageIndex:)]) {
            [self.delegate ninaCurrentPageIndex:self.PageIndex];
        }
        if (myArray.count > 5) {
            CGFloat topTabOffsetX = 0;
            if (page >= 2) {
                if (page <= myArray.count - 3) {
                    topTabOffsetX = (page - 2) * More5LineWidth;
                }
                else {
                    if (page == myArray.count - 2) {
                        topTabOffsetX = (page - 3) * More5LineWidth;
                    }else {
                        topTabOffsetX = (page - 4) * More5LineWidth;
                    }
                }
            }
            else {
                if (page == 1) {
                    topTabOffsetX = 0 * More5LineWidth;
                }else {
                    topTabOffsetX = page * More5LineWidth;
                }
            }
            [_pagerView.topTab setContentOffset:CGPointMake(topTabOffsetX, 0) animated:YES];
        }
        if (!LoadWholePage) {
            for (NSInteger i = 0; i < myArray.count; i++) {
                if (page == i && i <= classArray.count - 1) {
                    if ([classArray[i] isKindOfClass:[NSString class]]) {
                        NSString *className = classArray[i];
                        Class class = NSClassFromString(className);
                        if ([class isSubclassOfClass:[UIViewController class]] && viewAlloc[i] == NO) {
                            UIViewController *ctrl = nil;
                            ctrl = class.new;
                            [self createOtherViewControllers:ctrl WithControllerTag:i];
                        }else if ([class isSubclassOfClass:[UIView class]]) {
                            UIView *singleView =class.new;
                            singleView.frame = CGRectMake(FUll_VIEW_WIDTH * i, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT - PageBtn);
                            [_pagerView.scrollView addSubview:singleView];
                        }else if (!class) {
                            NSLog(@"Your Vc%li is not found in this project!",(long)i + 1);
                        }
                    }else {
                        if ([classArray[i] isKindOfClass:[UIViewController class]]) {
                            UIViewController *ctrl = classArray[i];
                            if (ctrl && viewAlloc[i] == NO) {
                                [self createOtherViewControllers:ctrl WithControllerTag:i];
                            }else if (!ctrl) {
                                NSLog(@"Your Vc%li is not found in this project!",(long)i + 1);
                            }
                        }else if ([classArray[i] isKindOfClass:[UIView class]]) {
                            UIView *singleView = classArray[i];
                            singleView.frame = CGRectMake(FUll_VIEW_WIDTH * i, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT - PageBtn);
                            [_pagerView.scrollView addSubview:singleView];
                        }
                    }
                }else if (page == i && i > classArray.count - 1) {
                    NSLog(@"You are not set title%li 's controller.",(long)i + 1);
                }else {
                    /**<  The number of controllers max is 5.   **/
                    if ([self.delegate performSelector:@selector(deallocVCsIfUnnecessary)] && !LoadWholePage) {
                        if (vcsArray.count > 5 && [self.delegate deallocVCsIfUnnecessary] == YES) {
                            UIViewController *deallocVC = [vcsArray firstObject];
                            NSInteger deallocTag = [[vcsTagArray firstObject] integerValue];
                            if (![self.limitControllerCache objectForKey:@(deallocTag)]) {
                                [self.limitControllerCache setObject:deallocVC forKey:@(deallocTag)];
                            };
                            [deallocVC.view removeFromSuperview];
                            deallocVC.view = nil;
                            [deallocVC removeFromParentViewController];
                            deallocVC = nil;
                            [vcsArray removeObjectAtIndex:0];
                            viewAlloc[deallocTag] = NO;
                            [vcsTagArray removeObjectAtIndex:0];
                        }
                    }
                }
            }
        }
    }
}

- (void)dealloc {
    [_pagerView removeObserver:self forKeyPath:@"currentPage"];
}

/**<  NSCache delegate method，print current dealloc object. **/
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    if (isDebug) {
        NSLog(@"Dealloc -------> %@", obj);
    }
}

#pragma mark - Private Method
/**
 *  Create first controller or views.
 *
 *  @param ctrl first controller.
 */
- (void)createFirstViewController:(UIViewController *)ctrl {
    firstVC = ctrl;
    
    
    ctrl.view.frame = CGRectMake(FUll_VIEW_WIDTH * ninaDefaultIndex, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT - PageBtn);
    
    [_pagerView.scrollView addSubview:ctrl.view];
    /**<  Add new test cache   **/
    if (![self.limitControllerCache objectForKey:@(0)]) {
        [self.limitControllerCache setObject:ctrl forKey:@(0)];
    };
    
    
    viewAlloc[ninaDefaultIndex] = YES;
    [vcsArray addObject:ctrl];
    NSString *transString = [NSString stringWithFormat:@"%li",(long)ninaDefaultIndex];
    [vcsTagArray addObject:transString];
    if (isDebug) {
        NSLog(@"Controller or view 1");
        NSLog(@"Use new created controller or view 0");
    }
    self.PageIndex = @"1";
}

/**
 *  Create other controllers or views.
 *
 *  @param ctrl controllers.
 *  @param i    controller's tag.
 */
- (void)createOtherViewControllers:(UIViewController *)ctrl WithControllerTag:(NSInteger)i {
    [self.viewController addChildViewController:ctrl];
    [vcsArray addObject:ctrl];
    NSString *tagStr = @(i).stringValue;
    [vcsTagArray addObject:tagStr];
    if (isDebug) {
        NSLog(@"Use new created controller or view%li",(long)i + 1);
    }
    /**<  The number of controllers max is 5.   **/
    if ([self.delegate performSelector:@selector(deallocVCsIfUnnecessary)] && !LoadWholePage) {
        if (vcsArray.count > 5 && [self.delegate deallocVCsIfUnnecessary] == YES) {
            UIViewController *deallocVC = [vcsArray firstObject];
            NSInteger deallocTag = [[vcsTagArray firstObject] integerValue];
            if (![self.limitControllerCache objectForKey:@(deallocTag)]) {
                [self.limitControllerCache setObject:deallocVC forKey:@(deallocTag)];
            };
            [deallocVC.view removeFromSuperview];
            deallocVC.view = nil;
            [deallocVC removeFromParentViewController];
            deallocVC = nil;
            [vcsArray removeObjectAtIndex:0];
            viewAlloc[deallocTag] = NO;
            if (isDebug) {
                NSLog(@"Controller or view %li is dealloced",(long)deallocTag + 1);
            }
            [vcsTagArray removeObjectAtIndex:0];
        }
    }
    ctrl.view.frame = CGRectMake(FUll_VIEW_WIDTH * i, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT - PageBtn);
    [_pagerView.scrollView addSubview:ctrl.view];
    viewAlloc[i] = YES;
}

/**
 *  Load whole page or not.
 *
 *  @param ninaTag Viewcontroller or view tag.
 *  @param mode Load whole page mode.
 */
- (void)loadWholeOrNotWithTag:(NSInteger)ninaTag WithMode:(NSInteger)mode {
    if ([classArray[ninaTag] isKindOfClass:[NSString class]]) {
        NSString *className = classArray[ninaTag];
        Class class = NSClassFromString(className);
        if ([class isSubclassOfClass:[UIViewController class]]) {
            UIViewController *ctrl = class.new;
            if (mode == 0) {
                [self createFirstViewController:ctrl];
            }else {
                [self createOtherViewControllers:ctrl WithControllerTag:ninaTag];
            }
        }else if ([class isSubclassOfClass:[UIView class]]) {
            UIView *singleView =class.new;
            singleView.frame = CGRectMake(FUll_VIEW_WIDTH * ninaTag, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT - PageBtn);
            [_pagerView.scrollView addSubview:singleView];
        }
    }else {
        if ([classArray[ninaTag] isKindOfClass:[UIViewController class]]) {
            UIViewController *ctrl = classArray[ninaTag];
            if (mode == 0) {
                [self createFirstViewController:ctrl];
            }else {
                [self createOtherViewControllers:ctrl WithControllerTag:ninaTag];
            }
        }else if ([classArray[ninaTag] isKindOfClass:[UIView class]]) {
            UIView *singleView = classArray[ninaTag];
            singleView.frame = CGRectMake(FUll_VIEW_WIDTH * ninaTag, 0, FUll_VIEW_WIDTH, FUll_CONTENT_HEIGHT - PageBtn);
            [_pagerView.scrollView addSubview:singleView];
        }
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    [self.pagerView.scrollView hitTest:point withEvent:event];
    return [super hitTest:point withEvent:event];
}
@end
