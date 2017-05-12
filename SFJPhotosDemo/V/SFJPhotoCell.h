//
//  SFJPhotoCell.h
//  SFJPhotosDemo
//
//  Created by 沙缚柩 on 2017/5/11.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;

static NSString *const SFJPhotoCellID = @"SFJPhotoCellID";

@interface SFJPhotoCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset *asset;

//@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) void(^deleteBlock)();

@end
