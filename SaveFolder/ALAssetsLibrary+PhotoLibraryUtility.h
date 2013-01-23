#import <AssetsLibrary/AssetsLibrary.h>

@interface ALAssetsLibrary (PhotoLibraryUtility)
- (void)saveImageToPhotoLibrary:(UIImage *)image groupName:(NSString *)name completion:(void(^)(NSError *error))completion;
@end
