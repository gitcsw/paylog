//
//  EditTableViewCell.h
//  paylog
//
//  Created by GitCsw on 2017/7/19.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *isget;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UITextView *moretxt;
@end
