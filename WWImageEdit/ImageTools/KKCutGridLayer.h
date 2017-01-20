//
//  KKCutGridLayer.h
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/16.
//  Copyright © 2017年 kook. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 网格视图
 */
@interface KKCutGridLayer : CALayer
@property (nonatomic, assign) CGRect clippingRect; //裁剪范围
@property (nonatomic, strong) UIColor *bgColor;    //背景颜色
@property (nonatomic, strong) UIColor *gridColor;  //线条颜色
@end
