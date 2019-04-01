//
//  TyptagTViewController.m
//  paylog
//
//  Created by Cooking singular wings on 2017/8/27.
//  Copyright © 2017年 Csw. All rights reserved.
//

#import "TyptagTViewController.h"
#import "TpMoreTViewController.h"

@interface TyptagTViewController ()
{
    CGSize csize;
    NSString *plistPath;
    NSDictionary *infoDic;
    NSMutableArray *tpdata;
    NSMutableArray *usersDic;
}

@end

@implementation TyptagTViewController

- (void)viewDidLoad {
    CGRect rect = [[UIScreen mainScreen] bounds];
    csize = rect.size;
    tpdata = [Whole gettype];
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addtype)];
    //
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    plistPath = [documentsPath stringByAppendingPathComponent:@"UserType.plist"];
    usersDic = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{//刷新
    tpdata = [Whole gettype];
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tpdata.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifer=@"tyc";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    //
    cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tpinfo"];
    
    //
    //NSString *mye = [infoDic objectForKey:@"money"];
    UILabel *aLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 11, 300, 21)];
    UILabel *bLabel=[[UILabel alloc]initWithFrame:CGRectMake(csize.width - 105, 11, 70, 21)];
    UILabel *cLabel=[[UILabel alloc]initWithFrame:CGRectMake(csize.width - 145, 11, 40, 21)];
    //
    infoDic = [tpdata objectAtIndex:indexPath.row];
    aLabel.text = [infoDic objectForKey:@"name"];
    cLabel.text = @"余额:";
    bLabel.text = [NSString stringWithFormat:@"%@",[infoDic objectForKey:@"money"]];
    bLabel.textAlignment = NSTextAlignmentRight;
    //aLabel.text =  [datatype objectAtIndex:indexPath.row];
    //bLabel.text = [NSString stringWithFormat:@"余额 %.2f",aab];
    //bLabel.text = [NSString stringWithFormat:@"余额 %@",[datatypeje objectAtIndex:indexPath.row]];
    [cell.contentView addSubview:aLabel];
    [cell.contentView addSubview:bLabel];
    [cell.contentView addSubview:cLabel];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TpMoreTViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"tpmore"];
    //vc.tpje=[datatypeje objectAtIndex:indexPath.row];
    //vc.title = [datatype objectAtIndex:indexPath.row];
    infoDic = [tpdata objectAtIndex:indexPath.row];
    vc.tpje = [infoDic objectForKey:@"money"];
    vc.title = [infoDic objectForKey:@"name"];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
}

//删除表单元
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"将会完全删除此类型的金额数据，确定删除？" preferredStyle:UIAlertControllerStyleAlert];
             //添加按钮
             UIAlertAction *action = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                     NSLog(@"点击了确定按钮");
                 [tpdata removeObjectAtIndex:indexPath.row];
                 [usersDic removeObjectAtIndex:indexPath.row];
                 [Whole settp:usersDic];
                 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                 [usersDic writeToFile:plistPath atomically:YES];
                 }];//UIAlertActionStyleDestructive
        
             [alert addAction:action];
        
             [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                     NSLog(@"点击了取消按钮");
                 }]];
        [self presentViewController:alert animated:nil completion:nil];
    }
}

-(void)addtype{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"新建类型" preferredStyle:UIAlertControllerStyleAlert];
    //增加取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    //增加确定按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第输入框内容
        NSMutableDictionary *new= [[NSMutableDictionary alloc]init];
        UITextField *NameTextField = alertController.textFields.firstObject;
        UITextField *MoneyTextField = alertController.textFields.lastObject;
        float money = 0;
        @try{
            money = [MoneyTextField.text floatValue];
        }
        @catch(NSException * e){
            NSLog(@"Exception: %@", e);
            UIAlertView * alert =
            [[UIAlertView alloc]
             initWithTitle:@"错误"
             message: [[NSString alloc] initWithFormat:@"%@",e]
             delegate:self
             cancelButtonTitle:nil
             otherButtonTitles:@"OK", nil];
            [alert show];
            return;
        }
        NSLog(@"类型：%@ 金额：%@",NameTextField.text,MoneyTextField.text);
        [new setObject:NameTextField.text forKey:@"name"];
        [new setObject:[NSString stringWithFormat:@"%.2f",money] forKey:@"money"];
        [tpdata addObject:new];
        [usersDic addObject:new];
        [Whole settp:usersDic];
        [usersDic writeToFile:plistPath atomically:YES];
        [self.tableView reloadData];
    }]];
    //定义两个输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入类型名称";
        //textField.secureTextEntry = YES;
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请设置此类型金额";
        //textField.secureTextEntry = YES;
        textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    }];
    [self presentViewController:alertController animated:true completion:nil];
}
@end
