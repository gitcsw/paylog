//
//  EditTableViewController.h
//  paylog
//
//  Created by GitCsw on 2017/7/19.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTableViewController : UITableViewController
@property (strong,nonatomic) NSMutableArray *consts;
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (strong,nonatomic) NSManagedObjectContext *context;
@end
