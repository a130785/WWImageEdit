# WWImageEdit
基本的图像编辑功能,画笔，马赛克，裁剪，添加文字表情
Demo运行：修改bundleID和signing，运行xcworkspace文件（虽然并没什么卵用）

Usage:

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{

    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    KKImageEditorViewController *editor = [[KKImageEditorViewController alloc] initWithImage:image delegate:self];
    
    [picker pushViewController:editor animated:YES];
    
}

![WechatIMG2.jpeg](http://upload-images.jianshu.io/upload_images/1968278-0f00f58cb15ed759.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####图片编辑简介

![iOS图片编辑.png](http://upload-images.jianshu.io/upload_images/1968278-2dc5edd1de304a02.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

编辑页面是盖在图片上的一层操作面板，选择不同的bar来处理不同的编辑场景

####视图层级图
![WechatIMG3.jpeg](http://upload-images.jianshu.io/upload_images/1968278-de7ebbb8c9026778.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

![WechatIMG10.jpeg](http://upload-images.jianshu.io/upload_images/1968278-fb97ec49d6f3aed7.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

马赛克处理为例：在编辑页面上盖里一个masaicView,masaicView分为上下2层，下面一层为加了CIPixellate滤镜的图层，上面一层为原始图片。虽然手指的移动，移动的路径变透明就显示出底层的马赛克效果。用户操作时感觉就像随手机移动而变成马赛克。最后截屏保存。

####UML 架构图

![Class Diagram.png](http://upload-images.jianshu.io/upload_images/1968278-1af712e26554d9d0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

1.每一个编辑功能我称为一个：tool，如DrawTool,继承ImageToolBase。ImageEditorVC可以视作一个大的tool，它里面包含裁剪，马赛克，编辑都子工具。 所有的tool都必须实现ImageToolProtocol协议。

2.底部的工具栏是一个toolbarItem的集合，每一个按钮，或者说一个编辑功能都是一个item

3.无论是toolbar还是tool，他们的信息都保存为一个ImageToolInfo对象

####手势识别
我这里的处理是在每个编辑组件中处理的，好的做法应该是：手势引擎既要『大一统』式地管理，又要与具体响应手势的元素视图进行解耦，做法就是统一接口，制定标准。可以配置元素对象来实现对手势响应的规则，更加灵活自如，而且零耦合。

####最后
本文理论参考腾讯小哥的[[多媒体编辑模块架构设计](http://yulingtianxia.com/blog/2016/12/29/Multimedia-Edit-Module-Architecture-Design/)](http://yulingtianxia.com/blog/2016/12/29/Multimedia-Edit-Module-Architecture-Design/)

关于滤镜方面，我用的是CIFilter，好的做法是适应GPU加速渲染
有兴趣的可以学习：[GPUImage](https://github.com/BradLarson/GPUImage)

imageEditorViewController实现UIScrollViewDelegate，因为图片裁剪后需要调整大小。需要动态调整maximumZoomScale，minimumZoomScale ，ZoomScale。我是直接搬的[CLImageEditor](https://github.com/yackle/CLImageEditor)
####没错，我就是代码的搬运工😢

打着加班的名义在写博客，该撤了。😊
源代码我会在下一篇【写一个iOS图片编辑器(二)】给出：在图片上添加icon，并拖动

![WechatIMG4.jpeg](http://upload-images.jianshu.io/upload_images/1968278-23c12ee196663276.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

简书地址：[wu大维的简书](http://www.jianshu.com/u/394efeb0517b)
