//
//  KKEmoticonTool.m
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/12.
//  Copyright © 2017年 kook. All rights reserved.
//

#import "KKEmoticonTool.h"
#import "KKToolBarItem.h"
#import "KKEmoticonView.h"

@implementation KKEmoticonTool{
    //修改前的图片
    UIImage *_originalImage;
    //工作区
    UIView *_workingView;
    //底部表情栏
    UIScrollView *_menuScroll;
}

#pragma -mark KKImageToolProtocol
+(NSString *)defaultTitle{
    return @"表情";
}

+(NSUInteger)orderNum{
    return KKToolIndexNumberThird;
}

+(UIImage *)defaultIconImage{
    return [UIImage imageNamed:@"ToolEmoicon"];
}

#pragma mark- implementation

- (void)setup
{
    _originalImage = self.editor.imageView.image;
    
    [self.editor fixZoomScaleWithAnimated:YES];
    
    _menuScroll = [[UIScrollView alloc] initWithFrame:self.editor.menuView.frame];
    _menuScroll.backgroundColor = self.editor.menuView.backgroundColor;
    _menuScroll.showsHorizontalScrollIndicator = NO;
    [self.editor.view addSubview:_menuScroll];
    //editor.imageView.superview 中的 editor.imageView 相对于 editor.view 的 frame
    _workingView = [[UIView alloc] initWithFrame:[self.editor.view convertRect:self.editor.imageView.frame fromView:self.editor.imageView.superview]];
    _workingView.clipsToBounds = YES;
    [self.editor.view addSubview:_workingView];
    
    [self setEmoticonMenu];
    
    _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
    [UIView animateWithDuration:kImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformIdentity;
                     }];
}

- (void)cleanup
{
    [self.editor resetZoomScaleWithAnimated:YES];
    
    [_workingView removeFromSuperview];
    
    [UIView animateWithDuration:kImageToolAnimationDuration
                     animations:^{
                         _menuScroll.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuScroll.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuScroll removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
    [KKEmoticonView setActiveEmoticonView:nil];
        
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImage *image = [self buildImage:_originalImage];
        completionBlock(image, nil, nil);
    });
}

#pragma mark-
- (void)setEmoticonMenu
{
    CGFloat W = 70;
    CGFloat H = _menuScroll.height;
    CGFloat x = 0;
    
    NSArray *list = @[@"banzai_search",@"1001",@"1002",@"1003",@"1004",@"1005",@"1006",@"1007",@"1008",@"1009",@"1010"];
    
    for(NSString *imgNmae in list){
        UIImage *image = [UIImage imageNamed:imgNmae];
        if(image){
            KKToolBarItem *view = [[KKToolBarItem alloc] initWithFrame:CGRectMake(x, 0, W, H) target:self action:@selector(tappedEmoticonPanel:) toolInfo:nil];
            view.iconView.image = image;
            
            [_menuScroll addSubview:view];
            x += W;
        }
    }
    _menuScroll.contentSize = CGSizeMake(MAX(x, _menuScroll.frame.size.width+1), 0);
}

- (void)tappedEmoticonPanel:(UITapGestureRecognizer*)sender
{
    KKToolBarItem *kkview = (KKToolBarItem *)sender.view;
    
    KKEmoticonView *view = [[KKEmoticonView alloc] initWithImage:kkview.iconView.image tool:self];
//    CGFloat ratio = MIN( (0.5 * _workingView.width) / view.width, (0.5 * _workingView.height) / view.height);
//    [view setScale:ratio];
    view.center = CGPointMake(_workingView.width/2, _workingView.height/2);
    
    [_workingView addSubview:view];
    [KKEmoticonView setActiveEmoticonView:view];
    

}

//截屏
- (UIImage*)buildImage:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    
    [image drawAtPoint:CGPointZero];
    
    //缩放比例
    CGFloat scale = image.size.width / _workingView.width;
    CGContextScaleCTM(UIGraphicsGetCurrentContext(), scale, scale);
    [_workingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *tmp = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return tmp;
}


@end
