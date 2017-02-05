//
//  KKTextTool.h
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/18.
//  Copyright © 2017年 kook. All rights reserved.
//

#import "KKImageToolBase.h"
@class KKTextView;

@interface KKTextTool : KKImageToolBase 
@property (nonatomic, strong) KKTextView *selectedTextView; //当前选中的文字
@end
