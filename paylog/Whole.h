//
//  Whole.h
//  paylog
//
//  Created by Cooking singular wings on 2017/7/17.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface Whole: NSObject
+ (void)setStr:(float)str;
+ (void)setNum:(int)number;
+ (void)setproNum:(NSString *)numpro;
+ (void)setsj:(NSMutableArray *)sj;
+ (void)settp:(NSMutableArray *)type;
+ (void)settp2:(NSMutableArray *)type2;
+ (void)setal:(PHAssetCollection *)placo;
+ (float)getStr;
+ (int)getNum;
+ (NSString *)getproNum;
+ (NSMutableArray *)getsj;
+ (NSMutableArray *)gettype;
+ (NSMutableArray *)gettype2;
+ (PHAssetCollection *)getAlbumCollection;
@end
