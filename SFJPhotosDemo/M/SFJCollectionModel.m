//
//  SFJCollectionModel.m
//  SFJPhotosDemo
//
//  Created by 沙缚柩 on 2017/5/11.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJCollectionModel.h"
#import "SFJPhotoManager.h"

@implementation SFJCollectionModel

- (NSString *)collectionName{
    return self.collection.localizedTitle;
}

- (PHAsset *)firstAsset{
    return [[SFJPhotoManager shareManager] firstAssetInCollection:self.collection];
}

- (UIImage *)p_firstImage{
    return [[SFJPhotoManager shareManager] requestImageWithAsset:[self firstAsset] targetSize:CGSizeMake(150, 150)];
}

- (PHFetchResult *)p_assets{
    return [[SFJPhotoManager shareManager] assetsInAssetCollection:self.collection];
}

- (NSArray<PHAsset *> *)sfj_assets{
    NSMutableArray *arr = [NSMutableArray array];
    PHFetchResult *assetsResult = [self p_assets];
    [assetsResult enumerateObjectsUsingBlock:^(PHAsset  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:obj];
    }];
    return arr;
}

- (void)setCollection:(PHAssetCollection *)collection{
    _collection = collection;
    
    self.collectionName = collection.localizedTitle;
    self.firstImage = [self p_firstImage];
    self.assets = [self sfj_assets];
}

+ (instancetype)modelWithCollection:(PHAssetCollection *)collection{
    SFJCollectionModel *model = [[self alloc] init];
    model.collection = collection;
    return model;
}
@end
