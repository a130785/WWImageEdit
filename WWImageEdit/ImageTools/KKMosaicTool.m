//
//  KKMasaicTool.m
//  CLImageEditorDemo
//
//  Created by 邬维 on 2017/1/4.
//  Copyright © 2017年 kook. All rights reserved.
//

#import "KKMosaicTool.h"
#import "KKMosaicView.h"

@implementation KKMosaicTool{

    KKMosaicView *mosaicView; //显示马赛克
    UIView *_menuView; //底部菜单
}


+ (NSString*)defaultTitle
{
    return @"Mosaic";
}

+ (UIImage*)defaultIconImage 
{
    return [UIImage imageNamed:@"ToolMasaic"];
}

+ (NSUInteger)orderNum{
    return KKToolIndexNumberSecond;
}

#pragma mark- implementation

- (void)setup{
    CIImage *ciImage = [[CIImage alloc] initWithImage:self.editor.imageView.image];
    //生成马赛克
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
    [filter setValue:ciImage  forKey:kCIInputImageKey];
    //马赛克像素大小
    [filter setValue:@(50) forKey:kCIInputScaleKey];
    CIImage *outImage = [filter valueForKey:kCIOutputImageKey];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outImage fromRect:[outImage extent]];
    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    mosaicView = [[KKMosaicView alloc]initWithFrame:self.editor.imageView.bounds];
    
    mosaicView.surfaceImage = self.editor.imageView.image;
    mosaicView.image = showImage;
    
    [self.editor.imageView addSubview:mosaicView];
    
    self.editor.imageView.userInteractionEnabled = YES;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
    
    _menuView = [[UIView alloc] initWithFrame:self.editor.menuView.frame];
    _menuView.backgroundColor = self.editor.menuView.backgroundColor;
    [self.editor.view addSubview:_menuView];
    
    [self setMenu];
    
    _menuView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuView.top);
    [UIView animateWithDuration:kImageToolAnimationDuration
                     animations:^{
                         _menuView.transform = CGAffineTransformIdentity;
                     }];

}

- (void)cleanup
{
    [mosaicView removeFromSuperview];
    self.editor.imageView.userInteractionEnabled = NO;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    
    [UIView animateWithDuration:kImageToolAnimationDuration
                     animations:^{
                         _menuView.transform = CGAffineTransformMakeTranslation(0, self.editor.view.height-_menuView.top);
                     }
                     completion:^(BOOL finished) {
                         [_menuView removeFromSuperview];
                     }];
}

- (void)executeWithCompletionBlock:(void (^)(UIImage *, NSError *, NSDictionary *))completionBlock
{
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//        });
    UIImage *image = [self buildImage];
    completionBlock(image, nil, nil);
}

- (void)setMenu{
    UIButton *oneButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 25, 30, 30)];
    oneButton.backgroundColor = [UIColor redColor];
    [_menuView addSubview:oneButton];
 
//    [button addTarget:self action:@selector(createGrayMasaicImg) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *whitebutton = [[UIButton alloc] initWithFrame:CGRectMake(180, 25, 30, 30)];
    whitebutton.backgroundColor = [UIColor whiteColor];
    [_menuView addSubview:whitebutton];
//    [whitebutton addTarget:self action:@selector(createWhiteMasaicImg) forControlEvents:UIControlEventTouchUpInside];
}


- (UIImage*)buildImage
{
    UIGraphicsBeginImageContextWithOptions(mosaicView.bounds.size, NO, 0);
    [mosaicView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
