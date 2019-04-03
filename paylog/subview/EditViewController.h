//
//  EditViewController.h
//  paylog
//
//  Created by GitCsw on 2017/8/14.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import <UIKit/UIKit.h>
//
#import "TLTagsControl.h"
#import "CustomDefine.h"
#import "Consts.h"
#import "Whole.h"

@interface EditViewController : UIViewController
@property (strong,nonatomic) NSMutableArray *consts;
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (strong,nonatomic) NSManagedObjectContext *context;
@end
