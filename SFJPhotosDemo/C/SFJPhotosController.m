//
//  SFJPhotosController.m
//  SFJPhotosDemo
//
//  Created by 沙缚柩 on 2017/5/11.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJPhotosController.h"
#import "SFJPhotoCell.h"
#import "SFJCollectionModel.h"

@interface SFJPhotosController ()

@property (nonatomic, strong) NSMutableArray *assets;
@end

@implementation SFJPhotosController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SFJPhotoCell class]) bundle:nil] forCellWithReuseIdentifier:SFJPhotoCellID];
    [self p_loadData];
}

- (void)p_loadData{
    _assets = [self.model.assets mutableCopy];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _assets.count;
//    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFJPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SFJPhotoCellID forIndexPath:indexPath];
    cell.asset = _assets[indexPath.item];
    __weak SFJPhotoCell *weakCell = cell;
    cell.deleteBlock = ^{
        [_assets removeObject:weakCell.asset];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [collectionView deleteItemsAtIndexPaths:@[indexPath]];
        });
    };
    return cell;
}




@end
