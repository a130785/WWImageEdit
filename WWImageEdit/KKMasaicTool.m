//
//  KKMasaicTool.m
//  CLImageEditorDemo
//
//  Created by 邬维 on 2017/1/4.
//  Copyright © 2017年 kook. All rights reserved.
//

#import "KKMasaicTool.h"
#import "KKMasaicView.h"

@implementation KKMasaicTool{

    KKMasaicView *masaicView;
    UIView *_menuView;
    CGSize _originalImageSize;
    UIImageView *_drawingView;
}


+ (NSString*)defaultTitle
{
    return @"Masaic";
}

+ (UIImage*)defaultIconImage
{
    return [UIImage imageNamed:@"ToolMasaic"];
}

+ (NSUInteger)orderNum{
    return 1;
}

#pragma mark- implementation

- (void)setup
{
    _originalImageSize = self.editor.imageView.image.size;
    _drawingView = [[UIImageView alloc] initWithFrame:self.editor.imageView.bounds];
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:self.editor.imageView.image];
    
    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
    [filter setValue:ciImage  forKey:kCIInputImageKey];
    [filter setDefaults];
    CIImage *outImage = [filter valueForKey:kCIOutputImageKey];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outImage fromRect:[outImage extent]];
    
    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    masaicView = [[KKMasaicView alloc]initWithFrame:self.editor.imageView.bounds];
    
    masaicView.surfaceImage = self.editor.imageView.image;
    masaicView.image = showImage;
    
    [self.editor.imageView addSubview:masaicView];
    
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
    [masaicView removeFromSuperview];
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self buildImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(image, nil, nil);
        });
    });
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


//-(UIImage *)createMasaicImg:(NSString *)filterName {
//
//    CIImage *ciImage = [[CIImage alloc] initWithImage:self.editor.imageView.image];
//    
//    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
//    [filter setValue:ciImage  forKey:kCIInputImageKey];
//    [filter setDefaults];
//    CIImage *outImage = [filter valueForKey:kCIOutputImageKey];
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef cgImage = [context createCGImage:outImage fromRect:[outImage extent]];
//    
//    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
//    CGImageRelease(cgImage);
//}

- (UIImage*)buildImage
{
    UIGraphicsBeginImageContextWithOptions(masaicView.bounds.size, NO, 0);
    
    [masaicView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return image;
}
@end
