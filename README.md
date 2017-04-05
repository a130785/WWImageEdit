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
