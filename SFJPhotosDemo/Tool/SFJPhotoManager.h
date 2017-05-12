//
//  SFJPhotoManager.h
//  SFJLoveHelper
//
//  Created by 沙缚柩 on 2017/5/8.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//  相片处理

/**
    PHAsset 照片
    PHAssetCollection 相册
    PHFetchResult 搜索集合 <可以是照片，相册等，该集合实现了NSFastEnumeration协议>
 */

#import <Photos/Photos.h>

@interface SFJPhotoManager : NSObject

+ (instancetype)shareManager;


#pragma mark -
#pragma mark - add
/** 
     保存相片到指定的相册 如果相册不存在则创建相册再保存
 */
- (void)saveImage:(UIImage *)image completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;
- (void)saveImage:(UIImage *)image collectionName:(NSString *)collectionName completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;
- (void)saveImages:(NSArray <UIImage *>*)images collectionName:(NSString *)collectionName completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;


#pragma mark -
#pragma mark - delete
/**
     删除照片
 */
- (void)deleteAsset:(PHAsset *)asset completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;
- (void)deleteAssets:(NSArray <PHAsset *> *)assets completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;

/**
    删除相册
 */
- (void)deleteAssetCollection:(PHAssetCollection *)assetCollection completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;


#pragma mark -
#pragma mark - fetch
// 查找相册的第一个PHAsset对象
- (PHAsset *)firstAssetInCollection:(PHAssetCollection *)collection;
// 所有的照片对象
- (PHFetchResult<PHAsset *> *)assetsInAssetCollection:(PHAssetCollection *)collection;

/** 
     根据PHAsset对象获取 UIImage 
 */
- (UIImage *)requestImageWithAsset:(PHAsset *)asset targetSize:(CGSize )size;
- (UIImage *)requestImageWithAsset:(PHAsset *)asset contentModel:(PHImageContentMode)contentModel targetSize:(CGSize)size;

/** 
     经由相机得来的相册
 */
- (PHFetchResult<PHAssetCollection *> *)smartAlbumCollections;
/**
     从 iTunes 同步来的相册，以及用户在 Photos 中自己建立的相册 
 */
- (PHFetchResult<PHAssetCollection *> *)albumCollections;
// 有图片的相册
- (NSArray<PHAssetCollection *> *)photoCollections;

/** 
     根据相册的名字查询 相册对象 
 */
- (PHAssetCollection *)photoCollectionByName:(NSString *)name;

#pragma mark -
#pragma mark - ohter
/**
     判断照片访问权限
 */
- (BOOL)canUserPhotos;

@end
