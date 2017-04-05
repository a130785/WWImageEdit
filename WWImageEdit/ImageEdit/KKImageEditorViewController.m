//
//  KKImageEditorViewController.m
//  WWImageEdit
//
//  Created by 邬维 on 2016/12/29.
//  Copyright © 2016年 kook. All rights reserved.
//

#import "KKImageEditorViewController.h"
#import "UIView+Frame.h"
#import "KKImageToolBase.h"
#import "KKImageToolInfo.h"
#import "KKToolBarItem.h"

@interface KKImageEditorViewController ()<KKImageToolProtocol>

@property (nonatomic, strong) KKImageToolBase *currentTool;
@property (nonatomic, strong) KKImageToolInfo *toolInfo;

@end

@implementation KKImageEditorViewController{
    UIImage *_originalImage;
    
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.toolInfo = [KKImageToolInfo toolInfoForToolClass:[self class]];
    }
    return self;
}

- (instancetype)init
{
    self = [self initWithNibName:nil bundle:nil];
    if (self){
        
    }
    return self;
}


- (instancetype)initWithImage:(UIImage*)image delegate:(id<KKImageEditorDelegate>)delegate{
    self = [self init];
    if (self){
        _originalImage = [image copy];
        self.delegate = delegate;
    }
    return self;
}

#pragma mark- view life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.clipsToBounds = YES;
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    [self.view setBackgroundColor:[KKImageEditorTheme theme].backgroundColor];
    self.title = self.toolInfo.title;
    [self initMenuView];
    [self initImageScrollView];
    [self initToolSettings];
    [self initNavigationBar];
    
    if(_imageView==nil){
        _imageView = [UIImageView new];
        [_scrollView addSubview:_imageView];
        [self refreshImageView];
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshImageView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNavigationItem) name:KTextEditDoneNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc{
    NSLog(@"KKImageEditorViewController dealloc");
}

#pragma -mark view init
//底部工具view
- (void)initMenuView{
    if (_menuView == nil) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 80, self.view.width, 80)];
        _menuView.backgroundColor = [KKImageEditorTheme theme].toolbarColor;
        [self.view addSubview:_menuView];
        
    }
}

//底层ScrollView
- (void)initImageScrollView
{
    if(_scrollView==nil){
        UIScrollView *imageScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        imageScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageScroll.showsHorizontalScrollIndicator = NO;
        imageScroll.showsVerticalScrollIndicator = NO;
        imageScroll.delegate = self;
        imageScroll.clipsToBounds = NO;
        
        CGFloat y = self.navigationController.navigationBar.bottom;
        imageScroll.top = y;
        imageScroll.height = self.view.height - imageScroll.top - _menuView.height;
        
        [self.view insertSubview:imageScroll atIndex:0];
        _scrollView = imageScroll;
    }
}

//init工具 item
- (void)initToolSettings{
    for(UIView *sub in _menuView.subviews){ [sub removeFromSuperview]; }
    
    CGFloat x = 0;
    CGFloat W = 55;
    CGFloat H = _menuView.height;
    //基类不算 -1
    NSUInteger toolCount = self.toolInfo.subtools.count - 1;
    CGFloat padding = 0;
    
    CGFloat diff = _menuView.frame.size.width - toolCount * W;
    if (0<diff) {
        padding = diff/(toolCount+1);
    }
    
    for(KKImageToolInfo *info in [KKImageToolInfo sortWithTools:self.toolInfo.subtools]){
        if ([info.title isEqualToString:[KKImageToolBase defaultTitle]]) {
            continue;
        }
        KKToolBarItem *view = [[KKToolBarItem alloc] initWithFrame:CGRectMake(x+padding, 0, W, H) target:self action:@selector(tappedToolMenuItem:) toolInfo:info];
        
        [_menuView addSubview:view];
        x += W+padding;
    }
}

- (void)initNavigationBar{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(imageEditFinishBtn)];
}

- (UIScrollView*)scrollView
{
    return _scrollView;
}

#pragma -mark KKImageToolProtocol
+ (UIImage*)defaultIconImage{
    return nil;
}

+ (NSString*)defaultTitle{
    return @"图片编辑";
}

+ (NSArray*)subtools{
    return [KKImageToolInfo toolsWithToolClass:[KKImageToolBase class]];
}

+ (NSUInteger)orderNum{
    return 0;
}

#pragma -mark implementation

- (void)resetImageViewFrame
{
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    if(size.width>0 && size.height>0){
        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
        CGFloat W = ratio * size.width * _scrollView.zoomScale;
        CGFloat H = ratio * size.height * _scrollView.zoomScale;
        
        _imageView.frame = CGRectMake(MAX(0, (_scrollView.width-W)/2), MAX(0, (_scrollView.height-H)/2), W, H);
    }
}

- (void)fixZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat minZoomScale = _scrollView.minimumZoomScale;
    _scrollView.maximumZoomScale = 0.95*minZoomScale;
    _scrollView.minimumZoomScale = 0.95*minZoomScale;
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
}

- (void)resetZoomScaleWithAnimated:(BOOL)animated
{
    CGFloat Rw = _scrollView.frame.size.width / _imageView.frame.size.width;
    CGFloat Rh = _scrollView.frame.size.height / _imageView.frame.size.height;
    
    //CGFloat scale = [[UIScreen mainScreen] scale];
    CGFloat scale = 1;
    Rw = MAX(Rw, _imageView.image.size.width / (scale * _scrollView.frame.size.width));
    Rh = MAX(Rh, _imageView.image.size.height / (scale * _scrollView.frame.size.height));
    
    _scrollView.contentSize = _imageView.frame.size;
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = MAX(MAX(Rw, Rh), 1);
    
    [_scrollView setZoomScale:_scrollView.minimumZoomScale animated:animated];
}

- (void)refreshImageView
{
    _imageView.image = _originalImage;
    
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimated:NO];
}

- (BOOL)shouldAutorotate
{
    return NO;
}


#pragma -mark Tap Action
- (void)imageEditFinishBtn{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if([self.delegate respondsToSelector:@selector(imageDidFinishEdittingWithImage:)]){
            [self.delegate imageDidFinishEdittingWithImage:_originalImage];
        }
    }];
}

- (void)pushedCancelBtn:(id)sender
{
    _imageView.image = _originalImage;
    [self resetImageViewFrame];
    
    self.currentTool = nil;
}

- (void)pushedDoneBtn:(id)sender
{
    self.view.userInteractionEnabled = NO;
    
    [self.currentTool executeWithCompletionBlock:^(UIImage *image, NSError *error, NSDictionary *userInfo) {
        if(error){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if(image){
            _originalImage = image;
            _imageView.image = image;
            
            [self resetImageViewFrame];
            self.currentTool = nil;
        }
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)tappedToolMenuItem:(UITapGestureRecognizer*)sender
{
    KKToolBarItem *view = (KKToolBarItem *)sender.view;
    
    view.alpha = 0.2;
    [UIView animateWithDuration:kImageToolAnimationDuration
                     animations:^{
                         view.alpha = 1;
                     }
     ];
    
    [self setupToolWithToolInfo:view.imgToolInfo];
}

//设置当前工具信息
- (void)setupToolWithToolInfo:(KKImageToolInfo*)info
{
    if(self.currentTool){ return; }
    
    Class toolClass = NSClassFromString(info.toolName);
    
    if(toolClass){
        id instance = [toolClass alloc];
        if(instance!=nil && [instance isKindOfClass:[KKImageToolBase class]]){
            instance = [instance initWithImageEditor:self withToolInfo:info];
            self.currentTool = instance;
        }
    }
}

//初始化当前工具
- (void)setCurrentTool:(KKImageToolBase *)currentTool
{
    if(currentTool != _currentTool){
        [_currentTool cleanup];
        _currentTool = currentTool;
        [_currentTool setup];
        
        [self swapToolBarWithEditting:(_currentTool!=nil)];
    }
}

//修改工具栏和导航栏
- (void)swapToolBarWithEditting:(BOOL)editting
{
    [UIView animateWithDuration:kImageToolAnimationDuration
                     animations:^{
                         if(editting){
                             _menuView.transform = CGAffineTransformMakeTranslation(0, self.view.height-_menuView.top);
                         }
                         else{
                             _menuView.transform = CGAffineTransformIdentity; //复位
                         }
                     }
     ];

    
    if(self.currentTool){
        [self updateNavigationItem];
    }else{
        self.navigationItem.hidesBackButton = NO;
        [self initNavigationBar];
        self.navigationItem.leftBarButtonItem = nil;
    }

}

- (void)updateNavigationItem{
    UINavigationItem *item  = self.navigationItem;
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleDone target:self action:@selector(pushedDoneBtn:)];
    item.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(pushedCancelBtn:)];
    self.navigationItem.hidesBackButton = YES;
}

#pragma mark- ScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGFloat Ws = _scrollView.frame.size.width - _scrollView.contentInset.left - _scrollView.contentInset.right;
    CGFloat Hs = _scrollView.frame.size.height - _scrollView.contentInset.top - _scrollView.contentInset.bottom;
    CGFloat W = _imageView.frame.size.width;
    CGFloat H = _imageView.frame.size.height;
    
    CGRect rct = _imageView.frame;
    rct.origin.x = MAX((Ws-W)/2, 0);
    rct.origin.y = MAX((Hs-H)/2, 0);
    _imageView.frame = rct;
}
@end
