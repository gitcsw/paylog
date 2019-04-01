//
//  TpMoreTViewController.m
//  paylog
//
//  Created by Cooking singular wings on 2017/8/29.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import "TpMoreTViewController.h"

@interface TpMoreTViewController ()
@property(strong,nonatomic)NSMutableArray *cts;
@property (weak, nonatomic) IBOutlet UITextField *yue;
@property (strong, nonatomic) IBOutlet UITableView *ctable;
@property(strong,nonatomic)Consts *ccst;
@end

@implementation TpMoreTViewController

- (void)viewDidLoad {
    _cts = [NSMutableArray arrayWithArray:[Whole getsj]];
    [super viewDidLoad];
    _yue.text = _tpje;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cswok:(id)sender {
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"UserType.plist"];
    NSMutableArray *usersDic = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    //设置属性值,没有的数据就新建，已有的数据就修改。
    for(int i = 0;i<usersDic.count;i++)
    {
        NSMutableDictionary *dic = [usersDic objectAtIndex:i];
        NSString *abc = [dic valueForKey:@"name"];
        if([abc isEqual: self.title])
        {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:abc forKey:@"name"];
            [dic setObject:_yue.text forKey:@"money"];
            [usersDic setObject:dic atIndexedSubscript:i];
            [Whole settp:usersDic];
            break;
        }
    }
    NSLog(@"%@ %@", usersDic,plistPath);
    //写入文件
    [usersDic writeToFile:plistPath atomically:YES];
    [self.yue resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.ctable dequeueReusableCellWithIdentifier:@"tpmcell" forIndexPath:indexPath];
    self.ccst = self.cts[indexPath.row];//反复刷屏这会报错
    if([self.ccst.cswtype isEqualToString:self.title])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.backgroundColor = SELECT_COLOR(255, 247, 123, 0.3);
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = SELECT_COLOR(255, 82, 105, 0.3);
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ ¥%.2f",self.ccst.name,self.ccst.money.floatValue];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ (%@)",self.ccst.time,self.ccst.cswtype];
    //
    NSString *cst = [NSString stringWithFormat:@"%.2f",self.ccst.money.floatValue];
    if([[cst substringToIndex:1]  isEqual: @"-"])
        cell.imageView.image = [UIImage imageNamed:@"paymoney.png"];
    else
        cell.imageView.image = [UIImage imageNamed:@"getmoney.png"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
