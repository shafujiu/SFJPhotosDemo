//
//  SFJCollectionModel.h
//  SFJPhotosDemo
//
//  Created by 沙缚柩 on 2017/5/11.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAssetCollection;
@class PHFetchResult;
@class PHAsset;

@interface SFJCollectionModel : NSObject

@property (nonatomic, strong) PHAssetCollection *collection;

// 辅助属性
@property (nonatomic, copy) NSString *collectionName;
@property (nonatomic, strong) UIImage *firstImage;
@property (nonatomic, strong) NSArray<PHAsset *> *assets;

+ (instancetype)modelWithCollection:(PHAssetCollection *)collection;
@end
