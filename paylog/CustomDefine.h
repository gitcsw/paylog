//
//  CustomDefine.h
//  paylog
//
//  Created by Cooking singular wings on 2017/7/17.
//  Copyright © 2017年 Csw. All rights reserved.
//

#ifndef CustomDefine_h
#define CustomDefine_h

/**
 *define:颜色设置的宏定义
 *prame: _r -- RGB的红
 *parma: _g -- RGB的绿
 *parma: _g -- RGB的蓝
 *parma: _alpha -- RGB的透明度
 */
#define SELECT_COLOR(_r,_g,_b,_alpha) [UIColor colorWithRed:_r / 255.0 green:_g / 255.0 blue:_b / 255.0 alpha:_alpha]

/**
 *define:获取屏幕的宽
 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

/**
 *define:获取屏幕的高
 */
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

/**
 *define:iOS 7.0的版本判断
 */
#define iOS7_OR_LATER [UIDevice currentDevice].systemVersion.floatValue >= 7.0

/**
 *define:iOS 8.0的版本判断
 */
#define iOS8_OR_LATER [UIDevice currentDevice].systemVersion.floatValue >= 8.0

/**
 *define:屏幕的宽高比
 */
#define CURRENT_SIZE(_size) _size / 375.0 * SCREEN_WIDTH


#endif /* CustomDefone_h */
