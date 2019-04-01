//
//  EditTableViewCell.m
//  paylog
//
//  Created by Cooking singular wings on 2017/7/19.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import "EditTableViewCell.h"

@implementation EditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.isget.text = NSLocalizedString(@"isget", @"");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.contentTextField becomeFirstResponder];
}
@end
