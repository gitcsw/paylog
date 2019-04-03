//
//  Whole.m
//  paylog
//
//  Created by GitCsw on 2017/7/17.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import "Whole.h"

static float lalala = 0;
static int ahaha = 0;
static NSString *mm = @"47120";
static NSMutableArray *wcts;
static NSMutableArray *ctp;
static NSMutableArray *ctp2;
static PHAssetCollection *plac;
@implementation Whole
+ (void)setStr:(float)str
{
    lalala = str;
}
+ (float)getStr
{
    return lalala;
}
//
+ (void)setNum:(int)number
{
    ahaha = number;
}
+ (int)getNum
{
    return ahaha;
}
//
+ (void)setproNum:(NSString *)numpro
{
    mm = numpro;
}
+ (NSString *)getproNum
{
    return mm;
}
//
+ (void)setsj:(NSMutableArray *)sj
{
    //wcts = sj;
    wcts = [NSMutableArray arrayWithArray:sj];
}
+ (NSMutableArray *)getsj
{
    //NSLog(@"%@",wcts);
    return wcts;
}
//
+ (void)settp:(NSMutableArray *)type
{
    ctp = type;
}
+ (NSMutableArray *)gettype
{
    return ctp;
}
//
+ (void)settp2:(NSMutableArray *)type
{
    ctp2 = type;
}
+ (NSMutableArray *)gettype2
{
    return ctp2;
}
//
+ (void)setal:(PHAssetCollection *)placo
{
    plac = placo;
}
+ (PHAssetCollection *)getAlbumCollection
{
    return plac;
}
@end
