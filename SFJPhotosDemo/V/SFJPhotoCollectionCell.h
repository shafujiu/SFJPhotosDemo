//
//  SFJPhotoCollectionCell.h
//  SFJPhotosDemo
//
//  Created by 沙缚柩 on 2017/5/11.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SFJCollectionModel;

static NSString *const SFJPhotoCollectionCellID = @"SFJPhotoCollectionCellID";
@interface SFJPhotoCollectionCell : UICollectionViewCell

@property (nonatomic, strong) SFJCollectionModel *model;

@end
