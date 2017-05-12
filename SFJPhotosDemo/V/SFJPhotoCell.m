//
//  SFJPhotoCell.m
//  SFJPhotosDemo
//
//  Created by 沙缚柩 on 2017/5/11.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJPhotoCell.h"
#import "SFJPhotoManager.h"

@interface SFJPhotoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@end
@implementation SFJPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setAsset:(PHAsset *)asset{
    _asset = asset;
    _imgView.image = [[SFJPhotoManager shareManager] requestImageWithAsset:asset targetSize:CGSizeMake(100, 100)];
}

- (IBAction)delete:(id)sender {
    [[SFJPhotoManager shareManager] deleteAsset:_asset completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            !_deleteBlock ? : _deleteBlock();
        }
    }];
}


@end
