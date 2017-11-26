//
//  KKMasaicView.m
//  WWImageEdit
//
//  Created by 邬维 on 2017/1/11.
//  Copyright © 2017年 kook. All rights reserved.
//

#import "KKMosaicView.h"

@interface KKMosaicView ()

@property (nonatomic, strong) UIImageView *surfaceImageView;

@property (nonatomic, strong) CALayer *imageLayer;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, assign) CGMutablePathRef path;

@end


@implementation KKMosaicView

- (void)dealloc
{
    if (self.path) {
        CGPathRelease(_path);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加imageview（surfaceImageView）到self上
        self.surfaceImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:self.surfaceImageView];
        //添加layer（imageLayer）到self上
        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = self.bounds;
        [self.layer addSublayer:self.imageLayer];
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.lineJoin = kCALineJoinRound;
    //手指移动时 画笔的宽度
        self.shapeLayer.lineWidth = 20.f;
        self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        self.shapeLayer.fillColor = nil;
        
        [self.layer addSublayer:self.shapeLayer];
        self.imageLayer.mask = self.shapeLayer;
        
        CGMutablePathRef pathRef = CGPathCreateMutable();
        self.path = CGPathCreateMutableCopy(pathRef);
        CGPathRelease(pathRef);
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathMoveToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    self.shapeLayer.path = path;
    CGPathRelease(path);
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathAddLineToPoint(self.path, NULL, point.x, point.y);
    CGMutablePathRef path = CGPathCreateMutableCopy(self.path);
    //

    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (!currentContext) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, YES, 0);
    }
    CGContextAddPath(currentContext, path);
    [[UIColor blueColor] setStroke];
    CGContextDrawPath(currentContext, kCGPathStroke);
    self.shapeLayer.path = path;
    CGPathRelease(path);
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
}


- (void)setImage:(UIImage *)image
{
    //底图
    _image = image;
    self.imageLayer.contents = (id)image.CGImage;
}

- (void)setSurfaceImage:(UIImage *)surfaceImage
{
    //顶图
    _surfaceImage = surfaceImage;
    self.surfaceImageView.image = surfaceImage;
}

@end
