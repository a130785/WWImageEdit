//
//  KKImageToolProtocol.h
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/10.
//  Copyright © 2017年 kook. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 工具共同的属性的实现
 */
@protocol KKImageToolProtocol <NSObject>

@required
+ (UIImage*)defaultIconImage;   //图片

+ (NSString*)defaultTitle;      //工具名称

+ (NSArray*)subtools;           //包含的子工具

+ (NSUInteger)orderNum;         //显示顺序

@end
