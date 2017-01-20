//
//  KKTextView.h
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/18.
//  Copyright © 2017年 kook. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKTextTool;

static NSString* const kTextViewActiveViewDidTapNotification = @"kTextViewActiveViewDidTapNotification";

@interface KKTextView : UIView

+ (void)setActiveTextView:(KKTextView*)view;
- (id)initWithTool:(KKTextTool*)tool;

- (void)setLableText:(NSString *)text;
- (NSString *)getLableText;

@end
