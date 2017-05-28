//
//  GXImpMsgPagerView.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXImpMsgBaseView.h"
typedef NS_ENUM(NSInteger, NinaPagerStyle) {
    /**<  上侧为下划线   **/
    NinaPagerStyleBottomLine = 0,
    /**<  上侧为滑块   **/
    NinaPagerStyleSlideBlock = 1,
    /**<  上侧只有文字颜色变化(没有下划线或滑块)   **/
    NinaPagerStyleStateNormal = 2,
    /**<  上侧为下划线的宽度 = 标题宽度   **/
    NinaPagerStyleBottomLineWidthWithTitleWidth = 3,
    
};

@protocol GXImpMsgPagerViewDelegate <NSObject>

@optional
- (BOOL)deallocVCsIfUnnecessary;
- (void)ninaCurrentPageIndex:(NSString *)currentPage;
@end

@interface GXImpMsgPagerView : UIView

- (instancetype)initWithNinaPagerStyle:(NinaPagerStyle)ninaPagerStyle WithTitles:(NSArray *)titles WithVCs:(NSArray *)childVCs WithColorArrays:(NSArray *)colors WithDefaultIndex:(NSInteger)defaultIndex;
//带标题字号大小初始化
- (instancetype)initWithNinaPagerStyle:(NinaPagerStyle)ninaPagerStyle WithTitles:(NSArray *)titles WithVCs:(NSArray *)childVCs WithColorArrays:(NSArray *)colors  WithDefaultIndex:(NSInteger)defaultIndex WithTitleFontSize:(NSInteger)fontSize;
@property (strong, nonatomic) UIColor *selectColor; /**<  选中时的颜色   **/
@property (strong, nonatomic) UIColor *unselectColor; /**<  未选中时的颜色   **/
@property (strong, nonatomic) UIColor *underlineColor; /**<  下划线的颜色   **/
@property (strong, nonatomic) UIColor *topTabColor; /**<  顶部菜单栏的背景颜色   **/
@property (assign, nonatomic) BOOL pushEnabled; /**<  使添加的视图可以进行点击push动作   **/
@property (copy, nonatomic) NSString *PageIndex; /**< 所在的控制器index或点击上方button的index **/
@property (assign, nonatomic) CGFloat titleScale; /**<  标题缩放比例   **/
@property (assign, nonatomic) CGFloat SelectBottomLinePer; /**<  标题缩放比例   **/
@property (assign, nonatomic) BOOL nina_navigationBarHidden; /**<  是否隐藏了导航栏   **/
@property (assign, nonatomic) CGFloat customBottomLinePer; /**<  下划线自定义长度   **/
@property (weak, nonatomic) id<GXImpMsgPagerViewDelegate>delegate; /**< NinaPagerView代理 **/

@property (nonatomic,strong)GXImpMsgBaseView *pagerView;

@end
