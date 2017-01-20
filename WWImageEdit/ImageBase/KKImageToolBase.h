//
//  KKImageToolBase.h
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/3.
//  Copyright © 2017年 kook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKImageEditorViewController.h"
#import "UIView+Frame.h"
#import "KKImageToolProtocol.h"
#import "KKImageToolInfo.h"
#import "KKImageEditorTheme.h"

static const CGFloat kImageToolAnimationDuration = 0.3; //工具栏平移动画时间

typedef NS_ENUM(NSUInteger,KKToolIndexNumber){
    KKToolIndexNumberFirst = 0,
    KKToolIndexNumberSecond = 1,
    KKToolIndexNumberThird = 2,
    KKToolIndexNumberFourth = 3,
    KKToolIndexNumberFifth = 4,
};

/**
 图片工具类 基类
 */
@interface KKImageToolBase : NSObject<KKImageToolProtocol>

@property (nonatomic, weak) KKImageEditorViewController *editor; //图片编辑vc
@property (nonatomic, weak) KKImageToolInfo *toolInfo;  //工具信息

- (id)initWithImageEditor:(KKImageEditorViewController*)editor withToolInfo:(KKImageToolInfo *)info;

/**
 初始化工具信息
 */
- (void)setup;


/**
 取消修改
 */
- (void)cleanup;

/**
 保存修改
 */
- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock;


@end
