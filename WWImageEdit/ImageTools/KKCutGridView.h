//
//  KKCutGridView.h
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/16.
//  Copyright © 2017年 kook. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 裁剪view
 */
@interface KKCutGridView : UIView
@property (nonatomic, assign) CGRect clippingRect;  //裁剪范围

- (id)initWithSuperview:(UIView*)superview frame:(CGRect)frame;


/**
 设置裁剪view的背景颜色
 */
- (void)setBgColor:(UIColor*)bgColor;


/**
 设置裁剪的网格颜色
 */
- (void)setGridColor:(UIColor*)gridColor;

@end
