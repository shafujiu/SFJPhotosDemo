//
//  SFJPhotoCollectionCell.m
//  SFJPhotosDemo
//
//  Created by 沙缚柩 on 2017/5/11.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJPhotoCollectionCell.h"
#import "SFJCollectionModel.h"

@interface SFJPhotoCollectionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *collectionName;

@end

@implementation SFJPhotoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SFJCollectionModel *)model{
    
    _model = model;
    _imgView.image = model.firstImage;
    _collectionName.text = model.collectionName;
}




@end
