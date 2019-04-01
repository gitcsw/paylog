//
//  CswPhotoCell.h
//  paylog
//
//  Created by Cooking singular wings on 2017/8/15.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CswPhotoCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UIButton *deleteBtn;
@property (nonatomic, strong) UILabel *gifLable;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) id asset;

- (UIView *)snapshotView;

@end
