//
//  KKEmoticonView.m
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/12.
//  Copyright © 2017年 kook. All rights reserved.
//

#import "KKEmoticonView.h"
#import "KKEmoticonTool.h"
#import "KKScaleButton.h"

static const NSUInteger kDeleteBtnSize = 32;

@implementation KKEmoticonView{

    UIImageView *_imageView;  //表情图片
    UIButton *_deleteButton;    //删除按钮
    KKScaleButton *_scaleBtn;
    
    CGFloat _scale;    //当前缩放比例
    CGFloat _arg;       //当前旋转比例
    
    CGPoint _initialPoint; //表情的中心点
    CGFloat _initialScale;  //修改前的缩放比例
    CGFloat _initialArg;    //修改前旋转比例
}

+ (void)setActiveEmoticonView:(KKEmoticonView*)view
{
    static KKEmoticonView *activeView = nil;
    if(view != activeView){
        [activeView setAvtive:NO]; //隐藏上一个表情的线和按钮
        activeView = view;
        
        //显示当前表情的线和按钮
        [activeView setAvtive:YES];
        //显示在最上层
        [activeView.superview bringSubviewToFront:activeView];
    }
}

- (instancetype)initWithImage:(UIImage *)image tool:(KKEmoticonTool *)tool{
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width+kDeleteBtnSize, image.size.height+kDeleteBtnSize)];
    if (self) {
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.layer.borderColor = [[UIColor blackColor] CGColor];
        _imageView.layer.cornerRadius = 3;
        _imageView.center = self.center;
        [self addSubview:_imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_deleteButton setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 32, 32);
        _deleteButton.center = _imageView.frame.origin;
        [_deleteButton addTarget:self action:@selector(clickDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _scaleBtn = [[KKScaleButton alloc] initWithFrame:CGRectMake(0, 0, kDeleteBtnSize, kDeleteBtnSize)];
        _scaleBtn.center = CGPointMake(_imageView.width + _imageView.frame.origin.x, _imageView.height + _imageView.frame.origin.y);
        _scaleBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:_scaleBtn];
        
        _scale = 1;
        _arg = 0;
        
        [self initGestures];
    }
    return self;
}

- (void)initGestures
{
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imageDidPan:)]];
    [_scaleBtn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scaleBtnDidPan:)]];
}

//删除
- (void)clickDeleteBtn:(id)sender
{
    KKEmoticonView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[KKEmoticonView class]]){
            nextTarget = (KKEmoticonView *)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[KKEmoticonView class]]){
                nextTarget = (KKEmoticonView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveEmoticonView:nextTarget];
    [self removeFromSuperview];
}

- (void)setAvtive:(BOOL)active
{
    _deleteButton.hidden = !active;
    _scaleBtn.hidden = !active;
    _imageView.layer.borderWidth = (active) ? 1/_scale : 0;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _imageView.transform = CGAffineTransformMakeScale(_scale, _scale); //缩放
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_imageView.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_imageView.height + 32)) / 2;
    rct.size.width  = _imageView.width + 32;
    rct.size.height = _imageView.height + 32;
    self.frame = rct;
    
    _imageView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_arg); //旋转
    
    _imageView.layer.borderWidth = 1/_scale;
    _imageView.layer.cornerRadius = 3/_scale;
}

//拖动
- (void)imageDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveEmoticonView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    
    if(sender.state == UIGestureRecognizerStateBegan){
        _initialPoint = self.center;
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

//缩放
- (void)scaleBtnDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1; //临时缩放值
    static CGFloat tmpA = 0; //临时旋转值
    if(sender.state == UIGestureRecognizerStateBegan){
        //表情view中的缩放按钮相对与表情view父视图中的位置
        _initialPoint = [self.superview convertPoint:_scaleBtn.center fromView:_scaleBtn.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        //缩放按钮中点与表情view中点的直线距离
        tmpR = sqrt(p.x*p.x + p.y*p.y); //开根号
        //缩放按钮中点与表情view中点连线的斜率角度
        tmpA = atan2(p.y, p.x);//反正切函数
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y); //拖动后的距离
    CGFloat arg = atan2(p.y, p.x);    // 拖动后的旋转角度
    //旋转角度
    _arg   = _initialArg + arg - tmpA; //原始角度+拖动后的角度 - 拖动前的角度
    //放大缩小的值
    [self setScale:MAX(_initialScale * R / tmpR, 0.2)];
}

@end
