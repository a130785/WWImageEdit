//
//  ViewController.m
//  WWImageEdit
//
//  Created by 邬维 on 2016/12/27.
//  Copyright © 2016年 kook. All rights reserved.
//

#import "ViewController.h"
#import "KKImageEditorViewController.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,KKImageEditorDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *resultImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)selectPic:(id)sender {
    UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if([UIImagePickerController isSourceTypeAvailable:type]){
//        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//            type = UIImagePickerControllerSourceTypeCamera;
//        }
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate   = self;
        picker.sourceType = type;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    KKImageEditorViewController *editor = [[KKImageEditorViewController alloc] initWithImage:image delegate:self];
    
    
    [picker pushViewController:editor animated:YES];
}


#pragma mark- KKImageEditorDelegate

- (void)imageDidFinishEdittingWithImage:(UIImage *)image
{
    _resultImageView.image = image;
}

@end
