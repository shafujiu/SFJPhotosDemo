# SFJPhotosDemo
相册工具类SFJPhotoManager
iOS 8之后我们对于相册相片的处理，系统为我们提供了photos框架。

> 本文对常用的一些操作进行了一些分装形成SFJPhotoManager工具类，demo里面有详细的使用。

### 首先介绍一下几个我们用到频率比较高的几个对象
- PHAsset 相当于相片对象。
- PHAssetCollection 相册对象
- PHFetchResult 搜索结果<可以是照片对象，也可以是相册对象，等等、、，并且该集合实现了NSFastEnumeration协议>
- PHAssetCollectionChangeRequest 修改相册的请求
- PHAssetChangeRequest 修改相片的请求


### 增
```Objective-c
/** 
     保存相片到指定的相册 如果相册不存在则创建相册再保存
 */
- (void)saveImage:(UIImage *)image completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;
- (void)saveImage:(UIImage *)image collectionName:(NSString *)collectionName completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;
- (void)saveImages:(NSArray <UIImage *>*)images collectionName:(NSString *)collectionName completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;
```

### 删
```Objective-c
/**
     删除照片
 */
- (void)deleteAsset:(PHAsset *)asset completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;
- (void)deleteAssets:(NSArray <PHAsset *> *)assets completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;
/**
    删除相册
 */
- (void)deleteAssetCollection:(PHAssetCollection *)assetCollection completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;
```

### 查

```Objective-c
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

```

### 其他
```Objective-c
/**
     判断照片访问权限
 */
- (BOOL)canUserPhotos;
```
