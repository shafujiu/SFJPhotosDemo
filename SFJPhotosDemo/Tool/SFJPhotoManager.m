//
//  SFJPhotoManager.m
//  SFJLoveHelper
//
//  Created by 沙缚柩 on 2017/5/8.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJPhotoManager.h"

static NSString *const SFJDefaultCollectionName = @"LoveHelper";

@implementation SFJPhotoManager

+ (instancetype)shareManager{
    static SFJPhotoManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


#pragma mark -
#pragma mark - add
- (void)saveImage:(UIImage *)image completionHandler:(void(^)(BOOL success, NSError *error))completionHandler {
    [self saveImage:image collectionName:SFJDefaultCollectionName completionHandler:^(BOOL success, NSError *error) {
        !completionHandler ? :completionHandler(success,error);
    }];
}

- (void)saveImage:(UIImage *)image collectionName:(NSString *)collectionName completionHandler:(void(^)(BOOL success, NSError *error))completionHandler {
    [self saveImages:@[image] collectionName:collectionName completionHandler:^(BOOL success, NSError *error) {
        !completionHandler ? :completionHandler(success,error);
    }];
}

// 保存多张图片
- (void)saveImages:(NSArray <UIImage *>*)images collectionName:(NSString *)collectionName completionHandler:(void(^)(BOOL success, NSError *error))completionHandler {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCollection *assetCollection = [self photoCollectionByName:collectionName];
        PHAssetCollectionChangeRequest *collectionReq;
        if (assetCollection) {
            // 0
            collectionReq = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        }else{
            collectionReq = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionName];
        }
        
        NSMutableArray *placeholders = [NSMutableArray array];
        for (UIImage *image in images) {
            // 1 根据传入的相片, 创建相片变动请求
            PHAssetChangeRequest *req = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            // 2 获取系统为变动请求 创建的占位对象
            PHObjectPlaceholder *placeholder = [req placeholderForCreatedAsset];
            [placeholders addObject:placeholder];
        }
        // 3 将占位对象添加到相册请求中
        [collectionReq addAssets:placeholders];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        !completionHandler ? :completionHandler(success,error);
    }];
}

// 非主线程 异步请求 创建相册
- (void)addAssetCollectionWithName:(NSString *)name completionHandler:(void(^)(BOOL success, NSError *error))completionHandler{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:name];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        !completionHandler ? :completionHandler(success,error);
    }];
}

#pragma mark -
#pragma mark - delete
- (void)deleteAsset:(PHAsset *)asset completionHandler:(void(^)(BOOL success, NSError *error))completionHandler{
   [self deleteAssets:@[asset] completionHandler:^(BOOL success, NSError *error) {
       !completionHandler ? :completionHandler(success, error);
   }];
}

- (void)deleteAssets:(NSArray <PHAsset *> *)assets completionHandler:(void(^)(BOOL success, NSError *error))completionHandler{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:assets];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        !completionHandler ? :completionHandler(success, error);
    }];
}

- (void)deleteAssetCollection:(PHAssetCollection *)assetCollection completionHandler:(void(^)(BOOL success, NSError *error))completionHandler{
    [self deleteAssetCollections:@[assetCollection] completionHandler:^(BOOL success, NSError *error) {
        !completionHandler ? : completionHandler(success,error);
    }];
}

- (void)deleteAssetCollections:(NSArray <PHAssetCollection*> *)assetCollections completionHandler:(void(^)(BOOL success, NSError *error))completionHandler{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCollectionChangeRequest deleteAssetCollections:assetCollections];
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        !completionHandler ? : completionHandler(success,error);
    }];
}


#pragma mark -
#pragma mark - fetch
- (PHAsset *)firstAssetInCollection:(PHAssetCollection *)collection{
    __block PHAsset *asset = nil;
    PHFetchResult<PHAsset *> *assets = [self fetchAssetsInAssetCollection:collection withFechLimit:1];
    [assets enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            asset = obj;
        }
    }];
    return asset;
}

- (PHFetchResult<PHAsset *> *)assetsInAssetCollection:(PHAssetCollection *)collection{
    return [self fetchAssetsInAssetCollection:collection withFechLimit:0];
}

// 限制数量查找，O 表示不限制
- (PHFetchResult<PHAsset *> *)fetchAssetsInAssetCollection:(PHAssetCollection *)collection withFechLimit:(NSInteger)limt{
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.fetchLimit = limt;
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:collection options:options];
    return assets;
}

/** 根据相册的名字查询 相册对象 */
- (PHAssetCollection *)photoCollectionByName:(NSString *)name{
    __block PHAssetCollection *resultCollection = nil;
    // 1. 创建搜索集合
    PHFetchResult *albumResult = self.albumCollections;
    // 2. 遍历搜索集合并取出对应的相册
    [albumResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([assetCollection.localizedTitle isEqualToString:name]) {
            resultCollection = assetCollection;
            *stop = YES;
        }
    }];
    
    PHFetchResult *smartResult = self.smartAlbumCollections;
    [smartResult enumerateObjectsUsingBlock:^(PHAssetCollection *assetCollection, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([assetCollection.localizedTitle isEqualToString:name]) {
            resultCollection = assetCollection;
            *stop = YES;
        }
    }];
    return resultCollection;
}

- (PHFetchResult<PHAssetCollection *> *)smartAlbumCollections{
    return [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
}

- (PHFetchResult<PHAssetCollection *> *)albumCollections{
    return [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
}

- (NSArray<PHAssetCollection *> *)photoCollections{
    NSMutableArray *arr = [NSMutableArray array];
    
    PHFetchResult *smart = [self smartAlbumCollections];
    [smart enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self firstAssetInCollection:collection]) {
            [arr addObject:collection];
        }
    }];
    
    PHFetchResult *album = [self albumCollections];
    [album enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self firstAssetInCollection:collection]) {
            [arr addObject:collection];
        }
    }];
    return arr;
}


- (UIImage *)requestImageWithAsset:(PHAsset *)asset targetSize:(CGSize)size{
    return [self requestImageWithAsset:asset contentModel:PHImageContentModeAspectFill targetSize:size];
}

- (UIImage *)requestImageWithAsset:(PHAsset *)asset contentModel:(PHImageContentMode)contentModel targetSize:(CGSize)size{
    __block UIImage *resultImg = nil;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片 同步会等待返回结果
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    // 从asset中获得图片
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:contentModel options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultImg = result;
    }];
    return resultImg;
}


#pragma mark -
#pragma mark - other
- (BOOL)canUserPhotos{
    switch ([PHPhotoLibrary authorizationStatus]) {
        case AVAuthorizationStatusNotDetermined:
            return NO;
        case AVAuthorizationStatusRestricted:
            return NO;
        case AVAuthorizationStatusDenied:
            return NO;
        case AVAuthorizationStatusAuthorized:
            return YES;
    }
}


@end
