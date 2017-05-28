//
//  GXEmotionCollectionView.h
//  GXEmotionKeyboard
//
//  Created by zhudong on 16/7/11.
//  Copyright © 2016年 zhudong. All rights reserved.
//

#import <UIKit/UIKit.h>
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND
//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"          // 布局框架
#define toobarHeight 0
#define keyboardViewHeight 216

@interface GXEmotionCollectionView : UICollectionView
@property (nonatomic,strong) NSArray *packages;
@property (nonatomic,copy) void (^scroolDelegate)(NSInteger index);
@end
