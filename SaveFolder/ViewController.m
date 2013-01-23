#import "ViewController.h"
#import "ALAssetsLibrary+PhotoLibraryUtility.h"

@implementation ViewController
{
    ALAssetsLibrary *library;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //非同期で保存している間にALAssetsLibraryのインスタンスは破棄したくない
    library = [[ALAssetsLibrary alloc] init];
    [library saveImageToPhotoLibrary:[UIImage imageNamed:@"lena.jpg"]
                           groupName:@"TEST GROUP"
                          completion:^(NSError *error)
    {
        if(error)
        {
            //失敗
            NSLog(@"失敗 : %@", error);
        }
        else
        {
            //成功
            NSLog(@"成功");
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
