//
//  SFJPhotoCollectionController.m
//  SFJPhotosDemo
//
//  Created by 沙缚柩 on 2017/5/11.
//  Copyright © 2017年 沙缚柩. All rights reserved.
//

#import "SFJPhotoCollectionController.h"
#import "SFJPhotoCollectionCell.h"
//#import "SFJPhotoManager+SFJExtension.h"
#import "SFJPhotoManager.h"
#import "SFJCollectionModel.h"
#import "SFJPhotosController.h"

@interface SFJPhotoCollectionController ()

@property (nonatomic, strong) NSMutableArray *models;

@end

@implementation SFJPhotoCollectionController

- (NSMutableArray *)models{
    
    if (!_models) {
        _models = [NSMutableArray array];
    }
    return _models;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([SFJPhotoCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:SFJPhotoCollectionCellID];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self p_loadData];
    
}

- (void)p_loadData{
    [self.models removeAllObjects];
    NSArray *collections = [[SFJPhotoManager shareManager] photoCollections];
    for (PHAssetCollection *collection in collections) {
        SFJCollectionModel *model = [SFJCollectionModel modelWithCollection:collection];
        [self.models addObject:model];
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SFJPhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SFJPhotoCollectionCellID forIndexPath:indexPath];
    
    cell.model = self.models[indexPath.item];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // storyboard 通过连线跳转控制器
    [self performSegueWithIdentifier:NSStringFromClass([self class]) sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"%@",sender);
    NSArray *indexs = self.collectionView.indexPathsForSelectedItems;
    NSIndexPath *indexpath = indexs[0];
    SFJPhotosController *vc = [segue destinationViewController];
    vc.model = self.models[indexpath.item];
}


@end
