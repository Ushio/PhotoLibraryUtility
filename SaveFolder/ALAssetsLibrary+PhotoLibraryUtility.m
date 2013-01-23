#import "ALAssetsLibrary+PhotoLibraryUtility.h"

//設定
static const float JPEG_COMPRESSION_QUALITY = 1.0f;

@implementation ALAssetsLibrary (PhotoLibraryUtility)
- (void)saveImageToPhotoLibrary:(UIImage *)image groupName:(NSString *)name completion:(void(^)(NSError *error))completion
{
    completion = completion? [completion copy] :[^(BOOL is){} copy];
    
    //まずは保存
    [self writeImageDataToSavedPhotosAlbum:UIImageJPEGRepresentation(image, JPEG_COMPRESSION_QUALITY)
                                  metadata:nil
                           completionBlock:^(NSURL *assetURL, NSError *error)
     {
         NSMutableArray *groups = [NSMutableArray array];
         [self enumerateGroupsWithTypes:ALAssetsGroupAlbum
                             usingBlock:^(ALAssetsGroup *group, BOOL *stop)
         {
             if(group)
             {
                 [groups addObject:group];
             }
             else
             {
                 //列挙完了
                 //指定した名前のグループが既にあるかどうかを調べる
                 ALAssetsGroup *foundGroup = nil;
                 for(ALAssetsGroup *thisGroup in groups)
                 {
                     if([[thisGroup valueForProperty:ALAssetsGroupPropertyName] isEqualToString:name])
                     {
                         foundGroup = thisGroup;
                         break;
                     }
                 }
                 
                 if(foundGroup)
                 {
                     //グループが既にある
                     [self assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                         [foundGroup addAsset:asset];
                         
                         //成功
                         completion(nil);
                     } failureBlock:^(NSError *error) {
                         //エラー
                         completion(error);
                     }];
                 }
                 else
                 {
                     //ないなら作る
                     __block __weak ALAssetsLibrary *_self = self;
                     [self addAssetsGroupAlbumWithName:name resultBlock:^(ALAssetsGroup *newGroup) {
                         [_self assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                             [newGroup addAsset:asset];
                             
                             //成功
                             completion(nil);
                         } failureBlock:^(NSError *error) {
                             //エラー
                             completion(error);
                         }];
                     } failureBlock:^(NSError *error) {
                         //エラー
                         completion(error);
                     }];
                 }
             }
         } failureBlock:^(NSError *error) {
             //エラー
             completion(error);
         }];
     }];
}
@end
