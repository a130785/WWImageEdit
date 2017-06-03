//
//  KKMasaicView.h
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/11.
//  Copyright © 2017年 kook. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKMosaicView : UIView
//马赛克图片
@property (nonatomic, strong) UIImage *image;

//涂层图片.
@property (nonatomic, strong) UIImage *surfaceImage;

@end
