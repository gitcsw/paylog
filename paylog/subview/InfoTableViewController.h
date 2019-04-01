//
//  InfoTableViewController.h
//  paylog
//
//  Created by Cooking singular wings on 2017/7/18.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewController : UITableViewController
@property (strong,nonatomic) NSMutableArray *consts;
@property (strong,nonatomic) NSIndexPath *indexPath;
@property (strong,nonatomic) NSManagedObjectContext *context;
@end
