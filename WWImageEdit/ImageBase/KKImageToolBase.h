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
//static const CGFloat kImageToolFadeoutDuration   = 0.2; //工具栏淡出时间


/**
 图片工具类 基类
 */
@interface KKImageToolBase : NSObject<KKImageToolProtocol>

@property (nonatomic, weak) KKImageEditorViewController *editor; //图片编辑vc
@property (nonatomic, weak) KKImageToolInfo *toolInfo;  //工具信息

- (id)initWithImageEditor:(KKImageEditorViewController*)editor withToolInfo:(KKImageToolInfo *)info;

- (void)setup;
- (void)cleanup;
- (void)executeWithCompletionBlock:(void(^)(UIImage *image, NSError *error, NSDictionary *userInfo))completionBlock;


@end
